import asyncio, os, re, socket, ssl
from typing import List
import httpx

VIRUSTOTAL_API_KEY = os.getenv("VIRUSTOTAL_API_KEY", "")
NVD_API_KEY = os.getenv("NVD_API_KEY", "")

def finding(check_id, title, status, severity, detail, remediation=""):
    return {
        "id": check_id,
        "title": title,
        "status": status,
        "severity": severity,
        "detail": detail,
        "remediation": remediation,
    }

async def run_advanced_checks(target: str, modules: list) -> List[dict]:
    results = []
    hostname = target.replace("https://", "").replace("http://", "").split("/")[0]

    tasks = []
    if "cookies"    in modules: tasks.append(check_cookies(target))
    if "xss"        in modules: tasks.append(check_xss(target))
    if "sqli"       in modules: tasks.append(check_sqli(target))
    if "dirs"       in modules: tasks.append(check_sensitive_files(target))
    if "access"     in modules: tasks.append(check_broken_access(target))
    if "stack"      in modules: tasks.append(check_tech_stack(target))
    if "email"      in modules: tasks.append(check_email_security(hostname))
    if "waf"        in modules: tasks.append(check_waf(target))
    if "session"    in modules: tasks.append(check_session_security(target))
    if "smtp"       in modules: tasks.append(check_smtp(hostname))
    if "sniffing"   in modules: tasks.append(check_sniffing_exposure(target))
    if "malware"    in modules: tasks.append(check_malware_indicators(target, hostname))
    if "db"         in modules: tasks.append(check_db_exposure(hostname))
    if "virustotal" in modules: tasks.append(check_virustotal(target))
    if "nvd"        in modules: tasks.append(check_nvd_cve(target))
    if "subdomains" in modules: tasks.append(check_subdomains(target))
    if "cors"       in modules: tasks.append(check_cors(target))
    if "methods"    in modules: tasks.append(check_http_methods(target))
    if "ratelimit"  in modules: tasks.append(check_rate_limiting(target))
    if "redirect"   in modules: tasks.append(check_open_redirect(target))

    groups = await asyncio.gather(*tasks, return_exceptions=True)
    for group in groups:
        if isinstance(group, Exception):
            continue
        if isinstance(group, list):
            results.extend(group)
    return results


# ─── COOKIE SECURITY ──────────────────────────────────────────────────────────

async def check_cookies(target: str) -> List[dict]:
    results = []
    try:
        async with httpx.AsyncClient(follow_redirects=True, timeout=8) as client:
            resp = await client.get(target)
            cookies = resp.cookies
            raw_headers = resp.headers.get_list("set-cookie") if hasattr(resp.headers, "get_list") else []

            if not raw_headers:
                raw_set_cookie = resp.headers.get("set-cookie", "")
                raw_headers = [raw_set_cookie] if raw_set_cookie else []

            if not raw_headers:
                results.append(finding("cookie_none", "Cookies", "info", "info",
                                       "No cookies set by this page."))
                return results

            for i, cookie_str in enumerate(raw_headers):
                cookie_str_lower = cookie_str.lower()
                cookie_name = cookie_str.split("=")[0].strip()

                # HttpOnly
                if "httponly" not in cookie_str_lower:
                    results.append(finding(
                        f"cookie_httponly_{i}", f"Cookie missing HttpOnly: {cookie_name}",
                        "fail", "high",
                        f"Cookie '{cookie_name}' lacks HttpOnly flag — accessible via JavaScript (XSS risk).",
                        "Add HttpOnly flag to all session cookies."
                    ))
                else:
                    results.append(finding(
                        f"cookie_httponly_{i}", f"Cookie HttpOnly: {cookie_name}",
                        "pass", "info", f"Cookie '{cookie_name}' has HttpOnly flag."
                    ))

                # Secure
                if "secure" not in cookie_str_lower:
                    results.append(finding(
                        f"cookie_secure_{i}", f"Cookie missing Secure: {cookie_name}",
                        "fail", "medium",
                        f"Cookie '{cookie_name}' lacks Secure flag — can be sent over HTTP.",
                        "Add Secure flag to all cookies to enforce HTTPS-only transmission."
                    ))
                else:
                    results.append(finding(
                        f"cookie_secure_{i}", f"Cookie Secure: {cookie_name}",
                        "pass", "info", f"Cookie '{cookie_name}' has Secure flag."
                    ))

                # SameSite
                if "samesite" not in cookie_str_lower:
                    results.append(finding(
                        f"cookie_samesite_{i}", f"Cookie missing SameSite: {cookie_name}",
                        "fail", "medium",
                        f"Cookie '{cookie_name}' lacks SameSite attribute — CSRF risk.",
                        "Set SameSite=Strict or SameSite=Lax on all cookies."
                    ))
                elif "samesite=none" in cookie_str_lower:
                    results.append(finding(
                        f"cookie_samesite_{i}", f"Cookie SameSite=None: {cookie_name}",
                        "warn", "medium",
                        f"Cookie '{cookie_name}' has SameSite=None — sent in cross-site requests.",
                        "Use SameSite=Strict or Lax unless cross-site is required."
                    ))
                else:
                    results.append(finding(
                        f"cookie_samesite_{i}", f"Cookie SameSite: {cookie_name}",
                        "pass", "info",
                        f"Cookie '{cookie_name}' has SameSite attribute."
                    ))

    except Exception as e:
        results.append(finding("cookie_error", "Cookie security check", "warn", "low",
                               f"Could not check cookies: {e}"))
    return results


# ─── XSS DETECTION ────────────────────────────────────────────────────────────

XSS_PAYLOADS = [
    '<script>alert(1)</script>',
    '"><script>alert(1)</script>',
    "'><img src=x onerror=alert(1)>",
    '<svg onload=alert(1)>',
]

async def check_xss(target: str) -> List[dict]:
    results = []
    try:
        async with httpx.AsyncClient(follow_redirects=True, timeout=8) as client:
            resp = await client.get(target)
            body = resp.text

            # Find input fields via regex
            inputs = re.findall(r'<input[^>]*name=["\']?(\w+)["\']?[^>]*>', body, re.IGNORECASE)
            forms  = re.findall(r'<form[^>]*action=["\']?([^"\'> ]*)["\']?', body, re.IGNORECASE)

            if not inputs and not forms:
                results.append(finding("xss_no_forms", "XSS — no input forms found", "info", "info",
                                       "No HTML forms detected on this page."))
                return results

            vulnerable = False
            for payload in XSS_PAYLOADS[:2]:  # Test first 2 payloads only
                for form_action in (forms or ["/"]):
                    action = form_action if form_action.startswith("http") else target.rstrip("/") + "/" + form_action.lstrip("/")
                    data = {inp: payload for inp in (inputs or ["q", "search", "input"])}
                    try:
                        r = await client.post(action, data=data, timeout=5)
                        if payload in r.text:
                            vulnerable = True
                            results.append(finding(
                                "xss_reflected", "Reflected XSS detected",
                                "fail", "critical",
                                f"Payload reflected unescaped in response: {payload[:40]}",
                                "Sanitize all user input. Use htmlspecialchars() in PHP. Implement CSP."
                            ))
                            break
                    except Exception:
                        pass
                if vulnerable:
                    break

            if not vulnerable:
                results.append(finding(
                    "xss_not_found", "XSS — no reflection detected", "pass", "info",
                    f"Tested {len(inputs)} input(s) — no obvious XSS reflection found. Manual testing recommended."
                ))

    except Exception as e:
        results.append(finding("xss_error", "XSS check", "warn", "low", f"XSS check failed: {e}"))
    return results


