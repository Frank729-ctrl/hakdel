from pydantic import BaseModel
from typing import Optional, List


class ScanRequest(BaseModel):
    url: str
    modules: Optional[List[str]] = [
        "whois", "ssl", "headers", "dns",
        "ports", "cms", "cve",
        "cookies", "xss", "sqli", "dirs",
        "access", "stack", "email", "waf",
        "session", "smtp", "sniffing", "malware", "db",
        "virustotal", "nvd",
        "subdomains", "cors", "methods", "ratelimit", "redirect",
    ]
    profile: Optional[str] = "quick"
