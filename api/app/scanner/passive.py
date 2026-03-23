import asyncio, ssl, socket, re
from datetime import datetime, timezone
from typing import List
import httpx

# Optional imports - gracefully degrade if not installed
try:
    import whois as whois_lib
    WHOIS_OK = True
except ImportError:
    WHOIS_OK = False

try:
    import dns.resolver
    DNS_OK = True
except ImportError:
    DNS_OK = False


def finding(check_id, title, status, severity, detail, remediation=""):
    """Standard finding object returned by every check."""
    return {
        "id": check_id,
        "title": title,
        "status": status,       # pass | fail | warn | info
        "severity": severity,   # critical | high | medium | low | info
        "detail": detail,
        "remediation": remediation,
    }


async def run_passive_checks(target: str, modules: list) -> List[dict]:
    results = []
    hostname = extract_hostname(target)

    tasks = []
    if "whois" in modules:
        tasks.append(check_whois(hostname))
    if "ssl" in modules:
        tasks.append(check_ssl(hostname))
    if "headers" in modules:
        tasks.append(check_headers(target))
    if "dns" in modules:
        tasks.append(check_dns(hostname))

    groups = await asyncio.gather(*tasks, return_exceptions=True)
    for group in groups:
        if isinstance(group, Exception):
            continue
        if isinstance(group, list):
            results.extend(group)
    return results


def extract_hostname(target: str) -> str:
    target = target.replace("https://", "").replace("http://", "")
    return target.split("/")[0].split(":")[0]


# ─── WHOIS ────────────────────────────────────────────────────────────────────

async def check_whois(hostname: str) -> List[dict]:
    results = []
    if not WHOIS_OK:
        results.append(finding("whois_lib", "WHOIS library", "warn", "low",
                               "python-whois not installed.", "pip install python-whois"))
        return results
    try:
        loop = asyncio.get_event_loop()
        w = await loop.run_in_executor(None, whois_lib.whois, hostname)

        # Registrar
        registrar = w.registrar if hasattr(w, "registrar") else None
        results.append(finding(
            "whois_registrar", "WHOIS registrar", "info", "info",
            f"Registered via: {registrar or 'Unknown'}"
        ))

        # Expiry
        exp = w.expiration_date
        if exp:
            if isinstance(exp, list):
                exp = exp[0]
            now = datetime.now(timezone.utc)
            if exp.tzinfo is None:
                exp = exp.replace(tzinfo=timezone.utc)
            days_left = (exp - now).days
            if days_left < 30:
                results.append(finding(
                    "whois_expiry", "Domain expiry", "fail", "high",
                    f"Domain expires in {days_left} days ({exp.date()}).",
                    "Renew the domain immediately to avoid service disruption."
                ))
            else:
                results.append(finding(
                    "whois_expiry", "Domain expiry", "pass", "info",
                    f"Domain expires in {days_left} days ({exp.date()})."
                ))

        # Privacy
        emails = w.emails
        if emails:
            results.append(finding(
                "whois_privacy", "WHOIS privacy", "fail", "medium",
                f"Registrant email exposed: {emails}",
                "Enable WHOIS privacy protection with your registrar."
            ))
        else:
            results.append(finding(
                "whois_privacy", "WHOIS privacy", "pass", "info",
                "Registrant details are redacted."
            ))
    except Exception as e:
        results.append(finding("whois_error", "WHOIS lookup", "warn", "low",
                               f"Could not retrieve WHOIS: {e}"))
    return results


# ─── SSL / TLS ────────────────────────────────────────────────────────────────

