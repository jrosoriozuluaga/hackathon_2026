import { Hono } from 'hono';
import { serve } from '@hono/node-server';
import type { Company, Signal } from '@lli/shared';

const app = new Hono();

app.get('/', (c) => c.json({ status: 'ok', service: 'latam-lead-intelligence' }));

app.get('/api/companies', async (c) => {
  // TODO: connect to Supabase and query companies
  return c.json({ data: [], message: 'Connect Supabase after H0 setup' });
});

app.get('/api/companies/:id', async (c) => {
  const id = c.req.param('id');
  return c.json({ data: null, message: `Company ${id} — connect Supabase` });
});

app.get('/api/companies/:id/signals', async (c) => {
  const id = c.req.param('id');
  return c.json({ data: [], message: `Signals for ${id} — connect Supabase` });
});

app.post('/api/webhook/ingest', async (c) => {
  // Webhook for Make.com ingest scenario
  const body = await c.req.json();
  console.log('[ingest] Received:', JSON.stringify(body).slice(0, 200));
  return c.json({ received: true });
});

const port = Number(process.env.PORT ?? 3000);
console.log(`[api] Starting on port ${port}`);
serve({ fetch: app.fetch, port });
