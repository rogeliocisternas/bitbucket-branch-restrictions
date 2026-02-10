#!/bin/bash

# Load common functions
source utils/common.sh

# Validate environment variables
if [[ -z "$BITBUCKET_USERNAME" || -z "$BITBUCKET_PASSWORD" || -z "$REPO_SLUG" ]]; then
  echo "Please set BITBUCKET_USERNAME, BITBUCKET_PASSWORD, and REPO_SLUG environment variables."
  exit 1
fi

# Assign permissions to groups using Bitbucket API
declare -A permissions
permissions=(
  [admin]="admin"
  [devops_td]="admin"
  [developers]="write"
  [lideres_canales_digitales]="write"
  [qa-canalesdigitales]="write"
)

for group in "${!permissions[@]}"; do
  curl -X PUT -u "$BITBUCKET_USERNAME:$BITBUCKET_PASSWORD" \
    "https://api.bitbucket.org/2.0/repositories/"></>rogeliocisternas/$REPO_SLUG/permissions-config/groups/$group" \
    -H 'Content-Type: application/json' \
    -d '{"permission": "${permissions[$group]}"}'
done

echo "Permissions assigned successfully.
"