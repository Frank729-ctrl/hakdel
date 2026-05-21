-- HakDel — PostgreSQL schema (Supabase)
-- Run: psql $DATABASE_URL -f schema_postgres.sql

-- ── Shared trigger for updated_at ────────────────────────────
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

-- ── USERS ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    id                      SERIAL PRIMARY KEY,
    username                VARCHAR(40)  NOT NULL UNIQUE,
    email                   VARCHAR(120) NOT NULL UNIQUE,
    google_id               VARCHAR(64)  UNIQUE,
    email_verified          BOOLEAN      NOT NULL DEFAULT FALSE,
    password_hash           VARCHAR(255) NOT NULL DEFAULT '',
    role                    TEXT         NOT NULL DEFAULT 'student' CHECK (role IN ('student','admin')),
    plan                    TEXT         NOT NULL DEFAULT 'free'    CHECK (plan IN ('free','pro')),
    plan_expires_at         TIMESTAMP,
    stripe_customer_id      VARCHAR(255),
    stripe_subscription_id  VARCHAR(255),
    xp                      INTEGER      NOT NULL DEFAULT 0,
    level                   SMALLINT     NOT NULL DEFAULT 1,
    streak_days             SMALLINT     NOT NULL DEFAULT 0,
    longest_streak          SMALLINT     NOT NULL DEFAULT 0,
    last_active             DATE,
    avatar_initials         VARCHAR(3),
    created_at              TIMESTAMP    DEFAULT NOW(),
    updated_at              TIMESTAMP    DEFAULT NOW()
);
CREATE TRIGGER users_updated_at BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ── SESSIONS ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS sessions (
    token       CHAR(64)  PRIMARY KEY,
    user_id     INTEGER   NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    expires_at  TIMESTAMP NOT NULL,
    created_at  TIMESTAMP DEFAULT NOW()
);

-- ── SCANS ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS scans (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER,
    job_id      CHAR(36)  NOT NULL UNIQUE,
    target_url  VARCHAR(500) NOT NULL,
    profile     TEXT DEFAULT 'quick' CHECK (profile IN ('quick','full','custom')),
    modules     JSONB,
    status      TEXT DEFAULT 'pending' CHECK (status IN ('pending','running','done','error')),
    score       SMALLINT,
    grade       VARCHAR(3),
    summary     TEXT,
    result_json TEXT,
    scanned_at  TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);
CREATE INDEX IF NOT EXISTS idx_scans_user   ON scans (user_id);
CREATE INDEX IF NOT EXISTS idx_scans_status ON scans (status);

