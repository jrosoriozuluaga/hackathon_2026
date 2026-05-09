# Make.com Flows — 3 Escenarios

## Escenario 1: Ingest Diario

**Trigger**: Webhook (llamado por scraper o cron)
**Frecuencia**: Cada ejecución del scraper

```
[Webhook recibe JSON] 
  → [HTTP: Claude API — normalizer prompt]
  → [JSON Parse response]
  → [Iterator: por cada empresa]
    → [Supabase: Upsert en tabla companies]
    → [Supabase: Insert en tabla signals (si hay)]
  → [Slack/Discord notification: "X empresas ingestadas"]
```

### Configuración del Webhook
- Método: POST
- Content-Type: application/json
- Body esperado:
```json
{
  "source": "registry_br",
  "country": "BR",
  "raw_records": [
    {
      "external_id": "12345678000100",
      "name": "Empresa Exemplo LTDA",
      "raw_html": "<div>...</div>",
      "source_url": "https://..."
    }
  ]
}
```

### Módulo Claude (Normalizer)
- HTTP Module → POST `https://api.anthropic.com/v1/messages`
- Headers: `x-api-key`, `anthropic-version: 2023-06-01`
- Model: `claude-sonnet-4-6`
- System prompt: contenido de `/prompts/normalizer.md`
- Max tokens: 4096

### Módulo Supabase
- Conexión: API REST de Supabase
- URL: `${SUPABASE_URL}/rest/v1/companies`
- Headers: `apikey: ${SUPABASE_ANON_KEY}`, `Authorization: Bearer ${SUPABASE_SERVICE_KEY}`
- Método: POST con `Prefer: resolution=merge-duplicates` (upsert por external_id + country)

---

## Escenario 2: Enriquecimiento

**Trigger**: Schedule (cada 30 min) o Webhook manual
**Input**: Empresas sin signal_score en Supabase

```
[Supabase: GET companies WHERE signal_score IS NULL LIMIT 20]
  → [Iterator: por cada empresa]
    → [HTTP: Claude API — signal-scorer prompt]
    → [JSON Parse: extraer score + justificación]
    → [Supabase: PATCH company con score + justification]
    → [Filter: score >= 7]
      → [Supabase: buscar/crear contacto]
      → [HTTP: Claude API — outreach-writer prompt]
      → [Supabase: INSERT en outreach (status=draft)]
  → [Slack notification: "X empresas scored, Y high-value"]
```

### Módulo Claude (Signal Scorer)
- System prompt: contenido de `/prompts/signal-scorer.md`
- User message: JSON con datos de la empresa + signals encontrados
- Output esperado: `{ "score": 8, "justification": "...", "signals_found": [...] }`

### Módulo Claude (Outreach Writer)
- System prompt: contenido de `/prompts/outreach-writer.md`
- User message: empresa + contacto + signals relevantes
- Output esperado: `{ "subject": "...", "body": "..." }`

---

## Escenario 3: CRM Push (Monday.com)

**Trigger**: Webhook o schedule cada hora
**Input**: Empresas con score >= 7 y outreach status = 'draft'

```
[Supabase: GET companies JOIN outreach WHERE score >= 7]
  → [Iterator]
    → [Monday.com: Create Item en board "LatAm Leads"]
      - Columnas: Empresa, País, Sector, Score, Contacto, Email, Outreach Draft
    → [Supabase: PATCH outreach SET status='sent' (o 'queued')]
  → [Slack: "X leads pushed to Monday"]
```

### Monday.com Setup
- Crear board "LatAm Leads" con columnas:
  - Empresa (text)
  - País (dropdown: BR, MX, CO, AR, CL, PE)
  - Sector (text)
  - Score (number)
  - Contacto (text)
  - Email (email)
  - LinkedIn (link)
  - Outreach (long text)
  - Status (status: New, Contacted, Replied, Won)

### Conexión Monday
- API Key: generar en monday.com/apps
- GraphQL endpoint: `https://api.monday.com/v2`
- Board ID: obtener del URL del board

---

## Variables de Entorno requeridas

```
MAKE_WEBHOOK_INGEST=     # URL del webhook del escenario 1
MAKE_WEBHOOK_ENRICH=     # URL del webhook del escenario 2
MAKE_WEBHOOK_CRM_PUSH=   # URL del webhook del escenario 3
```

## Testing

1. **Escenario 1**: enviar curl al webhook con 1 registro de prueba → verificar que aparece en Supabase
2. **Escenario 2**: insertar empresa sin score → esperar trigger → verificar score asignado
3. **Escenario 3**: marcar empresa con score 8 → verificar item en Monday
