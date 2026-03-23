#!/usr/bin/env python3
"""
HakDel Project Migration Script
================================
Run from the hakdel/ root directory:

    python3 migrate.py           # dry run — shows every action, writes nothing
    python3 migrate.py --apply   # executes the migration

What this does
--------------
1. Creates the new directory structure
2. Copies every PHP file to its new location with updated paths
3. Copies Python scanner modules to api/app/scanner/
4. Writes new Python package files (main.py, routers, models, services)
5. Writes new standard files (.env.example, .gitignore, docker-compose.yml,
   vercel.json, railway.toml, start-dev.sh)

Originals are NOT deleted — verify the new files, then remove the old ones
using the cleanup commands printed at the end.
"""

import sys
import shutil
from pathlib import Path

DRY = "--apply" not in sys.argv
ROOT = Path(__file__).parent
FE   = ROOT / "frontend"
API  = ROOT / "api"
DB   = ROOT / "database"
OLD  = ROOT / "scanner-api"


# ── Helpers ────────────────────────────────────────────────────────────────────

def log(msg: str) -> None:
    print(msg)

def mkdir(path: Path) -> None:
    if not DRY:
        path.mkdir(parents=True, exist_ok=True)
    log(f"  mkdir   {path.relative_to(ROOT)}")

def transform_copy(src: Path, dst: Path, repls: list[tuple[str, str]]) -> None:
    """Copy src → dst applying string replacements. Skips if src missing."""
    if not src.exists():
        log(f"  SKIP    {src.relative_to(ROOT)} (not found)")
        return
    content = src.read_text(encoding="utf-8")
    for old, new in repls:
        content = content.replace(old, new)
    if not DRY:
        dst.parent.mkdir(parents=True, exist_ok=True)
        dst.write_text(content, encoding="utf-8")
    log(f"  copy    {src.relative_to(ROOT)}  →  {dst.relative_to(ROOT)}")

def plain_copy(src: Path, dst: Path) -> None:
    if not src.exists():
        log(f"  SKIP    {src.relative_to(ROOT)} (not found)")
        return
    if not DRY:
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)
    log(f"  copy    {src.relative_to(ROOT)}  →  {dst.relative_to(ROOT)}")

def create(path: Path, content: str) -> None:
    if not DRY:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")
    log(f"  create  {path.relative_to(ROOT)}")


# ── Replacement sets ───────────────────────────────────────────────────────────

# config.php moved to config/app.php — update credentials to use env vars,
# and fix the require_login() redirect that references the old /login.php path.
CONFIG_REPLS = [
    ("define('DB_HOST', 'localhost')",
     "define('DB_HOST',   getenv('DB_HOST')   ?: 'localhost')"),
    ("define('DB_NAME', 'hakdel')",
     "define('DB_NAME',   getenv('DB_NAME')   ?: 'hakdel')"),
    ("define('DB_USER', 'root')",
     "define('DB_USER',   getenv('DB_USER')   ?: 'root')"),
    # Remove the hardcoded password — use env var, fall back to empty string
    ("define('DB_PASS', 'Shequan123!')",
     "define('DB_PASS',   getenv('DB_PASS')   ?: '')"),
    ("define('DB_PORT', 3306)",
     "define('DB_PORT',   (int)(getenv('DB_PORT')   ?: 3306))"),
    ("define('API_BASE', 'http://localhost:8000')",
     "define('API_BASE',  getenv('API_BASE')  ?: 'http://localhost:8000')"),
    ("define('SITE_URL', 'http://localhost:8080')",
     "define('SITE_URL',  getenv('SITE_URL')  ?: 'http://localhost:8080')"),
    # Auth redirect inside require_login()
    ("header('Location: /login.php')",
     "header('Location: /auth/login.php')"),
    ('header("Location: /login.php")',
     'header("Location: /auth/login.php")'),
]

