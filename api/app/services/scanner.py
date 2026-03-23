import time
from ..scanner.passive  import run_passive_checks
from ..scanner.active   import run_active_checks
from ..scanner.advanced import run_advanced_checks
from ..scanner.score    import calculate_score


async def run_scan_job(jobs: dict, job_id: str, req) -> None:
    """Orchestrate all scanner modules and write results back into jobs dict."""
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
