# Risk Register — Top 5

| # | Riesgo | Probabilidad | Impacto | Score | Mitigación | Owner |
|---|---|---|---|---|---|---|
| R1 | **Registro público inaccesible** (captcha, IP ban, downtime) | Alta | Alto | 🔴 | Pre-descargar datos en H0. Tener 2+ fuentes por país. Fallback a datos estáticos. Ver runbook §1 | Tech |
| R2 | **Claude API rate-limit durante demo** | Media | Crítico | 🔴 | Cache todas las respuestas pre-demo. Batch requests. Tener respuestas pre-generadas para el demo flow exacto. Ver runbook §3 | Tech |
| R3 | **Datos insuficientes para demo convincente** (< 50 empresas con score) | Media | Alto | 🟡 | Checkpoint H4: si < 50 empresas, pivotar a fewer-but-richer. Seed manual si es necesario. Comercial valida volumen en H3 | Comercial |
| R4 | **Scope creep — intentar demasiadas features** | Alta | Medio | 🟡 | Plan hora-por-hora es rígido. Checkpoint H4 corta features. "Working demo > feature list". Tech Lead tiene veto en scope | Tech |
| R5 | **Internet del venue falla** | Baja | Crítico | 🟡 | 2 hotspots móviles como backup. Datos pre-cargados. Demo offline como plan B. Screencast grabado en H7. Ver runbook §2 | Todos |

---

## Triggers de escalación

| Hora | Trigger | Acción |
|---|---|---|
| H1 | No se puede acceder a ningún registro | Pivotar a fuente alternativa o país con API pública |
| H2 | Scraper tiene < 10 registros | Cargar datos manual + fallback estáticos |
| H3 | Pipeline no funciona end-to-end | Simplificar: quitar Make, hacer todo local |
| H4 | < 30 empresas en DB | Seed manual + reducir scope del demo |
| H6 | Demo no funciona en run-through | Congelar features, focus en lo que SÍ funciona |
| H7 | Cualquier cosa se rompe | Usar screencast grabado como backup |

---

## Decisiones de corte (qué sacrificar primero)

Orden de sacrificio si hay que cortar scope:

1. ~~CRM push (Monday)~~ — mostrar datos en Supabase directamente
2. ~~Outreach generation~~ — mostrar solo scoring
3. ~~Múltiples fuentes de signals~~ — usar solo 1 (hiring O funding)
4. ~~UI pulida~~ — datos en tabla básica funciona
5. **NUNCA cortar**: scraping + normalización + al menos 1 signal type. Sin esto no hay demo.
