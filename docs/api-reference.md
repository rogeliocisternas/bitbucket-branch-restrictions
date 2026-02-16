# Bitbucket API Reference

## Authentication
Bitbucket API usa OAuth o tokens de API para autenticación. Para realizar llamadas a la API, debes usar un token de API (Bearer token).

### Example usando cURL:
```bash
curl -H "Authorization: Bearer YOUR_API_TOKEN" https://api.bitbucket.org/2.0/user
```

## Repository Permissions Endpoints
### Get Repository Permissions
- **Endpoint:** `GET /repositories/{username}/{repo_slug}/permissions/
- **Description:** Retrieve permissions for a repository.

### Example:
```bash
curl -X GET -H "Authorization: Bearer YOUR_API_TOKEN" https://api.bitbucket.org/2.0/repositories/username/reponame/permissions/
```
- **Response Example:**
```json
{
    "type": "repository",
    "permissions": [
        {"type": "read"},
        {"type": "write"}
    ]
}
```

## Default Reviewers Endpoints
### Get Default Reviewers
- **Endpoint:** `GET /repositories/{username}/{repo_slug}/default-reviewers/
- **Description:** Retrieve default reviewers for a repository.

## Branch Restrictions Endpoints
The following types of restrictions can be applied:
1. **Push**
2. **Delete**
3. **Force**
4. **Require Approvals to Merge**
5. **Require Default Reviewer Approvals to Merge**
6. **Require Tasks to be Completed**
7. **Require Passing Builds to Merge**
8. **Enforce Merge Checks**

### Example to Set a Push Restriction:
```bash
curl -X POST -H "Authorization: Bearer YOUR_API_TOKEN" \
-H "Content-Type: application/json" \
-d '{"kind": "push", "users": ["user1", "user2"]}' \
https://api.bitbucket.org/2.0/repositories/username/reponame/branch-restrictions/
```
### Response:
```json
{
    "type": "branch_restriction",
    "kind": "push",
    "users": ["user1", "user2"]
}
```

## Users Endpoints
### Get Users
- **Endpoint:** `GET /users/
- **Description:** Retrieve a list of users.

### Example:
```bash
curl -X GET -H "Authorization: Bearer YOUR_API_TOKEN" https://api.bitbucket.org/2.0/users/
```

## HTTP Response Codes
- **200 OK:** Request succeeded.
- **401 Unauthorized:** Authentication failed.
- **403 Forbidden:** Insufficient permissions.
- **404 Not Found:** Resource not found.

## Error Examples
- **Error:** `Unauthorized`
```json
{
    "error": {
        "message": "Authentication failed"
    }
}
```

## Limitations
- Some configurations require manual setup in the Bitbucket UI.

## Official References
- [Bitbucket API Documentation](https://developer.atlassian.com/server/bitbucket/rest/overview/)

## Branch Match Kinds
- **Glob:** Matches based on wildcard patterns.
- **Branching Model:** Uses the defined branching strategy of the repository.

## Development Tips
Use [jq](https://stedolan.github.io/jq/) para parsear respuestas JSON:
```bash
curl -X GET -H "Authorization: Bearer YOUR_API_TOKEN" https://api.bitbucket.org/2.0/repositories/username/reponame/permissions/ | jq '.permissions[] | .type'
```

