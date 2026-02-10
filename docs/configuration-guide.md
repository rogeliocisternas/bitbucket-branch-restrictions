# Guía de Configuración para Bitbucket Branch Restrictions

## Introducción
Esta guía proporciona instrucciones detalladas para la configuración de restricciones de rama en Bitbucket, incluyendo la creación de contraseñas de aplicación, la configuración del archivo .env y la obtención de UUIDs de usuario.

## Instrucciones de Instalación Paso a Paso
1. **Acceso a tu Repositorio**: Abre tu repositorio en Bitbucket.
2. **Configuración del Entorno**: Crea un archivo `.env` y añade las siguientes variables:
   - `BITBUCKET_USERNAME`: Tu nombre de usuario de Bitbucket.
   - `BITBUCKET_APP_PASSWORD`: Tu contraseña de aplicación Bitbucket.
3. **Autenticación**: Usar el nombre de usuario y la contraseña de aplicación para autenticarse con la API.

## Cómo Crear una Contraseña de Aplicación de Bitbucket
1. Ve a la sección de **Configuraciones de Cuenta**.
2. Selecciona **Contraseñas de Aplicación**.
3. Crea una nueva contraseña para tu aplicación.

### Capturas de Pantalla
![Captura de Pantalla de Crear Contraseña de Aplicación](url_de_la_imagen)

## Configuración del Archivo .env
Asegúrate de que tu archivo `.env` contenga la información necesaria:
```
BITBUCKET_USERNAME=tu_usuario
BITBUCKET_APP_PASSWORD=tu_contraseña
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
- Siempre usa contraseñas de aplicación.
- Implementa revisiones de código obligatorias.

## Alternativas de Configuración Manual en la UI de Bitbucket
Accede a la configuración de ramas y sigue las indicaciones para establecer restricciones manualmente.