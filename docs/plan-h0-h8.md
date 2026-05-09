# Plan H0–H8: Timeline Hora por Hora

> Placeholders `[país]` y `[vertical]` se lockean al final de H1.
> Syncs cada 2h (H2, H4, H6). Checkpoint duro en H4.

---

## H0 (0:00–1:00) — SETUP

| Persona | Tarea | Output |
|---|---|---|
| **Tech** | Clone repo, `pnpm install`, crear proyecto Supabase, correr migration, configurar `.env` | Supabase vivo, schema deployed |
| **Marketing** | Crear cuenta Make.com, crear los 3 webhooks vacíos, documentar URLs en `.env` | Webhooks listos |
| **Design** | Abrir Figma/Canva, crear board para UI del dashboard demo, definir paleta y componentes | Board de diseño listo |
| **Comercial** | Crear/configurar cuenta Apollo, obtener API key, preparar las 5 queries | Apollo listo para baseline |
| **Influencer** | Crear cuentas en redes si faltan, preparar templates de posts, listar hashtags | Social media playbook |

---

## H0–H1 (0:00–1:00) — DISCOVERY SPRINT (paralelo con setup)

| Persona | Tarea | Output |
|---|---|---|
| **Tech** | Investigar BR + MX (registros, APIs, scrapeabilidad) | 2 issues `discovery` con score |
| **Marketing** | Investigar CO + AR (registros, cámaras) | 2 issues `discovery` con score |
| **Design** | Investigar CL + PE (registros tributarios) | 2 issues `discovery` con score |
| **Comercial** | Correr 5 queries Apollo en 6 países, medir cobertura | Issue `discovery` con baseline |
| **Influencer** | Mapear job boards + medios en 6 países | Issue `discovery` con mapa |

### H1:00 — DECISION GATE
- Meeting 15 min: presentar scores → elegir [país] + [vertical]
- Crear issue `DECISION: [país] + [vertical]`
- Cerrar milestone `H1-discovery-gate`
- **NADIE avanza hasta que esto esté cerrado**

---

## H1–H2 (1:00–2:00) — FOUNDATION

| Persona | Tarea | Output |
|---|---|---|
| **Tech** | Construir scraper v1 para registro público de [país]. Target: extraer 50+ empresas | `packages/scraper/` funcional |
| **Marketing** | Configurar escenario 1 en Make.com (webhook → normalize → Supabase insert) | Flow de ingest documentado |
| **Design** | Wireframes del dashboard: lista de empresas, detalle, score visual | Wireframes en `/demo/` |
| **Comercial** | Extraer datos Apollo para [país]+[vertical] como CSV baseline | CSV en `/data/apollo-baseline.csv` |
| **Influencer** | Primer post teaser: "Building X at hackathon" + behind-the-scenes | Post publicado con link |

### H2:00 — SYNC #1 (10 min)
- Tech muestra datos scrapeados
- Comercial compara con Apollo
- Ajustar si el scraper no está dando suficiente data

---

## H2–H3 (2:00–3:00) — DATA PIPELINE

| Persona | Tarea | Output |
|---|---|---|
| **Tech** | Integrar Claude API: normalizer prompt → clean data → insert en Supabase | Pipeline scrape→normalize→store |
| **Marketing** | Configurar escenario 2: enriquecimiento con Claude (signal scoring) | Flow de enrichment en Make |
| **Design** | Construir UI del dashboard con datos reales de Supabase | Dashboard v1 funcional |
| **Comercial** | Definir ICP de [vertical] en [país], crear lista de 20 empresas target | ICP doc + target list |
| **Influencer** | Crear contenido: "Apollo no tiene esto" — side-by-side comparison visual | Asset de comparación |

---

## H3–H4 (3:00–4:00) — ENRICHMENT + OUTREACH

| Persona | Tarea | Output |
|---|---|---|
| **Tech** | Signal scorer: procesar señales (hiring + funding + press) con Claude | Signals en DB con score 1-10 |
| **Marketing** | Configurar escenario 3: push a CRM/Monday con datos enriquecidos | Flow CRM push funcional |
| **Design** | UI de detalle de empresa: signals timeline, score gauge, contact info | Detalle UI completo |
| **Comercial** | Generar outreach drafts con Claude para top 10 empresas | 10 mensajes en tabla `outreach` |
| **Influencer** | Segundo post: demo preview / data insight interesante | Post publicado |

### H4:00 — CHECKPOINT (15 min) ⚠️
Ver `/docs/checkpoint-h4.md` para criterios de corte.

---

## H4–H5 (4:00–5:00) — POLISH + EDGE CASES

| Persona | Tarea | Output |
|---|---|---|
| **Tech** | Dedup logic, error handling, retry en scrapers, performance | Pipeline robusto |
| **Marketing** | QA de los 3 flows de Make, documentar edge cases | Flows probados end-to-end |
| **Design** | Responsive, animaciones, loading states, empty states | UI pulida |
| **Comercial** | Validar calidad de outreach: ¿suena humano? Ajustar prompt si no | Outreach refinado |
| **Influencer** | Preparar assets para el post de resultados final | Assets listos |

---

## H5–H6 (5:00–6:00) — DEMO PREP

| Persona | Tarea | Output |
|---|---|---|
| **Tech** | Seed DB con datos limpios para demo, fix bugs críticos | DB con 100+ empresas limpias |
| **Marketing** | Preparar métricas: "X empresas, Y signals, Z% más que Apollo" | Slide de métricas |
| **Design** | Pantallas finales del demo flow, favicon, branding | UI demo-ready |
| **Comercial** | Ensayar pitch 1x, ajustar script con feedback | Script validado |
| **Influencer** | Tercer post: "Results are in" con métricas parciales | Post publicado |

### H6:00 — SYNC #3 (10 min)
- Run-through del demo completo
- Identificar gaps y asignar fixes

---

## H6–H7 (6:00–7:00) — REHEARSAL

| Persona | Tarea | Output |
|---|---|---|
| **Tech** | Feature freeze. Solo bugfixes. Deploy final si aplica | Sistema estable |
| **Marketing** | Preparar one-pager / leave-behind para jueces | PDF listo |
| **Design** | Grabación de respaldo del demo (screencast) | Video backup en `/demo/` |
| **Comercial** | 2 ensayos completos del pitch de 2 min | Pitch afinado |
| **Influencer** | Post de countdown al demo | Post publicado |

---

## H7–H8 (7:00–8:00) — DEMO TIME

| Persona | Tarea | Output |
|---|---|---|
| **Tech** | Soporte técnico durante demo, backup si algo falla | Sistema corriendo |
| **Marketing** | Timer visible, señales al presenter si se pasa de tiempo | Timing perfecto |
| **Design** | Manejar pantalla / cambiar slides si es necesario | Visual support |
| **Comercial** | **DAR EL PITCH** | Demo entregado |
| **Influencer** | Grabación en vivo del demo, post inmediato post-demo | Contenido en vivo |

---

## Milestones

| Milestone | Hora | Gate |
|---|---|---|
| `H1-discovery-gate` | H1:00 | País + vertical lockeados |
| `H4-checkpoint` | H4:00 | Pipeline vivo o cortar features |
| `H8-demo-ready` | H7:30 | Demo ensayado y funcionando |
