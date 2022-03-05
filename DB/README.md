# Repositorio para el almacenamiento del sistema de BD y archivos

Tras descargar el repositorio, abrir un terminal sobre él y ejecutar el siguiente comando:

> docker compose up -d

Para las ejecuciones siguientes se debe ejecutar de la siguiente forma

> docker compose up
## Para el servidor de archivos

Para poder subir al servidor de archivos un fichero se debe hacer mediante POST. Se puede usar cURL a modo de ejemplo de la siguiente forma:

> curl -F file=@{rutaFichero} localhost:3000

Sustituyendo los corchetes y su contenido por la ruta del fichero local que queremos subir al servidor. Por defecto se ejecuta en localhost sobre el puerto 3000.

## Para el servidor de BD

Los datos que hemos de rellenar para acceder a PhPMyAdming son

| User     | Password |
|----------|-------|
| admin | admin  |

PhPMyAdmin se ejecuta sobre el puerto 8081 o 80.
MySQL se ejecuta sobre el puerto 6033 o 3306.
