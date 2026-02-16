# Guía de Configuración para Bitbucket Branch Restrictions

## Introducción
Esta guía proporciona instrucciones detalladas para la configuración de restricciones de rama en Bitbucket, incluyendo la creación de contraseñas de aplicación, la configuración del archivo .env y la obtención de UUIDs de usuario.

## Instrucciones de Instalación Paso a Paso
1. **Acceso a tu Repositorio**: Abre tu repositorio en Bitbucket.
2. **Configuración del Entorno**: Crea un archivo `.env` y añade las siguientes variables:
   - `WORKSPACE`: El workspace de Bitbucket.
   - `REPO_SLUG`: El slug del repositorio.
   - `API_TOKEN`: Tu token de API de Bitbucket.
3. **Autenticación**: Usar el token de API para autenticarse con la API usando Bearer token.

## Cómo Crear un Token de API de Bitbucket
1. Ve a la sección de **Configuraciones de Cuenta**.
2. Selecciona **App passwords** (nombre legacy, ahora genera tokens).
3. Crea un nuevo token con los siguientes permisos:
   - Account: Read
   - Repositories: Admin, Write, Read
   - Pull requests: Read, Write
4. Copia el token generado (solo se muestra una vez).

### Capturas de Pantalla
![Captura de Pantalla de Crear Token de API](url_de_la_imagen)

## Configuración del Archivo .env
Asegúrate de que tu archivo `.env` contenga la información necesaria:
```
BITBUCKET_URL="https://api.bitbucket.org/2.0"
WORKSPACE=tu_workspace
REPO_SLUG=tu_repositorio
API_TOKEN=tu_token_api
```

## Obtención de UUIDs de Usuario
Utiliza el siguiente endpoint de la API:
```
GET /rest/api/1.0/users
```

## Explicación de Tipos de Restricciones de Rama
- **Restricción de Push**: Restringe quién puede realizar push a la rama.
- **Restricción de Eliminación**: Previene que se eliminen ramas.

## Errores Comunes y Soluciones
- **Error 401**: Autenticación fallida - Verifica tus credenciales.
- **Error 403**: Permiso denegado - Asegúrate de tener permisos adecuados.

## Mejores Prácticas para la Protección de Ramas
- Siempre usa tokens de API con permisos mínimos necesarios.
- Protege tus tokens de API y no los publiques en repositorios.
- Implementa revisiones de código obligatorias.

## Alternativas de Configuración Manual en la UI de Bitbucket
Accede a la configuración de ramas y sigue las indicaciones para establecer restricciones manualmente.