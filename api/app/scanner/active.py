import asyncio, re, socket
from typing import List
import httpx

try:
    import nmap
    NMAP_OK = True
except ImportError:
    NMAP_OK = False


def finding(check_id, title, status, severity, detail, remediation=""):
    return {
        "id": check_id,
        "title": title,
        "status": status,
        "severity": severity,
        "detail": detail,
        "remediation": remediation,
    }


async def run_active_checks(target: str, modules: list) -> List[dict]:
    results = []
    hostname = target.replace("https://", "").replace("http://", "").split("/")[0]

    tasks = []
    if "ports" in modules:
        tasks.append(check_ports(hostname))
    if "cms" in modules:
        tasks.append(check_cms(target))
    if "cve" in modules:
        tasks.append(check_cve_headers(target))

    groups = await asyncio.gather(*tasks, return_exceptions=True)
    for group in groups:
        if isinstance(group, Exception):
            continue
        if isinstance(group, list):
            results.extend(group)
    return results


# ─── PORT SCANNING ────────────────────────────────────────────────────────────

DANGEROUS_PORTS = {
    21:   ("FTP",        "high",   "FTP transmits credentials in plaintext."),
    22:   ("SSH",        "medium", "SSH exposed — ensure key-based auth and fail2ban."),
    23:   ("Telnet",     "critical","Telnet is unencrypted. Disable immediately."),
    25:   ("SMTP",       "medium", "SMTP open — could be used for spam relay."),
    3306: ("MySQL",      "critical","MySQL port exposed to internet."),
    5432: ("PostgreSQL", "critical","PostgreSQL port exposed to internet."),
    6379: ("Redis",      "critical","Redis exposed — no auth by default."),
    27017:("MongoDB",    "critical","MongoDB exposed — often unauthenticated."),
    8080: ("HTTP-alt",   "low",    "Alternate HTTP port open."),
    8443: ("HTTPS-alt",  "low",    "Alternate HTTPS port open."),
    3389: ("RDP",        "critical","Remote Desktop exposed to internet."),
    5900: ("VNC",        "critical","VNC exposed — often weak passwords."),
    11211:("Memcached",  "critical","Memcached exposed — amplification DDoS risk."),
}

COMMON_PORTS = [21, 22, 23, 25, 80, 443, 3306, 5432, 6379, 8080, 8443, 3389, 5900, 6443, 27017, 11211]


async def check_ports(hostname: str) -> List[dict]:
    results = []
    if NMAP_OK:
        results.extend(await _nmap_scan(hostname))
    else:
        results.extend(await _socket_scan(hostname))
    return results


async def _socket_scan(hostname: str) -> List[dict]:
    results = []

    async def try_port(port):
        try:
            loop = asyncio.get_event_loop()
            await loop.run_in_executor(
                None,
                lambda: socket.create_connection((hostname, port), timeout=2).close()
            )
            return port
        except Exception:
            return None

    tasks = [try_port(p) for p in COMMON_PORTS]
    port_results = await asyncio.gather(*tasks)
    open_ports = [p for p in port_results if p is not None]

    if not open_ports:
        results.append(finding("ports_none", "Open ports", "info", "info",
                               "No common dangerous ports found open."))
        return results

    results.append(finding("ports_summary", "Open ports detected", "info", "info",
                            f"Open ports: {', '.join(str(p) for p in open_ports)}"))

    for port in open_ports:
        if port in DANGEROUS_PORTS:
            service, severity, detail = DANGEROUS_PORTS[port]
            status = "fail" if severity in ("critical", "high") else "warn"
            results.append(finding(
                f"port_{port}", f"Port {port} ({service})", status, severity,
                detail,
                f"Close port {port} if not needed, or firewall it from public access."
            ))
        elif port in (80, 443, 6443):
            results.append(finding(f"port_{port}", f"Port {port} open", "pass", "info",
                                   f"Standard web port {port} is open."))
    return results


async def _nmap_scan(hostname: str) -> List[dict]:
    results = []
    try:
        loop = asyncio.get_event_loop()
        nm = nmap.PortScanner()

        def _run():
            port_str = ",".join(str(p) for p in COMMON_PORTS)
            nm.scan(hostname, port_str, arguments="-Pn -sV --open -T4")
            return nm

        nm = await loop.run_in_executor(None, _run)
        host = hostname

        if host not in nm.all_hosts():
            results.append(finding("ports_host", "Port scan", "warn", "low",
                                   "Host did not respond to nmap scan. Note: run scanner with sudo for more accurate port results on Linux."))
            return results

        for proto in nm[host].all_protocols():
            ports = nm[host][proto].keys()
            for port in ports:
                state = nm[host][proto][port]["state"]
                service = nm[host][proto][port].get("name", "unknown")
                version = nm[host][proto][port].get("version", "")
                if state == "open":
                    if port in DANGEROUS_PORTS:
                        _, severity, detail = DANGEROUS_PORTS[port]
                        status = "fail" if severity in ("critical", "high") else "warn"
                        results.append(finding(
                            f"port_{port}", f"Port {port} ({service})", status, severity,
                            f"{detail} Version: {version}".strip(),
                            f"Close or firewall port {port}."
                        ))
                    else:
                        results.append(finding(
                            f"port_{port}", f"Port {port} ({service})", "info", "info",
                            f"Open — {version}".strip()
                        ))
    except Exception as e:
        results.append(finding("nmap_error", "Port scan (nmap)", "warn", "low",
                               f"nmap scan failed: {e}"))
    return results


