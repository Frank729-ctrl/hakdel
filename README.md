# HakDel

A cybersecurity operations platform for blue teamers, students, and security professionals.

---

## What it does

HakDel brings together the tools and training that security teams actually use, in one place:

- **Site Scanner** — deep security analysis of any web target: TLS, headers, DNS, exposed paths, CMS fingerprinting, SQLi/XSS surface, WAF detection, and more. Scored 0–100 with letter grades.
- **Security Tools** — IP reputation, file hash lookup, CVE search, port scanning, network utilities (DNS, WHOIS, HTTP headers).
- **OSINT Suite** — domain intelligence, subdomain enumeration, security headers grading, URL/phishing checks, email record analysis (SPF/DMARC/DKIM).
- **Watchlist** — monitor domains for SSL expiry and DNS changes with email alerts.
- **Incident Tracker** — log, triage, and track security incidents with severity/status workflow.
- **Labs** — SSH into purpose-built vulnerable environments, complete challenges, submit flags for XP.
- **CEH Quiz** — practice questions across all 20 CEH domains with instant explanations.
- **XP & Levels** — earn experience for every action; streak bonuses, leaderboard ranking, badges.
- **Notifications** — platform-wide alert system with real-time badge counts.
- **2FA** — TOTP-based two-factor authentication with backup codes.
- **Google OAuth** — sign in or register with Google.
- **Subscriptions** — 30-day free trial, then monthly/annual Pro plan via Paystack.

---

## Tech Stack

### Frontend
| Technology | Purpose |
|---|---|
| PHP 8.1 | Server-side rendering, routing, auth, business logic |
| Vanilla JavaScript (ES6+) | UI interactivity, AJAX, SSE streaming, dropdowns |
| CSS3 (custom, no framework) | Dark theme design system with CSS variables |
| HTML5 | Semantic markup |

### Backend / API
| Technology | Purpose |
|---|---|
| Python 3.10+ | Scanner API runtime |
| FastAPI | REST API framework for the scanner engine |
| httpx | Async HTTP requests in scanner modules |
| dnspython | DNS record resolution in scanner |
| uvicorn | ASGI server for FastAPI |

### Database & Storage
| Technology | Purpose |
|---|---|
| MySQL 8 | Primary database — users, scans, tools, labs, XP |
| PDO (PHP) | Database access layer with prepared statements |

### Authentication & Security
| Technology | Purpose |
|---|---|
| bcrypt (PHP) | Password hashing (cost factor 12) |
| TOTP / RFC 6238 | Two-factor authentication (implemented in pure PHP) |
| Google OAuth 2.0 | Social login via Google |
| CSRF tokens | Form protection on all state-changing requests |
| Session tokens | 256-bit random server-side session management |

### Payments
| Technology | Purpose |
|---|---|
| Paystack | Subscription billing — cards + mobile money |

### Email
| Technology | Purpose |
|---|---|
| PHPMailer | SMTP email delivery |
| Custom HTML templates | Welcome, verification, watchlist alert, password reset emails |

### External APIs
| API | Used for |
|---|---|
| VirusTotal | Hash lookup, URL reputation, IP reputation |
| AbuseIPDB | IP abuse scoring |
| Shodan | Open ports and services on IPs |
| NVD (NIST) | CVE data and CVSS scores |
| Google Safe Browsing | URL phishing/malware classification |
| PhishTank | Phishing URL verification |
| HackerTarget | Port scanning, reverse IP lookup |
| crt.sh | Certificate transparency — subdomain enumeration |
| Anthropic Claude API | AI-powered scan result interpretation (SSE streaming) |
| QR Server | TOTP QR code generation for 2FA setup |

### Infrastructure
| Technology | Purpose |
|---|---|
| Linux (Ubuntu Server) | Lab VM host |
| OpenSSH | Lab access — users SSH into challenge environments |
| Composer | PHP dependency management |

---

## Self-hosting

This is the source for the live platform. Self-hosting is possible but not officially supported — the setup involves several moving parts (scanner API, lab VMs, external API keys, mail config) that require manual wiring. If you want to run your own instance, read through the source; it's well-structured.

`.env.example` lists all required environment variables.

---

## Legal

- Only scan targets you own or have explicit written permission to test.
- Unauthorized scanning may violate computer misuse laws in your jurisdiction.
- Lab environments are intentionally vulnerable — do not expose them to the public internet.
- See [Terms of Service](/legal/terms.php) and [Privacy Policy](/legal/privacy.php) for platform usage terms.

---

## License

MIT — built by Frank Dela.
# hakdel
# hakdel
