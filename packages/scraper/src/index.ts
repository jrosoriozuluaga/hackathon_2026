import type { Country, NormalizerInput } from '@lli/shared';

const COUNTRY = (process.env.TARGET_COUNTRY ?? 'BR') as Country;

console.log(`[scraper] Starting scrape for country: ${COUNTRY}`);
console.log('[scraper] TODO: implement country-specific scraper after H1 discovery gate');
console.log('[scraper] See /docs/discovery-sheet.md for registry URLs');