# ─── SQL INJECTION PROBE ──────────────────────────────────────────────────────

SQLI_PAYLOADS  = ["'", '"', "' OR '1'='1", "1; DROP TABLE users--", "' OR 1=1--"]
SQLI_ERRORS    = [
    "sql syntax", "mysql_fetch", "mysqli", "pg_query", "sqlite",
    "ora-", "sqlstate", "unclosed quotation", "syntax error",
    "you have an error in your sql"
]

async def check_sqli(target: str) -> List[dict]:
    results = []
    try:
        async with httpx.AsyncClient(follow_redirects=True, timeout=8) as client:
            resp = await client.get(target)
            body = resp.text
            inputs = re.findall(r'<input[^>]*name=["\']?(\w+)["\']?[^>]*>', body, re.IGNORECASE)
            forms  = re.findall(r'<form[^>]*action=["\']?([^"\'> ]*)["\']?', body, re.IGNORECASE)

            if not inputs:
                results.append(finding("sqli_no_forms", "SQLi — no input forms", "info", "info",
                                       "No HTML input forms found to test."))
                return results

            vulnerable = False
            for payload in SQLI_PAYLOADS:
                for form_action in (forms or ["/"]):
                    action = form_action if form_action.startswith("http") else target.rstrip("/") + "/" + form_action.lstrip("/")
                    data = {inp: payload for inp in inputs}
                    try:
                        r = await client.post(action, data=data, timeout=5)
                        response_lower = r.text.lower()
                        for error in SQLI_ERRORS:
                            if error in response_lower:
                                vulnerable = True
                                results.append(finding(
                                    "sqli_error_based", "SQL injection — error-based",
                                    "fail", "critical",
                                    f"SQL error detected in response with payload: {payload}. Error pattern: '{error}'",
                                    "Use prepared statements/parameterized queries. Never concatenate user input into SQL."
                                ))
                                break
                    except Exception:
                        pass
                    if vulnerable:
                        break
                if vulnerable:
                    break

            if not vulnerable:
                results.append(finding(
                    "sqli_not_found", "SQLi — no errors detected", "pass", "info",
                    "No SQL error responses detected. Blind SQLi may still be present — manual testing recommended."
                ))

    except Exception as e:
        results.append(finding("sqli_error", "SQLi check", "warn", "low", f"SQLi check failed: {e}"))
    return results


# ─── SENSITIVE FILE / DIRECTORY EXPOSURE ──────────────────────────────────────

SENSITIVE_PATHS = [
    ("/.env",               "Environment file",       "critical", "Contains API keys, DB passwords, secrets."),
    ("/.git/config",        ".git directory exposed",  "critical", "Full source code may be downloadable."),
    ("/wp-config.php.bak",  "WordPress config backup", "critical", "Database credentials may be exposed."),
    ("/config.php.bak",     "Config backup file",      "critical", "Backup files may contain credentials."),
    ("/backup.zip",         "Backup archive",          "high",     "Site backup may be publicly downloadable."),
    ("/backup.sql",         "SQL dump exposed",        "critical", "Database dump publicly accessible."),
    ("/.htpasswd",          ".htpasswd exposed",       "critical", "Password hashes publicly accessible."),
    ("/admin/",             "Admin panel exposed",     "high",     "Admin interface accessible without auth check."),
    ("/phpinfo.php",        "phpinfo() exposed",       "high",     "Server configuration details leaked."),
    ("/server-status",      "Apache server-status",    "medium",   "Server activity information exposed."),
    ("/robots.txt",         "robots.txt",              "info",     "May reveal hidden paths."),
    ("/.DS_Store",          ".DS_Store exposed",       "low",      "macOS metadata file reveals directory structure."),
    ("/debug.log",          "Debug log exposed",       "high",     "Application debug output may contain sensitive data."),
    ("/error.log",          "Error log exposed",       "high",     "Error logs may contain sensitive information."),
    ("/config.yaml",        "Config YAML exposed",     "high",     "Configuration file may contain secrets."),
    ("/config.json",        "Config JSON exposed",     "high",     "Configuration file may contain secrets."),
]

async def check_sensitive_files(target: str) -> List[dict]:
    results = []
    found_count = 0
    try:
        async with httpx.AsyncClient(follow_redirects=False, timeout=5) as client:
            tasks = []
            for path, name, severity, detail in SENSITIVE_PATHS:
                url = target.rstrip("/") + path
                tasks.append(_probe_path(client, url, path, name, severity, detail))

            findings = await asyncio.gather(*tasks, return_exceptions=True)
            for f in findings:
                if isinstance(f, dict):
                    results.append(f)
                    if f["status"] == "fail":
                        found_count += 1

        if found_count == 0:
            results.append(finding(
                "dirs_clean", "Sensitive files — none found", "pass", "info",
                f"Checked {len(SENSITIVE_PATHS)} common sensitive paths — none accessible."
            ))

    except Exception as e:
        results.append(finding("dirs_error", "Directory check", "warn", "low", f"Check failed: {e}"))
    return results

async def _probe_path(client, url, path, name, severity, detail):
    try:
        r = await client.get(url, timeout=4)
        if r.status_code in (200, 301, 302, 403):
            status = "fail" if r.status_code in (200, 301, 302) else "warn"
            sev    = severity if status == "fail" else "low"
            return finding(
                f"dir_{path.strip('/').replace('/', '_').replace('.', '')}",
                f"{name} accessible" if status == "fail" else f"{name} — forbidden (but exists)",
                status, sev,
                f"HTTP {r.status_code} at {url}. {detail}",
                f"Remove or restrict access to {path} via server configuration."
            )
    except Exception:
        pass
    return None


# ─── BROKEN ACCESS CONTROL ────────────────────────────────────────────────────

ADMIN_PATHS = [
    "/admin", "/admin/", "/administrator",
    "/wp-admin", "/dashboard", "/panel",
    "/phpMyAdmin", "/phpmyadmin",
    "/api/admin", "/api/users",
    "/config", "/setup", "/install",
    "/admin.php", "/manager",
]

async def check_broken_access(target: str) -> List[dict]:
    results = []
    exposed = []
    try:
        async with httpx.AsyncClient(follow_redirects=False, timeout=5) as client:
            tasks = [_probe_admin(client, target.rstrip("/") + path) for path in ADMIN_PATHS]
            probes = await asyncio.gather(*tasks, return_exceptions=True)
            for probe in probes:
                if probe:
                    exposed.append(probe)

        if exposed:
            results.append(finding(
                "access_admin_paths", "Admin/sensitive paths found",
                "fail", "high",
                f"Accessible paths: {', '.join(exposed)}",
                "Restrict access to admin paths by IP or require authentication."
            ))
        else:
            results.append(finding(
                "access_clean", "Broken access control — no exposed paths", "pass", "info",
                f"Checked {len(ADMIN_PATHS)} common admin paths — none publicly accessible."
            ))

    except Exception as e:
        results.append(finding("access_error", "Access control check", "warn", "low", f"Check failed: {e}"))
    return results

