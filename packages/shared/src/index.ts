export type Country = 'BR' | 'MX' | 'CO' | 'AR' | 'CL' | 'PE';

export type SourceType = 'registry' | 'job_board' | 'press' | 'funding' | 'social' | 'manual';

export type SignalType = 'hiring' | 'funding' | 'press' | 'product_launch' | 'expansion' | 'award' | 'partnership';

export type OutreachChannel = 'email' | 'linkedin' | 'whatsapp';
export type OutreachStatus = 'draft' | 'sent' | 'replied' | 'bounced';

export type EmployeeRange = '1-10' | '11-50' | '51-200' | '201-500' | '500+';

export interface Company {
  id: string;
  source_id: string | null;
  external_id: string | null;
  name: string;
  normalized_name: string | null;
  country: Country;
  city: string | null;
  sector: string | null;
  subsector: string | null;
  employee_count: number | null;
  employee_range: EmployeeRange | null;
  founded_year: number | null;
  website: string | null;
  linkedin_url: string | null;
  description: string | null;
  revenue_usd: number | null;
  last_funding_usd: number | null;
  last_funding_date: string | null;
  funding_stage: string | null;
  signal_score: number | null;
  signal_justification: string | null;
  meta: Record<string, unknown>;
  raw_html: string | null;
  apollo_match: boolean;
  created_at: string;
  updated_at: string;
}

export interface Contact {
  id: string;
  company_id: string;
  full_name: string;
  title: string | null;
  email: string | null;
  phone: string | null;
  linkedin_url: string | null;
  source: string | null;
  meta: Record<string, unknown>;
  created_at: string;
}

export interface Signal {
  id: string;
  company_id: string;
  signal_type: SignalType;
  title: string;
  description: string | null;
  source_url: string | null;
  signal_date: string | null;
  relevance_score: number | null;
  meta: Record<string, unknown>;
  created_at: string;
}

export interface Outreach {
  id: string;
  contact_id: string;
  company_id: string;
  channel: OutreachChannel;
  subject: string | null;
  body: string;
  status: OutreachStatus;
  sent_at: string | null;
  meta: Record<string, unknown>;
  created_at: string;
}

export interface NormalizerInput {
  source: string;
  country: Country;
  raw_records: Array<{
    external_id: string;
    name: string;
    raw_html: string;
    source_url: string;
  }>;
}

export interface SignalScorerOutput {
  score: number;
  justification: string;
  breakdown: Record<string, number>;
  signals_found: Array<{
    type: SignalType;
    detail: string;
    date: string;
  }>;
  recommended_approach: string;
  approach_reason: string;
}

export interface OutreachOutput {
  subject: string;
  body: string;
  language: 'es' | 'pt-BR';
  word_count: number;
  hook_signal: string;
}
