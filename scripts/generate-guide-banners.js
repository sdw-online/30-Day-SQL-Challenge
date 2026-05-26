#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const OUT = path.resolve(__dirname, '..', 'assets', 'banners');

function escXml(s) { return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }

// Small inline banners for the guide pages - same brand system
function guideBanner(title, subtitle) {
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 100" fill="none">
  <defs>
    <linearGradient id="gbg" x1="400" y1="0" x2="800" y2="100" gradientUnits="userSpaceOnUse">
      <stop offset="0%" stop-color="#1a0a0e"/>
      <stop offset="100%" stop-color="#4c0519"/>
    </linearGradient>
    <filter id="glow"><feGaussianBlur stdDeviation="2" result="blur"/><feMerge><feMergeNode in="blur"/><feMergeNode in="SourceGraphic"/></feMerge></filter>
  </defs>
  <rect width="800" height="100" rx="12" fill="url(#gbg)"/>
  <rect x="1" y="1" width="798" height="98" rx="12" fill="none" stroke="#dc2626" stroke-width="1.5" opacity="0.35" filter="url(#glow)"/>
  <circle cx="720" cy="16" r="2" fill="#dc2626" opacity="0.2"/><circle cx="740" cy="16" r="2" fill="#dc2626" opacity="0.25"/><circle cx="760" cy="16" r="2" fill="#dc2626" opacity="0.3"/><circle cx="780" cy="16" r="2" fill="#dc2626" opacity="0.35"/>
  <circle cx="740" cy="36" r="2" fill="#dc2626" opacity="0.15"/><circle cx="760" cy="36" r="2" fill="#dc2626" opacity="0.2"/><circle cx="780" cy="36" r="2" fill="#dc2626" opacity="0.25"/>
  <text x="40" y="44" font-family="Segoe UI, system-ui, sans-serif" font-size="22" font-weight="700" fill="#ffffff">${escXml(title)}</text>
  <text x="40" y="72" font-family="Segoe UI, system-ui, sans-serif" font-size="13" fill="#c4a0a6">${escXml(subtitle)}</text>
</svg>`;
}

const banners = [
  { file: 'why-daily-practice.svg', title: 'Daily Practice', subtitle: '30 minutes a day beats a 15-hour weekend binge. Consistency builds fluency.' },
  { file: 'why-real-data.svg', title: 'Real Data', subtitle: 'Logistics, finance, healthcare, SaaS - the kind of data you will actually see in a job.' },
  { file: 'why-career-exercises.svg', title: 'Career-Ready Exercises', subtitle: 'Every exercise puts you in a real role solving real business problems.' },
  { file: 'why-decompose.svg', title: 'Decompose Problems', subtitle: 'Break vague questions into precise, solvable steps. A thinking skill, not just syntax.' },
  { file: 'why-precision.svg', title: 'Be Precise', subtitle: 'Databases do not guess what you meant. You learn rigour that transfers everywhere.' },
  { file: 'why-direct-access.svg', title: 'Direct Access to Truth', subtitle: 'Query the source yourself. No middleman between you and the data.' },
];

let count = 0;
for (const b of banners) {
  fs.writeFileSync(path.join(OUT, b.file), guideBanner(b.title, b.subtitle));
  count++;
}

console.log(`Generated ${count} guide banners in ${OUT}`);