# require_once fixes — depth determines relative path to config/app.php
REQUIRE_ROOT = [   # frontend/index.php (stays at root)
    ("require_once 'config.php'",
     "require_once __DIR__ . '/config/app.php'"),
    ('require_once "config.php"',
     'require_once __DIR__ . "/config/app.php"'),
]
REQUIRE_SUBDIR = [  # files moved one level deep: auth/, scanner/, labs/, etc.
    ("require_once 'config.php'",
     "require_once __DIR__ . '/../config/app.php'"),
    ('require_once "config.php"',
     'require_once __DIR__ . "/../config/app.php"'),
]
REQUIRE_ADMIN = [   # admin/* (was already one level deep, referenced ../config.php)
    ("require_once '../config.php'",
     "require_once __DIR__ . '/../config/app.php'"),
    ('require_once "../config.php"',
     'require_once __DIR__ . "/../config/app.php"'),
]

# PHP redirect() calls — all use absolute paths so they work from any subdir
REDIRECTS = [
    ("redirect('/scanner.php')",      "redirect('/scanner/')"),
    ('redirect("/scanner.php")',      'redirect("/scanner/")'),
    ("redirect('/login.php')",        "redirect('/auth/login.php')"),
    ('redirect("/login.php")',        'redirect("/auth/login.php")'),
    ("redirect('/register.php')",     "redirect('/auth/register.php')"),
    ('redirect("/register.php")',     'redirect("/auth/register.php")'),
    ("redirect('/labs.php')",         "redirect('/labs/')"),
    ('redirect("/labs.php")',         'redirect("/labs/")'),
    # submit_flag.php: $back = '/lab.php?slug=' . urlencode(...)
    ("= '/lab.php?slug='",            "= '/labs/view.php?slug='"),
    # lab.php inline: redirect('/labs.php') already covered above;
    # lab.php inline: redirect('/lab.php?...) not present — redirects go to /labs.php
]

# Nav <a href="..."> — use absolute paths so every page's nav just works
NAV_HREFS = [
    ('href="scanner.php"',      'href="/scanner/"'),
    ('href="history.php"',      'href="/scanner/history.php"'),
    # labs.php appears twice: nav link AND inline back-link in lab.php
    ('href="labs.php"',         'href="/labs/"'),
    # dynamic lab card links: href="lab.php?slug=..."
    ('"lab.php?slug=',          '"/labs/view.php?slug='),
    ('href="quiz.php"',         'href="/quiz/"'),
    ('href="leaderboard.php"',  'href="/leaderboard/"'),
    ('href="profile.php"',      'href="/profile/"'),
    ('href="about.php"',        'href="/about/"'),
    ('href="logout.php"',       'href="/auth/logout.php"'),
    ('href="login.php"',        'href="/auth/login.php"'),
    ('href="register.php"',     'href="/auth/register.php"'),
]

# HTML form action attributes
FORM_ACTIONS = [
    ('action="/login.php"',      'action="/auth/login.php"'),
    ('action="/register.php"',   'action="/auth/register.php"'),
    # lab.php flag form (was relative; now absolute so it works from labs/)
    ('action="submit_flag.php"', 'action="/labs/submit.php"'),
]

# JavaScript fetch() calls — use absolute paths for safety across directories
JS_FETCH = [
    ("fetch('save_scan.php',",          "fetch('/scanner/save.php',"),
    ('fetch("save_scan.php",',          'fetch("/scanner/save.php",'),
    ("fetch('get_scan.php?id='",        "fetch('/scanner/get.php?id='"),
    ('fetch("get_scan.php?id="',        'fetch("/scanner/get.php?id="'),
    ("fetch('save_quiz_answer.php',",   "fetch('/quiz/save_answer.php',"),
    ('fetch("save_quiz_answer.php",',   'fetch("/quiz/save_answer.php",'),
    ("fetch('award_xp.php',",           "fetch('/quiz/award_xp.php',"),
    ('fetch("award_xp.php",',           'fetch("/quiz/award_xp.php",'),
]

# CSS <link href="assets/..."> — absolute so subdirectory pages resolve correctly
CSS_ASSETS = [
    ('href="assets/style.css"',   'href="/assets/style.css"'),
    ('href="assets/layout.css"',  'href="/assets/layout.css"'),
    ('href="assets/auth.css"',    'href="/assets/auth.css"'),
]

