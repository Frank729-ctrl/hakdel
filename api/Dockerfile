FROM python:3.12-slim

# System deps — nmap required for port scanning module
RUN apt-get update && apt-get install -y --no-install-recommends \
        nmap \
        libssl-dev \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python deps first (cached layer)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

EXPOSE 8000

# Render injects $PORT at runtime; fall back to 8000 locally
CMD uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}
