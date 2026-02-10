#!/bin/bash

# Cargar variables de entorno desde el archivo .env
if [ -f .env ]; then
    # Cargar variables de entorno
    export $(grep -v '^#' .env | xargs)
else
    echo '\033[31mError: .env no encontrado.\033[0m'
    exit 1
fi

# Función para imprimir mensajes de progreso
print_progress() {
    local message="$1"
    echo "\033[32m[PROGRESS] $message\033[0m"
}

# Función para manejar errores
error_handling() {
    local exit_code="$1"
    local last_command="$2"
    if [ $exit_code -ne 0 ]; then
        echo "\033[31mError: El comando '$last_command' falló con el código de salida $exit_code.\033[0m"
        exit $exit_code
    fi
}

# Sección de permisos de repositorio
print_progress "Ejecutando 01-repository-permissions.sh..."
./01-repository-permissions.sh
error_handling $? "./01-repository-permissions.sh"

# Sección de revisores predeterminados
print_progress "Ejecutando 02-default-reviewers.sh..."
./02-default-reviewers.sh
error_handling $? "./02-default-reviewers.sh"

# Restricciones de rama para producción
print_progress "Ejecutando 03-branch-restrictions-production.sh..."
./03-branch-restrictions-production.sh
error_handling $? "./03-branch-restrictions-production.sh"

# Restricciones de rama para QA/FALP
print_progress "Ejecutando 04-branch-restrictions-qafalp.sh..."
./04-branch-restrictions-qafalp.sh
error_handling $? "./04-branch-restrictions-qafalp.sh"

# Restricciones de rama para desarrollo
print_progress "Ejecutando 05-branch-restrictions-develop.sh..."
./05-branch-restrictions-develop.sh
error_handling $? "./05-branch-restrictions-develop.sh"

print_progress "Todos los scripts se han ejecutado correctamente."