# ─── CMS FINGERPRINTING ───────────────────────────────────────────────────────

CMS_SIGNATURES = [
    ("WordPress",  ["/wp-login.php", "/wp-admin/", "/wp-content/", "/wp-includes/"]),
    ("Joomla",     ["/joomla.xml", "com_content", "Joomla! ", "/media/jui/", "/templates/system/"]),
    ("Drupal",     ["X-Generator: Drupal", "Drupal.settings", "drupal.js", "/misc/drupal.js"]),
    ("Laravel",    ["laravel_session", "XSRF-TOKEN", "laravel/framework"]),
    ("Django",     ["csrfmiddlewaretoken", "__django", "django.contrib"]),
    ("Magento",    ["/skin/frontend/", "Mage.Cookies", "var BLANK_URL", "Magento"]),
    ("Shopify",    ["cdn.shopify.com", "myshopify.com", "Shopify.theme"]),
    ("Wix",        ["X-Wix-Request-Id", "wixstatic.com", "_wixCIDX"]),
]


async def check_cms(target: str) -> List[dict]:
    results = []
    detected = []

    async with httpx.AsyncClient(follow_redirects=True, timeout=15) as client:
        try:
            resp = await client.get(target)
            body = resp.text[:5000]
            headers_str = str(resp.headers)

            for cms_name, signatures in CMS_SIGNATURES:
                for sig in signatures:
                    if sig in body or sig in headers_str:
                        detected.append(cms_name)
                        break

            if "WordPress" in detected:
                results.append(finding(
                    "cms_wordpress", "CMS: WordPress detected", "fail", "medium",
                    "WordPress identified via login/admin paths. Attackers can target known CVEs.",
                    "Hide wp-admin, keep core + plugins updated, use a WAF."
                ))
                try:
                    xmlrpc = await client.get(target.rstrip("/") + "/xmlrpc.php")
                    if xmlrpc.status_code == 200:
                        results.append(finding(
                            "cms_xmlrpc", "WordPress XML-RPC enabled", "fail", "high",
                            "xmlrpc.php is accessible — brute-force amplification risk.",
                            "Disable XML-RPC if not needed via .htaccess or a security plugin."
                        ))
                except Exception:
                    pass
            elif detected:
                for cms in detected:
                    results.append(finding(
                        f"cms_{cms.lower()}", f"CMS: {cms} detected", "warn", "medium",
                        f"{cms} fingerprinted. Keep it updated and review known CVEs.",
                        f"Check {cms} security advisories and apply patches."
                    ))
            else:
                results.append(finding(
                    "cms_none", "CMS fingerprint", "pass", "info",
                    "No common CMS signatures detected."
                ))

        except Exception as e:
            results.append(finding("cms_error", "CMS fingerprint", "warn", "low",
                                   f"CMS check failed: {e}"))
    return results


# ─── CVE HEADER CHECK ─────────────────────────────────────────────────────────

async def check_cve_headers(target: str) -> List[dict]:
    results = []

    VERSION_PATTERNS = [
        (r"Apache/([\d.]+)",    "Apache",  "https://httpd.apache.org/security/vulnerabilities_24.html"),
        (r"nginx/([\d.]+)",     "nginx",   "https://nginx.org/en/security_advisories.html"),
        (r"PHP/([\d.]+)",       "PHP",     "https://www.php.net/ChangeLog-8.php"),
        (r"OpenSSL/([\d.]+)",   "OpenSSL", "https://www.openssl.org/news/secadv/"),
        (r"IIS/([\d.]+)",       "IIS",     "https://msrc.microsoft.com/update-guide"),
    ]

    try:
        async with httpx.AsyncClient(follow_redirects=True, timeout=15) as client:
            resp = await client.get(target)
            headers_str = " ".join(f"{k}: {v}" for k, v in resp.headers.items())

            found_any = False
            for pattern, tech, advisory_url in VERSION_PATTERNS:
                match = re.search(pattern, headers_str, re.IGNORECASE)
                if match:
                    found_any = True
                    version = match.group(1)
                    results.append(finding(
                        f"cve_{tech.lower()}", f"{tech} version exposed",
                        "fail", "medium",
                        f"{tech} version {version} disclosed in headers. Check for known CVEs.",
                        f"Remove version from headers and check advisories: {advisory_url}"
                    ))

            if not found_any:
                results.append(finding(
                    "cve_headers", "Version disclosure", "pass", "info",
                    "No software version strings found in response headers."
                ))

    except Exception as e:
        results.append(finding("cve_error", "CVE header check", "warn", "low",
                               f"CVE check failed: {e}"))
    return results