def subdir_repls() -> list:
    """All replacements for PHP files moved into a feature subdirectory."""
    return REQUIRE_SUBDIR + REDIRECTS + NAV_HREFS + FORM_ACTIONS + JS_FETCH + CSS_ASSETS

def root_repls() -> list:
    """Replacements for index.php, which stays at the frontend root."""
    return REQUIRE_ROOT + REDIRECTS + NAV_HREFS + CSS_ASSETS

def admin_repls() -> list:
    """Replacements for admin/* files (already one level deep)."""
    return REQUIRE_ADMIN + REDIRECTS


# ── Migration steps ────────────────────────────────────────────────────────────

def step1_create_dirs() -> None:
    log("\n[1/6] Creating directories")
    for d in [
        API / "app" / "routers",
        API / "app" / "models",
        API / "app" / "services",
        API / "app" / "scanner",
        API / "tests",
        FE / "config",
        FE / "auth",
        FE / "scanner",
        FE / "labs",
        FE / "quiz",
        FE / "leaderboard",
        FE / "profile",
        FE / "about",
        DB / "seeds",
    ]:
        mkdir(d)


def step2_php_frontend() -> None:
    log("\n[2/6] Migrating PHP frontend")

    # config.php → config/app.php  (env vars + auth redirect)
    transform_copy(FE/"config.php",   FE/"config"/"app.php",  CONFIG_REPLS)

    # index.php stays at root — only require + redirect paths change
    transform_copy(FE/"index.php",    FE/"index.php",          root_repls())

    # auth/
    transform_copy(FE/"login.php",    FE/"auth"/"login.php",    subdir_repls())
    transform_copy(FE/"register.php", FE/"auth"/"register.php", subdir_repls())
    transform_copy(FE/"logout.php",   FE/"auth"/"logout.php",   subdir_repls())

    # scanner/
    transform_copy(FE/"scanner.php",    FE/"scanner"/"index.php",  subdir_repls())
    transform_copy(FE/"save_scan.php",  FE/"scanner"/"save.php",   subdir_repls())
    transform_copy(FE/"history.php",    FE/"scanner"/"history.php",subdir_repls())
    transform_copy(FE/"get_scan.php",   FE/"scanner"/"get.php",    subdir_repls())

    # labs/
    transform_copy(FE/"labs.php",        FE/"labs"/"index.php",  subdir_repls())
    transform_copy(FE/"lab.php",         FE/"labs"/"view.php",   subdir_repls())
    transform_copy(FE/"submit_flag.php", FE/"labs"/"submit.php", subdir_repls())

    # quiz/
    transform_copy(FE/"quiz.php",             FE/"quiz"/"index.php",      subdir_repls())
    transform_copy(FE/"save_quiz_answer.php",  FE/"quiz"/"save_answer.php",subdir_repls())
    transform_copy(FE/"award_xp.php",          FE/"quiz"/"award_xp.php",  subdir_repls())

    # standalone pages
    transform_copy(FE/"leaderboard.php", FE/"leaderboard"/"index.php", subdir_repls())
    transform_copy(FE/"profile.php",     FE/"profile"/"index.php",     subdir_repls())
    transform_copy(FE/"about.php",       FE/"about"/"index.php",       subdir_repls())

    # admin/ — stays in place, only config require path changes
    transform_copy(FE/"admin"/"admin_config.php", FE/"admin"/"admin_config.php", admin_repls())
    transform_copy(FE/"admin"/"index.php",         FE/"admin"/"index.php",        admin_repls())
    transform_copy(FE/"admin"/"dashboard.php",     FE/"admin"/"dashboard.php",    admin_repls())
    transform_copy(FE/"admin"/"logout.php",        FE/"admin"/"logout.php",       admin_repls())
    # admin.css — unchanged
    # assets/ — unchanged (CSS uses absolute paths already after above replacements)


def step3_python_scanner_modules() -> None:
    log("\n[3/6] Moving Python scanner modules → api/app/scanner/")
    for f in ["__init__.py", "passive.py", "active.py", "advanced.py", "score.py"]:
        plain_copy(OLD/"scanner"/f, API/"app"/"scanner"/f)
    plain_copy(OLD/"requirements.txt", API/"requirements.txt")
    plain_copy(OLD/"Procfile",         API/"Procfile")


