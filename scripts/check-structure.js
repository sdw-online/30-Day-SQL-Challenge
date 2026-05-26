#!/usr/bin/env node

/**
 * Validates that every day-XX folder has the required files.
 *
 * Published days (setup.sql exists): README.md + setup.sql + solutions.sql
 * Unpublished days (no setup.sql yet): README.md only (no enforcement)
 */

const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const DAYS = 30;
const errors = [];

for (let i = 1; i <= DAYS; i++) {
  const day = String(i).padStart(2, '0');
  const dir = path.join(ROOT, `day-${day}`);

  if (!fs.existsSync(dir)) {
    errors.push(`day-${day}: folder missing`);
    continue;
  }

  const readme = path.join(dir, 'README.md');
  if (!fs.existsSync(readme)) {
    errors.push(`day-${day}: README.md missing`);
  }

  // Only enforce SQL files for published days (those that already have setup.sql)
  const setup = path.join(dir, 'setup.sql');
  if (fs.existsSync(setup)) {
    const solutions = path.join(dir, 'solutions.sql');
    if (!fs.existsSync(solutions)) {
      errors.push(`day-${day}: solutions.sql missing (setup.sql exists, so solutions are required)`);
    }
  }
}

if (errors.length > 0) {
  console.error('Structure check FAILED:\n');
  errors.forEach(e => console.error(`  - ${e}`));
  process.exit(1);
} else {
  console.log(`Structure check PASSED: all ${DAYS} day folders valid.`);
}
