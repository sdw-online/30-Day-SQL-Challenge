#!/usr/bin/env node

/**
 * Generates day concept card SVGs and "Where To Next?" navigation tree SVGs
 * for all 30 days of the SQL challenge.
 */

const fs = require('fs');
const path = require('path');

const OUT = path.resolve(__dirname, '..', 'assets', 'banners');

const days = [
  { day: 1, slug: 'intro-to-sql', title: 'Introduction to SQL & Databases', diff: 'Beginner', learn: ['What SQL is', 'Tables, rows, columns', 'Data types', 'Primary keys'] },
  { day: 2, slug: 'select-where', title: 'SELECT & WHERE', diff: 'Beginner', learn: ['SELECT columns', 'WHERE filters', 'Comparison operators', 'Text matching'] },
  { day: 3, slug: 'order-by-limit', title: 'ORDER BY & LIMIT', diff: 'Beginner', learn: ['ASC/DESC sorting', 'LIMIT rows', 'OFFSET', 'Multi-column sort'] },
  { day: 4, slug: 'group-by', title: 'Aggregate Functions & GROUP BY', diff: 'Beginner', learn: ['GROUP BY', 'COUNT/SUM/AVG', 'HAVING filter', 'Aggregate logic'] },
  { day: 5, slug: 'insert-update-delete', title: 'INSERT, UPDATE & DELETE', diff: 'Beginner', learn: ['INSERT rows', 'UPDATE values', 'DELETE rows', 'WHERE safety'] },
  { day: 6, slug: 'keys-constraints', title: 'Primary & Foreign Keys', diff: 'Beginner', learn: ['Primary keys', 'Foreign keys', 'UNIQUE/NOT NULL', 'Table relationships'] },
  { day: 7, slug: 'project-freight', title: 'Project: Freight & Logistics Report', diff: 'Beginner', learn: ['Combine Week 1', 'Real logistics data', 'Build a report', 'Present findings'] },
  { day: 8, slug: 'null-handling', title: 'NULL Handling', diff: 'Intermediate', learn: ['IS NULL/IS NOT NULL', 'COALESCE', 'NULLIF', 'NULL in aggregates'] },
  { day: 9, slug: 'string-numeric', title: 'String & Numeric Functions', diff: 'Intermediate', learn: ['UPPER/LOWER/TRIM', 'SUBSTRING/CONCAT', 'ROUND/CEIL/FLOOR', 'Type casting'] },
  { day: 10, slug: 'date-functions', title: 'Date Functions & CAST', diff: 'Intermediate', learn: ['DATE_PART/EXTRACT', 'AGE/intervals', 'DATE_TRUNC', 'CAST to date'] },
  { day: 11, slug: 'case-when', title: 'CASE WHEN', diff: 'Intermediate', learn: ['CASE WHEN syntax', 'Multiple conditions', 'Nested CASE', 'Categorisation'] },
  // Day 12 exists
  { day: 13, slug: 'ctes', title: 'CTEs (Part 1)', diff: 'Intermediate', learn: ['WITH clause', 'Named subqueries', 'Multi-step CTEs', 'Readability'] },
  { day: 14, slug: 'project-fleet', title: 'Project: Fleet Intelligence Pipeline', diff: 'Intermediate', learn: ['Multi-step pipeline', 'CTEs + subqueries', 'Real fleet data', 'Week 2 synthesis'] },
  // Day 15 exists
  { day: 16, slug: 'cross-self-join', title: 'CROSS JOIN & Self Joins', diff: 'Intermediate', learn: ['CROSS JOIN', 'Self joins', 'Row combinations', 'Comparing within table'] },
  { day: 17, slug: 'union', title: 'UNION & UNION ALL', diff: 'Intermediate', learn: ['UNION', 'UNION ALL', 'Deduplication', 'Column matching'] },
  { day: 18, slug: 'normalisation', title: 'Normalisation & Denormalisation', diff: 'Intermediate', learn: ['1NF/2NF/3NF', 'Redundancy removal', 'When to denormalise', 'Trade-offs'] },
  { day: 19, slug: 'recursive-ctes', title: 'Recursive CTEs', diff: 'Advanced', learn: ['Recursive WITH', 'Base + recursive case', 'Hierarchies', 'Org charts'] },
  { day: 20, slug: 'star-schema', title: 'Data Modelling (Star Schema)', diff: 'Advanced', learn: ['Fact tables', 'Dimension tables', 'Star design', 'Analytics queries'] },
  { day: 21, slug: 'project-saas', title: 'Project: SaaS Trial-to-Paid Conversion', diff: 'Advanced', learn: ['SaaS metrics', 'Trial-to-paid funnel', 'Conversion analysis', 'Week 3 synthesis'] },
  { day: 22, slug: 'window-functions-1', title: 'Window Functions Part 1', diff: 'Advanced', learn: ['ROW_NUMBER', 'RANK/DENSE_RANK', 'PARTITION BY', 'Window frames'] },
  { day: 23, slug: 'window-functions-2', title: 'Window Functions Part 2', diff: 'Advanced', learn: ['LAG/LEAD', 'Running totals', 'QUALIFY', 'Row comparison'] },
  { day: 24, slug: 'scd-merge', title: 'SCD Types & MERGE', diff: 'Advanced', learn: ['SCD Type 1/2', 'MERGE statement', 'Upsert logic', 'History tracking'] },
  { day: 25, slug: 'views', title: 'Views & Materialised Views', diff: 'Advanced', learn: ['CREATE VIEW', 'Materialised views', 'REFRESH', 'Performance'] },
  { day: 26, slug: 'information-schema', title: 'Information Schema & Metadata', diff: 'Advanced', learn: ['information_schema', 'Table metadata', 'Column types', 'Self-querying'] },
  { day: 27, slug: 'udfs', title: 'CREATE FUNCTION (UDFs)', diff: 'Advanced', learn: ['CREATE FUNCTION', 'Parameters', 'Return types', 'Reusable logic'] },
  { day: 28, slug: 'explain-indexing', title: 'EXPLAIN & Indexing', diff: 'Advanced', learn: ['EXPLAIN ANALYSE', 'Seq vs Index scan', 'CREATE INDEX', 'Cost reduction'] },
  { day: 29, slug: 'pro-tips', title: 'PostgreSQL Pro Tips', diff: 'Advanced', learn: ['Shortcuts', 'psql tricks', 'Settings', 'Daily efficiency'] },
  { day: 30, slug: 'capstone', title: 'Capstone: FinTech Lending Analytics', diff: 'Advanced', learn: ['Full platform', 'Schema design', 'Pipelines', 'Performance tuning'] },
];

