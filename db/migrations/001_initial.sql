-- LatAm Lead Intelligence — Initial Schema
-- Country-agnostic: specific fields go in meta JSONB columns

-- Extensions
create extension if not exists "uuid-ossp";
create extension if not exists "pg_trgm";

-- ============================================================
-- SOURCES: where data came from (registry, job board, press)
-- ============================================================
create table sources (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  country char(2) not null,               -- ISO 3166-1 alpha-2
  source_type text not null check (source_type in ('registry', 'job_board', 'press', 'funding', 'social', 'manual')),
  base_url text,
  scrape_config jsonb default '{}',       -- selectors, pagination, rate limits
  last_scraped_at timestamptz,
  created_at timestamptz default now()
);

create index idx_sources_country on sources(country);

-- ============================================================
-- COMPANIES: core entity
-- ============================================================
create table companies (
  id uuid primary key default uuid_generate_v4(),
  source_id uuid references sources(id),
  external_id text,                       -- tax ID / registration number from source
  name text not null,
  normalized_name text,                   -- lowercase, no accents, for dedup
  country char(2) not null,
  city text,
  sector text,
  subsector text,
  employee_count int,
  employee_range text,                    -- '1-10', '11-50', '51-200', '201-500', '500+'
  founded_year int,
  website text,
  linkedin_url text,
  description text,
  revenue_usd numeric,
  last_funding_usd numeric,
  last_funding_date date,
  funding_stage text,                     -- pre-seed, seed, series-a, etc.
  signal_score smallint check (signal_score between 1 and 10),
  signal_justification text,
  meta jsonb default '{}',               -- country-specific fields
  raw_html text,                         -- original scraped content
  apollo_match boolean default false,     -- whether Apollo has this company
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index idx_companies_country on companies(country);
create index idx_companies_sector on companies(sector);
create index idx_companies_signal on companies(signal_score desc);
create index idx_companies_normalized on companies using gin(normalized_name gin_trgm_ops);
create unique index idx_companies_dedup on companies(country, external_id) where external_id is not null;

-- ============================================================
-- CONTACTS: people at companies
-- ============================================================
create table contacts (
  id uuid primary key default uuid_generate_v4(),
  company_id uuid references companies(id) on delete cascade,
  full_name text not null,
  title text,
  email text,
  phone text,
  linkedin_url text,
  source text,                            -- where we found this contact
  meta jsonb default '{}',
  created_at timestamptz default now()
);

create index idx_contacts_company on contacts(company_id);

-- ============================================================
-- SIGNALS: hiring, funding, press mentions, etc.
-- ============================================================
create table signals (
  id uuid primary key default uuid_generate_v4(),
  company_id uuid references companies(id) on delete cascade,
  signal_type text not null check (signal_type in ('hiring', 'funding', 'press', 'product_launch', 'expansion', 'award', 'partnership')),
  title text not null,
  description text,
  source_url text,
  signal_date date,
  relevance_score smallint check (relevance_score between 1 and 10),
  meta jsonb default '{}',
  created_at timestamptz default now()
);

create index idx_signals_company on signals(company_id);
create index idx_signals_type on signals(signal_type);
create index idx_signals_date on signals(signal_date desc);

-- ============================================================
-- OUTREACH: generated messages and their status
-- ============================================================
create table outreach (
  id uuid primary key default uuid_generate_v4(),
  contact_id uuid references contacts(id) on delete cascade,
  company_id uuid references companies(id) on delete cascade,
  channel text not null check (channel in ('email', 'linkedin', 'whatsapp')),
  subject text,
  body text not null,
  status text default 'draft' check (status in ('draft', 'sent', 'replied', 'bounced')),
  sent_at timestamptz,
  meta jsonb default '{}',
  created_at timestamptz default now()
);

create index idx_outreach_company on outreach(company_id);
create index idx_outreach_status on outreach(status);

-- ============================================================
-- RLS (basic — tighten per-team later)
-- ============================================================
alter table companies enable row level security;
alter table contacts enable row level security;
alter table signals enable row level security;
alter table outreach enable row level security;

create policy "Allow all for authenticated" on companies for all using (auth.role() = 'authenticated');
create policy "Allow all for authenticated" on contacts for all using (auth.role() = 'authenticated');
create policy "Allow all for authenticated" on signals for all using (auth.role() = 'authenticated');
create policy "Allow all for authenticated" on outreach for all using (auth.role() = 'authenticated');

-- ============================================================
-- Updated-at trigger
-- ============================================================
create or replace function update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger trg_companies_updated
  before update on companies
  for each row execute function update_updated_at();
