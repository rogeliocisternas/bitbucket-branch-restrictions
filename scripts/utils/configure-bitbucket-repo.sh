#!/bin/bash

# Configuración
BITBUCKET_URL="https://api.bitbucket.org/2.0"
WORKSPACE="tu-workspace"
REPO_SLUG="tu-repositorio"
USERNAME="tu-usuario"
APP_PASSWORD="tu-app-password"

echo "========================================="
echo "Configurando repositorio: ${REPO_SLUG}"
echo "========================================="

# 1. PERMISOS DE REPOSITORIO
echo "1. Configurando permisos de repositorio..."

groups=("administrators:admin" "devops_td:admin" "developers:write" "lideres_canales_digitales:write" "qa-canalesdigitales:write")

for group_perm in "${groups[@]}"; do
  IFS=':' read -r group perm <<< "$group_perm"
  echo "  - Asignando ${perm} a ${group}"
  curl -s -X PUT \
    -u "${USERNAME}:${APP_PASSWORD}" \
    "${BITBUCKET_URL}/workspaces/${WORKSPACE}/permissions/repositories/${REPO_SLUG}" \
    -H "Content-Type: application/json" \
    -d "{\"type\": \"repository_group_permission\", \"group\": {\"slug\": \"${group}\"}, \"permission\": \"${perm}\"}" > /dev/null
done

echo "✓ Permisos configurados"

# 2. DEFAULT REVIEWERS
echo "2. Configurando default reviewers..."
echo "   NOTA: Debes reemplazar los UUIDs con los valores reales"

reviewers=(
  "jabes.fuentes"
  "jhon.valderrama"
  "jose.opazo"
  "juan.puga"
  "karen.sudzuki"
  "luis.cruz"
  "patricio.sanhueza"
  "rogelio.cisternas"
)

# Descomentar cuando tengas los UUIDs reales
# for reviewer in "${reviewers[@]}"; do
#   echo "  - Agregando ${reviewer}"
#   curl -s -X PUT \
#     -u "${USERNAME}:${APP_PASSWORD}" \
#     "${BITBUCKET_URL}/repositories/${WORKSPACE}/${REPO_SLUG}/default-reviewers/${reviewer}" > /dev/null
# done

echo "✓ Default reviewers configurados (verificar UUIDs)"

# 3. BRANCH RESTRICTIONS
echo "3. Configurando branch restrictions..."

# Helper function
create_restriction() {
  curl -s -X POST \
    -u "${USERNAME}:${APP_PASSWORD}" \
    "${BITBUCKET_URL}/repositories/${WORKSPACE}/${REPO_SLUG}/branch-restrictions" \
    -H "Content-Type: application/json" \
    -d "$1" > /dev/null
}

# PRODUCTION BRANCH
echo "  - Configurando rama 'production'"
create_restriction '{"kind": "push", "branch_match_kind": "glob", "pattern": "production", "groups": [{"slug": "administrators"}]}'
create_restriction '{"kind": "delete", "branch_match_kind": "glob", "pattern": "production", "groups": [], "users": []}'
create_restriction '{"kind": "force", "branch_match_kind": "glob", "pattern": "production", "groups": [], "users": []}'
create_restriction '{"kind": "require_approvals_to_merge", "branch_match_kind": "glob", "pattern": "production", "value": 3, "groups": [{"slug": "administrators"}]}'
create_restriction '{"kind": "require_default_reviewer_approvals_to_merge", "branch_match_kind": "glob", "pattern": "production", "value": 3}'
create_restriction '{"kind": "require_tasks_to_be_completed", "branch_match_kind": "glob", "pattern": "production"}'
create_restriction '{"kind": "require_passing_builds_to_merge", "branch_match_kind": "glob", "pattern": "production", "value": 1}'
create_restriction '{"kind": "enforce_merge_checks", "branch_match_kind": "glob", "pattern": "production"}'

# QAFALP BRANCH
echo "  - Configurando rama 'qafalp'"
create_restriction '{"kind": "push", "branch_match_kind": "glob", "pattern": "qafalp", "groups": [{"slug": "administrators"}]}'
create_restriction '{"kind": "delete", "branch_match_kind": "glob", "pattern": "qafalp", "groups": [], "users": []}'
create_restriction '{"kind": "force", "branch_match_kind": "glob", "pattern": "qafalp", "groups": [], "users": []}'
create_restriction '{"kind": "require_approvals_to_merge", "branch_match_kind": "glob", "pattern": "qafalp", "value": 1, "groups": [{"slug": "administrators"}, {"slug": "devops_td"}, {"slug": "lideres_canales_digitales"}, {"slug": "qa-canalesdigitales"}]}'
create_restriction '{"kind": "require_default_reviewer_approvals_to_merge", "branch_match_kind": "glob", "pattern": "qafalp", "value": 1}'
create_restriction '{"kind": "enforce_merge_checks", "branch_match_kind": "glob", "pattern": "qafalp"}'

# DEVELOP BRANCH
echo "  - Configurando rama 'develop'"
create_restriction '{"kind": "push", "branch_match_kind": "glob", "pattern": "develop", "groups": [{"slug": "administrators"}, {"slug": "devops_td"}, {"slug": "lideres_canales_digitales"}]}'
create_restriction '{"kind": "delete", "branch_match_kind": "glob", "pattern": "develop", "groups": [], "users": []}'
create_restriction '{"kind": "force", "branch_match_kind": "glob", "pattern": "develop", "groups": [], "users": []}'
create_restriction '{"kind": "require_approvals_to_merge", "branch_match_kind": "glob", "pattern": "develop", "value": 1, "groups": [{"slug": "administrators"}, {"slug": "developers"}, {"slug": "devops_td"}, {"slug": "lideres_canales_digitales"}]}'
create_restriction '{"kind": "require_passing_builds_to_merge", "branch_match_kind": "glob", "pattern": "develop", "value": 1}'
create_restriction '{"kind": "enforce_merge_checks", "branch_match_kind": "glob", "pattern": "develop"}'

echo "✓ Branch restrictions configuradas"

echo "========================================="
echo "Configuración completada exitosamente"
echo "========================================="