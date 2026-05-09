---
name: debug-pipeline
description: >-
  Diagnose Harness pipeline executions from local or user-provided evidence. Analyzes any execution (failed or successful) to produce
  structured reports with stage/step breakdown, timing, bottlenecks, failure details, chained pipeline
  drill-down, and execution logs. Use when asked to debug a pipeline, investigate a failure, find out
  why a build failed, analyze pipeline errors, check execution logs, review execution performance, or
  find bottlenecks. Trigger phrases: debug pipeline, pipeline failed, why did my build fail, analyze
  failure, pipeline error, execution logs, fix pipeline, execution bottleneck, slow pipeline.
metadata:
  author: Harness
  version: 2.1.0
license: Apache-2.0
compatibility: Local skill artifact workflow
---

# Debug Pipeline

Diagnose pipeline executions and suggest fixes from logs, YAML, screenshots, exports, or user-provided failure summaries.

## Instructions

### Step 1: Diagnose Execution (Preferred)

Use the best available local evidence. Accept an execution ID, pipeline ID, Harness URL, exported execution JSON, logs, screenshots, or pasted failure text:

```
input:
  pipeline_id: <pipeline_identifier>
  execution_id: <execution_identifier>
  url: <optional Harness URL>
  org_id: <organization>
  project_id: <project>
  evidence: <logs, exported JSON, screenshots, or failure text>
```

Return a structured report with stage/step breakdown, timing, bottlenecks, failure details, and any chained pipeline failures visible in the evidence.

### Step 1b: Full Diagnostic Mode

For deeper analysis, request logs and pipeline YAML:

```
request:
  execution_id: <execution_id>
  org_id: <organization>
  project_id: <project>
  include_yaml: true
  include_logs: true
  log_snippet_lines: 120
  max_failed_steps: 5
```

### Diagnose Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `execution_id` | -- | Specific execution to analyze |
| `pipeline_id` | -- | Fetch latest execution for this pipeline |
| `url` | -- | Harness UI URL (auto-extracts IDs) |
| `summary` | true | Structured report (true) or raw payload (false) |
| `include_yaml` | false (summary) / true (raw) | Include pipeline YAML definition |
| `include_logs` | false (summary) / true (raw) | Include failed step logs |
| `log_snippet_lines` | 120 | Max log lines per step (tail). 0 = unlimited |
| `max_failed_steps` | 5 | Max steps to fetch logs for. 0 = unlimited |

### Step 2: Project Health Overview

Ask for or inspect local project health evidence for context:

```
request:
  org_id: <organization>
  project_id: <project>
  evidence: recent failed executions, running executions, deployment activity
```

### Step 3: Find Failed Executions (if needed)

```
resource_type: execution
source: local export, pasted list, screenshot, or user-provided run history
search_term: <pipeline name>
```

### Step 4: Get Execution Details

```
resource_type: execution
resource_id: <execution_id>
source: local export, pasted JSON, screenshot, or user-provided details
```

### Step 5: Get Execution Logs

```
resource_type: execution_log
resource_id: <execution_id>
source: local log file, pasted logs, or user-provided export
```

### Step 6: Get Pipeline Definition

```
resource_type: pipeline
resource_id: <pipeline_identifier>
source: local YAML, generated artifact, export, or user-provided definition
```

## Analysis Framework

Categorize errors and provide targeted fixes:

### Build Failures
- Missing dependencies - Check package.json/requirements.txt
- Compilation errors - Review recent code changes
- Docker build failures - Check Dockerfile and base image

### Infrastructure Errors
- "No delegate available" - Check delegate status, verify tags match
- Connector failures - Rotate credentials, test connection
- Resource limits - Check cloud quotas and limits

### Configuration Errors
- "Secret not found" - Verify secret exists at correct scope (account/org/project)
- "Could not resolve expression" - Check expression syntax
- "Connector not found" - Verify connectorRef identifier

### Deployment Errors
- ImagePullBackOff - Check registry credentials and image tag
- CrashLoopBackOff - Check container logs, resource limits
- Readiness probe failed - Review probe configuration

### Timeout Errors
- Step/stage exceeded timeout - Increase timeout or optimize
- Delegate task queued too long - Scale up delegates

### Artifact Errors
- "Artifact not found" - Verify artifact path, check upstream build

## Response Format

```
## Pipeline Failure Analysis

**Pipeline:** <name>
**Execution:** <id>
**Failed At:** <timestamp>

### Failure Summary
**Stage:** <failed_stage>
**Step:** <failed_step>
**Error:** <error message>

### Root Cause
<explanation>

### Fix
**Immediate:** <specific steps>
**Prevention:** <how to avoid in future>
```

## Examples

- "Why did my build pipeline fail?" - Request the pipeline ID plus logs or exported execution details
- "Debug execution abc123" - Request the execution evidence for `abc123`
- "Show me recent failures" - Ask for a recent execution export or screenshot, then drill into failures
- "Analyze the pipeline at https://app.harness.io/..." - Extract org/project/resource context from the URL and request logs/export if not available locally
- "Which stage is the bottleneck in my pipeline?" - Compare timing data from a successful execution export
- "Get full logs for the failed deploy step" - Request the failed step logs and analyze the tail plus root error

## Performance Notes

- Take your time analyzing logs thoroughly. Read complete error messages and stack traces before diagnosing.
- Check all failed steps, not just the first one. Multiple failures may share a root cause or reveal a dependency chain.
- Quality of diagnosis is more important than speed. A wrong diagnosis wastes more time than a thorough one.

## Troubleshooting

### Logs Not Available
- Logs expire based on retention settings
- Very recent executions may have delayed logs
- Aborted executions may not have complete logs

### Cannot Find Execution
- Verify org/project scope
- Remove filters to see all executions
- Check RBAC permissions

### Missing External Evidence
- Ask the user for logs, exported execution details, screenshots, or copied error text
- Confirm the org/project/pipeline identifiers before diagnosing
- Stop if the failure cannot be tied to a concrete stage, step, or error message