async def _probe_admin(client, url):
    try:
        r = await client.get(url, timeout=5)
        if r.status_code == 200:
            return url
    except Exception:
        pass
    return None


# ─── TECHNOLOGY STACK DETECTION ───────────────────────────────────────────────

TECH_SIGNATURES = [
    ("X-Powered-By",      r"PHP/([\d.]+)",         "PHP"),
    ("X-Powered-By",      r"ASP\.NET",              "ASP.NET"),
    ("Server",            r"Apache/([\d.]+)",       "Apache"),
    ("Server",            r"nginx/([\d.]+)",        "nginx"),
    ("Server",            r"IIS/([\d.]+)",          "IIS"),
    ("X-Generator",       r"WordPress ([\d.]+)",    "WordPress"),
    ("X-Drupal-Cache",    r".*",                    "Drupal"),
    ("X-Joomla-Token",   r".*",                    "Joomla"),
]

BODY_SIGNATURES = [
    (r'content="WordPress ([\d.]+)"',    "WordPress"),
    (r'Joomla!',                          "Joomla"),
    (r'Drupal',                           "Drupal"),
    (r'laravel_session|Laravel',          "Laravel"),
    (r'__django|csrftoken',               "Django"),
    (r'React\.createElement|__NEXT_DATA__',"React/Next.js"),
    (r'ng-version=|angular\.js',          "Angular"),
    (r'vue\.js|__vue__',                  "Vue.js"),
    (r'cdn\.shopify\.com',                "Shopify"),
    (r'wp-content|wp-includes',           "WordPress"),
]

async def check_tech_stack(target: str) -> List[dict]:
    results = []
    detected = []
    try:
        async with httpx.AsyncClient(follow_redirects=True, timeout=15) as client:
            resp = await client.get(target)
            headers = dict(resp.headers)
            body    = resp.text[:8000]

            # Header-based detection
            for header, pattern, tech in TECH_SIGNATURES:
                val = headers.get(header, "")
                match = re.search(pattern, val, re.IGNORECASE)
                if match:
                    version = match.group(1) if match.lastindex else ""
                    label   = f"{tech} {version}".strip()
                    if label not in detected:
                        detected.append(label)

            # Body-based detection
            for pattern, tech in BODY_SIGNATURES:
                if re.search(pattern, body, re.IGNORECASE):
                    if tech not in [d.split()[0] for d in detected]:
                        detected.append(tech)

            if detected:
                results.append(finding(
                    "stack_detected", "Technology stack identified",
                    "warn", "medium",
                    f"Detected: {', '.join(detected)}. Exposing software versions helps attackers target known CVEs.",
                    "Remove version strings from HTTP headers. Keep all software updated."
                ))
            else:
                results.append(finding(
                    "stack_hidden", "Technology stack — not detected", "pass", "info",
                    "No obvious technology stack signatures found in headers or page source."
                ))

    except Exception as e:
        results.append(finding("stack_error", "Stack detection", "warn", "low", f"Check failed: {e}"))
    return results


# ─── EMAIL SECURITY (SPF, DMARC, DKIM) ───────────────────────────────────────

async def check_email_security(hostname: str) -> List[dict]:
    results = []
    try:
        import dns.resolver
        DNS_OK = True
    except ImportError:
        DNS_OK = False

    if not DNS_OK:
        results.append(finding("email_lib", "Email security", "warn", "low",
                               "dnspython not installed.", "pip install dnspython"))
        return results

    loop = asyncio.get_event_loop()
    resolver = dns.resolver.Resolver()

    def _query(name, qtype):
        try:
            return [r.to_text() for r in resolver.resolve(name, qtype)]
        except Exception:
            return []

    # SPF
    txt = await loop.run_in_executor(None, _query, hostname, "TXT")
    spf = [r for r in txt if "v=spf1" in r.lower()]
    if spf:
        spf_val = spf[0]
        if "~all" in spf_val:
            results.append(finding("email_spf_soft", "SPF — softfail (~all)", "warn", "medium",
                                   f"SPF uses ~all (softfail) — spoofed emails may still be delivered.",
                                   "Consider upgrading to -all (hardfail) for stricter enforcement."))
        elif "-all" in spf_val:
            results.append(finding("email_spf", "SPF record", "pass", "info",
                                   f"SPF present with hardfail: {spf_val[:80]}"))
        else:
            results.append(finding("email_spf_weak", "SPF — weak policy", "warn", "medium",
                                   f"SPF present but policy may be too permissive: {spf_val[:80]}",
                                   "Tighten SPF policy to -all."))
    else:
        results.append(finding("email_spf_missing", "SPF record missing", "fail", "high",
                               "No SPF record — domain can be used for email spoofing.",
                               "Add TXT record: v=spf1 include:yourmailprovider.com -all"))

    # DMARC
    dmarc = await loop.run_in_executor(None, _query, f"_dmarc.{hostname}", "TXT")
    if dmarc:
        dmarc_val = dmarc[0]
        if "p=none" in dmarc_val:
            results.append(finding("email_dmarc_none", "DMARC — policy none", "warn", "medium",
                                   "DMARC present but policy is p=none — no enforcement.",
                                   "Change DMARC policy to p=quarantine or p=reject."))
        elif "p=quarantine" in dmarc_val:
            results.append(finding("email_dmarc", "DMARC — quarantine", "pass", "info",
                                   "DMARC present with quarantine policy."))
        elif "p=reject" in dmarc_val:
            results.append(finding("email_dmarc_strict", "DMARC — strict (reject)", "pass", "info",
                                   "DMARC present with strict reject policy. Excellent."))
    else:
        results.append(finding("email_dmarc_missing", "DMARC record missing", "fail", "high",
                               "No DMARC record — phishing and spoofing risk.",
                               "Add _dmarc TXT: v=DMARC1; p=quarantine; rua=mailto:dmarc@yourdomain.com"))

    # DKIM (check common selectors)
    dkim_found = False
    for selector in ["default", "google", "mail", "dkim", "k1", "selector1", "selector2"]:
        dkim = await loop.run_in_executor(None, _query, f"{selector}._domainkey.{hostname}", "TXT")
        if dkim:
            dkim_found = True
            results.append(finding("email_dkim", f"DKIM record found ({selector})", "pass", "info",
                                   f"DKIM selector '{selector}' present."))
            break

    if not dkim_found:
        results.append(finding("email_dkim_missing", "DKIM record not found", "warn", "medium",
                               "No DKIM record found for common selectors. Email authenticity cannot be verified.",
                               "Configure DKIM signing with your email provider and publish the public key."))

    return results


# ─── WAF DETECTION ────────────────────────────────────────────────────────────

WAF_SIGNATURES = [
    ("x-sucuri-id",           "Sucuri WAF"),
    ("x-sucuri-cache",        "Sucuri WAF"),
    ("x-firewall-protection", "Generic WAF"),
    ("x-waf-event-info",      "Generic WAF"),
    ("x-cloudflare-ray",      "Cloudflare"),
    ("cf-ray",                "Cloudflare"),
    ("x-amzn-requestid",      "AWS WAF/CloudFront"),
    ("x-akamai-transformed",  "Akamai"),
    ("x-cdn",                 "CDN/WAF"),
    ("x-iinfo",               "Imperva Incapsula"),
    ("x-cdn-geo",             "CDN"),
    ("server: sucuri",        "Sucuri WAF"),
    ("server: cloudflare",    "Cloudflare"),
]

