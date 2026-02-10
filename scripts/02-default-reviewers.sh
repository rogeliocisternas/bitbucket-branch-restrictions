#!/bin/bash

# Configure default reviewers for Bitbucket Pull Requests

# List of default reviewers
declare -a DEFAULT_REVIEWERS=(
    "Jabes Fuentes Salazar"
    "Jhon Alexander Valderrama Golborne"
    "Jose Ignacio Opazo Lopez"
    "Juan Carlos Puga Calderon"
    "Karen Sudzuki Toro"
    "Luis Kevin Cruz Flores"
    "Patricio Frank Sanhueza Titiro"
    "Rogelio Andres Cisternas Vera"
)

# API Endpoint
BITBUCKET_API_URL="https://api.bitbucket.org/2.0/repositories/{workspace}/{repo_slug}/default-reviewers"

# Setting up default reviewers
for reviewer in "${DEFAULT_REVIEWERS[@]}"; do
    curl -X POST "${BITBUCKET_API_URL}" \ 
        -H "Content-Type: application/json" \ 
        -d "{\"user\":{\"username\":\"$reviewer\"}}"
done

echo "Default reviewers configured successfully!"