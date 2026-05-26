#!/usr/bin/env node

/**
 * Validates that each day README contains required sections.
 * Only checks days that have a setup.sql (published days).
 */

const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const DAYS = 30;

const REQUIRED_SECTIONS = [
  { pattern: /## What You'll Learn/i, name: 'What You\'ll Learn' },
  { pattern: /## (Quick Setup|Dataset)/i, name: 'Quick Setup / Dataset' },
  { pattern: /## Exercises/i, name: 'Exercises' },
  { pattern: /## Key Concepts/i, name: 'Key Concepts' },
];

const errors = [];

for (let i = 1; i <= DAYS; i++) {
  const day = String(i).padStart(2, '0');
  const dir = path.join(ROOT, `day-${day}`);
  const setup = path.join(dir, 'setup.sql');
  const readme = path.join(dir, 'README.md');

  // Only check published days
  if (!fs.existsSync(setup) || !fs.existsSync(readme)) continue;

  const content = fs.readFileSync(readme, 'utf8');

  for (const section of REQUIRED_SECTIONS) {
    if (!section.pattern.test(content)) {
      errors.push(`day-${day}: missing section "${section.name}"`);
    }
  }
}

if (errors.length > 0) {
  console.error('README template check FAILED:\n');
  errors.forEach(e => console.error(`  - ${e}`));
  process.exit(1);
} else {
  console.log('README template check PASSED: all published days have required sections.');
}
