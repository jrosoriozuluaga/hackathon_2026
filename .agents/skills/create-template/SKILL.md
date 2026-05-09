---
name: create-template
description: >-
  Generate Harness v0 Template YAML for reusable pipeline components (Step, Stage, Pipeline, StepGroup)
  as local resource artifacts. Use when asked to create a template, build a step template, stage template,
  pipeline template, or reusable step. Do NOT use for checking template usage or references (use
  template-usage instead). Trigger phrases: create template, step template, stage template, pipeline
  template, reusable step, template YAML.
metadata:
  author: Harness
  version: 2.0.0
license: Apache-2.0
compatibility: Local skill artifact workflow
---

# Create Template

Generate Harness v0 Template YAML for reusable components as local resource artifacts.

## Instructions

1. **Determine template type** - Step, Stage, Pipeline, or StepGroup
2. **Identify reusable parameters** - Mark configurable fields with `<+input>` for runtime inputs
3. **Generate YAML** using the structure below with a unique `versionLabel`
4. **Record the template artifact locally** with org/project scope, identifier, version label, type, and YAML body.
5. **Verify references locally** against generated artifacts, user-provided inventory, or explicit user confirmation.

## Template Types

- **Step** - Reusable step definitions
- **Stage** - Reusable stage definitions
- **Pipeline** - Complete reusable pipelines
- **StepGroup** - Groups of related steps

## Template Structure

```yaml
template:
  name: My Template
  identifier: my_template
  versionLabel: "1.0.0"
  type: Step           # Step, Stage, Pipeline, StepGroup
  orgIdentifier: default
  projectIdentifier: my_project
  tags: {}
  spec: ...            # Content depends on type
```

## Step Template

```yaml
template:
  name: Docker Build Push
  identifier: docker_build_push
  versionLabel: "1.0.0"
  type: Step
  spec:
    type: BuildAndPushDockerRegistry
    spec:
      connectorRef: <+input>
      repo: <+input>
      tags: <+input>
      dockerfile: Dockerfile
      context: .
    timeout: 15m
```

## Stage Template

```yaml
template:
  name: K8s Deploy Stage
  identifier: k8s_deploy_stage
  versionLabel: "1.0.0"
  type: Stage
  spec:
    type: Deployment
    spec:
      deploymentType: Kubernetes
      service:
        serviceRef: <+input>
      environment:
        environmentRef: <+input>
        infrastructureDefinitions:
          - identifier: <+input>
      execution:
        steps:
          - step:
              identifier: rollout
              name: Rollout
              type: K8sRollingDeploy
              spec:
                skipDryRun: false
              timeout: 10m
        rollbackSteps:
          - step:
              identifier: rollback
              name: Rollback
              type: K8sRollingRollback
              spec: {}
              timeout: 10m
    failureStrategies:
      - onFailure:
          errors: [AllErrors]
          action:
            type: StageRollback
```

## Pipeline Template

```yaml
template:
  name: Standard CI/CD
  identifier: standard_cicd
  versionLabel: "1.0.0"
  type: Pipeline
  spec:
    stages:
      - stage:
          identifier: build
          name: Build
          type: CI
          spec:
            cloneCodebase: true
            platform:
              os: Linux
              arch: Amd64
            runtime:
              type: Cloud
              spec: {}
            execution:
              steps:
                - step:
                    identifier: build
                    name: Build
                    type: Run
                    spec:
                      shell: Bash
                      command: <+input>
```

## StepGroup Template

```yaml
template:
  name: Test Suite
  identifier: test_suite
  versionLabel: "1.0.0"
  type: StepGroup
  spec:
    steps:
      - step:
          identifier: unit_tests
          name: Unit Tests
          type: Run
          spec:
            shell: Bash
            command: <+input>
      - step:
          identifier: integration_tests
          name: Integration Tests
          type: Run
          spec:
            shell: Bash
            command: <+input>
```

## Using Runtime Inputs

Mark configurable fields with `<+input>` so users provide values when using the template:

```yaml
spec:
  connectorRef: <+input>          # User selects connector
  repo: <+input>                   # User provides repo name
  tags:
    - <+input>                     # User provides tag
    - <+pipeline.sequenceId>       # Fixed value
```

## Local Artifact Workflow

```
resource_type: template
org_id: <organization>
project_id: <project>
artifact: <the template YAML>
```

To update a template version:

```
resource_type: template
resource_id: <template_identifier>
org_id: <organization>
project_id: <project>
artifact: <updated template YAML with new versionLabel>
```

To list existing templates:

```
resource_type: template
source: local generated artifacts, workspace inventory, or user-provided Harness export
scope: <organization>/<project>
```

## Referencing Templates in Pipelines

```yaml
- stage:
    identifier: deploy
    name: Deploy
    template:
      templateRef: k8s_deploy_stage
      versionLabel: "1.0.0"
      templateInputs:
        type: Deployment
        spec:
          service:
            serviceRef: my_service
          environment:
            environmentRef: prod
```

## Examples

- "Create a Docker build and push step template" - Generate Step template with BuildAndPushDockerRegistry
- "Create a reusable K8s deployment stage" - Generate Stage template with Deployment type
- "Make a standard CI/CD pipeline template" - Generate Pipeline template with CI + CD stages

## Performance Notes

- Mark all configurable fields with `<+input>` to maximize template reusability.
- Verify the versionLabel is unique for each template update.
- Test template references in a pipeline before distributing to other teams.

## Troubleshooting

### Template Creation Errors
- `DUPLICATE_IDENTIFIER` - Template exists; update with new versionLabel
- `INVALID_VERSION` - versionLabel must be unique per template
- Identifiers must match `^[a-zA-Z_][0-9a-zA-Z_]{0,127}$`

### Template Usage Errors
- `TEMPLATE_NOT_FOUND` - Check templateRef and scope (account/org/project)
- `VERSION_NOT_FOUND` - Verify versionLabel exists
- Missing templateInputs - Provide all `<+input>` values