function escXml(s) { return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }

function conceptCard({ day, title, diff, learn }) {
  const dd = String(day).padStart(2, '0');
  const diffColor = diff === 'Beginner' ? '#22c55e' : diff === 'Intermediate' ? '#f59e0b' : '#ef4444';
  const bullets = learn.map((item, i) => {
    const y = 100 + i * 24;
    return `  <circle cx="48" cy="${y}" r="3" fill="#ef4444"/>
  <text x="60" y="${y + 4}" font-family="Segoe UI, system-ui, sans-serif" font-size="12" fill="#fce4ec">${escXml(item)}</text>`;
  }).join('\n');

  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 200" fill="none">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="800" y2="200" gradientUnits="userSpaceOnUse">
      <stop offset="0%" stop-color="#1a0a0e"/>
      <stop offset="100%" stop-color="#2a1015"/>
    </linearGradient>
    <filter id="glow"><feGaussianBlur stdDeviation="2" result="blur"/><feMerge><feMergeNode in="blur"/><feMergeNode in="SourceGraphic"/></feMerge></filter>
  </defs>
  <rect width="800" height="200" rx="12" fill="url(#bg)"/>
  <rect x="1" y="1" width="798" height="198" rx="12" fill="none" stroke="#dc2626" stroke-width="1.5" opacity="0.35" filter="url(#glow)"/>
  <circle cx="720" cy="16" r="2" fill="#dc2626" opacity="0.2"/><circle cx="740" cy="16" r="2" fill="#dc2626" opacity="0.25"/><circle cx="760" cy="16" r="2" fill="#dc2626" opacity="0.3"/><circle cx="780" cy="16" r="2" fill="#dc2626" opacity="0.35"/>
  <circle cx="740" cy="36" r="2" fill="#dc2626" opacity="0.15"/><circle cx="760" cy="36" r="2" fill="#dc2626" opacity="0.2"/><circle cx="780" cy="36" r="2" fill="#dc2626" opacity="0.25"/>
  <!-- Day badge -->
  <rect x="24" y="20" width="56" height="28" rx="6" fill="#dc2626"/>
  <text x="52" y="39" font-family="Segoe UI, system-ui, sans-serif" font-size="13" font-weight="700" fill="#ffffff" text-anchor="middle">DAY ${dd}</text>
  <!-- Title -->
  <text x="92" y="40" font-family="Segoe UI, system-ui, sans-serif" font-size="18" font-weight="700" fill="#ffffff">${escXml(title)}</text>
  <!-- Difficulty pill - away from corner dots -->
  <rect x="620" y="20" width="90" height="24" rx="12" fill="${diffColor}" opacity="0.2"/>
  <text x="665" y="37" font-family="Segoe UI, system-ui, sans-serif" font-size="11" font-weight="600" fill="${diffColor}" text-anchor="middle">${diff}</text>
  <!-- Bullet list - left aligned under title -->
  <text x="40" y="76" font-family="Segoe UI, system-ui, sans-serif" font-size="12" fill="#c4a0a6">What you'll learn:</text>
${bullets}
</svg>`;
}

// Navigation trees
const navData = [
  { day: 1, topic: 'Introduction to SQL', cont: ['Day 2', 'SELECT & WHERE'], apply: ['Review Day 1 exercises', ''], brush: ['Rewatch the setup guide', ''], skip: ['Day 8', 'Jump to Week 2'] },
  { day: 2, topic: 'SELECT & WHERE', cont: ['Day 3', 'ORDER BY & LIMIT'], apply: ['Day 2 exercises', ''], brush: ['Day 1 (setup basics)', ''], skip: ['Day 8', 'Jump to Week 2'] },
  { day: 3, topic: 'ORDER BY & LIMIT', cont: ['Day 4', 'GROUP BY'], apply: ['Day 3 exercises', ''], brush: ['Day 2 (SELECT/WHERE)', ''], skip: ['Day 8', 'Jump to Week 2'] },
  { day: 4, topic: 'GROUP BY', cont: ['Day 5', 'INSERT/UPDATE/DELETE'], apply: ['Day 4 exercises', ''], brush: ['Day 2 or Day 3', ''], skip: ['Day 8', 'Jump to Week 2'] },
  { day: 5, topic: 'INSERT, UPDATE & DELETE', cont: ['Day 6', 'Keys & Constraints'], apply: ['Day 5 exercises', ''], brush: ['Day 4 (GROUP BY)', ''], skip: ['Day 8', 'Jump to Week 2'] },
  { day: 6, topic: 'Primary & Foreign Keys', cont: ['Day 7', 'Week 1 Project'], apply: ['Day 6 exercises', ''], brush: ['Day 5 (INSERT/UPDATE/DELETE)', ''], skip: ['Day 15', 'Jump to JOINs'] },
  { day: 7, topic: 'Project: Freight & Logistics', cont: ['Day 8', 'NULL Handling'], apply: ['Redo project your own way', ''], brush: ['Day 4 or Day 6', ''], skip: ['Day 15', 'Jump to JOINs'] },
  { day: 8, topic: 'NULL Handling', cont: ['Day 9', 'String & Numeric Functions'], apply: ['Day 8 exercises', ''], brush: ['Day 4 (GROUP BY)', ''], skip: ['Day 15', 'Jump to JOINs'] },
  { day: 9, topic: 'String & Numeric Functions', cont: ['Day 10', 'Date Functions'], apply: ['Day 9 exercises', ''], brush: ['Day 8 (NULL Handling)', ''], skip: ['Day 15', 'Jump to JOINs'] },
  { day: 10, topic: 'Date Functions & CAST', cont: ['Day 11', 'CASE WHEN'], apply: ['Day 10 exercises', ''], brush: ['Day 9 (String functions)', ''], skip: ['Day 15', 'Jump to JOINs'] },
  { day: 11, topic: 'CASE WHEN', cont: ['Day 12', 'Subqueries'], apply: ['Day 11 exercises', ''], brush: ['Day 4 or Day 8', ''], skip: ['Day 15', 'Jump to JOINs'] },
  // Day 12 exists
  { day: 13, topic: 'CTEs (Part 1)', cont: ['Day 14', 'Week 2 Project'], apply: ['Day 13 exercises', ''], brush: ['Day 12 (Subqueries)', ''], skip: ['Day 15', 'Jump to JOINs'] },
  { day: 14, topic: 'Project: Fleet Intelligence', cont: ['Day 15', 'JOINs Part 1'], apply: ['Redo project your own way', ''], brush: ['Day 12 or Day 13', ''], skip: ['Day 22', 'Jump to Week 4'] },
  { day: 15, topic: 'JOINs Part 1', cont: ['Day 16', 'CROSS & Self Joins'], apply: ['Day 15 exercises', ''], brush: ['Day 6 (Keys)', ''], skip: ['Day 22', 'Jump to Week 4'] },
  { day: 16, topic: 'CROSS & Self Joins', cont: ['Day 17', 'UNION'], apply: ['Day 16 exercises', ''], brush: ['Day 15 (JOIN basics)', ''], skip: ['Day 22', 'Jump to Week 4'] },
  { day: 17, topic: 'UNION & UNION ALL', cont: ['Day 18', 'Normalisation'], apply: ['Day 17 exercises', ''], brush: ['Day 15 (JOINs)', ''], skip: ['Day 22', 'Jump to Week 4'] },
  { day: 18, topic: 'Normalisation', cont: ['Day 19', 'Recursive CTEs'], apply: ['Day 18 exercises', ''], brush: ['Day 6 or Day 15', ''], skip: ['Day 22', 'Jump to Week 4'] },
  { day: 19, topic: 'Recursive CTEs', cont: ['Day 20', 'Star Schema'], apply: ['Day 19 exercises', ''], brush: ['Day 13 (CTEs Part 1)', ''], skip: ['Day 22', 'Jump to Week 4'] },
  { day: 20, topic: 'Star Schema', cont: ['Day 21', 'Week 3 Project'], apply: ['Day 20 exercises', ''], brush: ['Day 18 (Normalisation)', ''], skip: ['Day 22', 'Jump to Week 4'] },
  { day: 21, topic: 'Project: SaaS Conversion', cont: ['Day 22', 'Window Functions'], apply: ['Redo project your own way', ''], brush: ['Day 15 or Day 20', ''], skip: ['Day 30', 'Jump to Capstone'] },
  { day: 22, topic: 'Window Functions Part 1', cont: ['Day 23', 'LAG, LEAD, QUALIFY'], apply: ['Day 22 exercises', ''], brush: ['Day 4 or Day 12', ''], skip: ['Day 30', 'Jump to Capstone'] },
  { day: 23, topic: 'Window Functions Part 2', cont: ['Day 24', 'SCD & MERGE'], apply: ['Day 23 exercises', ''], brush: ['Day 22 (Window Part 1)', ''], skip: ['Day 30', 'Jump to Capstone'] },
  { day: 24, topic: 'SCD Types & MERGE', cont: ['Day 25', 'Views'], apply: ['Day 24 exercises', ''], brush: ['Day 5 (INSERT/UPDATE/DELETE)', ''], skip: ['Day 30', 'Jump to Capstone'] },
  { day: 25, topic: 'Views & Materialised Views', cont: ['Day 26', 'Information Schema'], apply: ['Day 25 exercises', ''], brush: ['Day 13 (CTEs)', ''], skip: ['Day 30', 'Jump to Capstone'] },
  { day: 26, topic: 'Information Schema', cont: ['Day 27', 'UDFs'], apply: ['Day 26 exercises', ''], brush: ['Day 6 (Keys/Constraints)', ''], skip: ['Day 30', 'Jump to Capstone'] },
  { day: 27, topic: 'CREATE FUNCTION (UDFs)', cont: ['Day 28', 'EXPLAIN & Indexing'], apply: ['Day 27 exercises', ''], brush: ['Day 11 (CASE WHEN)', ''], skip: ['Day 30', 'Jump to Capstone'] },
  { day: 28, topic: 'EXPLAIN & Indexing', cont: ['Day 29', 'Pro Tips'], apply: ['Day 28 exercises', ''], brush: ['Day 12 (Subqueries)', ''], skip: ['Day 30', 'Jump to Capstone'] },
  { day: 29, topic: 'PostgreSQL Pro Tips', cont: ['Day 30', 'Capstone Project'], apply: ['Day 29 exercises', ''], brush: ['Review any weak areas', ''], skip: ['Day 30', 'Start the Capstone'] },
  { day: 30, topic: 'Capstone: FinTech Lending', cont: ['Review weak areas', ''], apply: ['Redo projects (Day 7/14/21)', ''], brush: ['Star this repo', ''], skip: ['Next course coming soon', ''] },
];

function navTree({ day, topic, cont, apply, brush, skip }) {
  const dd = String(day).padStart(2, '0');
  const titleText = day === 30 ? "What's Next?" : 'Where To Next?';
  const subtitleText = day === 30
    ? 'You completed the 30 Day SQL Challenge!'
    : `You just finished Day ${dd}: ${escXml(topic)}`;

  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 900 320" fill="none">
  <defs>
    <linearGradient id="wnbg" x1="450" y1="0" x2="900" y2="320" gradientUnits="userSpaceOnUse">
      <stop offset="0%" stop-color="#1a0a0e"/>
      <stop offset="100%" stop-color="#4c0519"/>
    </linearGradient>
    <filter id="glow2"><feGaussianBlur stdDeviation="2" result="blur"/><feMerge><feMergeNode in="blur"/><feMergeNode in="SourceGraphic"/></feMerge></filter>
  </defs>
  <rect width="900" height="320" rx="12" fill="url(#wnbg)"/>
  <rect x="1" y="1" width="898" height="318" rx="12" fill="none" stroke="#dc2626" stroke-width="1.5" opacity="0.35" filter="url(#glow2)"/>
  <circle cx="820" cy="16" r="2" fill="#dc2626" opacity="0.2"/><circle cx="840" cy="16" r="2" fill="#dc2626" opacity="0.25"/><circle cx="860" cy="16" r="2" fill="#dc2626" opacity="0.3"/><circle cx="880" cy="16" r="2" fill="#dc2626" opacity="0.35"/>
  <circle cx="840" cy="36" r="2" fill="#dc2626" opacity="0.15"/><circle cx="860" cy="36" r="2" fill="#dc2626" opacity="0.2"/><circle cx="880" cy="36" r="2" fill="#dc2626" opacity="0.25"/>
  <text x="450" y="38" font-family="Segoe UI, system-ui, sans-serif" font-size="20" font-weight="700" fill="#ffffff" text-anchor="middle">${escXml(titleText)}</text>
  <text x="450" y="58" font-family="Segoe UI, system-ui, sans-serif" font-size="12" fill="#c4a0a6" text-anchor="middle">${subtitleText}</text>
  <rect x="320" y="76" width="260" height="40" rx="8" fill="#dc2626" opacity="0.15"/>
  <rect x="320" y="76" width="260" height="40" rx="8" fill="none" stroke="#dc2626" stroke-width="1.5"/>
  <text x="450" y="101" font-family="Segoe UI, system-ui, sans-serif" font-size="13" font-weight="600" fill="#ffffff" text-anchor="middle">What do you want to do?</text>
  <line x1="450" y1="116" x2="450" y2="138" stroke="#ef4444" stroke-width="1.5"/>
  <line x1="130" y1="138" x2="770" y2="138" stroke="#ef4444" stroke-width="1.5"/>
  <circle cx="450" cy="138" r="3" fill="#ef4444"/>
  <circle cx="310" cy="138" r="3" fill="#ef4444"/>
  <circle cx="590" cy="138" r="3" fill="#ef4444"/>
  <circle cx="130" cy="138" r="3" fill="#ef4444" opacity="0.6"/>
  <circle cx="770" cy="138" r="3" fill="#ef4444" opacity="0.6"/>
  <line x1="310" y1="138" x2="310" y2="160" stroke="#ef4444" stroke-width="1.5"/>
  <line x1="590" y1="138" x2="590" y2="160" stroke="#ef4444" stroke-width="1.5"/>
  <line x1="130" y1="138" x2="130" y2="240" stroke="#ef4444" stroke-width="1" opacity="0.6"/>
  <line x1="770" y1="138" x2="770" y2="240" stroke="#ef4444" stroke-width="1" opacity="0.6"/>
  <rect x="190" y="160" width="240" height="52" rx="8" fill="#dc2626"/>
  <text x="310" y="182" font-family="Segoe UI, system-ui, sans-serif" font-size="12" font-weight="700" fill="#ffffff" text-anchor="middle">${escXml(cont[0])}</text>
  <text x="310" y="202" font-family="Segoe UI, system-ui, sans-serif" font-size="11" fill="#fca5a5" text-anchor="middle">${escXml(cont[1])}</text>
  <rect x="470" y="160" width="240" height="52" rx="8" fill="#dc2626"/>
  <text x="590" y="182" font-family="Segoe UI, system-ui, sans-serif" font-size="12" font-weight="700" fill="#ffffff" text-anchor="middle">${escXml(apply[0])}</text>
  <text x="590" y="202" font-family="Segoe UI, system-ui, sans-serif" font-size="11" fill="#fca5a5" text-anchor="middle">${escXml(apply[1])}</text>
  <rect x="16" y="240" width="230" height="52" rx="8" fill="#dc2626" opacity="0.15"/>
  <rect x="16" y="240" width="230" height="52" rx="8" fill="none" stroke="#dc2626" stroke-width="1"/>
  <text x="131" y="262" font-family="Segoe UI, system-ui, sans-serif" font-size="11" font-weight="600" fill="#fca5a5" text-anchor="middle">${escXml(brush[0])}</text>
  <text x="131" y="280" font-family="Segoe UI, system-ui, sans-serif" font-size="11" fill="#c4a0a6" text-anchor="middle">${escXml(brush[1])}</text>
  <rect x="654" y="240" width="230" height="52" rx="8" fill="#dc2626" opacity="0.15"/>
  <rect x="654" y="240" width="230" height="52" rx="8" fill="none" stroke="#dc2626" stroke-width="1"/>
  <text x="769" y="262" font-family="Segoe UI, system-ui, sans-serif" font-size="11" font-weight="600" fill="#fca5a5" text-anchor="middle">${escXml(skip[0])}</text>
  <text x="769" y="280" font-family="Segoe UI, system-ui, sans-serif" font-size="11" fill="#c4a0a6" text-anchor="middle">${escXml(skip[1])}</text>
</svg>`;
}

// Generate concept cards
let conceptCount = 0;
for (const d of days) {
  const dd = String(d.day).padStart(2, '0');
  const file = path.join(OUT, `day-${dd}-${d.slug}.svg`);
  fs.writeFileSync(file, conceptCard(d));
  conceptCount++;
}

// Generate nav trees
let navCount = 0;
for (const n of navData) {
  const dd = String(n.day).padStart(2, '0');
  const file = path.join(OUT, `day-${dd}-where-next.svg`);
  fs.writeFileSync(file, navTree(n));
  navCount++;
}

console.log(`Generated ${conceptCount} concept cards + ${navCount} navigation trees in ${OUT}`);
console.log(`Total: ${conceptCount + navCount} SVGs`);