async def check_ssl(hostname: str) -> List[dict]:
    results = []
    try:
        loop = asyncio.get_event_loop()
        ctx = ssl.create_default_context()

        def _get_cert():
            with socket.create_connection((hostname, 443), timeout=10) as sock:
                with ctx.wrap_socket(sock, server_hostname=hostname) as ssock:
                    cert = ssock.getpeercert()
                    protocol = ssock.version()
                    cipher = ssock.cipher()
                    return cert, protocol, cipher

        cert, protocol, cipher = await loop.run_in_executor(None, _get_cert)

        # Certificate validity
        not_after = datetime.strptime(cert["notAfter"], "%b %d %H:%M:%S %Y %Z")
        not_after = not_after.replace(tzinfo=timezone.utc)
        now = datetime.now(timezone.utc)
        days_left = (not_after - now).days

        if days_left < 0:
            results.append(finding("ssl_expired", "SSL certificate", "fail", "critical",
                                   "Certificate has EXPIRED.", "Renew your SSL certificate immediately."))
        elif days_left < 14:
            results.append(finding("ssl_expiry", "SSL certificate expiry", "fail", "high",
                                   f"Certificate expires in {days_left} days.",
                                   "Renew your certificate before it expires."))
        else:
            results.append(finding("ssl_expiry", "SSL certificate expiry", "pass", "info",
                                   f"Certificate valid for {days_left} more days."))

        # Protocol version
        weak_protocols = ["TLSv1.0", "TLSv1.1", "SSLv2", "SSLv3"]
        if protocol.strip() in weak_protocols:
            results.append(finding("ssl_protocol", "TLS version", "fail", "high",
                                   f"Weak protocol in use: {protocol}",
                                   "Configure server to use TLS 1.2 or TLS 1.3 only."))
        else:
            results.append(finding("ssl_protocol", "TLS version", "pass", "info",
                                   f"Protocol: {protocol}"))

        # Cipher
        cipher_name = cipher[0] if cipher else "Unknown"
        weak_ciphers = ["RC4", "DES", "3DES", "NULL", "EXPORT", "anon"]
        if any(w in cipher_name for w in weak_ciphers):
            results.append(finding("ssl_cipher", "Cipher suite", "fail", "high",
                                   f"Weak cipher: {cipher_name}",
                                   "Disable weak cipher suites in your server config."))
        else:
            results.append(finding("ssl_cipher", "Cipher suite", "pass", "info",
                                   f"Cipher: {cipher_name}"))

        # SANs
        sans = [v for _, v in cert.get("subjectAltName", [])]
        results.append(finding("ssl_san", "Subject Alt Names", "info", "info",
                               f"SANs: {', '.join(sans) if sans else 'None found'}"))

    except ssl.SSLError as e:
        results.append(finding("ssl_error", "SSL/TLS", "fail", "critical",
                               f"SSL error: {e}", "Fix your SSL configuration."))
    except ConnectionRefusedError:
        results.append(finding("ssl_no_https", "HTTPS availability", "fail", "high",
                               "Port 443 not open — site may not support HTTPS.",
                               "Enable HTTPS and redirect all HTTP traffic."))
    except Exception as e:
        results.append(finding("ssl_error", "SSL check", "warn", "low", f"Could not check SSL: {e}"))
    return results


# ─── HTTP SECURITY HEADERS ────────────────────────────────────────────────────

SECURITY_HEADERS = [
    ("content-security-policy",       "Content-Security-Policy",       "critical",
     "Prevents XSS by controlling resource origins.",
     "Add a strict CSP header to your server response."),
    ("strict-transport-security",     "HSTS",                          "high",
     "Forces HTTPS connections.",
     "Add: Strict-Transport-Security: max-age=31536000; includeSubDomains"),
    ("x-frame-options",               "X-Frame-Options",               "high",
     "Prevents clickjacking.",
     "Add: X-Frame-Options: DENY or SAMEORIGIN"),
    ("x-content-type-options",        "X-Content-Type-Options",        "medium",
     "Prevents MIME sniffing.",
     "Add: X-Content-Type-Options: nosniff"),
    ("referrer-policy",               "Referrer-Policy",               "low",
     "Controls referrer information leakage.",
     "Add: Referrer-Policy: no-referrer-when-downgrade"),
    ("permissions-policy",            "Permissions-Policy",            "low",
     "Controls browser feature access.",
     "Add: Permissions-Policy: geolocation=(), microphone=()"),
    ("x-xss-protection",              "X-XSS-Protection",              "medium",
     "Legacy XSS filter (supplement with CSP).",
     "Add: X-XSS-Protection: 1; mode=block"),
]