async def check_waf(target: str) -> List[dict]:
    results = []
    try:
        async with httpx.AsyncClient(follow_redirects=True, timeout=15) as client:
            # Normal request
            resp = await client.get(target)
            headers_str = " ".join(f"{k.lower()}:{v.lower()}" for k, v in resp.headers.items())

            detected_waf = None
            for sig, waf_name in WAF_SIGNATURES:
                if sig.lower() in headers_str:
                    detected_waf = waf_name
                    break

            # Test with malicious payload to trigger WAF
            if not detected_waf:
                try:
                    r2 = await client.get(target + "/?test=<script>alert(1)</script>", timeout=8)
                    if r2.status_code in (403, 406, 429, 503):
                        detected_waf = "Unknown WAF (blocked malicious request)"
                except Exception:
                    pass

            if detected_waf:
                results.append(finding(
                    "waf_detected", f"WAF detected: {detected_waf}",
                    "pass", "info",
                    f"{detected_waf} is protecting this site. Malicious requests are likely being filtered.",
                ))
            else:
                results.append(finding(
                    "waf_none", "No WAF detected",
                    "warn", "medium",
                    "No Web Application Firewall detected. Site may be directly exposed to attacks.",
                    "Consider adding Cloudflare (free tier) or another WAF for basic protection."
                ))

    except Exception as e:
        results.append(finding("waf_error", "WAF detection", "warn", "low", f"Check failed: {e}"))
    return results


# ─── SESSION SECURITY ──────────────────────────────────────────────────────────

async def check_session_security(target: str) -> List[dict]:
    results = []
    try:
        async with httpx.AsyncClient(follow_redirects=True, timeout=15) as client:
            resp = await client.get(target)
            headers = dict(resp.headers)
            cookies_raw = str(resp.headers.get("set-cookie", "")).lower()

            # Session fixation — does session ID change after request?
            session_patterns = ["phpsessid", "jsessionid", "asp.net_sessionid", "sessionid", "sid"]
            session_found = any(p in cookies_raw for p in session_patterns)

            if session_found:
                # Check if session cookie has proper flags
                if "httponly" not in cookies_raw:
                    results.append(finding(
                        "session_httponly", "Session cookie missing HttpOnly",
                        "fail", "critical",
                        "Session cookie accessible via JavaScript — session hijacking risk via XSS.",
                        "Set HttpOnly flag on all session cookies."
                    ))
                if "secure" not in cookies_raw:
                    results.append(finding(
                        "session_secure", "Session cookie missing Secure flag",
                        "fail", "high",
                        "Session cookie transmitted over HTTP — interception risk.",
                        "Set Secure flag on session cookies to enforce HTTPS."
                    ))
                if "samesite" not in cookies_raw:
                    results.append(finding(
                        "session_samesite", "Session cookie missing SameSite",
                        "fail", "high",
                        "Session cookie lacks SameSite — CSRF attack possible.",
                        "Set SameSite=Strict on session cookies."
                    ))
                if all(f in cookies_raw for f in ["httponly", "secure", "samesite"]):
                    results.append(finding(
                        "session_secure_ok", "Session cookie well configured",
                        "pass", "info",
                        "Session cookie has HttpOnly, Secure, and SameSite flags."
                    ))
            else:
                results.append(finding(
                    "session_none", "No session cookie detected",
                    "info", "info",
                    "No standard session cookie found on this page."
                ))

            # Check for session in URL (very bad practice)
            url_query = str(getattr(resp.url, 'query', '') or '')
            if any(p in url_query for p in ["sessionid", "phpsessid", "sid", "token"]):
                results.append(finding(
                    "session_url", "Session ID in URL",
                    "fail", "critical",
                    "Session token found in URL — easily leaked via browser history, logs, referrer headers.",
                    "Never put session IDs in URLs. Use cookies exclusively."
                ))

    except Exception as e:
        results.append(finding("session_error", "Session security check", "warn", "low", f"Check failed: {e}"))
    return results


# ─── SMTP ENUMERATION ─────────────────────────────────────────────────────────

async def check_smtp(hostname: str) -> List[dict]:
    results = []
    smtp_ports = [25, 465, 587, 2525]
    open_smtp  = []

    loop = asyncio.get_event_loop()

    async def try_port(port):
        try:
            await loop.run_in_executor(
                None,
                lambda: socket.create_connection((hostname, port), timeout=1).close()
            )
            return port
        except Exception:
            return None

    port_results = await asyncio.gather(*[try_port(p) for p in smtp_ports])
    open_smtp = [p for p in port_results if p]

    if not open_smtp:
        results.append(finding("smtp_none", "SMTP ports", "info", "info",
                               "No SMTP ports open on this host."))
        return results

    # Per-port logic: port 25 is risky, submission ports are normal
    if 25 in open_smtp:
        results.append(finding("smtp_port25", "SMTP port 25 open",
            "warn", "medium",
            "Port 25 open — check for open relay and VRFY/EXPN enumeration.",
            "Disable VRFY/EXPN. Restrict relaying. Configure SPF/DMARC."))

    submission_ports = [p for p in open_smtp if p in (465, 587, 2525)]
    if submission_ports:
        results.append(finding("smtp_submission", f"SMTP submission port(s) open: {submission_ports}",
            "info", "info",
            f"Standard mail submission port(s) {submission_ports} open — expected for email service."))

    # Try banner grab on port 25
    if 25 in open_smtp:
        try:
            def _banner():
                s = socket.create_connection((hostname, 25), timeout=5)
                banner = s.recv(1024).decode(errors="ignore")
                s.close()
                return banner
            banner = await loop.run_in_executor(None, _banner)
            if banner:
                results.append(finding(
                    "smtp_banner", "SMTP banner",
                    "warn", "low",
                    f"SMTP banner: {banner[:100].strip()}",
                    "Hide SMTP software version from banner to reduce fingerprinting."
                ))
                # Check for VRFY
                vrfy_indicators = ["sendmail", "postfix", "exim", "exchange"]
                for indicator in vrfy_indicators:
                    if indicator in banner.lower():
                        results.append(finding(
                            "smtp_software", f"SMTP software identified: {indicator.title()}",
                            "warn", "medium",
                            f"SMTP software version disclosed in banner.",
                            "Configure SMTP banner to hide software and version."
                        ))
                        break
        except Exception:
            pass

    return results


# ─── SNIFFING EXPOSURE INDICATORS ────────────────────────────────────────────

