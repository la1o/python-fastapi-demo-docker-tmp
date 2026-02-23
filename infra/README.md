# Crear infraestructura

Para desplegar, se crea el proyecto

```bash
gcloud projects create tecnica-devops --tags=environment=dev
```

Se activa el billing en el proyecto y se obtiene el PROJECT_NUMBER

```bash
export PROJECT_ID=tecnica-devops
export PROJECT_NUMBER=11111
gcloud services enable secretmanager.googleapis.com --project=${PROJECT_ID}
gcloud services enable run.googleapis.com --project=${PROJECT_ID}
gcloud services enable artifactregistry.googleapis.com --project=${PROJECT_ID}
gcloud services enable containerregistry.googleapis.com --project=${PROJECT_ID}
gcloud services enable iamcredentials.googleapis.com --project=${PROJECT_ID}
```

Se ejecuta dentro del directorio infra/envs/dev

```bash
terraform apply \
  -var="project_id=${PROJECT_ID}" \
  -var="project_number=${PROJECT_NUMBER}" \
  -var="environment=dev" \
  -var="region=europe-north2" \
  -var="app_name=app-api" \
  -var="github_repository=la1o/python-fastapi-demo-docker" \
  -var="image=us-docker.pkg.dev/cloudrun/container/hello" \
  -var="docker_database_url=sqlite:///:memory:"
```

# Justificación

La infraestructura se ha organizado siguiendo el principio 
DRY (Don't Repeat Yourself), separando la lógica de los recursos de su 
implementación por entorno.

Se evita tener modulos/versiones desactualizadas entre los distintos ambientes.