async def check_headers(target: str) -> List[dict]:
    results = []
    try:
        async with httpx.AsyncClient(follow_redirects=True, timeout=15) as client:
            resp = await client.get(target)
            headers = {k.lower(): v for k, v in resp.headers.items()}

        # Check HTTPS redirect
        if target.startswith("http://"):
            if resp.url.scheme == "https":
                results.append(finding("http_redirect", "HTTP→HTTPS redirect", "pass", "info",
                                       "Site redirects HTTP to HTTPS."))
            else:
                results.append(finding("http_redirect", "HTTP→HTTPS redirect", "fail", "high",
                                       "Site does not redirect HTTP to HTTPS.",
                                       "Configure a 301 redirect from HTTP to HTTPS."))

        # Server header leakage
        server = headers.get("server", "")
        via = headers.get("via", "")
        if server:
            results.append(finding("header_server", "Server header", "warn", "medium",
                                   f"Server version exposed: {server}",
                                   "Remove or obscure the Server header in your web server config."))
        if via:
            results.append(finding("header_via", "Via header", "warn", "low",
                                   f"Proxy/CDN revealed: {via}"))

        # X-Powered-By
        powered = headers.get("x-powered-by", "")
        if powered:
            results.append(finding("header_powered", "X-Powered-By", "fail", "medium",
                                   f"Technology stack exposed: {powered}",
                                   "Remove X-Powered-By header from your PHP/framework config."))

        # Security headers
        for header_key, header_name, severity, description, remediation in SECURITY_HEADERS:
            if header_key in headers:
                val = headers[header_key]
                # HSTS quality check
                if header_key == "strict-transport-security":
                    match = re.search(r"max-age=(\d+)", val)
                    if match and int(match.group(1)) < 2592000:
                        results.append(finding(
                            f"hdr_{header_key}", header_name, "warn", "medium",
                            f"HSTS max-age too low: {match.group(1)}s (recommend 31536000).",
                            "Increase HSTS max-age to at least 31536000 (1 year)."
                        ))
                        continue
                results.append(finding(f"hdr_{header_key}", header_name, "pass", "info",
                                       f"Present: {val[:80]}"))
            else:
                results.append(finding(f"hdr_{header_key}", header_name, "fail", severity,
                                       f"{header_name} header is missing. {description}",
                                       remediation))

    except httpx.ConnectError:
        results.append(finding("headers_connect", "HTTP headers", "fail", "critical",
                               "Could not connect to target.", "Verify the URL is reachable."))
    except Exception as e:
        results.append(finding("headers_error", "HTTP headers", "warn", "low",
                               f"Header check failed: {e}"))
    return results


# ─── DNS ──────────────────────────────────────────────────────────────────────

async def check_dns(hostname: str) -> List[dict]:
    results = []
    if not DNS_OK:
        results.append(finding("dns_lib", "DNS checks", "warn", "low",
                               "dnspython not installed.", "pip install dnspython"))
        return results
    try:
        loop = asyncio.get_event_loop()
        resolver = dns.resolver.Resolver()

        def _query(qtype):
            try:
                return resolver.resolve(hostname, qtype)
            except Exception:
                return []

        # A records
        a_records = await loop.run_in_executor(None, _query, "A")
        ips = [r.address for r in a_records]
        results.append(finding("dns_a", "DNS A records", "info", "info",
                               f"IP addresses: {', '.join(ips) if ips else 'None'}"))

        # MX
        mx_records = await loop.run_in_executor(None, _query, "MX")
        if mx_records:
            results.append(finding("dns_mx", "MX records", "info", "info",
                                   f"Mail servers: {', '.join(str(r.exchange) for r in mx_records)}"))

        # DNSSEC
        try:
            ds = await loop.run_in_executor(None, lambda: resolver.resolve(hostname, "DS"))
            results.append(finding("dns_dnssec", "DNSSEC", "pass", "info", "DNSSEC is enabled."))
        except Exception:
            results.append(finding("dns_dnssec", "DNSSEC", "warn", "low",
                                   "DNSSEC not detected.",
                                   "Enable DNSSEC via your DNS registrar for DNS spoofing protection."))

    except Exception as e:
        results.append(finding("dns_error", "DNS checks", "warn", "low", f"DNS check failed: {e}"))
    return results