def step4_python_package() -> None:
    log("\n[4/6] Creating Python package files")

    # Empty __init__ files
    for p in [
        API/"app"/"__init__.py",
        API/"app"/"routers"/"__init__.py",
        API/"app"/"models"/"__init__.py",
        API/"app"/"services"/"__init__.py",
        API/"tests"/"__init__.py",
    ]:
        create(p, "")

    create(API / "main.py", """\
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import scan

app = FastAPI(title="HakDel Scanner API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["GET", "POST"],
    allow_headers=["*"],
)


@app.get("/")
def root():
    return {"platform": "HakDel", "status": "online"}


app.include_router(scan.router, prefix="/scan", tags=["scan"])
""")

    create(API / "app" / "models" / "scan.py", """\
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
    ]
    profile: Optional[str] = "quick"
""")

    create(API / "app" / "routers" / "scan.py", """\
import uuid
import time
from fastapi import APIRouter, BackgroundTasks, HTTPException
from ..models.scan import ScanRequest
from ..services import scanner as scanner_svc

router = APIRouter()

PROFILE_ESTIMATES = {"quick": 45, "full": 180, "custom": 90}

# In-memory job store — replace with Redis for multi-worker production deployments
jobs: dict = {}


@router.post("/start")
async def start_scan(req: ScanRequest, background_tasks: BackgroundTasks):
    job_id = str(uuid.uuid4())
    jobs[job_id] = {
        "status":     "pending",
        "progress":   0,
        "result":     None,
        "error":      None,
        "started_at": time.time(),
        "estimated":  PROFILE_ESTIMATES.get(req.profile or "quick", 90),
    }
    background_tasks.add_task(scanner_svc.run_scan_job, jobs, job_id, req)
    return {"job_id": job_id, "status": "pending"}


@router.get("/status/{job_id}")
def scan_status(job_id: str):
    if job_id not in jobs:
        raise HTTPException(status_code=404, detail="Job not found")
    job      = jobs[job_id]
    elapsed  = int(time.time() - job.get("started_at", time.time()))
    estimated = job.get("estimated", 90)
    return {
        "job_id":    job_id,
        "status":    job["status"],
        "progress":  job["progress"],
        "elapsed":   elapsed,
        "estimated": estimated,
        "remaining": max(0, estimated - elapsed),
        "result":    job["result"] if job["status"] == "done" else None,
        "error":     job["error"],
    }
""")

    create(API / "app" / "services" / "scanner.py", """\
import time
from ..scanner.passive  import run_passive_checks
from ..scanner.active   import run_active_checks
from ..scanner.advanced import run_advanced_checks
from ..scanner.score    import calculate_score


async def run_scan_job(jobs: dict, job_id: str, req) -> None:
    \"\"\"Orchestrate all scanner modules and write results back into jobs dict.\"\"\"
    try:
        jobs[job_id]["status"] = "running"
        target   = str(req.url).rstrip("/")
        modules  = req.modules
        findings = []

        jobs[job_id]["progress"] = 10
        findings.extend(await run_passive_checks(target, modules))
        jobs[job_id]["progress"] = 40

        findings.extend(await run_active_checks(target, modules))
        jobs[job_id]["progress"] = 70

        findings.extend(await run_advanced_checks(target, modules))
        jobs[job_id]["progress"] = 85

        score_data = calculate_score(findings)
        jobs[job_id].update({
            "progress": 100,
            "status":   "done",
            "result": {
                "target":     target,
                "scanned_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
                "findings":   findings,
                "score":      score_data["score"],
                "grade":      score_data["grade"],
                "summary":    score_data["summary"],
            },
        })
    except Exception as exc:
        jobs[job_id]["status"] = "error"
        jobs[job_id]["error"]  = str(exc)
""")


