#!/bin/bash

# Script para obtener UUIDs de usuarios de Bitbucket

set -e
set -u

# Cargar funciones comunes
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
source "${SCRIPT_DIR}/common.sh"

# Cargar configuración
load_env "${PROJECT_ROOT}/.env"

# Función para obtener UUID de un usuario intentando diferentes endpoints
get_user_uuid() {
    local username="$1"
    
    info "Obteniendo UUID para usuario: $username"
    
    # Intentar 1: Endpoint público de usuarios
    local response=$(curl -s -w "\n%{http_code}" \
        "https://api.bitbucket.org/2.0/users/${username}")
    
    local http_code=$(echo "$response" | tail -n1)
    local body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" -eq 200 ]; then
        local uuid=$(echo "$body" | grep -o '"uuid":[[:space:]]*"[^"]*"' | cut -d'"' -f4)
        if [ -n "$uuid" ]; then
            success "UUID encontrado: $uuid"
            echo "$uuid"
            return 0
        fi
    fi
    
    # Intentar 2: Buscar en pull requests del repositorio
    info "Buscando en pull requests del repositorio..."
    response=$(curl -s -w "\n%{http_code}" \
        -H "Authorization: Bearer ${API_TOKEN}" \
        "https://api.bitbucket.org/2.0/repositories/${WORKSPACE}/${REPO_SLUG}/pullrequests?state=ALL&pagelen=100")
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" -eq 200 ] && command_exists jq; then
        local uuid=$(echo "$body" | jq -r ".values[] | select(.author.nickname == \"${username}\" or .author.username == \"${username}\") | .author.uuid" | head -n1)
        if [ -n "$uuid" ] && [ "$uuid" != "null" ]; then
            success "UUID encontrado en pull requests: $uuid"
            echo "$uuid"
            return 0
        fi
    fi
    
    error "No se pudo obtener UUID para $username"
    warning "El usuario podría no existir o no tener pull requests en este repositorio"
    warning "Verifica que el username sea correcto (ej: 'jabes.fuentes', no 'Jabes Fuentes')"
    return 1
}

# Función para listar todos los miembros del workspace o repositorio
list_workspace_members() {
    info "Intentando listar miembros del repositorio '${WORKSPACE}/${REPO_SLUG}'..."
    echo ""
    
    # Primero intentar endpoint del repositorio (requiere menos permisos)
    local response=$(curl -s -w "\n%{http_code}" \
        -H "Authorization: Bearer ${API_TOKEN}" \
        "https://api.bitbucket.org/2.0/repositories/${WORKSPACE}/${REPO_SLUG}/pullrequests?state=ALL&pagelen=100")
    
    local http_code=$(echo "$response" | tail -n1)
    local body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" -eq 200 ]; then
        if command_exists jq; then
            success "Usuarios encontrados en pull requests:"
            echo ""
            echo "$body" | jq -r '.values[] | select(.author != null) | "\(.author.nickname // .author.username) - \(.author.display_name) - UUID: \(.author.uuid)"' | sort -u
            echo ""
            info "Esto muestra usuarios que han creado pull requests en el repositorio."
        else
            warning "Instala 'jq' para formatear el resultado."
            echo "$body"
        fi
        return 0
    else
        error "No se pudieron listar los miembros (HTTP $http_code)"
        warning "Verifica que tu API Token tenga los permisos: 'account:read', 'repository:read', 'pullrequest:read'"
        echo ""
        info "Para crear un nuevo API Token con los permisos correctos:"
        echo "  1. Ve a https://bitbucket.org/account/settings/app-passwords/"
        echo "  2. Crea un nuevo token con permisos:"
        echo "     - Account: Read"
        echo "     - Repositories: Read"
        echo "     - Pull requests: Read"
        echo "     - Repositories: Write (para branch restrictions)"
        echo "  3. Actualiza API_TOKEN en tu archivo .env"
        echo ""
        if command_exists jq; then
            echo "$body" | jq '.' 2>/dev/null || echo "$body"
        else
            echo "$body"
        fi
        return 1
    fi
}

# Main
header "Obtener UUIDs de Usuarios de Bitbucket"

check_dependencies

# Si se proporciona --list, mostrar todos los miembros
if [ "${1:-}" = "--list" ]; then
    list_workspace_members
    exit 0
fi

# Lista de usuarios predeterminados
USERNAMES=(
    "jabes.fuentes"
    "jhon.valderrama"
    "jose.opazo"
    "juan.puga"
    "karen.sudzuki"
    "luis.cruz"
    "patricio.sanhueza"
    "rogelio.cisternas"
)

# Si se proporciona un argumento, buscar solo ese usuario
if [ $# -gt 0 ]; then
    get_user_uuid "$1"
    exit 0
fi

# Si no, buscar todos los usuarios predeterminados
info "Buscando UUIDs para todos los revisores predeterminados..."
echo ""

for username in "${USERNAMES[@]}"; do
    uuid=$(get_user_uuid "$username" || echo "")
    if [ -n "$uuid" ]; then
        echo "export REVIEWER_${username^^}_UUID=\"$uuid\""
    fi
    echo ""
done

info "Copia y pega las líneas de arriba en tu archivo .env"