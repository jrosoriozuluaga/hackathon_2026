# Runbook de Fallback

## Escenario 1: Scraping falla

### Síntomas
- Timeout en requests al registro público
- Captcha bloquea acceso
- IP baneada
- HTML structure cambió

### Plan B
1. **Inmediato (< 5 min)**: Cambiar a datos estáticos pre-descargados
   - Descargar manualmente 50-100 registros como HTML/JSON
   - Guardar en `/data/fallback/[país]/`
   - Apuntar el pipeline al directorio local en vez del scraper
2. **Si el registro principal está caído**: Usar fuente alternativa
   - BR: BrasilAPI (API pública) en vez de Receita Federal
   - MX: SIEM en vez de SAT
   - CO: Cámaras locales en vez de RUES
3. **Último recurso**: Usar datos de Crunchbase/LinkedIn scraping manual
   - Cada persona del equipo busca 10 empresas manualmente
   - Las carga en un CSV → import directo a Supabase

### Comando de fallback
```bash
# Cargar datos estáticos
node packages/scraper/src/load-fallback.ts --dir data/fallback/BR
```

---

## Escenario 2: Internet falla

### Plan B
1. **Hotspot móvil**: Al menos 2 personas deben tener datos móviles como backup
2. **Datos pre-cargados**: Antes de H2, descargar y commitear:
   - 100 registros crudos en `/data/raw/`
   - Respuestas de Claude pre-generadas en `/data/cached-responses/`
3. **Modo offline del demo**:
   - Dashboard funciona con datos locales (SQLite o JSON)
   - Screencast grabado como backup del demo en vivo
4. **Si internet vuelve parcialmente**: Priorizar solo las llamadas a Claude API (el scraping puede esperar)

---

## Escenario 3: Claude rate-limit / API down

### Síntomas
- HTTP 429 (rate limit)
- HTTP 529 (overloaded)
- Latencia > 30s por request

### Plan B
1. **Rate limit**: Implementar exponential backoff
   ```typescript
   const delay = Math.min(1000 * 2 ** attempt, 30000);
   ```
2. **Reducir volumen**: Procesar solo top 20 empresas en vez de todas
3. **Batch más grande**: Enviar 5 empresas por request en vez de 1
4. **Cache agresivo**: Guardar cada respuesta de Claude en `/data/cached-responses/`
5. **Fallback a reglas**: Si Claude está completamente caído:
   - Normalizer: regex + lookup tables hardcodeados por país
   - Scorer: scoring basado en reglas simples (tiene funding = +3, hiring = +2, etc.)
   - Outreach: templates pre-escritos con merge fields

### Templates de fallback (scorer)
```
score = 0
IF has_funding: score += 3
IF has_hiring_signals: score += 2
IF employee_count > 50: score += 1
IF founded_after_2020: score += 1
IF has_press_mentions: score += 2
IF has_website: score += 1
```

---

## Escenario 4: Supabase falla

### Plan B
1. **SQLite local**: Tener un script que crea las mismas tablas en SQLite
   ```bash
   sqlite3 data/local.db < db/migrations/001_initial_sqlite.sql
   ```
2. **JSON files**: Como último recurso, guardar datos como JSON en `/data/json/`
3. **Para el demo**: Apuntar el dashboard a datos estáticos JSON

---

## Escenario 5: Make.com falla

### Plan B
1. **Scripts locales**: Cada escenario de Make tiene un script equivalente en Node
   ```bash
   node scripts/manual-ingest.ts
   node scripts/manual-enrich.ts
   node scripts/manual-crm-push.ts
   ```
2. **Cron local**: `node-cron` corriendo en la máquina del Tech Lead
3. **Manual**: En el peor caso, correr los 3 pasos a mano antes del demo

---

## Contactos de emergencia

| Recurso | Acción |
|---|---|
| Supabase down | Status: status.supabase.com |
| Claude API | Status: status.anthropic.com |
| Make.com | Status: status.make.com |
| GitHub | Status: githubstatus.com |
| Internet venue | Pedir a organización del hackathon |

---

## Pre-flight checklist (correr en H0)

- [ ] Hotspot móvil testeado
- [ ] 50 registros de ejemplo descargados en `/data/fallback/`
- [ ] Script de fallback SQLite probado
- [ ] Screencast tool instalado (OBS / QuickTime)
- [ ] Todos los API keys en `.env` verificados con un test call
