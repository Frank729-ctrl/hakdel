import uuid
import time
from fastapi import APIRouter, BackgroundTasks, HTTPException
from ..models.scan import ScanRequest
from ..services import scanner as scanner_svc

router = APIRouter()

PROFILE_ESTIMATES = {"quick": 60, "full": 300, "custom": 120}

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