async def check_sniffing_exposure(target: str) -> List[dict]:
    results = []
    try:
        async with httpx.AsyncClient(follow_redirects=True, timeout=15) as client:
            resp = await client.get(target)
            headers = dict(resp.headers)

            # Check if site uses HTTP (sniffable)
            if str(resp.url).startswith("http://"):
                results.append(finding(
                    "sniff_http", "Site served over HTTP",
                    "fail", "critical",
                    "All traffic including credentials is sent in plaintext — trivially sniffable on the same network.",
                    "Enforce HTTPS everywhere. Redirect all HTTP to HTTPS."
                ))
            else:
                results.append(finding(
                    "sniff_https", "Site uses HTTPS",
                    "pass", "info",
                    "Traffic is encrypted — passive sniffing of content is not possible."
                ))

            # HSTS check (prevents SSL stripping attacks)
            hsts = headers.get("strict-transport-security", "")
            if not hsts:
                results.append(finding(
                    "sniff_hsts", "HSTS not set — SSL stripping possible",
                    "fail", "high",
                    "Without HSTS, attackers on the same network can downgrade HTTPS to HTTP (SSL strip attack).",
                    "Add: Strict-Transport-Security: max-age=31536000; includeSubDomains; preload"
                ))
            else:
                results.append(finding(
                    "sniff_hsts_ok", "HSTS present", "pass", "info",
                    "HSTS prevents SSL stripping attacks."
                ))

            # Mixed content check
            body = resp.text[:5000]
            http_resources = re.findall(r'src=["\']http://[^"\']+["\']', body)
            if http_resources:
                results.append(finding(
                    "sniff_mixed", "Mixed content detected",
                    "fail", "high",
                    f"HTTP resources loaded on HTTPS page: {http_resources[0][:80]}. These can be intercepted.",
                    "Ensure all resources (scripts, images, fonts) are loaded over HTTPS."
                ))
            else:
                results.append(finding(
                    "sniff_mixed_ok", "No mixed content detected",
                    "pass", "info",
                    "No HTTP resources found on this HTTPS page."
                ))

    except Exception as e:
        results.append(finding("sniff_error", "Sniffing exposure check", "warn", "low", f"Check failed: {e}"))
    return results


# ─── MALWARE / BLACKLIST INDICATORS ──────────────────────────────────────────

MALWARE_PATTERNS = [
    (r'eval\s*\(\s*base64_decode',    "PHP base64 eval — common malware pattern"),
    (r'document\.write\s*\(\s*unescape', "JavaScript unescape injection"),
    (r'<iframe[^>]*style=["\'][^"\']*display:\s*none', "Hidden iframe — possible clickjacking/malware"),
    (r'\.onion',                          "Tor .onion reference in page"),
    (r'bitcoin|monero|cryptonight',       "Cryptocurrency mining reference"),
    (r'coinhive|coin-hive|mineralt',      "Cryptomining script detected"),
]

async def check_malware_indicators(target: str, hostname: str) -> List[dict]:
    results = []
    try:
        async with httpx.AsyncClient(follow_redirects=True, timeout=15) as client:
            resp = await client.get(target)
            body = resp.text

            found = []
            for pattern, description in MALWARE_PATTERNS:
                if re.search(pattern, body, re.IGNORECASE):
                    found.append(description)

            if found:
                for desc in found:
                    results.append(finding(
                        f"malware_{re.sub(r'[^a-z]', '_', desc.lower()[:20])}",
                        f"Malware indicator: {desc}",
                        "fail", "critical",
                        f"Suspicious pattern found in page source: {desc}",
                        "Investigate immediately. Site may be compromised. Scan server files."
                    ))
            else:
                results.append(finding(
                    "malware_clean", "Malware indicators — none found",
                    "pass", "info",
                    "No common malware patterns detected in page source."
                ))

            # Check Google Safe Browsing status via URL check
            # (Basic check — full integration requires API key)
            suspicious_tlds = [".tk", ".ml", ".ga", ".cf", ".gq"]
            if any(hostname.endswith(tld) for tld in suspicious_tlds):
                results.append(finding(
                    "malware_tld", "Suspicious TLD detected",
                    "warn", "medium",
                    f"Domain uses free TLD ({hostname}) — commonly associated with malicious sites.",
                    "Consider registering a reputable TLD (.com, .org, .net) for your platform."
                ))

    except Exception as e:
        results.append(finding("malware_error", "Malware check", "warn", "low", f"Check failed: {e}"))
    return results


# ─── DATABASE EXPOSURE ────────────────────────────────────────────────────────

DB_PORTS = {
    3306:  ("MySQL",      "critical", "MySQL exposed to internet — direct DB access possible."),
    5432:  ("PostgreSQL", "critical", "PostgreSQL exposed — direct DB access possible."),
    27017: ("MongoDB",    "critical", "MongoDB exposed — often unauthenticated by default."),
    6379:  ("Redis",      "critical", "Redis exposed — no auth by default, data theft risk."),
    1433:  ("MSSQL",      "critical", "Microsoft SQL Server exposed to internet."),
    1521:  ("Oracle DB",  "critical", "Oracle Database port exposed."),
    5984:  ("CouchDB",    "high",     "CouchDB exposed — check authentication."),
    9200:  ("Elasticsearch", "critical", "Elasticsearch exposed — often unauthenticated."),
    9042:  ("Cassandra",  "high",     "Cassandra exposed to internet."),
    28015: ("RethinkDB",  "high",     "RethinkDB exposed to internet."),
}

async def check_db_exposure(hostname: str) -> List[dict]:
    results = []
    exposed = []
    loop = asyncio.get_event_loop()

    async def try_port(port, service, severity, detail):
        try:
            await loop.run_in_executor(
                None,
                lambda: socket.create_connection((hostname, port), timeout=1).close()
            )
            return (port, service, severity, detail)
        except Exception:
            return None

    tasks = [try_port(port, *info) for port, info in DB_PORTS.items()]
    port_results = await asyncio.gather(*tasks)

    for result in port_results:
        if result:
            port, service, severity, detail = result
            exposed.append(service)
            results.append(finding(
                f"db_port_{port}", f"{service} port {port} exposed",
                "fail", severity,
                f"{detail} Port {port} is open and reachable from the internet.",
                f"Firewall port {port}. Database servers should never be directly internet-accessible."
            ))

    if not exposed:
        results.append(finding(
            "db_none_exposed", "Database ports — none exposed",
            "pass", "info",
            f"Checked {len(DB_PORTS)} common database ports — none publicly reachable."
        ))

    return results


# ─── VIRUSTOTAL URL REPUTATION ────────────────────────────────────────────────

