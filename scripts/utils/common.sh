#!/bin/bash

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes de éxito
success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Función para imprimir mensajes de error
error() {
    echo -e "${RED}✗${NC} $1" >&2
}

# Función para imprimir mensajes de advertencia
warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Función para imprimir mensajes informativos
info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Función para imprimir encabezados
header() {
    echo ""
    echo -e "${BLUE}=========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=========================================${NC}"
    echo ""
}

# Función para verificar si un comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Función para verificar dependencias
check_dependencies() {
    local missing_deps=()
    
    if ! command_exists curl; then
        missing_deps+=("curl")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        error "Faltan las siguientes dependencias: ${missing_deps[*]}"
        error "Por favor instala las dependencias faltantes antes de continuar."
        exit 1
    fi
    
    if ! command_exists jq; then
        warning "jq no está instalado. La salida JSON no será formateada."
    fi
}

# Función para cargar variables de entorno
load_env() {
    local env_file="${1:-.env}"
    
    if [ ! -f "$env_file" ]; then
        error "Archivo de configuración no encontrado: $env_file"
        error "Copia .env.example a .env y configura tus credenciales."
        exit 1
    fi
    
    # Cargar variables
    set -a
    source "$env_file"
    set +a
    
    # Verificar variables requeridas
    local required_vars=("BITBUCKET_URL" "WORKSPACE" "REPO_SLUG" "USERNAME" "APP_PASSWORD")
    local missing_vars=()
    
    for var in "${required_vars[@]}"; do
        if [ -z "">${!var}" ]; then
            missing_vars+=("$var")
        fi
    done
    
    if [ ${#missing_vars[@]} -ne 0 ]; then
        error "Faltan las siguientes variables de entorno: ${missing_vars[*]}"
        error "Por favor configura todas las variables requeridas en el archivo .env"
        exit 1
    fi
    
    success "Configuración cargada correctamente"
}

# Función para hacer llamadas a la API de Bitbucket
bitbucket_api_call() {
    local method="$1"
    local endpoint="$2"
    local data="$3"
    local description="$4"
    
    local url="${BITBUCKET_URL}${endpoint}"
    local response
    local http_code
    
    if [ -n "$data" ]; then
        response=$(curl -s -w "\n%{http_code}" -X "$method" \
            -u "${USERNAME}:${APP_PASSWORD}" \
            -H "Content-Type: application/json" \
            -d "$data" \
            "$url")
    else
        response=$(curl -s -w "\n%{http_code}" -X "$method" \
            -u "${USERNAME}:${APP_PASSWORD}" \
            "$url")
    fi
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 300 ]; then
        if [ -n "$description" ]; then
            success "$description"
        fi
        return 0
    else
        if [ -n "$description" ]; then
            error "$description (HTTP $http_code)"
        fi
        if command_exists jq; then
            echo "$body" | jq '.' 2>/dev/null || echo "$body"
        else
            echo "$body"
        fi
        return 1
    fi
}

# Exportar funciones
export -f success error warning info header
export -f command_exists check_dependencies load_env bitbucket_api_call
