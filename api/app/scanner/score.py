from typing import List

# Weight deducted per severity level per failing check
SEVERITY_WEIGHTS = {
    "critical": 25,
    "high":     15,
    "medium":    8,
    "low":       3,
    "info":      0,
}

# Checks that add bonus points when passed
BONUS_CHECKS = {
    "ssl_expiry":                        5,
    "ssl_protocol":                      5,
    "ssl_cipher":                        5,
    "hdr_content-security-policy":      10,
    "hdr_strict-transport-security":     8,
    "hdr_x-frame-options":               5,
    "dns_spf":                           4,
    "dns_dmarc":                         4,
    "dns_dnssec":                        3,
    "whois_privacy":                     3,
    "cms_none":                          2,
    "cve_headers":                       3,
    # New modules
    "waf_detected":                      8,
    "sniff_https":                       5,
    "sniff_hsts_ok":                     5,
    "sniff_mixed_ok":                    3,
    "session_secure_ok":                 6,
    "malware_clean":                     5,
    "db_none_exposed":                   8,
    "email_spf_strict":                  4,
    "email_dmarc_strict":                4,
    "email_dkim":                        3,
    "xss_not_found":                     4,
    "sqli_not_found":                    4,
    "dirs_clean":                        4,
    "access_clean":                      4,
    # Threat intel
    "vt_clean":                         10,
    "nvd_no_versions":                   5,
    # New modules
    "cors_ok":                           6,
    "methods_ok":                        4,
    "ratelimit_ok":                      6,
    "redirect_none":                     4,
    "subdomains_ok":                     2,
}

GRADE_TABLE = [
    (90, "A", "Excellent"),
    (75, "B", "Good"),
    (60, "C+", "Fair"),
    (50, "C", "Below Average"),
    (35, "D", "Poor"),
    (0,  "F", "Critical Risk"),
]


def calculate_score(findings: List[dict]) -> dict:
    score = 100
    passed = 0
    failed = 0
    warned = 0
    critical_findings = []
    high_findings = []

    for f in findings:
        status = f.get("status")
        severity = f.get("severity", "info")
        check_id = f.get("id", "")

        if status == "fail":
            deduction = SEVERITY_WEIGHTS.get(severity, 0)
            score -= deduction
            failed += 1
            if severity == "critical":
                critical_findings.append(f["title"])
            elif severity == "high":
                high_findings.append(f["title"])

        elif status == "pass":
            bonus = BONUS_CHECKS.get(check_id, 0)
            score += bonus
            passed += 1

        elif status == "warn":
            score -= SEVERITY_WEIGHTS.get(severity, 0) // 2
            warned += 1

    # Clamp
    score = max(0, min(100, score))

    # Grade
    grade = "F"
    grade_label = "Critical Risk"
    for threshold, g, label in GRADE_TABLE:
        if score >= threshold:
            grade = g
            grade_label = label
            break

    # Summary
    summary_parts = []
    if critical_findings:
        summary_parts.append(f"{len(critical_findings)} critical issue(s): {', '.join(critical_findings[:2])}")
    if high_findings:
        summary_parts.append(f"{len(high_findings)} high-severity issue(s)")
    if not summary_parts:
        if score >= 75:
            summary_parts.append("Site is well-configured. Minor hardening recommended.")
        else:
            summary_parts.append("Several issues found. Review findings and remediate.")

    return {
        "score": round(score),
        "grade": grade,
        "grade_label": grade_label,
        "passed": passed,
        "failed": failed,
        "warned": warned,
        "total": len(findings),
        "summary": ". ".join(summary_parts),
    }