async def check_virustotal(target: str) -> List[dict]:
    results = []
    if not VIRUSTOTAL_API_KEY:
        results.append(finding(
            "vt_no_key", "VirusTotal — API key not configured",
            "warn", "low",
            "Set the VIRUSTOTAL_API_KEY environment variable to enable this check.",
            "Export VIRUSTOTAL_API_KEY=<your_key> before starting the API."
        ))
        return results

    try:
        vt_headers = {
            "x-apikey": VIRUSTOTAL_API_KEY,
            "content-type": "application/x-www-form-urlencoded",
        }
        async with httpx.AsyncClient(timeout=60) as client:
            # Step 1: submit URL
            resp = await client.post(
                "https://www.virustotal.com/api/v3/urls",
                headers=vt_headers,
                data={"url": target},
            )
            if resp.status_code not in (200, 201):
                results.append(finding(
                    "vt_submit_err", "VirusTotal — submission failed",
                    "warn", "low",
                    f"VirusTotal API returned HTTP {resp.status_code}. Check API key or quota."
                ))
                return results

            analysis_id = resp.json()["data"]["id"]

            # Step 2: Poll up to 6 times every 5 seconds until status == "completed"
            attrs = None
            for attempt in range(6):
                await asyncio.sleep(5)
                r2 = await client.get(
                    f"https://www.virustotal.com/api/v3/analyses/{analysis_id}",
                    headers={"x-apikey": VIRUSTOTAL_API_KEY},
                )
                if r2.status_code == 200:
                    data = r2.json()["data"]
                    if data["attributes"].get("status") == "completed":
                        attrs = data["attributes"]
                        break

            if attrs is None:
                results.append(finding("vt_timeout", "VirusTotal — analysis timed out", "warn", "low",
                    "Analysis did not complete within 30 seconds. Try again."))
                return results

            stats      = attrs.get("stats", {})
            malicious  = stats.get("malicious",  0)
            suspicious = stats.get("suspicious", 0)
            harmless   = stats.get("harmless",   0)
            undetected = stats.get("undetected", 0)
            total      = malicious + suspicious + harmless + undetected

            # Collect names of engines that flagged it
            raw_results = attrs.get("results", {})
            flagged_engines = [
                name for name, data in raw_results.items()
                if data.get("category") in ("malicious", "phishing", "malware")
            ]
            engine_list = ", ".join(flagged_engines[:6]) + ("…" if len(flagged_engines) > 6 else "")

            if malicious >= 3:
                results.append(finding(
                    "vt_malicious", "VirusTotal — URL flagged MALICIOUS",
                    "fail", "critical",
                    f"{malicious}/{total} engines flagged this URL as malicious"
                    + (f" ({engine_list})." if engine_list else ".")
                    + (f" {suspicious} suspicious." if suspicious else ""),
                    "URL is actively flagged by multiple engines. Investigate for compromise or phishing immediately."
                ))
            elif malicious >= 1:
                results.append(finding(
                    "vt_malicious_low", "VirusTotal — URL flagged by engine(s)",
                    "fail", "high",
                    f"{malicious}/{total} engine(s) flagged this URL"
                    + (f" ({engine_list})." if engine_list else ".")
                    + (f" {suspicious} suspicious." if suspicious else ""),
                    "Review the flagged URL. May be a false positive but warrants investigation."
                ))
            elif suspicious > 0:
                results.append(finding(
                    "vt_suspicious", "VirusTotal — URL marked suspicious",
                    "warn", "medium",
                    f"{suspicious}/{total} engines marked this URL suspicious (0 malicious).",
                    "Monitor the URL and review VirusTotal report for context."
                ))
            else:
                results.append(finding(
                    "vt_clean", "VirusTotal — URL reputation clean",
                    "pass", "info",
                    f"0/{total} engines flagged this URL. Harmless: {harmless}, Undetected: {undetected}."
                ))

    except Exception as e:
        results.append(finding(
            "vt_error", "VirusTotal check",
            "warn", "low", f"VirusTotal check failed: {e}"
        ))
    return results


# ─── NVD CVE LOOKUP ───────────────────────────────────────────────────────────

NVD_VERSION_PATTERNS = [
    (r"Apache/([\d.]+)",  "Apache HTTP Server"),
    (r"nginx/([\d.]+)",   "nginx"),
    (r"PHP/([\d.]+)",     "PHP"),
    (r"OpenSSL/([\d.]+)", "OpenSSL"),
    (r"IIS/([\d.]+)",     "Microsoft IIS"),
]

BODY_VERSION_PATTERNS = [
    (r'<meta[^>]+name=["\']generator["\'][^>]+content=["\']([^"\']+)["\']', None),  # parse name+version from content
    (r'jquery[.\-]([\d]+\.[\d]+\.[\d]+)(?:\.min)?\.js', "jQuery"),
    (r'bootstrap[.\-]([\d]+\.[\d]+\.[\d]+)(?:\.min)?\.(?:js|css)', "Bootstrap"),
    (r'angular[.\-]([\d]+\.[\d]+\.[\d]+)(?:\.min)?\.js', "Angular"),
    (r'react[.\-]([\d]+\.[\d]+\.[\d]+)(?:\.min)?\.js', "React"),
    (r'vue[.\-]([\d]+\.[\d]+\.[\d]+)(?:\.min)?\.js', "Vue.js"),
    (r'\?ver=([\d]+\.[\d]+\.?[\d]*)', "WordPress component"),  # WordPress ?ver= query param
]

def _detect_versions_from_body(body: str) -> list:
    """Scan HTML body for software version strings. Returns list of (software, version) tuples."""
    detected = []
    seen = set()

    for pattern, software in BODY_VERSION_PATTERNS:
        for match in re.finditer(pattern, body, re.IGNORECASE):
            version_str = match.group(1)
            if software is None:
                # Generator meta tag — try to parse "Software X.Y.Z" from content
                content = version_str.strip()
                # Look for version number in the content string
                ver_match = re.search(r'([\w\s]+?)\s+([\d]+\.[\d]+\.?[\d]*)', content)
                if ver_match:
                    sw_name = ver_match.group(1).strip()
                    sw_ver  = ver_match.group(2)
                    key = (sw_name.lower(), sw_ver)
                    if key not in seen:
                        seen.add(key)
                        detected.append((sw_name, sw_ver))
                else:
                    # No version found, skip
                    pass
            else:
                key = (software.lower(), version_str)
                if key not in seen:
                    seen.add(key)
                    detected.append((software, version_str))

    return detected


async def check_nvd_cve(target: str) -> List[dict]:
    results = []
    try:
        async with httpx.AsyncClient(follow_redirects=True, timeout=15) as client:
            resp = await client.get(target)
            headers_str = " ".join(f"{k}: {v}" for k, v in resp.headers.items())
            body = resp.text[:20000]

            detected = []
            for pattern, software in NVD_VERSION_PATTERNS:
                m = re.search(pattern, headers_str, re.IGNORECASE)
                if m:
                    detected.append((software, m.group(1)))

            # Also scan body for version strings
            body_versions = _detect_versions_from_body(body)
            for sw, ver in body_versions:
                # Deduplicate against header detections
                if not any(d[0].lower() == sw.lower() for d in detected):
                    detected.append((sw, ver))

            if not detected:
                results.append(finding(
                    "nvd_no_versions", "NVD CVE lookup — no versions detected",
                    "info", "info",
                    "No software version strings found in response headers or page body to query NVD against."
                ))
                return results

        # Query NVD for each detected software+version
        nvd_headers = {}
        if NVD_API_KEY:
            nvd_headers["apiKey"] = NVD_API_KEY

        async with httpx.AsyncClient(timeout=20) as nvd_client:
            for software, version in detected:
                keyword = f"{software} {version}"
                try:
                    r = await nvd_client.get(
                        "https://services.nvd.nist.gov/rest/json/cves/2.0",
                        params={"keywordSearch": keyword, "resultsPerPage": 3},
                        headers=nvd_headers,
                    )
                    if r.status_code != 200:
                        results.append(finding(
                            f"nvd_{software.lower().replace(' ', '_')}_err",
                            f"NVD lookup failed for {software} {version}",
                            "warn", "low",
                            f"NVD API returned HTTP {r.status_code}."
                        ))
                        continue

                    vulns = r.json().get("vulnerabilities", [])
                    if not vulns:
                        results.append(finding(
                            f"nvd_{software.lower().replace(' ', '_')}_clean",
                            f"NVD: No CVEs found for {software} {version}",
                            "info", "info",
                            f"NVD returned 0 CVEs matching '{keyword}'."
                        ))
                        continue

                    for item in vulns[:3]:
                        cve   = item.get("cve", {})
                        cve_id = cve.get("id", "CVE-UNKNOWN")
                        desc  = next(
                            (d["value"] for d in cve.get("descriptions", []) if d.get("lang") == "en"),
                            "No description available."
                        )

                        # Extract best available CVSS score
                        metrics = cve.get("metrics", {})
                        cvss_score = None
                        for key in ["cvssMetricV31", "cvssMetricV30", "cvssMetricV2"]:
                            ml = metrics.get(key, [])
                            if ml:
                                cvss_score = ml[0].get("cvssData", {}).get("baseScore")
                                break

                        if cvss_score is None:
                            severity = "medium"
                        elif cvss_score >= 9.0:
                            severity = "critical"
                        elif cvss_score >= 7.0:
                            severity = "high"
                        elif cvss_score >= 4.0:
                            severity = "medium"
                        else:
                            severity = "low"

                        status     = "fail" if severity in ("critical", "high") else "warn"
                        score_str  = f"CVSS {cvss_score:.1f}" if cvss_score is not None else "CVSS N/A"
                        safe_id    = cve_id.lower().replace("-", "_")

                        results.append(finding(
                            f"nvd_{safe_id}",
                            f"{cve_id} — {software} {version} ({score_str})",
                            status, severity,
                            desc[:250],
                            f"Update {software} to the latest patched release. "
                            f"Details: https://nvd.nist.gov/vuln/detail/{cve_id}"
                        ))

                except Exception:
                    continue

    except Exception as e:
        results.append(finding(
            "nvd_error", "NVD CVE lookup",
            "warn", "low", f"NVD check failed: {e}"
        ))
    return results


