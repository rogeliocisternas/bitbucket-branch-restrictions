#!/bin/bash

# Script para obtener UUIDs de usuarios de Bitbucket

set -e
set -u

# Cargar funciones comunes
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

# Cargar configuración
load_env

# Función para obtener UUID de un usuario
get_user_uuid() {
    local username="$1"
    
    info "Obteniendo UUID para usuario: $username"
    
    local response=$(curl -s -w "\n%{http_code}" \
        -u "${USERNAME}:${APP_PASSWORD}" \
        "https://api.bitbucket.org/2.0/users/${username}")
    
    local http_code=$(echo "$response" | tail -n1)
    local body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" -eq 200 ]; then
        local uuid=$(echo "$body" | grep -o '"uuid":[[:space:]]*"[^"]*"' | cut -d'"' -f4)
        if [ -n "$uuid" ]; then
            success "UUID encontrado: $uuid"
            echo "$uuid"
            return 0
        else
            error "No se pudo extraer el UUID de la respuesta"
            return 1
        fi
    else
        error "No se pudo obtener UUID para $username (HTTP $http_code)"
        return 1
    fi
}

# Main
header "Obtener UUIDs de Usuarios de Bitbucket"

check_dependencies

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