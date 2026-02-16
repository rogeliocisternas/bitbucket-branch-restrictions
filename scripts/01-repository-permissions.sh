#!/bin/bash

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load common functions
source "$SCRIPT_DIR/utils/common.sh"

# Check dependencies
check_dependencies

# Load environment variables from .env file in repository root
load_env "$SCRIPT_DIR/../.env"

# Display header
header "Configurando Permisos de Repositorio"

# Assign permissions to groups using Bitbucket API
declare -A permissions
permissions=(
  [admin]="admin"
  [devops_td]="admin"
  [developers]="write"
  [lideres_canales_digitales]="write"
  [qa-canalesdigitales]="write"
)

info "Asignando permisos a grupos..."

for group in "${!permissions[@]}"; do
  local permission="${permissions[$group]}"
  local endpoint="/repositories/$WORKSPACE/$REPO_SLUG/permissions-config/groups/$group"
  local data="{\"permission\": \"$permission\"}"
  
  bitbucket_api_call "PUT" "$endpoint" "$data" "Permiso '$permission' asignado al grupo '$group'"
done

echo ""
success "¡Todos los permisos fueron asignados exitosamente!"
