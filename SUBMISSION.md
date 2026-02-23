# Info

- Repositorio: https://github.com/la1o/python-fastapi-demo-docker-tmp
- URL Despliegue: https://app-api-dev-589250491076.europe-north2.run.app
- Tag: https://github.com/la1o/python-fastapi-demo-docker-tmp/releases/tag/v0.0.7
- Pipeline despliegue: https://github.com/la1o/python-fastapi-demo-docker-tmp/actions/runs/22290412444

# Decisiones principales
- App se modifico para usar sqlite en memoria dentro del despliegue
- No se hizo despliegue de la BD, por lo anterior
- Se actualizo App a Python 3.14.3
- No se incluyo documentacion de GKE, no se implemento

# Mejoras
- Crear templates de GithubActions por Jobs
- Agregar cache a tareas (instalación pip, docker build)
- Usar Cloud SQL con Auth IAM
- Ya el mismo template podria usar solo configurando variables para desplegar
