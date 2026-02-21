# Use an official Python runtime as a parent image
FROM python:3.14-slim-bookworm as builder

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /server

# Install system dependencies and Python dependencies
COPY ./server/requirements.txt /server/
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /server/wheels -r requirements.txt

FROM python:3.14-slim-bookworm as runner

WORKDIR /server

RUN groupadd --gid 5001 app \
    && useradd --uid 5001 --gid 5001 -m app

USER app

ENV PATH=/home/app/.local/bin:$PATH

# Install system dependencies and Python dependencies
COPY --chown=app:app --from=builder /server/wheels /server/wheels
COPY --chown=app:app --from=builder /server/requirements.txt .
RUN pip install --no-cache-dir /server/wheels/* \
    && pip install --no-cache-dir uvicorn

# Copy project
COPY --chown=app:app ./server/app /server/server/app/

# Expose the port the app runs in
EXPOSE 8000

# Define the command to start the container
CMD ["uvicorn", "server.app.main:app", "--host", "0.0.0.0", "--port", "8000"]
