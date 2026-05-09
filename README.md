# Hackathon 2026 Harness

Este repositorio es un harness de ingeniería para agentes de IA. Su objetivo es mantener en un solo lugar las skills, subagentes, reglas de arquitectura y artefactos de gestión que permiten construir, validar y documentar recursos de Harness.io sin depender de un runtime específico.

El principio central es simple: `.agents/` es la fuente canónica y cada agente externo consume una vista del mismo contenido mediante symlinks o adaptadores livianos. Así Claude, Codex, Cursor, Windsurf u otros runtimes pueden trabajar con la misma base sin duplicar prompts, skills ni decisiones.

## Arquitectura

El harness separa tres capas:

- **Capa canónica**: `.agents/` contiene las skills reales, los subagentes reutilizables y los documentos de gestión del proyecto.
- **Vistas por runtime**: `.claude/`, `.codex/`, `skills/` y futuras carpetas como `.cursor/` o `.windsurf/` exponen symlinks hacia `.agents/`.
- **Artefactos locales**: los recursos de Harness se diseñan, generan y validan como YAML, Markdown o reportes locales antes de cualquier aplicación externa.

El flujo de orquestación entra por `harness-architect`. El arquitecto define alcance, dependencias y riesgos; delega a especialistas cuando aplica; y pasa por `harness-tester` antes de marcar trabajo como terminado.

## Estructura Del Repositorio

```text
harness/
├── .agents/
│   ├── skills/                  # Fuente canónica de skills
│   │   └── <skill-name>/
│   │       ├── SKILL.md
│   │       ├── references/
│   │       ├── scripts/
│   │       └── assets/
│   ├── subagents/               # Roles reutilizables
│   │   ├── architect.md
│   │   ├── frontend.md
│   │   ├── backend.md
│   │   └── tester.md
│   └── project-management/      # Tareas, decisiones, roadmap y changelog
│       ├── TASKS.md
│       ├── CHANGELOG.md
│       ├── DECISIONS.md
│       └── ROADMAP.md
├── .claude/                     # Vista para Claude mediante symlinks
├── .codex/                      # Vista para Codex mediante symlinks
├── skills/                      # Vista de compatibilidad hacia .agents/skills
├── scripts/
│   └── validate-skills.sh       # Validación local del harness
├── skills-lock.json             # Manifest de skills y hashes
├── AGENTS.md                    # Reglas operativas generales
├── CLAUDE.md                    # Guía de arquitectura para agentes
└── README.md
```

## Subagentes

- `harness-architect`: punto de entrada. Clasifica solicitudes, confirma `org_id` y `project_id`, ordena dependencias y decide qué skill o subagente usar.
- `harness-frontend`: especialista en CI/CD de aplicaciones frontend, builds, tests, previews, assets y despliegues UI.
- `harness-backend`: especialista en servicios backend, APIs, workers, contenedores, secretos, migraciones y despliegues.
- `harness-tester`: validador. Revisa YAML, dependencias, placeholders, riesgos, criterios de aceptación y trazabilidad.

## Skills Disponibles

Las skills viven en `.agents/skills/` y se registran en `skills-lock.json`. Actualmente el harness incluye capacidades para:

- construcción de harness de agentes;
- conectores de Harness;
- infraestructura de despliegue;
- pipelines v0;
- políticas OPA;
- secretos;
- templates;
- debugging de pipelines;
- roles y RBAC.

Cada skill produce artefactos locales y debe validar su salida antes de presentarla como lista para usar.

## Flujo De Trabajo

1. **Intake**: el arquitecto interpreta la solicitud y confirma alcance de cuenta, organización, proyecto y recurso.
2. **Verificación de dependencias**: antes de crear dependientes, se confirma que existan conectores, secretos, servicios, ambientes e infraestructura.
3. **Delegación**: frontend, backend o una skill especializada preparan el artefacto o diagnóstico.
4. **Validación**: tester revisa forma, dependencias, placeholders, riesgos y criterios de aceptación.
5. **Registro**: la tarea se actualiza en `TASKS.md` y el cambio relevante se anota en `CHANGELOG.md`.
6. **Entrega**: el resultado queda como artefacto local listo para revisión o aplicación manual por el usuario.

Para onboarding de un microservicio nuevo, el orden esperado es:

1. conectores;
2. secretos;
3. servicio;
4. ambiente;
5. infraestructura;
6. pipeline;
7. trigger.

No se debe crear un recurso que referencie otro recurso no verificado.

## Gestión De Issues Y Tareas

Las tareas del harness se gestionan en `.agents/project-management/TASKS.md`. Cada issue o tarea usa un identificador incremental `HARNESS-NNN` y una fila con:

- `Status`: `TODO`, `IN_PROGRESS`, `BLOCKED`, `REVIEW` o `DONE`;
- `Owner`: `Architect`, `Frontend`, `Backend` o `Tester`;
- `Skill`: skill relacionada, o `n/a` si no aplica;
- `Created` y `Updated`: fechas en formato `YYYY-MM-DD`;
- `Acceptance Criteria`: criterios concretos y verificables.

El ciclo de gestión es:

1. **Crear tarea**: cuando aparezca una mejora, bug, validación o nuevo artefacto, se agrega a `TASKS.md` con estado `TODO` o `IN_PROGRESS`.
2. **Asignar dueño**: el arquitecto conserva la coordinación; especialistas toman tareas de dominio; tester toma validación.
3. **Actualizar estado**: los agentes cambian la fila conforme avanza el trabajo y mantienen la fecha `Updated` al día.
4. **Bloquear explícitamente**: si falta contexto, credenciales, alcance o una decisión del usuario, la tarea pasa a `BLOCKED`.
5. **Pasar a revisión**: antes de cerrar, la tarea debe cumplir criterios de aceptación y, cuando no sea solo documentación, pasar por tester.
6. **Cerrar**: solo se marca `DONE` cuando el resultado está validado y el cambio queda reflejado en `CHANGELOG.md`.

Si más adelante se conectan issues de GitHub, Linear u otra herramienta, `TASKS.md` seguirá siendo el registro local mínimo. La integración externa debe mapear cada issue al ID `HARNESS-NNN` para conservar trazabilidad.

## Decisiones Y Roadmap

- `DECISIONS.md` guarda ADRs cortas sobre arquitectura y reglas permanentes.
- `ROADMAP.md` agrupa las fases de evolución del harness.
- `CHANGELOG.md` registra cambios entregados o validados.
- `TASKS.md` mantiene el estado operacional de cada trabajo.

Todo cambio estructural debe tener una tarea y una entrada de changelog asociada.

## Validación Local

Ejecuta la validación del harness con:

```bash
scripts/validate-skills.sh
```

Este script revisa contratos de subagentes, consistencia de skills, documentos de gestión y symlinks de runtime.