def step5_standard_files() -> None:
    log("\n[5/6] Creating standard config files")

    create(API / "railway.toml", """\
[build]
builder = "nixpacks"

[deploy]
startCommand = "uvicorn main:app --host 0.0.0.0 --port $PORT"
healthcheckPath = "/"
healthcheckTimeout = 30
restartPolicyType = "on_failure"
restartPolicyMaxRetries = 3
""")

    create(API / ".env.example", """\
# Scanner API — copy to api/.env and fill in values
PORT=8000
ALLOWED_ORIGINS=http://localhost:8080,https://your-frontend.vercel.app
""")

    create(ROOT / ".env.example", """\
# HakDel — copy to .env and fill in values
# This file is safe to commit. The actual .env is gitignored.

# ── Database (PHP frontend) ────────────────────────────────────────────────────
DB_HOST=localhost
DB_PORT=3306
DB_NAME=hakdel
DB_USER=root
DB_PASS=

# ── Scanner API ────────────────────────────────────────────────────────────────
API_BASE=http://localhost:8000

# ── Frontend ───────────────────────────────────────────────────────────────────
SITE_URL=http://localhost:8080
APP_ENV=development
""")

    create(ROOT / ".gitignore", """\
# ── Python ────────────────────────────────────────────────────────────────────
__pycache__/
*.py[cod]
*.pyo
.venv/
venv/
env/
*.egg-info/
dist/
build/
.pytest_cache/
.mypy_cache/

# ── Environment & secrets ─────────────────────────────────────────────────────
.env
.env.local
.env.production
*.env.local

# ── PHP ───────────────────────────────────────────────────────────────────────
frontend/vendor/
frontend/composer.lock

# ── OS ────────────────────────────────────────────────────────────────────────
.DS_Store
Thumbs.db
desktop.ini

# ── IDE ───────────────────────────────────────────────────────────────────────
.vscode/settings.json
.idea/
*.swp
*.swo

# ── Logs ──────────────────────────────────────────────────────────────────────
*.log
logs/

# ── Docker ────────────────────────────────────────────────────────────────────
docker-compose.override.yml
""")

    create(ROOT / "docker-compose.yml", """\
version: "3.9"

# HakDel — Lab VM containers
# Each lab is an isolated Ubuntu 22.04 container with:
#   - SSH on a fixed host port
#   - A planted flag.txt with restricted permissions (400)
#   - Lab challenge files mounted from ./labs/<slug>/
#
# Usage:
#   docker-compose up -d                     # start all labs
#   docker-compose up -d lab-recon-basics    # start one lab
#   ssh labuser@localhost -p 2201            # connect to lab 1
#
# Add new labs by copying a service block and incrementing the port.

x-lab-defaults: &lab-defaults
  image: ubuntu:22.04
  restart: unless-stopped
  networks:
    - labs

services:

  # ── Lab 1: Recon Basics ───────────────────────────────────────────────────
  lab-recon-basics:
    <<: *lab-defaults
    container_name: hakdel-lab-recon-basics
    hostname: recon-basics
    ports:
      - "2201:22"
    environment:
      LAB_USER: labuser
      LAB_PASS: "Hakd3l@Lab1"
      FLAG: "flag{recon_m4st3r_2024}"
    volumes:
      - ./labs/recon-basics:/opt/lab:ro
    command: >
      bash -c "
        apt-get update -qq &&
        DEBIAN_FRONTEND=noninteractive apt-get install -y -qq openssh-server &&
        mkdir /run/sshd &&
        useradd -m -s /bin/bash $$LAB_USER &&
        echo \"$$LAB_USER:$$LAB_PASS\" | chpasswd &&
        install -d -m 700 -o $$LAB_USER /home/$$LAB_USER/.flag &&
        echo \"$$FLAG\" > /home/$$LAB_USER/.flag/flag.txt &&
        chown $$LAB_USER /home/$$LAB_USER/.flag/flag.txt &&
        chmod 400 /home/$$LAB_USER/.flag/flag.txt &&
        /usr/sbin/sshd -D
      "

  # ── Lab 2: Web Headers ────────────────────────────────────────────────────
  lab-web-headers:
    <<: *lab-defaults
    container_name: hakdel-lab-web-headers
    hostname: web-headers
    ports:
      - "2202:22"
    environment:
      LAB_USER: labuser
      LAB_PASS: "Hakd3l@Lab2"
      FLAG: "flag{h3aders_sp34k_v0lumes}"
    volumes:
      - ./labs/web-headers:/opt/lab:ro
    command: >
      bash -c "
        apt-get update -qq &&
        DEBIAN_FRONTEND=noninteractive apt-get install -y -qq openssh-server &&
        mkdir /run/sshd &&
        useradd -m -s /bin/bash $$LAB_USER &&
        echo \"$$LAB_USER:$$LAB_PASS\" | chpasswd &&
        install -d -m 700 -o $$LAB_USER /home/$$LAB_USER/.flag &&
        echo \"$$FLAG\" > /home/$$LAB_USER/.flag/flag.txt &&
        chown $$LAB_USER /home/$$LAB_USER/.flag/flag.txt &&
        chmod 400 /home/$$LAB_USER/.flag/flag.txt &&
        /usr/sbin/sshd -D
      "

  # ── Lab 3: SQL Injection ──────────────────────────────────────────────────
  lab-sqli:
    <<: *lab-defaults
    container_name: hakdel-lab-sqli
    hostname: sqli-lab
    ports:
      - "2203:22"
    environment:
      LAB_USER: labuser
      LAB_PASS: "Hakd3l@Lab3"
      FLAG: "flag{sqli_byp4ss_pr0}"
    volumes:
      - ./labs/sqli:/opt/lab:ro
    command: >
      bash -c "
        apt-get update -qq &&
        DEBIAN_FRONTEND=noninteractive apt-get install -y -qq openssh-server &&
        mkdir /run/sshd &&
        useradd -m -s /bin/bash $$LAB_USER &&
        echo \"$$LAB_USER:$$LAB_PASS\" | chpasswd &&
        install -d -m 700 -o $$LAB_USER /home/$$LAB_USER/.flag &&
        echo \"$$FLAG\" > /home/$$LAB_USER/.flag/flag.txt &&
        chown $$LAB_USER /home/$$LAB_USER/.flag/flag.txt &&
        chmod 400 /home/$$LAB_USER/.flag/flag.txt &&
        /usr/sbin/sshd -D
      "

networks:
  labs:
    driver: bridge
""")

    create(FE / "vercel.json", """\
{
  "functions": {
    "**/*.php": { "runtime": "@vercel/php@0.6.0" }
  },
  "rewrites": [
    { "source": "/",                 "destination": "/index.php"               },
    { "source": "/scanner",          "destination": "/scanner/index.php"       },
    { "source": "/scanner/history",  "destination": "/scanner/history.php"     },
    { "source": "/scanner/save",     "destination": "/scanner/save.php"        },
    { "source": "/scanner/get",      "destination": "/scanner/get.php"         },
    { "source": "/labs",             "destination": "/labs/index.php"          },
    { "source": "/labs/view",        "destination": "/labs/view.php"           },
    { "source": "/labs/submit",      "destination": "/labs/submit.php"         },
    { "source": "/quiz",             "destination": "/quiz/index.php"          },
    { "source": "/quiz/answer",      "destination": "/quiz/save_answer.php"    },
    { "source": "/quiz/xp",          "destination": "/quiz/award_xp.php"       },
    { "source": "/leaderboard",      "destination": "/leaderboard/index.php"   },
    { "source": "/profile",          "destination": "/profile/index.php"       },
    { "source": "/about",            "destination": "/about/index.php"         },
    { "source": "/auth/login",       "destination": "/auth/login.php"          },
    { "source": "/auth/register",    "destination": "/auth/register.php"       },
    { "source": "/auth/logout",      "destination": "/auth/logout.php"         },
    { "source": "/admin",            "destination": "/admin/index.php"         },
    { "source": "/admin/dashboard",  "destination": "/admin/dashboard.php"     }
  ]
}
""")

    create(ROOT / "start-dev.sh", """\
#!/bin/bash
# HakDel Local Dev — run from hakdel/ root: bash start-dev.sh

echo ""
echo " ================================="
echo "  HAKDEL — Local Dev Environment"
echo " ================================="
echo ""

echo "[1/2] Starting Scanner API on http://localhost:8000 ..."
cd api
python3 -m uvicorn main:app --reload --port 8000 &
API_PID=$!
cd ..

sleep 1

echo "[2/2] Starting PHP frontend on http://localhost:8080 ..."
cd frontend
php -S localhost:8080 &
PHP_PID=$!
cd ..

echo ""
echo " Both servers running:"
echo "   Frontend : http://localhost:8080/auth/login.php"
echo "   API docs : http://localhost:8000/docs"
echo ""
echo " Press Ctrl+C to stop both servers."
echo ""

trap "kill $API_PID $PHP_PID 2>/dev/null; echo 'Servers stopped.'" EXIT
wait
""")

    create(ROOT / "start-dev.bat", """\
@echo off
REM HakDel Local Dev — run from hakdel\\ root

echo.
echo  =================================
echo   HAKDEL - Local Dev Environment
echo  =================================
echo.

echo [1/2] Starting Scanner API on http://localhost:8000 ...
start "HakDel API" cmd /k "cd api && python -m uvicorn main:app --reload --port 8000"

timeout /t 2 /nobreak >nul

echo [2/2] Starting PHP frontend on http://localhost:8080 ...
start "HakDel Frontend" cmd /k "cd frontend && php -S localhost:8080"

echo.
echo  Both servers starting in separate windows.
echo    Frontend : http://localhost:8080/auth/login.php
echo    API docs : http://localhost:8000/docs
echo.
pause
""")


