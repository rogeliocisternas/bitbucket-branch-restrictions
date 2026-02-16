# Bitbucket Branch Restrictions - Scripts de Configuración

Scripts automatizados en bash para configurar permisos de repositorio, revisores predeterminados y restricciones de ramas en Bitbucket usando la API REST v2.0.

## 📋 Descripción

Este repositorio contiene scripts de automatización que te permiten configurar de manera rápida y consistente:

1. **Permisos de repositorio** para grupos de usuarios
2. **Revisores predeterminados** en pull requests
3. **Restricciones de ramas** para Production, qafalp y Develop

## 🚀 Inicio Rápido

### Prerrequisitos

- Cuenta de Bitbucket con permisos de administrador
- API Token de Bitbucket (anteriormente App Password)
- `curl` instalado
- `jq` instalado (opcional, para formatear JSON)
- Sistema Unix/Linux o macOS

### Instalación

1. Clona este repositorio:
```bash
git clone https://github.com/rogeliocisternas/bitbucket-branch-restrictions.git
cd bitbucket-branch-restrictions
```

2. Copia el archivo de ejemplo de variables de entorno:
```bash
cp .env.example .env
```

3. Edita `.env` con tus credenciales y configuración:
```bash
nano .env
```

4. Da permisos de ejecución a los scripts:
```bash
chmod +x scripts/*.sh
chmod +x scripts/utils/*.sh
```

### Uso

#### Configuración Completa

Para ejecutar todos los scripts de configuración:

```bash
./scripts/configure-all.sh
```

#### Configuración Individual

También puedes ejecutar scripts individuales:

```bash
# Solo permisos de repositorio
./scripts/01-repository-permissions.sh

# Solo revisores predeterminados
./scripts/02-default-reviewers.sh

# Solo restricciones de rama Production
./scripts/03-branch-restrictions-production.sh

# Solo restricciones de rama qafalp
./scripts/04-branch-restrictions-qafalp.sh

# Solo restricciones de rama Develop
./scripts/05-branch-restrictions-develop.sh
```

## 📝 Configuración

### 1. Crear API Token en Bitbucket

1. Ve a tu perfil de Bitbucket
2. Settings → Personal settings → App passwords (el nombre es legacy, pero ahora genera API tokens)
3. Crea un nuevo token con los siguientes permisos:
   - **Account**: Read
   - **Repositories**: Admin, Write, Read
   - **Pull requests**: Read, Write
4. Copia el token generado (solo se muestra una vez)

### 2. Configurar Variables de Entorno

Edita el archivo `.env`:

```bash
BITBUCKET_URL="https://api.bitbucket.org/2.0"
WORKSPACE="tu-workspace"
REPO_SLUG="tu-repositorio"
API_TOKEN="tu-api-token"
```

### 3. Obtener UUIDs de Usuarios

Para configurar los revisores predeterminados, necesitas los UUIDs de los usuarios:

```bash
./scripts/utils/get-user-uuids.sh nombre-usuario
```

## 📚 Documentación

- [Guía de Configuración Detallada](docs/configuration-guide.md)
- [Referencia de API de Bitbucket](docs/api-reference.md)

## 🔧 Configuración Aplicada

### Permisos de Repositorio

| Grupo | Nivel de Acceso |
|-------|----------------|
| Administrators | Admin |
| DevOps_TD | Admin |
| Developers | Write |
| Lideres_Canales_Digitales | Write |
| QA-CanalesDigitales | Write |

### Revisores Predeterminados

- Jabes Fuentes Salazar
- Jhon Alexander Valderrama Golborne
- Jose Ignacio Opazo Lopez
- Juan Carlos Puga Calderon
- Karen Sudzuki Toro
- Luis Kevin Cruz Flores
- Patricio Frank Sanhueza Titiro
- Rogelio Andres Cisternas Vera

### Restricciones de Ramas

#### 🔴 Production
- **Write access**: Solo Administrators
- **Protecciones**: No eliminar, no reescribir historia
- **Merge via PR**: Solo Administrators
- **Requerimientos**:
  - Mínimo 3 aprobaciones
  - Mínimo 3 aprobaciones de revisores predeterminados
  - Todas las tareas resueltas
  - Al menos 1 build exitoso, sin builds fallidos o en progreso
  - Rama no más de 5 commits atrás del destino
  - No permitir merge con checks sin resolver

#### 🟡 qafalp
- **Write access**: Solo Administrators
- **Protecciones**: No eliminar, no reescribir historia
- **Merge via PR**: Administrators, DevOps_TD, Lideres_Canales_Digitales, QA-CanalesDigitales
- **Requerimientos**:
  - Mínimo 1 aprobación
  - Mínimo 1 aprobación de revisor predeterminado
  - Rama no más de 10 commits atrás del destino
  - No permitir merge con checks sin resolver

#### 🟢 Develop
- **Write access**: Administrators, DevOps_TD, Lideres_Canales_Digitales
- **Protecciones**: No eliminar, no reescribir historia
- **Merge via PR**: Administrators, Developers, DevOps_TD, Lideres_Canales_Digitales
- **Requerimientos**:
  - Mínimo 1 aprobación
  - Al menos 1 build exitoso, sin builds fallidos o en progreso
  - No permitir merge con checks sin resolver

## 🛠️ Troubleshooting

### Error 401: Unauthorized
- Verifica que tu API Token sea correcto
- Asegúrate de que el token tenga los permisos necesarios:
  - Account: Read
  - Repositories: Admin, Write, Read
  - Pull requests: Read, Write

### Error 403: Forbidden
- Verifica que tengas permisos de administrador en el repositorio
- Confirma que el workspace y repositorio sean correctos

### Error 404: Not Found
- Verifica que el workspace y repositorio existan
- Confirma que los nombres estén escritos correctamente

### Script no ejecuta
```bash
chmod +x scripts/*.sh
chmod +x scripts/utils/*.sh
```

## ⚠️ Limitaciones

Algunas restricciones avanzadas no están disponibles en la API de Bitbucket v2.0 y deben configurarse manualmente desde la UI:

- Límite de commits detrás del destino (5 commits, 10 commits)
- Algunas configuraciones avanzadas requieren Bitbucket Premium

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agrega nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crea un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

## 👤 Autor

**Rogelio Cisternas**
- GitHub: [@rogeliocisternas](https://github.com/rogeliocisternas)

## 🙏 Agradecimientos

- Bitbucket API Documentation
- Comunidad de DevOps

---

**Nota**: Este repositorio contiene scripts de automatización. Revisa y prueba los scripts en un entorno de desarrollo antes de aplicarlos en producción.