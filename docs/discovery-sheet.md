# Discovery Sprint Protocol (H0–H1)

## Objetivo
Evaluar 6 países LatAm en 60 min para elegir el de mayor oportunidad. Cada persona investiga 2 países en paralelo. Al final de H1 se lockea país + vertical.

---

## Asignaciones

| Persona | País 1 | País 2 | Foco |
|---|---|---|---|
| **Tech Lead** | Brasil (BR) | México (MX) | Registros públicos, APIs de datos |
| **Marketer** | Colombia (CO) | Argentina (AR) | Registros, cámaras de comercio |
| **Designer** | Chile (CL) | Perú (PE) | Registros tributarios |
| **Comercial** | _Todos_ | _Todos_ | Apollo baseline — mismas 5 queries en 6 países |
| **Influencer** | _Todos_ | _Todos_ | Job boards + medios/prensa LatAm |

---

## URLs de registros públicos por país

### Brasil (BR)
- **Receita Federal / CNPJ**: https://servicos.receita.fazenda.gov.br/servicos/cnpjreva/cnpjreva_solicitacao.asp
- **API pública CNPJ**: https://brasilapi.com.br/docs#tag/CNPJ
- **Junta Comercial (REDESIM)**: https://www.gov.br/empresas-e-negocios/pt-br/redesim
- **Job boards**: Gupy (gupy.io), Catho, InfoJobs BR
- **Press/Funding**: Brazil Journal, Startups.com.br, LAVCA

### México (MX)
- **SAT / RFC**: https://www.sat.gob.mx/aplicacion/operacion/31274/consulta-tu-informacion-fiscal
- **IMSS (empleados)**: https://serviciosdigitales.imss.gob.mx/portal-ciudadano-web-externo/home
- **SIEM (registro empresarial)**: https://siem.gob.mx/consulta
- **Job boards**: OCC Mundial, Computrabajo MX, LinkedIn MX
- **Press/Funding**: Contxto, El Economista, TechCrunch LatAm

### Colombia (CO)
- **RUES**: https://www.rues.org.co/
- **Cámara de Comercio Bogotá**: https://linea.ccb.org.co/certificadoselectronicosR/
- **Confecámaras**: https://confecamaras.org.co/
- **Job boards**: elempleo.com, Computrabajo CO, Get on Board
- **Press/Funding**: Bloomberg Línea, La República

### Argentina (AR)
- **AFIP / CUIT**: https://seti.afip.gob.ar/padron-puc-constancia-internet/ConsultaConstanciaAction.do
- **IGJ**: https://www.argentina.gob.ar/justicia/igj
- **Registro de Sociedades**: vía IGJ
- **Job boards**: Bumeran, Computrabajo AR, Get on Board
- **Press/Funding**: iProUP, Infobae economía

### Chile (CL)
- **SII / RUT**: https://zeus.sii.cl/cvc_cgi/stc/getstc
- **Registro de Comercio**: https://www.conservador.cl/
- **StartupChile data**: https://startupchile.org/
- **Job boards**: Trabajando.com, Get on Board, Computrabajo CL
- **Press/Funding**: Fintual blog, DF.cl, LAVCA

### Perú (PE)
- **SUNAT / RUC**: https://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/FrameCriterioBusquedaWeb.jsp
- **SUNARP**: https://www.sunarp.gob.pe/
- **Produce (MYPE)**: https://www.gob.pe/produce
- **Job boards**: Computrabajo PE, Bumeran PE, Indeed PE
- **Press/Funding**: Gestión, El Comercio, Semana Económica

---

## Queries para Apollo (Comercial)

Correr estas 5 queries en cada país y registrar resultados:

1. `fintech AND [país] AND founded:2020-2025` — count + freshness
2. `healthtech AND [país] AND employees:10-200` — count + data quality
3. `SaaS AND [país] AND funding:seed+` — count + funding data
4. `e-commerce AND [país] AND city:[capital]` — count + contact emails
5. `logistics AND [país] AND hiring:true` — count + signals

**Registrar por query**: total resultados, % con email, % con funding data, fecha del dato más reciente.

---

## Job boards y medios (Influencer)

| Fuente | Tipo | Cobertura | URL |
|---|---|---|---|
| Get on Board | Job board | CL, CO, MX, PE, AR | getonbrd.com |
| Bumeran | Job board | AR, PE, VE | bumeran.com |
| Computrabajo | Job board | Todos LatAm | computrabajo.com |
| Bloomberg Línea | Press | Todos LatAm | bloomberglinea.com |
| Contxto | Startups | Todos LatAm | contxto.com |
| LAVCA | Funding | Todos LatAm | lavca.org |
| Brazil Journal | Press | BR | braziljournal.com |
| Startups.com.br | Press | BR | startups.com.br |

---

## Matriz de evaluación (score /15)

| Criterio | 0 | 1 | 2 | 3 |
|---|---|---|---|---|
| **Acceso al registro** | Bloqueado / captcha fuerte | Scrape difícil (JS render) | Scrape OK (HTML estático) | API pública documentada |
| **Riqueza de data** | Solo nombre | + sector | + empleados / revenue | + financials / funding |
| **Job board signal** | Inexistente | 1 fuente pobre | 2 fuentes con data | 3+ fuentes rica |
| **Press/funding signal** | Nada | RSS pobre | 2-3 fuentes | Rico + reciente (< 30 días) |
| **Gap vs Apollo** | Apollo cubre bien | Cobertura media | Cobertura mala | Terrible — ganamos acá |

---

## Score Sheet

Copiar esta tabla y llenar durante la investigación:

| País | Acceso registro | Riqueza data | Job board | Press/funding | Gap Apollo | **TOTAL /15** |
|---|---|---|---|---|---|---|
| Brasil (BR) | /3 | /3 | /3 | /3 | /3 | **/15** |
| México (MX) | /3 | /3 | /3 | /3 | /3 | **/15** |
| Colombia (CO) | /3 | /3 | /3 | /3 | /3 | **/15** |
| Argentina (AR) | /3 | /3 | /3 | /3 | /3 | **/15** |
| Chile (CL) | /3 | /3 | /3 | /3 | /3 | **/15** |
| Perú (PE) | /3 | /3 | /3 | /3 | /3 | **/15** |

---

## Evidencia requerida por país

Cada hallazgo se commitea como GitHub issue con label `discovery`. Incluir:

1. **Screenshot** del registro/portal mostrando los datos disponibles
2. **curl response** (si hay API) mostrando estructura del JSON
3. **Conteo** de registros accesibles (estimado)
4. **Ejemplo** de un registro completo (1 empresa)
5. **Score** con justificación de 1 línea por criterio

---

## Decision Meeting (últimos 15 min de H1)

1. Cada persona presenta sus 2 países — **2 min máx por país**
2. Comercial presenta baseline Apollo — **3 min**
3. Influencer presenta mapa de señales — **2 min**
4. Se suma la matriz → **gana el score más alto**
5. Vertical = sector con más rondas LatAm en últimos 12 meses (LAVCA data)
6. Se crea issue `DECISION: [país] + [vertical]` y se cierra milestone `H1-discovery-gate`

### Tiebreakers
1. Volumen de demo (¿cuántos leads podemos mostrar en 2 min?)
2. Familiaridad del equipo con el sector
3. Si alguien habla portugués nativo, Brasil sube +1
