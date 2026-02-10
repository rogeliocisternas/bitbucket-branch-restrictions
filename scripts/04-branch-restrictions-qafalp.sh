#!/bin/bash

# Bash script to set branch restrictions for the 'qafalp' branch

# Define repository details
REPO_OWNER="rogeliocisternas"
REPO_NAME="bitbucket-branch-restrictions"
BRANCH_NAME="qafalp"

# Define branch restrictions JSON payload
BRANCH_RESTRICTIONS='''{
    "type": "branch_restriction",
    "kind": "write_access",
    "value": ["Administrators"]
}, {
    "type": "branch_restriction",
    "kind": "delete",
    "value": false
}, {
    "type": "branch_restriction",
    "kind": "force",
    "value": false
}, {
    "type": "branch_restriction",
    "kind": "require_approvals_to_merge",
    "value": 1,
    "groups": ["Administrators", "devops_td", "lideres_canales_digitales", "qa-canalesdigitales"]
}, {
    "type": "branch_restriction",
    "kind": "require_default_reviewer_approvals_to_merge",
    "value": 1
}, {
    "type": "branch_restriction",
    "kind": "enforce_merge_checks"
}'''

# Call the Bitbucket API to set branch restrictions

curl -X POST "https://api.bitbucket.org/2.0/repositories/$REPO_OWNER/$REPO_NAME/branch-restrictions" \
-H "Content-Type: application/json" \
-d "$BRANCH_RESTRICTIONS" \
-H "Authorization: Bearer <YOUR_ACCESS_TOKEN>" # Replace <YOUR_ACCESS_TOKEN> with your actual access token  

echo "Branch restrictions for '$BRANCH_NAME' have been set."