# ─── SUBDOMAIN ENUMERATION ────────────────────────────────────────────────────

async def check_subdomains(target: str) -> List[dict]:
    results = []
    try:
        hostname = target.replace("https://", "").replace("http://", "").split("/")[0]
        parts = hostname.split(".")
        base_domain = ".".join(parts[-2:]) if len(parts) >= 2 else hostname

        url = f"https://crt.sh/?q=%.{base_domain}&output=json"

        async with httpx.AsyncClient(timeout=20, follow_redirects=True) as client:
            try:
                resp = await client.get(url)
                if resp.status_code != 200:
                    results.append(finding("subdomains_error", "Subdomain enumeration", "warn", "low",
                                           f"crt.sh returned HTTP {resp.status_code}."))
                    return results

                data = resp.json()
            except Exception as e:
                results.append(finding("subdomains_error", "Subdomain enumeration", "warn", "low",
                                       f"crt.sh query failed: {e}"))
                return results

        # Extract unique subdomains, filter wildcards
        subdomains = set()
        for entry in data:
            name = entry.get("name_value", "")
            for sub in name.split("\n"):
                sub = sub.strip().lower()
                if sub and not sub.startswith("*") and sub.endswith(base_domain):
                    subdomains.add(sub)

        subdomains = sorted(subdomains)
        total = len(subdomains)

        if total == 0:
            results.append(finding("subdomains_none", "Subdomain enumeration", "pass", "info",
                                   f"No subdomains found for {base_domain} via certificate transparency."))
            return results

        # Check DNS resolution and flag suspicious names
        suspicious_keywords = ["admin", "dev", "staging", "test", "api", "internal", "beta", "old", "backup"]
        suspicious_found = []
        loop = asyncio.get_event_loop()

        try:
            import dns.resolver
            resolver = dns.resolver.Resolver()

            async def _resolve(sub):
                try:
                    await loop.run_in_executor(None, lambda: resolver.resolve(sub, "A"))
                    return sub
                except Exception:
                    return None

            resolve_tasks = [_resolve(sub) for sub in subdomains[:50]]
            resolved = [s for s in await asyncio.gather(*resolve_tasks) if s]
        except ImportError:
            resolved = list(subdomains[:50])

        for sub in resolved:
            sub_label = sub.replace(f".{base_domain}", "").replace(base_domain, "")
            if any(kw in sub_label for kw in suspicious_keywords):
                suspicious_found.append(sub)

        # Report top 10 subdomains
        top10 = subdomains[:10]
        results.append(finding(
            "subdomains_found", f"Found {total} subdomains for {base_domain}",
            "info", "info",
            f"Certificate transparency reveals {total} subdomain(s). Sample: {', '.join(top10)}"
            + (f" (and {total - 10} more)" if total > 10 else "")
        ))

        if suspicious_found:
            results.append(finding(
                "subdomains_suspicious", "Suspicious subdomains detected",
                "warn", "medium",
                f"Potentially sensitive subdomains found: {', '.join(suspicious_found[:10])}",
                "Review these subdomains. Dev/staging/admin environments should not be publicly accessible."
            ))
        else:
            results.append(finding(
                "subdomains_ok", "No suspicious subdomains detected",
                "pass", "info",
                "No subdomains with suspicious names (admin, dev, staging, etc.) found."
            ))

    except Exception as e:
        results.append(finding("subdomains_error", "Subdomain enumeration", "warn", "low",
                               f"Subdomain check failed: {e}"))
    return results


# ─── CORS MISCONFIGURATION ────────────────────────────────────────────────────

async def check_cors(target: str) -> List[dict]:
    results = []
    evil_origin = "https://evil-hakdel-test.com"
    try:
        async with httpx.AsyncClient(follow_redirects=True, timeout=15) as client:
            resp = await client.get(target, headers={"Origin": evil_origin})
            acao = resp.headers.get("access-control-allow-origin", "")
            acac = resp.headers.get("access-control-allow-credentials", "").lower()

            if acao == evil_origin:
                results.append(finding(
                    "cors_reflect", "CORS — origin reflected (critical)",
                    "fail", "critical",
                    f"Server reflects arbitrary Origin header: '{acao}'. Attackers can make cross-origin requests on behalf of users.",
                    "Validate Origin against a strict allowlist. Never reflect arbitrary origins."
                ))
            elif acao == "*" and acac == "true":
                results.append(finding(
                    "cors_wildcard_creds", "CORS — wildcard with credentials",
                    "fail", "high",
                    "Access-Control-Allow-Origin: * combined with Access-Control-Allow-Credentials: true — browsers block this but it indicates misconfiguration.",
                    "Remove credentials flag or restrict origin to specific domains."
                ))
            elif acao == "*":
                results.append(finding(
                    "cors_wildcard", "CORS — wildcard origin",
                    "warn", "medium",
                    "Access-Control-Allow-Origin: * allows any website to read responses. Acceptable for public APIs, risky for authenticated endpoints.",
                    "Restrict CORS to known trusted origins if the endpoint serves authenticated data."
                ))
            elif acao:
                results.append(finding(
                    "cors_ok", "CORS policy configured",
                    "pass", "info",
                    f"CORS origin restricted to: {acao[:80]}"
                ))
            else:
                results.append(finding(
                    "cors_ok", "CORS — no cross-origin header",
                    "pass", "info",
                    "No CORS headers returned — cross-origin requests are blocked by default."
                ))

    except Exception as e:
        results.append(finding("cors_error", "CORS check", "warn", "low", f"CORS check failed: {e}"))
    return results


