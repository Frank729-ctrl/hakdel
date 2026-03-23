<?php
/**
 * HakDel Scheduled Scanner — run via cron every minute
 * Picks up due scheduled_scans, runs them, emails if score drops
 */
define('HAKDEL_CRON', true);
require_once __DIR__ . '/../frontend/config/app.php';
require_once __DIR__ . '/../frontend/config/mail.php';
require_once __DIR__ . '/../frontend/config/mail_templates.php';

$now    = date('Y-m-d H:i:s');
$api    = getenv('API_BASE') ?: 'http://localhost:8000';
$mailto = getenv('ALERT_EMAIL') ?: '';

$stmt = db()->prepare("
    SELECT ss.*, u.email, u.username
    FROM scheduled_scans ss
    JOIN users u ON u.id = ss.user_id
    WHERE ss.active = 1 AND ss.next_run_at <= ?
    LIMIT 10
");
$stmt->execute([$now]);
$due = $stmt->fetchAll();

foreach ($due as $s) {
    echo "[" . date('H:i:s') . "] Running scan: {$s['target_url']} for {$s['username']}\n";

    // Start scan job
    $modules = $s['profile'] === 'full'
        ? ['whois','ssl','headers','dns','ports','cms','cve','cookies','xss','sqli','dirs','access','stack','email','waf','session','smtp','sniffing','malware','db','virustotal','nvd']
        : ['whois','ssl','headers','dns','cookies','waf','stack'];

    $start = @file_get_contents($api . '/scan/start', false, stream_context_create([
        'http' => [
            'method'  => 'POST',
            'header'  => "Content-Type: application/json\r\n",
            'content' => json_encode(['url' => $s['target_url'], 'modules' => $modules, 'profile' => $s['profile']]),
            'timeout' => 10,
        ]
    ]));

    if (!$start) {
        echo "  ERROR: Could not reach API\n";
        continue;
    }

    $job = json_decode($start, true);
    if (empty($job['job_id'])) {
        echo "  ERROR: No job_id returned\n";
        continue;
    }

    $job_id = $job['job_id'];
    echo "  Job ID: $job_id\n";

    // Poll until done (max 5 minutes)
    $result = null;
    $timeout = time() + 300;
    while (time() < $timeout) {
        sleep(5);
        $status_raw = @file_get_contents($api . '/scan/status/' . $job_id);
        if (!$status_raw) continue;
        $status = json_decode($status_raw, true);
        if ($status['status'] === 'done') {
            $result = $status['result'];
            break;
        }
        if ($status['status'] === 'error') {
            echo "  ERROR: {$status['error']}\n";
            break;
        }
    }

    if (!$result) {
        echo "  ERROR: Scan timed out\n";
        continue;
    }

    $new_score = (int)$result['score'];
    $old_score = (int)$s['last_score'];
    echo "  Score: $new_score (was: {$old_score})\n";

    // Save to scans table
    $save = db()->prepare("
        INSERT INTO scans (user_id, job_id, target_url, profile, modules, score, grade, summary, result_json, status, scanned_at)
        VALUES (?,?,?,?,?,?,?,?,?,'done',NOW())
    ");
    $save->execute([
        $s['user_id'], $job_id, $s['target_url'], $s['profile'],
        json_encode($modules), $new_score, $result['grade'] ?? 'F',
        $result['summary'] ?? '', json_encode($result),
    ]);

    // Compute next run
    $next = match($s['frequency']) {
        'daily'   => date('Y-m-d H:i:s', strtotime('+1 day')),
        'monthly' => date('Y-m-d H:i:s', strtotime('+1 month')),
        default   => date('Y-m-d H:i:s', strtotime('+1 week')),
    };

    // Update schedule
    db()->prepare("
        UPDATE scheduled_scans SET last_run_at=NOW(), last_score=?, next_run_at=? WHERE id=?
    ")->execute([$new_score, $next, $s['id']]);

    // Email alert if score dropped below threshold
    $should_alert = $s['email_alerts']
        && $new_score < (int)$s['alert_threshold']
        && !empty($s['email']);

    if ($should_alert) {
        $to          = $s['email'];
        $history_url = (getenv('SITE_URL') ?: 'http://localhost:8080') . '/scanner/history.php';
        $tpl = mail_template_scan_alert(
            $s['username'],
            $s['target_url'],
            (int)$new_score,
            $result['grade'],
            $result['summary'],
            (int)$s['alert_threshold'],
            $history_url
        );
        if (send_mail($to, $tpl['subject'], $tpl['text'], $tpl['html'])) {
            echo "  Email sent to {$to}\n";
        } else {
            echo "  Email failed (check error_log for SMTP details)\n";
        }
    }
}

echo "[" . date('H:i:s') . "] Done. Processed " . count($due) . " schedule(s).\n";