def step6_database_seeds() -> None:
    log("\n[6/6] Creating database seeds directory")
    # Seeds are extracted from schema.sql — create placeholder files
    # showing which INSERT blocks belong where.
    create(DB / "seeds" / "badges.sql", """\
-- HakDel seed data: badges
-- Extract the INSERT INTO badges (...) block from ../schema.sql and paste here.
-- Run: mysql -u root -p hakdel < badges.sql
""")
    create(DB / "seeds" / "labs.sql", """\
-- HakDel seed data: sample labs
-- Extract the INSERT INTO labs (...) block from ../schema.sql and paste here.
-- Run: mysql -u root -p hakdel < labs.sql
""")
    create(DB / "seeds" / "quiz_questions.sql", """\
-- HakDel seed data: CEH quiz questions
-- Extract the INSERT INTO quiz_questions (...) block from ../schema.sql and paste here.
-- Run: mysql -u root -p hakdel < quiz_questions.sql
""")


# ── Entry point ────────────────────────────────────────────────────────────────

def main() -> None:
    log("=" * 65)
    log(f"HakDel Migration{'  [DRY RUN — pass --apply to execute]' if DRY else ''}")
    log("=" * 65)

    step1_create_dirs()
    step2_php_frontend()
    step3_python_scanner_modules()
    step4_python_package()
    step5_standard_files()
    step6_database_seeds()

    log("\n" + "=" * 65)
    if DRY:
        log("Dry run complete. Nothing was written.")
        log("Run  python3 migrate.py --apply  to execute.")
    else:
        log("Migration complete!")
        log("")
        log("Next steps:")
        log("")
        log("  1. Test locally:")
        log("       bash start-dev.sh")
        log("       open http://localhost:8080/auth/login.php")
        log("")
        log("  2. Once verified, remove the old flat PHP files:")
        log("       cd frontend && rm -f config.php login.php register.php logout.php \\")
        log("         scanner.php save_scan.php history.php get_scan.php \\")
        log("         labs.php lab.php submit_flag.php quiz.php \\")
        log("         save_quiz_answer.php award_xp.php leaderboard.php \\")
        log("         profile.php about.php")
        log("")
        log("  3. Remove the old scanner-api directory:")
        log("       rm -rf scanner-api/")
        log("")
        log("  4. Set up environment:")
        log("       cp .env.example .env        # fill in DB_PASS")
        log("       cp api/.env.example api/.env")
        log("")
        log("  5. Split seed data from database/schema.sql into database/seeds/")
        log("     (badges.sql, labs.sql, quiz_questions.sql)")
        log("")
        log("  6. Delete this script:")
        log("       rm migrate.py")
    log("=" * 65)


if __name__ == "__main__":
    main()
