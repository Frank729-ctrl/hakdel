-- 004_tools.sql — Security Tools tables
-- Run: mysql -u root -p hakdel < database/migrations/004_tools.sql

USE hakdel;

-- ── IP Reputation Checker ─────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS ip_checks (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id     INT UNSIGNED NOT NULL,
    ip_address  VARCHAR(45)  NOT NULL,
    result      JSON,
    risk_score  TINYINT UNSIGNED,
    checked_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_ip_user (user_id, checked_at)
);

-- ── Hash Lookup ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS hash_checks (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id     INT UNSIGNED NOT NULL,
    hash_value  VARCHAR(64)  NOT NULL,
    hash_type   ENUM('md5','sha1','sha256'),
    result      JSON,
    verdict     ENUM('clean','suspicious','malicious','unknown') DEFAULT 'unknown',
    checked_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_hash_user (user_id, checked_at)
);

-- ── CVE Lookup ────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS cve_lookups (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id     INT UNSIGNED NOT NULL,
    query       VARCHAR(100) NOT NULL,
    cve_id      VARCHAR(20),
    result      JSON,
    cvss_score  DECIMAL(3,1),
    severity    VARCHAR(10),
    looked_up_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_cve_user (user_id, looked_up_at)
);

-- ── Domain Watchlist ──────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS watchlist (
    id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id          INT UNSIGNED NOT NULL,
    domain           VARCHAR(255) NOT NULL,
    check_ssl        BOOLEAN DEFAULT TRUE,
    check_dns        BOOLEAN DEFAULT TRUE,
    alert_email      VARCHAR(255),
    ssl_expiry_days  INT,
    ssl_last_checked DATETIME,
    dns_snapshot     JSON,
    dns_last_checked DATETIME,
    is_active        BOOLEAN DEFAULT TRUE,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_domain (user_id, domain),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS watchlist_alerts (
    id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    watchlist_id INT UNSIGNED NOT NULL,
    alert_type   ENUM('ssl_expiry','dns_change','ssl_expired') NOT NULL,
    message      TEXT,
    is_read      BOOLEAN DEFAULT FALSE,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (watchlist_id) REFERENCES watchlist(id) ON DELETE CASCADE,
    INDEX idx_alert_read (watchlist_id, is_read)
);
