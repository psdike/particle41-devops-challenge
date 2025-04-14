FROM python:3.11-slim

# Create non-root user
RUN useradd -m appuser

# Set working directory and copy files
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Use non-root user
USER appuser

# Expose and run
EXPOSE 8080
CMD ["python", "app.py"]
