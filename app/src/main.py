from fastapi import FastAPI
from pydantic import BaseModel
from datetime import datetime
import os

APP_VERSION = os.getenv("APP_VERSION", "0.1.0")

app = FastAPI(
    title="Project 2 Platform API",
    version=APP_VERSION,
)

class CheckInRequest(BaseModel):
    user_id: str
    location: str | None = None

@app.get("/health")
def health():
    return {"status": "ok", "ts": datetime.utcnow().isoformat() + "Z"}

@app.get("/version")
def version():
    return {"version": APP_VERSION}

@app.post("/api/checkin")
def checkin(payload: CheckInRequest):
    return {
        "message": "check-in received",
        "user_id": payload.user_id,
        "location": payload.location,
        "ts": datetime.utcnow().isoformat() + "Z",
    }
