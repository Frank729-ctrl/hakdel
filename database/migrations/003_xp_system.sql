-- ─────────────────────────────────────────────────────────────────────────────
-- 003_xp_system.sql  —  XP system redesign migration
-- Safe to run multiple times (IF NOT EXISTS / INSERT IGNORE / column checks)
-- Run: mysql -u root -pShequan123! hakdel < database/migrations/003_xp_system.sql
-- ─────────────────────────────────────────────────────────────────────────────
USE hakdel;

-- 1. XP audit log table ───────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS xp_log (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id     INT UNSIGNED  NOT NULL,
    amount      INT           NOT NULL,
    source      ENUM('lab_complete','quiz_session','tier_unlock',
                     'level_bonus','daily_streak','manual') NOT NULL,
    source_ref  INT UNSIGNED  DEFAULT NULL,
    description VARCHAR(255)  DEFAULT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_xp (user_id),
    INDEX idx_source  (source),
    INDEX idx_created (created_at)
);

-- 2. Add longest_streak column if not already present ─────────────────────────
SET @col_exists = (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'longest_streak'
);
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE users ADD COLUMN longest_streak TINYINT UNSIGNED NOT NULL DEFAULT 0 AFTER streak_days',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 3. Update lab xp_reward defaults by difficulty ──────────────────────────────
UPDATE labs SET xp_reward = 100 WHERE difficulty = 'easy';
UPDATE labs SET xp_reward = 200 WHERE difficulty = 'medium';
UPDATE labs SET xp_reward = 350 WHERE difficulty = 'hard';
UPDATE labs SET xp_reward = 500 WHERE difficulty = 'expert';

-- 4. Backfill xp_log from existing quiz_attempts (approximate) ────────────────
--    One entry per correct answer using the old per-question award value.
INSERT IGNORE INTO xp_log (user_id, amount, source, description, created_at)
SELECT
    qa.user_id,
    COALESCE(qq.points, 10),
    'quiz_session',
    CONCAT('Migrated: ', qq.category, ' T', qq.tier),
    qa.answered_at
FROM quiz_attempts qa
JOIN quiz_questions qq ON qa.question_id = qq.id
WHERE qa.is_correct = 1;

-- 5. Backfill xp_log from existing solved labs ────────────────────────────────
INSERT IGNORE INTO xp_log (user_id, amount, source, source_ref, description, created_at)
SELECT
    la.user_id,
    l.xp_reward,
    'lab_complete',
    la.lab_id,
    CONCAT('Migrated: ', l.title),
    COALESCE(la.solved_at, la.started_at)
FROM lab_attempts la
JOIN labs l ON la.lab_id = l.id
WHERE la.status = 'solved';