-- ── LABS ─────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS labs (
    id             SERIAL PRIMARY KEY,
    slug           VARCHAR(60)  NOT NULL UNIQUE,
    title          VARCHAR(120) NOT NULL,
    description    TEXT,
    category       VARCHAR(60),
    difficulty     TEXT DEFAULT 'easy' CHECK (difficulty IN ('easy','medium','hard','expert')),
    xp_reward      SMALLINT     DEFAULT 100,
    level_required SMALLINT     DEFAULT 1,
    flag_hash      CHAR(64),
    instructions   TEXT,
    hints          JSONB,
    is_active      BOOLEAN      DEFAULT TRUE,
    sort_order     SMALLINT     DEFAULT 0,
    created_at     TIMESTAMP    DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS lab_attempts (
    id             SERIAL PRIMARY KEY,
    user_id        INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    lab_id         INTEGER NOT NULL REFERENCES labs(id)  ON DELETE CASCADE,
    status         TEXT DEFAULT 'started' CHECK (status IN ('started','solved','failed')),
    attempts_count SMALLINT  DEFAULT 0,
    solved_at      TIMESTAMP,
    started_at     TIMESTAMP DEFAULT NOW(),
    UNIQUE (user_id, lab_id)
);

-- ── QUIZ ─────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS quiz_categories (
    id             SERIAL PRIMARY KEY,
    slug           VARCHAR(60)  NOT NULL UNIQUE,
    name           VARCHAR(80)  NOT NULL,
    description    TEXT,
    icon           VARCHAR(10),
    level_required SMALLINT     DEFAULT 1,
    sort_order     SMALLINT     DEFAULT 0,
    intro_text     TEXT,
    key_concepts   JSONB,
    is_active      BOOLEAN      DEFAULT TRUE,
    created_at     TIMESTAMP    DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS quiz_questions (
    id            SERIAL PRIMARY KEY,
    domain        VARCHAR(80),
    domain_number SMALLINT,
    category      VARCHAR(60),
    tier          SMALLINT     DEFAULT 1,
    points        SMALLINT     DEFAULT 10,
    question      TEXT         NOT NULL,
    option_a      VARCHAR(400) NOT NULL,
    option_b      VARCHAR(400) NOT NULL,
    option_c      VARCHAR(400) NOT NULL,
    option_d      VARCHAR(400) NOT NULL,
    correct       TEXT         NOT NULL CHECK (correct IN ('a','b','c','d')),
    explanation   TEXT,
    difficulty    TEXT DEFAULT 'medium' CHECK (difficulty IN ('easy','medium','hard')),
    is_active     BOOLEAN      DEFAULT TRUE,
    created_at    TIMESTAMP    DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS quiz_attempts (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER NOT NULL REFERENCES users(id)           ON DELETE CASCADE,
    question_id INTEGER NOT NULL REFERENCES quiz_questions(id)  ON DELETE CASCADE,
    answer      TEXT    NOT NULL CHECK (answer IN ('a','b','c','d')),
    is_correct  BOOLEAN NOT NULL,
    answered_at TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_user ON quiz_attempts (user_id);

CREATE TABLE IF NOT EXISTS quiz_tier_progress (
    id             SERIAL PRIMARY KEY,
    user_id        INTEGER      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category_slug  VARCHAR(60)  NOT NULL,
    tier           SMALLINT     NOT NULL DEFAULT 1,
    questions_done SMALLINT     DEFAULT 0,
    correct_count  SMALLINT     DEFAULT 0,
    unlocked       BOOLEAN      DEFAULT FALSE,
    unlocked_at    TIMESTAMP,
    UNIQUE (user_id, category_slug, tier)
);
CREATE INDEX IF NOT EXISTS idx_qtp_user ON quiz_tier_progress (user_id, category_slug);

-- ── BADGES ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS badges (
    id              SERIAL PRIMARY KEY,
    slug            VARCHAR(60)  NOT NULL UNIQUE,
    name            VARCHAR(80)  NOT NULL,
    description     VARCHAR(255),
    icon            VARCHAR(10),
    condition_type  TEXT CHECK (condition_type IN ('labs_solved','xp_reached','streak','quiz_score','scan_count')),
    condition_value INTEGER
);

CREATE TABLE IF NOT EXISTS user_badges (
    user_id   INTEGER NOT NULL REFERENCES users(id)  ON DELETE CASCADE,
    badge_id  INTEGER NOT NULL REFERENCES badges(id) ON DELETE CASCADE,
    earned_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (user_id, badge_id)
);

-- ── XP LOG ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS xp_log (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER  NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    amount      INTEGER  NOT NULL,
    source      TEXT     NOT NULL CHECK (source IN ('lab_complete','quiz_session','tier_unlock','level_bonus','daily_streak','manual')),
    source_ref  INTEGER,
    description VARCHAR(255),
    created_at  TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_xp_log_user    ON xp_log (user_id);
CREATE INDEX IF NOT EXISTS idx_xp_log_source  ON xp_log (source);
CREATE INDEX IF NOT EXISTS idx_xp_log_created ON xp_log (created_at);

-- ── EMAIL AUTH ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS email_verifications (
    id         SERIAL PRIMARY KEY,
    user_id    INTEGER      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token      VARCHAR(64)  NOT NULL UNIQUE,
    created_at TIMESTAMP    NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMP    NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_ev_token ON email_verifications (token);
CREATE INDEX IF NOT EXISTS idx_ev_user  ON email_verifications (user_id);

CREATE TABLE IF NOT EXISTS password_resets (
    id         SERIAL PRIMARY KEY,
    email      VARCHAR(255) NOT NULL,
    token      VARCHAR(64)  NOT NULL UNIQUE,
    created_at TIMESTAMP    NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMP    NOT NULL,
    used       BOOLEAN      NOT NULL DEFAULT FALSE
);
CREATE INDEX IF NOT EXISTS idx_pr_token ON password_resets (token);
CREATE INDEX IF NOT EXISTS idx_pr_email ON password_resets (email);

-- ── USER 2FA ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS user_2fa (
    user_id      INTEGER      NOT NULL PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    secret       VARCHAR(32)  NOT NULL,
    backup_codes JSONB,
    enabled_at   TIMESTAMP    DEFAULT NOW()
);

-- ── USER SETTINGS ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS user_settings (
    user_id               INTEGER NOT NULL PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    notif_watchlist_email BOOLEAN DEFAULT TRUE,
    notif_scan_email      BOOLEAN DEFAULT FALSE,
    notif_badge_email     BOOLEAN DEFAULT FALSE,
    updated_at            TIMESTAMP DEFAULT NOW()
);
CREATE TRIGGER user_settings_updated_at BEFORE UPDATE ON user_settings
FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- ── NOTIFICATIONS ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS notifications (
    id         SERIAL PRIMARY KEY,
    user_id    INTEGER      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type       VARCHAR(50)  NOT NULL,
    title      VARCHAR(255) NOT NULL,
    message    TEXT,
    link       VARCHAR(512) DEFAULT '',
    is_read    BOOLEAN      DEFAULT FALSE,
    created_at TIMESTAMP    DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_notif_user ON notifications (user_id, is_read);

-- ── INCIDENTS ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS incidents (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title       VARCHAR(255) NOT NULL,
    severity    TEXT DEFAULT 'medium' CHECK (severity IN ('critical','high','medium','low','info')),
    status      TEXT DEFAULT 'open'   CHECK (status  IN ('open','investigating','contained','resolved','closed')),
    description TEXT,
    created_at  TIMESTAMP DEFAULT NOW(),
    updated_at  TIMESTAMP DEFAULT NOW()
);
CREATE TRIGGER incidents_updated_at BEFORE UPDATE ON incidents
FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE INDEX IF NOT EXISTS idx_incidents_user ON incidents (user_id, status);

CREATE TABLE IF NOT EXISTS incident_notes (
    id          SERIAL PRIMARY KEY,
    incident_id INTEGER NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    user_id     INTEGER NOT NULL REFERENCES users(id)     ON DELETE CASCADE,
    note        TEXT    NOT NULL,
    created_at  TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_incident_notes ON incident_notes (incident_id);

CREATE TABLE IF NOT EXISTS incident_evidence (
    id          SERIAL PRIMARY KEY,
    incident_id INTEGER      NOT NULL REFERENCES incidents(id) ON DELETE CASCADE,
    type        VARCHAR(30)  NOT NULL,
    ref_id      INTEGER,
    title       VARCHAR(255),
    detail      TEXT,
    added_at    TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_incident_evidence ON incident_evidence (incident_id);

-- ── WATCHLIST ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS watchlist (
    id               SERIAL PRIMARY KEY,
    user_id          INTEGER      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    domain           VARCHAR(255) NOT NULL,
    check_ssl        BOOLEAN      DEFAULT TRUE,
    check_dns        BOOLEAN      DEFAULT TRUE,
    alert_email      VARCHAR(255),
    ssl_expiry_days  INTEGER,
    ssl_last_checked TIMESTAMP,
    dns_snapshot     JSONB,
    dns_last_checked TIMESTAMP,
    is_active        BOOLEAN      DEFAULT TRUE,
    created_at       TIMESTAMP    DEFAULT NOW(),
    UNIQUE (user_id, domain)
);

CREATE TABLE IF NOT EXISTS watchlist_alerts (
    id           SERIAL PRIMARY KEY,
    watchlist_id INTEGER NOT NULL REFERENCES watchlist(id) ON DELETE CASCADE,
    alert_type   TEXT    NOT NULL CHECK (alert_type IN ('ssl_expiry','dns_change','ssl_expired')),
    message      TEXT,
    is_read      BOOLEAN   DEFAULT FALSE,
    created_at   TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_walert_read ON watchlist_alerts (watchlist_id, is_read);

-- ── SCHEDULED SCANS ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS scheduled_scans (
    id              SERIAL PRIMARY KEY,
    user_id         INTEGER      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    target_url      VARCHAR(500) NOT NULL,
    profile         VARCHAR(20)  DEFAULT 'quick',
    frequency       TEXT DEFAULT 'weekly' CHECK (frequency IN ('daily','weekly','monthly')),
    alert_threshold INTEGER      DEFAULT 70,
    email_alerts    BOOLEAN      DEFAULT TRUE,
    last_run_at     TIMESTAMP,
    next_run_at     TIMESTAMP    NOT NULL,
    last_score      INTEGER,
    created_at      TIMESTAMP    DEFAULT NOW(),
    active          BOOLEAN      DEFAULT TRUE
);
CREATE INDEX IF NOT EXISTS idx_scheduled_user    ON scheduled_scans (user_id);
CREATE INDEX IF NOT EXISTS idx_scheduled_next    ON scheduled_scans (next_run_at);
CREATE INDEX IF NOT EXISTS idx_scheduled_active  ON scheduled_scans (active);

-- ── TOOLS ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS ip_checks (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER     NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    ip_address  VARCHAR(45) NOT NULL,
    result      JSONB,
    risk_score  SMALLINT,
    checked_at  TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_ip_checks_user ON ip_checks (user_id, checked_at);

CREATE TABLE IF NOT EXISTS hash_checks (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER     NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    hash_value  VARCHAR(64) NOT NULL,
    hash_type   TEXT CHECK (hash_type IN ('md5','sha1','sha256')),
    result      JSONB,
    verdict     TEXT DEFAULT 'unknown' CHECK (verdict IN ('clean','suspicious','malicious','unknown')),
    checked_at  TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_hash_checks_user ON hash_checks (user_id, checked_at);

CREATE TABLE IF NOT EXISTS cve_lookups (
    id           SERIAL PRIMARY KEY,
    user_id      INTEGER      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    query        VARCHAR(100) NOT NULL,
    cve_id       VARCHAR(20),
    result       JSONB,
    cvss_score   NUMERIC(3,1),
    severity     VARCHAR(10),
    looked_up_at TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_cve_lookups_user ON cve_lookups (user_id, looked_up_at);

CREATE TABLE IF NOT EXISTS port_scans (
    id         SERIAL PRIMARY KEY,
    user_id    INTEGER      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    target     VARCHAR(255) NOT NULL,
    mode       VARCHAR(20)  DEFAULT 'common',
    open_ports JSONB,
    scanned_at TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_port_scans_user ON port_scans (user_id);

CREATE TABLE IF NOT EXISTS header_checks (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    url         VARCHAR(512) NOT NULL,
    score       SMALLINT     DEFAULT 0,
    grade       VARCHAR(3)   DEFAULT 'F',
    result_json TEXT,
    checked_at  TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_header_checks_user ON header_checks (user_id);

CREATE TABLE IF NOT EXISTS url_checks (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER       NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    url         VARCHAR(2048) NOT NULL,
    verdict     VARCHAR(20)   DEFAULT 'unknown',
    result_json TEXT,
    checked_at  TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_url_checks_user ON url_checks (user_id);

CREATE TABLE IF NOT EXISTS domain_lookups (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    domain      VARCHAR(255) NOT NULL,
    result_json TEXT,
    looked_up_at TIMESTAMP DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_domain_lookups_user ON domain_lookups (user_id);

-- ── ADMIN ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS admin_logs (
    id             SERIAL PRIMARY KEY,
    admin_id       INTEGER     NOT NULL,
    admin_username VARCHAR(40) NOT NULL,
    action         VARCHAR(80) NOT NULL,
    target_type    VARCHAR(40),
    target_id      INTEGER,
    detail         TEXT,
    ip             VARCHAR(45),
    created_at     TIMESTAMP DEFAULT NOW()
);

-- ── SEED: Badges ─────────────────────────────────────────────
INSERT INTO badges (slug, name, description, icon, condition_type, condition_value) VALUES
('first-scan',   'First Scan',    'Ran your first site scan',       '🔍', 'scan_count',  1),
('scanner-pro',  'Scanner Pro',   'Completed 10 scans',             '🛡️', 'scan_count',  10),
('lab-newbie',   'Lab Rat',       'Solved your first lab',          '🧪', 'labs_solved', 1),
('lab-veteran',  'Lab Veteran',   'Solved 10 labs',                 '⚡', 'labs_solved', 10),
('quiz-starter', 'Quiz Starter',  'Answered 10 CEH questions',      '📝', 'quiz_score',  10),
('streak-7',     '7-Day Streak',  'Active 7 days in a row',         '🔥', 'streak',      7),
('level-5',      'Level 5',       'Reached Level 5',                '🏆', 'xp_reached',  500),
('level-10',     'Level 10',      'Reached Level 10',               '💎', 'xp_reached',  1000)
ON CONFLICT (slug) DO NOTHING;

-- ── SEED: Labs ───────────────────────────────────────────────
INSERT INTO labs (slug, title, description, category, difficulty, xp_reward, level_required, flag_hash, instructions, hints) VALUES
(
  'sqli-101', 'SQL Injection 101',
  'Exploit a vulnerable login form using classic SQLi payloads.',
  'Web Exploitation', 'easy', 120, 1,
  encode(sha256('flag{sqli_bypass_auth_success}'::bytea), 'hex'),
  E'## SQL Injection 101\n\nA local vulnerable web app is running at `http://localhost:9001`.\n\nYour goal: bypass the login form without knowing the password.\n\n### Steps\n1. Start the lab VM or Docker container\n2. Navigate to the login page\n3. Try classic SQLi payloads in the username field\n4. Retrieve the flag from the dashboard',
  '["Try entering a single quote '' to test for errors","The classic payload is: '' OR ''1''=''1","Look at the URL after login for the flag"]'
),
(
  'xss-cookie-steal', 'XSS Cookie Hijack',
  'Inject a script to steal a session cookie and demonstrate session hijacking.',
  'Web Exploitation', 'medium', 200, 3,
  encode(sha256('flag{xss_cookie_stolen_session}'::bytea), 'hex'),
  E'## XSS Cookie Hijack\n\nA vulnerable comment box is running locally.\n\nYour goal: steal the admin session cookie using a reflected XSS payload.',
  '["Try: <script>alert(1)</script> first to confirm XSS","Use document.location to exfiltrate the cookie","Start a Python listener: python3 -m http.server 9999"]'
),
(
  'syn-flood-lab', 'SYN Flood Simulation',
  'Simulate a SYN flood attack on a controlled local target and observe the TCP state.',
  'Network Attacks', 'medium', 180, 3,
  encode(sha256('flag{syn_flood_half_open_connections}'::bytea), 'hex'),
  E'## SYN Flood Simulation\n\n**Only run this on your local machine or authorized lab environment.**',
  '["hping3 command: hping3 -S --flood -V -p 8080 127.0.0.1","Check connections: netstat -an | grep SYN_RECV","The flag appears in server.log after the threshold"]'
)
ON CONFLICT (slug) DO NOTHING;
