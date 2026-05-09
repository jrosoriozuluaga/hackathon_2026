# Demo Script — 2 Minutos

> Presenter: **Comercial**
> Soporte técnico: **Tech Lead** (backup si algo falla)
> Timer: **Marketing** (señal a 1:30 para wrap up)

---

## Pre-demo checklist
- [ ] Dashboard abierto en browser, pestaña única
- [ ] Supabase con datos frescos cargados
- [ ] Terminal cerrada (no mostrar al público)
- [ ] Screencast grabado como backup (OBS/QuickTime)
- [ ] Agua en la mesa

---

## Script segundo por segundo

### 0:00–0:10 — HOOK (10 seg)
> "Si buscan empresas en [país] en Apollo hoy, encuentran [X] resultados. Nosotros encontramos [Y] — con datos que Apollo no tiene. Les muestro."

**Acción**: Pantalla ya mostrando el dashboard con la lista de empresas.

### 0:10–0:30 — EL PROBLEMA (20 seg)
> "Los equipos de ventas B2B en LatAm pierden horas buscando leads manualmente. Apollo tiene buena data de US y Europa, pero en [país] su cobertura es del [Z]%. Las empresas que más crecen en la región simplemente no están ahí."

**Acción**: Mostrar brevemente una búsqueda en Apollo (screenshot) con pocos resultados.

### 0:30–0:50 — LA SOLUCIÓN (20 seg)
> "Nosotros conectamos directamente con registros públicos de [país] — [nombre del registro] — y con señales de hiring, funding y prensa local. Todo procesado con Claude para normalizar datos sucios y scorear leads automáticamente."

**Acción**: Mostrar el flow visual (diagrama simple): Registro → Scraper → Claude → DB → Dashboard.

### 0:50–1:15 — DEMO EN VIVO (25 seg)
> "Veamos un ejemplo real."

**Acción paso a paso**:
1. Click en una empresa de la lista (score alto, 8+)
2. Mostrar datos: nombre, sector, empleados, funding
3. Mostrar signals: "Levantó Serie A hace 2 meses, está contratando 5 devs"
4. Mostrar score: "Score 8/10 — y miren por qué" (breakdown visible)
5. Mostrar outreach generado: "Y el mensaje de primer contacto ya está listo"

> "Este mensaje se genera automáticamente basado en las señales detectadas. No es un template genérico — menciona su funding reciente."

### 1:15–1:35 — MÉTRICAS (20 seg)
> "En [X] horas de hackathon:
> - [N] empresas de [país] ingestadas y normalizadas
> - [M] con signal score y outreach listo
> - [Z]% de estas empresas NO ESTÁN en Apollo
> - Pipeline completo: scraping → normalización → scoring → outreach, todo automatizado"

**Acción**: Mostrar pantalla de métricas/stats del dashboard.

### 1:35–1:55 — VISIÓN + CIERRE (20 seg)
> "Hoy es [país]. Mañana son 6 países de LatAm. Cada registro público es una fuente de leads que nadie más está usando. Mientras Apollo mira para otro lado, nosotros estamos construyendo la base de datos B2B más completa de Latinoamérica."

### 1:55–2:00 — CALL TO ACTION (5 seg)
> "Se llama [nombre del producto]. Y ya funciona."

**Silencio. Sonrisa. Esperar aplausos.**

---

## Si algo falla durante el demo

| Falla | Recovery |
|---|---|
| Dashboard no carga | "Mientras carga, les cuento..." → hablar sobre métricas, dar tiempo |
| Click en empresa no responde | Usar la segunda empresa de la lista (tener 3 preparadas) |
| Score no aparece | "El scoring corre async, pero aquí tienen un ejemplo..." → screenshot |
| Todo explota | Cambiar a screencast grabado. "Les muestro la grabación de hace 30 min" |

## Reglas del presenter

1. NO leer el script. Saber los beats, improvisar las palabras.
2. NO decir "como pueden ver" ni "básicamente".
3. NO explicar la tech stack. A nadie le importa que usamos Playwright.
4. SÍ decir números concretos. "[N] empresas" suena mejor que "muchas empresas".
5. SÍ hacer pausa después del hook. Dejar que el número haga efecto.
6. Velocidad: hablar como si estuvieras explicando algo cool a un amigo. No como pitch de MBA.
