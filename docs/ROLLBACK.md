# 🔄 Plan de Reversión (Rollback Runbook)

Este documento define los procedimientos operativos para restaurar la estabilidad del servicio en caso de incidentes críticos tras un despliegue en **Google Cloud Run**.

## 🔴 Escenarios de Activación
Se debe ejecutar un rollback si tras un despliegue se detecta:
1. **Errores 5xx:** Tasa de error superior al 5% en [Cloud Logging](https://console.cloud.google.com).
2. **Latencia Crítica:** Incremento del p95 superior a 2 segundos.
3. **Regresión de Seguridad:** Exposición no deseada de secretos o endpoints.

---

## 🛠️ Procedimiento 1: Reversión de Tráfico (Inmediato)
Este es el método más rápido, ya que no requiere re-construir la imagen ni ejecutar el pipeline de CI/CD.

### 1. Identificar la última revisión estable
```bash
gcloud run revisions list \
  --service=python-fastapi-demo \
  --region=us-central1 \
  --limit=5
```

gcloud run services update-traffic app-api-dev \
  --to-revisions=[REVISION_ESTABLE]=100 \
  --region=us-central1
```
