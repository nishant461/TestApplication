FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential \
  && rm -rf /var/lib/apt/lists/*

# Copy requirements and install (use a single layer for caching)
COPY requirements.txt ./
RUN pip install --upgrade pip \
  && pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . /app

# Use a non-root user for better security
RUN useradd --create-home appuser && chown -R appuser /app
USER appuser

# Expose port used by the Flask app
EXPOSE 8000

# Use Gunicorn to serve the app in production
# app:app refers to the `app` Flask instance in app.py
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app", "--workers", "3"]
