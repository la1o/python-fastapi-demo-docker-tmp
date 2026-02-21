from fastapi.testclient import TestClient
from server.app.main import app

import os
os.environ["RUN_MIGRATIONS"] = "false"
os.environ["DOCKER_DATABASE_URL="] = "sqlite:///:memory:"

client = TestClient(app)

def test_health_endpoint():
    response = client.get("/health")
    assert response.status_code == 200
