---
name: manage-roles
description: >-
  Manage Harness RBAC roles, role assignments, permissions, and resource groups as local resource artifacts.
  List, create, update, and delete custom roles. View role assignments and permissions for users,
  groups, and service accounts. Use when asked to manage access control, assign roles, check
  permissions, create custom roles, review RBAC configuration, onboard users, or audit access.
  Trigger phrases: manage roles, RBAC, role assignment, user permissions, access control, custom role,
  resource group, who has access, grant access, revoke access.
metadata:
  author: Harness
  version: 1.0.0
license: Apache-2.0
compatibility: Local skill artifact workflow
---

# Manage Roles Skill

Manage Harness RBAC (Role-Based Access Control) as local resource artifacts.

## Local Artifact Operations

| Operation | Resource Type | Purpose |
|-----------|--------------|---------|
| Check local inventory | `role` | Find existing roles |
| Check local inventory | `role_assignment` | Review assignments |
| Check local inventory | `permission` | Review available permissions |
| Check local inventory | `resource_group` | Review resource groups |
| Draft artifact | `role` | Create or update a custom role definition |
| Draft artifact | `role_assignment` | Propose access grants or removals |
| Validate shape | `role` | Check required fields using local references |

For built-in roles (account/org/project/module), resource groups, common permissions, and role assignment structure, consult references/builtin-roles.md.

## Instructions

### Step 1: Understand Requirements

Determine:
- **Who** needs access (user email, group ID, or service account ID)
- **What** level of access (admin, developer, viewer, executor, custom)
- **Where** (account, org, project scope)
- **Which resources** (all or specific resource group)

### Step 2: List Existing Roles

```
resource_type: role
source: local inventory, generated artifacts, or user-provided Harness export
scope: <org>/<project>
search_term: <keyword>
```

### Step 3: Check Current Assignments

```
resource_type: role_assignment
source: local inventory, generated artifacts, or user-provided Harness export
scope: <org>/<project>
```

### Step 4: List Available Permissions (for custom roles)

```
resource_type: permission
source: local references, generated inventory, or user-provided Harness export
```

### Step 5: Create Custom Role (if needed)

```
resource_type: role
org_id: <org>
project_id: <project>
artifact:
  identifier: custom_deployer
  name: Custom Deployer
  description: Can execute pipelines and view services
  permissions:
    - core_pipeline_execute
    - core_pipeline_view
    - core_service_view
    - core_environment_view
```

Identifier must match pattern: `^[a-zA-Z_][0-9a-zA-Z_]{0,127}$`

### Step 6: View Resource Groups

```
resource_type: resource_group
source: local inventory, generated artifacts, or user-provided Harness export
scope: <org>/<project>
```

## Examples

### List all roles in a project

```
/manage-roles
Show me all roles available in the payments project
```

### Check who has admin access

```
/manage-roles
List all role assignments with admin privileges in the default org
```

### Create a custom read-only deployer role

```
/manage-roles
Create a custom role called "release-manager" that can execute pipelines,
view services and environments, but cannot edit anything
```

### Audit access for a user

```
/manage-roles
What roles does jane.smith@company.com have across all projects?
```

### Review resource groups

```
/manage-roles
Show me all resource groups and what they include
```

## Best Practices

- **Prefer groups over individual users** -- assign roles to USER_GROUP for easier management
- **Follow least privilege** -- start with viewer roles and add permissions as needed
- **Scope narrowly** -- use project-level roles over account-level when possible
- **Use built-in roles first** -- create custom roles only when built-in roles do not fit
- **Naming convention:** `{role}_{principal}` for identifiers (e.g., `deployer_ops_team`)

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| Role not found | Invalid role identifier | Built-in roles start with `_` -- verify exact identifier |
| Resource group not found | Invalid resource group | Check local inventory or user-provided resource group export |
| Principal not found | User/group/SA does not exist | Verify the principal exists before assigning |
| Duplicate identifier | Role with same ID exists | Use a unique identifier or update the existing role |
| Permission denied | Caller lacks RBAC management permissions | Need `core_role_view` / `core_role_edit` permissions |

## Performance Notes

- List existing roles and resource groups before creating new ones to avoid duplication.
- Verify role permissions match the principle of least privilege.
- Confirm user/group identifiers are correct before assigning roles — incorrect assignments may grant unintended access.

## Troubleshooting

### User Cannot Access Resources

1. List role assignments for the user to confirm a role is assigned
2. Check the role has the required permissions in local inventory or user-provided export
3. Verify the resource group scope includes the target resources
4. Check that the assignment is not `disabled: true`

### Custom Role Not Working

1. Verify all required permissions are included (e.g., `_view` permission is needed alongside `_edit`)
2. Check the role is assigned at the correct scope (account/org/project)
3. Confirm the resource group matches the resources the user needs

### Permission Denied When Managing Roles

1. The caller needs `core_role_edit` to create/update roles
2. The caller needs `core_roleassignment_edit` to manage assignments
3. Account-level operations require account admin or equivalent
