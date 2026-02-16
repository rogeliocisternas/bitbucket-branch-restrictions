#!/bin/bash

# Configure branch restrictions for the Production branch in Bitbucket using API

REPO_URL="https://api.bitbucket.org/2.0/repositories/rogeliocisternas/bitbucket-branch-restrictions/branch-restrictions"

# JSON payload for the restrictions
read -r -d '' PAYLOAD << EOM
{
  "type": "access",
  "kind": "access",
  "pattern": "production",
  "value": [
    {
      "kind": "allow",
      "group": "Administrators"
    }
  ]
}
EOM

# Prevent deletion
curl -X POST "$REPO_URL" -H "Content-Type: application/json" -d '{"type":"delete","pattern":"production"}'

# Prevent force push
curl -X POST "$REPO_URL" -H "Content-Type: application/json" -d '{"type":"force","pattern":"production"}'

# Require 3 approvals
curl -X POST "$REPO_URL" -H "Content-Type: application/json" -d '{"type":"require_approvals_to_merge","value":3,"pattern":"production"}'

# Require 3 default reviewer approvals
curl -X POST "$REPO_URL" -H "Content-Type: application/json" -d '{"type":"require_default_reviewer_approvals_to_merge","value":3,"pattern":"production"}'

# Require all tasks completed
curl -X POST "$REPO_URL" -H "Content-Type: application/json" -d '{"type":"require_tasks_to_be_completed","pattern":"production"}'

# Require passing builds
curl -X POST "$REPO_URL" -H "Content-Type: application/json" -d '{"type":"require_passing_builds_to_merge","value":1,"pattern":"production"}'

# Enforce merge checks
curl -X POST "$REPO_URL" -H "Content-Type: application/json" -d '{"type":"enforce_merge_checks","pattern":"production"}'
