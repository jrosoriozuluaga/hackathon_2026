# Harness Skills

This repository contains local agent skills for designing, generating, validating, and documenting Harness.io CI/CD resources. The skills are file-first: they produce local YAML, Markdown, and review artifacts that can later be applied through the user's preferred Harness workflow.

## Local Skill Workflow

All skills operate through local artifacts and structured handoffs:

| Artifact | Purpose |
|----------|---------|
| Skill instructions | Define how to generate and validate each Harness resource type |
| `references/` | Local schema notes, examples, and domain guidance loaded on demand |
| `scripts/` | Optional local validators and helper scripts |
| `assets/` | Optional static examples, templates, or support files |
| Project-management docs | Track tasks, decisions, changelog entries, and roadmap items |

The default output is an implementation-ready artifact plus a validation checklist. Resource existence checks are performed against user-provided context, local manifests, generated artifacts, or explicit inventory files in the workspace.

## Skill Directory

Skills live in `skills/<skill-name>/SKILL.md`. Each skill folder may contain `references/`, `scripts/`, and `assets/` subdirectories.

### Pipeline & Execution

| Skill | Description |
|-------|-------------|
| `/create-pipeline` | Generate v0 pipeline YAML (CI, CD, combined, approvals) |
| `/create-pipeline-v1` | Generate v1 simplified pipeline YAML |
| `/create-trigger` | Create webhook, scheduled, and artifact triggers |
| `/create-template` | Create reusable step, stage, pipeline, and step group templates |
| `/run-pipeline` | Execute and monitor pipeline runs |
| `/debug-pipeline` | Diagnose pipeline execution failures |
| `/migrate-pipeline` | Convert v0 pipelines to v1 format |

### Infrastructure & Resources

| Skill | Description |
|-------|-------------|
| `/create-service` | Define services (Kubernetes, Helm, ECS) with artifact sources |
| `/create-environment` | Create environments (PreProduction, Production) with overrides |
| `/create-infrastructure` | Define infrastructure (K8s, ECS, Serverless) |
| `/create-connector` | Create connectors (GitHub, AWS, GCP, Azure, Docker, K8s) |
| `/create-secret` | Manage secrets (SecretText, SecretFile, SSHKey, WinRM) |

### Access Control & Users

| Skill | Description |
|-------|-------------|
| `/manage-users` | Manage users, user groups, and service accounts |
| `/manage-roles` | RBAC roles, assignments, permissions, and resource groups |

### Feature Flags

| Skill | Description |
|-------|-------------|
| `/manage-feature-flags` | Create, list, toggle, and delete feature flags |

### Platform Operations

| Skill | Description |
|-------|-------------|
| `/manage-delegates` | Monitor delegate health and manage registration tokens |

### Observability & Governance

| Skill | Description |
|-------|-------------|
| `/analyze-costs` | Cloud cost analysis, recommendations, and anomaly detection |
| `/security-report` | Security vulnerabilities, SBOMs, and compliance reports |
| `/dora-metrics` | DORA metrics and engineering performance reports |
| `/gitops-status` | GitOps application health, sync status, and pod logs |
| `/chaos-experiment` | Create and run chaos engineering experiments |
| `/scorecard-review` | IDP scorecards and service maturity review |
| `/audit-report` | Audit trails and compliance evidence (SOC2, GDPR, HIPAA) |
| `/template-usage` | Template dependency tracking, impact analysis, and adoption |
| `/create-policy` | Create OPA governance policies for supply chain security |

### Agents

| Skill | Description |
|-------|-------------|
| `/create-agent-template` | Generate AI agent templates (metadata.json, pipeline.yaml, wiki.MD) |

## Cross-Skill Workflows

When users need end-to-end setup, follow these dependency chains. Each step depends on the previous -- do not skip steps or create resources that reference connectors/secrets that don't exist yet.

### New Microservice Setup

Use when a user wants to deploy a new service to Harness. Follow this exact order:

1. **Create connectors** (`/create-connector`) -- GitHub connector for source code and manifests, Docker/ECR/GCR connector for container images, K8s/cloud connector for target infrastructure
2. **Create secrets** (`/create-secret`) -- Authentication tokens, SSH keys, or credentials referenced by connectors
3. **Create service** (`/create-service`) -- Reference the Git connector for manifests, reference the Docker connector for artifact source
4. **Create environment** (`/create-environment`) -- PreProduction and/or Production with environment-specific variables
5. **Create infrastructure** (`/create-infrastructure`) -- Reference the K8s/cloud connector for the target cluster. If no connector exists for the target, create one first
6. **Create pipeline** (`/create-pipeline`) -- Build pipeline based on source code language and manifest type. Reference the service, environment, and infrastructure from previous steps
7. **Create trigger** (`/create-trigger`) -- Automate the pipeline with webhook (PR/push) or artifact triggers

### New Project Onboarding

Use when a user is setting up a brand new Harness project from scratch:

1. **Create project definition** -- Capture the target `org_id`, project identifier, and project name as local planning artifacts
2. **Create connectors** (`/create-connector`) -- All connectors needed for the project (Git, cloud, registry, cluster)
3. **Create secrets** (`/create-secret`) -- All secret references for connector auth
4. **Create service** (`/create-service`) -- Service definitions for each microservice
5. **Create environment** (`/create-environment`) -- Dev, staging, production environments
6. **Create infrastructure** (`/create-infrastructure`) -- Infrastructure definitions per environment
7. **Create pipeline** (`/create-pipeline`) -- CI/CD pipelines for each service
8. **Create trigger** (`/create-trigger`) -- Automate all pipelines

**Key rule:** Always check if a referenced resource (connector, secret, environment) exists before creating something that depends on it. If it doesn't exist, create it first. Ask the user for the org and project context before starting.

## Scope & Context Convention

Before generating or changing any resource artifact, always establish the user's scope:

1. **Ask for org and project** if not already known. Most Harness resources are scoped to an org + project.
2. **Check local inventory or user-provided context** to verify referenced resources exist before creating dependents (e.g., confirm a connector exists before referencing it in a service).
3. **Account-level resources** (no org/project) are visible to all orgs and projects. Org-level resources are visible to all projects in that org. Project-level resources are only visible within that project.
4. **If the user provides a Harness UI URL**, extract `org_id`, `project_id`, and `resource_id` manually and record them in the local task context.

## Schema Validation Convention

When generating local resource artifacts, validate them before presenting them as ready:

1. **Each skill lists required fields** in its Instructions section (identifier, name, type, yaml, etc.)
2. **Use local references** in the skill folder to discover expected shape and resource-specific rules.
3. **On validation errors**, identify the missing or invalid field, fix the artifact, and rerun local validation.

## Skill Standards

When creating or modifying skills, run `scripts/validate-skills.sh` to check compliance. See `CONTRIBUTING.md` for the full structure guide. Skills must have: frontmatter (name, description, metadata, license, compatibility), `## Instructions`, `## Examples`, `## Performance Notes`, and `## Troubleshooting` sections.

## Schema References

- **v0 Pipelines/Templates/Triggers**: https://github.com/harness/harness-schema/tree/main/v0
- **v1 Pipelines**: https://github.com/thisrohangupta/spec
- **Agent Templates**: https://github.com/thisrohangupta/agents
