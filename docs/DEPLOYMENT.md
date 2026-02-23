# 🚀 Guía de Despliegue (CD)

Este documento detalla el flujo de entrega continua (CD) desde el commit en una rama de desarrollo hasta la puesta en producción en **Google Cloud Run**.

## 🔄 Flujo de Trabajo (Workflow)

El sistema utiliza una estrategia de **GitFlow Simplificado** combinada con **GitHub Environments** para asegurar la calidad y el control.

### 1. Desarrollo (`feature/*`)
- Cada push a una rama `feature/` dispara un pipeline de **Integración Continua (CI)**.
- **Resultado:** Validación técnica sin despliegue.

### 2. Integración (`main`)
- Al abrir un **Pull Request (PR)** hacia `main`, se genera un resumen accionable en los comentarios del PR.
- Una vez mergeado, el workflow de **Release** analiza los mensajes de commit ([Conventional Commits](https://www.conventionalcommits.org)).
- Se ejecutan: `terraform fmt`, `terraform validate` y lints de la aplicación.
- Se genera automáticamente un nuevo **Tag SemVer** (ej. `v1.2.0`) y se crea una GitHub Release.

### 3. Despliegue a Producción (Tags)
El despliegue real solo se activa cuando se detecta la creación de un Tag:

1. **Build & Push:** Se construye la imagen Docker y se sube a [Artifact Registry](https://cloud.google.com) etiquetada con el número de versión.
2. **Aprobación Manual:** El job de despliegue entra en estado de espera. Requiere que un revisor autorizado apruebe el cambio en la pestaña de **Actions** de GitHub.
3. **Deploy:** Una vez aprobado, se ejecuta `gcloud run deploy` apuntando a la versión del tag
---

## 🛠️ Comandos de Despliegue Manual
*Nota: Solo usar en caso de falla del pipeline.*