# ─── HTTP METHOD TESTING ──────────────────────────────────────────────────────

async def check_http_methods(target: str) -> List[dict]:
    results = []
    try:
        async with httpx.AsyncClient(follow_redirects=True, timeout=15) as client:
            # OPTIONS request to discover allowed methods
            try:
                opts = await client.options(target, timeout=8)
                allow_header = opts.headers.get("allow", "") or opts.headers.get("Access-Control-Allow-Methods", "")
            except Exception:
                allow_header = ""

            safe_methods = {"GET", "POST", "HEAD", "OPTIONS"}
            dangerous_found = []
            unusual_found = []

            # Test TRACE
            try:
                trace_resp = await client.request("TRACE", target, timeout=8)
                if trace_resp.status_code == 200:
                    dangerous_found.append("TRACE")
                    results.append(finding(
                        "methods_trace", "HTTP TRACE method enabled",
                        "fail", "critical",
                        "TRACE method returns 200 — Cross-Site Tracing (XST) attack possible. Credentials in headers can be leaked.",
                        "Disable TRACE method in your web server configuration."
                    ))
            except Exception:
                pass

            # Test PUT
            try:
                put_resp = await client.put(target, content=b"test", timeout=8)
                if put_resp.status_code in (200, 201, 204):
                    dangerous_found.append("PUT")
                    results.append(finding(
                        "methods_put", "HTTP PUT method allowed",
                        "fail", "high",
                        f"PUT method returned {put_resp.status_code} — arbitrary file upload may be possible.",
                        "Disable PUT method unless required by your API. Authenticate all write operations."
                    ))
            except Exception:
                pass

            # Test DELETE
            try:
                del_resp = await client.delete(target, timeout=8)
                if del_resp.status_code in (200, 204):
                    dangerous_found.append("DELETE")
                    results.append(finding(
                        "methods_delete", "HTTP DELETE method allowed",
                        "fail", "high",
                        f"DELETE method returned {del_resp.status_code} — resource deletion may be unauthenticated.",
                        "Disable DELETE method unless required. Require authentication for all destructive operations."
                    ))
            except Exception:
                pass

            # Check Allow header for unusual methods
            if allow_header:
                allowed = {m.strip().upper() for m in allow_header.split(",")}
                unusual_found = [m for m in allowed if m not in safe_methods and m not in dangerous_found]
                if unusual_found:
                    results.append(finding(
                        "methods_unusual", f"Unusual HTTP methods in Allow header: {unusual_found}",
                        "warn", "low",
                        f"Server advertises non-standard methods: {', '.join(unusual_found)}",
                        "Review whether these methods are required and restrict accordingly."
                    ))

            if not dangerous_found and not unusual_found:
                results.append(finding(
                    "methods_ok", "HTTP methods — no dangerous methods found",
                    "pass", "info",
                    "TRACE, PUT, DELETE not accessible. Standard methods only."
                ))

    except Exception as e:
        results.append(finding("methods_error", "HTTP methods check", "warn", "low", f"Check failed: {e}"))
    return results


# ─── RATE LIMITING DETECTION ──────────────────────────────────────────────────

async def check_rate_limiting(target: str) -> List[dict]:
    results = []
    try:
        async with httpx.AsyncClient(follow_redirects=True, timeout=15) as client:
            # Send 10 concurrent GET requests
            tasks = [client.get(target, timeout=8) for _ in range(10)]
            responses = await asyncio.gather(*tasks, return_exceptions=True)

            got_429 = False
            has_ratelimit_headers = False
            has_retry_after = False

            for resp in responses:
                if isinstance(resp, Exception):
                    continue
                if resp.status_code == 429:
                    got_429 = True
                rl_headers = [h for h in resp.headers.keys() if h.lower().startswith("x-ratelimit")]
                if rl_headers:
                    has_ratelimit_headers = True
                if resp.headers.get("retry-after"):
                    has_retry_after = True

            if got_429:
                results.append(finding(
                    "ratelimit_ok", "Rate limiting — 429 response detected",
                    "pass", "info",
                    "Server returned HTTP 429 (Too Many Requests) — rate limiting is active."
                ))
            elif has_ratelimit_headers:
                results.append(finding(
                    "ratelimit_ok", "Rate limiting — headers detected",
                    "pass", "info",
                    "X-RateLimit-* headers present — rate limiting is configured."
                ))
            elif has_retry_after:
                results.append(finding(
                    "ratelimit_ok", "Rate limiting — Retry-After header detected",
                    "pass", "info",
                    "Retry-After header present — server indicates rate limiting."
                ))
            else:
                results.append(finding(
                    "ratelimit_none", "No rate limiting detected",
                    "fail", "high",
                    "10 concurrent requests completed without any 429 or rate limit headers. Brute force and scraping attacks may be unrestricted.",
                    "Implement rate limiting (e.g., nginx limit_req, Cloudflare rules, or application-level throttling)."
                ))

    except Exception as e:
        results.append(finding("ratelimit_error", "Rate limiting check", "warn", "low", f"Check failed: {e}"))
    return results


# ─── OPEN REDIRECT DETECTION ─────────────────────────────────────────────────

async def check_open_redirect(target: str) -> List[dict]:
    results = []
    evil_url = "https://evil-hakdel-test.com"
    redirect_params = [
        "next", "url", "redirect", "return", "goto", "dest",
        "destination", "forward", "redir", "redirect_uri", "return_url"
    ]
    try:
        async with httpx.AsyncClient(follow_redirects=False, timeout=15) as client:
            # First fetch the page to find existing URL parameters
            try:
                resp = await client.get(target, timeout=8)
                body = resp.text[:10000]
            except Exception:
                body = ""

            # Look for redirect-like params in existing links and forms
            found_params = set()
            # Check href and action attributes
            param_pattern = re.compile(
                r'(?:href|action|src)=["\'][^"\']*[?&](' + '|'.join(redirect_params) + r')=',
                re.IGNORECASE
            )
            for match in param_pattern.finditer(body):
                found_params.add(match.group(1).lower())

            if not found_params:
                results.append(finding(
                    "redirect_none", "Open redirect — no redirect parameters found",
                    "pass", "info",
                    "No common redirect URL parameters detected on the page."
                ))
                return results

            # Test each found parameter with evil URL
            vulnerable = False
            for param in found_params:
                test_url = f"{target.rstrip('/')}?{param}={evil_url}"
                try:
                    r = await client.get(test_url, timeout=8)
                    location = r.headers.get("location", "")
                    if evil_url in location:
                        vulnerable = True
                        results.append(finding(
                            "redirect_open", f"Open redirect via parameter '{param}'",
                            "fail", "critical",
                            f"Server redirects to attacker-controlled URL via '?{param}=' parameter. Location: {location[:100]}",
                            "Validate redirect destinations against a strict allowlist. Never redirect to arbitrary URLs."
                        ))
                except Exception:
                    pass

            if not vulnerable:
                results.append(finding(
                    "redirect_none", "Open redirect — parameters tested, none vulnerable",
                    "pass", "info",
                    f"Tested redirect parameter(s) {list(found_params)} — no open redirect detected."
                ))

    except Exception as e:
        results.append(finding("redirect_error", "Open redirect check", "warn", "low", f"Check failed: {e}"))
    return results
