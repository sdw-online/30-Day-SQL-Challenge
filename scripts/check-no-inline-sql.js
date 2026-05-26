#!/usr/bin/env node

/**
 * Detects inline SQL dumps in README files.
 * Flags any README that has CREATE TABLE or INSERT INTO outside
 * of a "Verify Your Setup" or small example context.
 *
 * Threshold: more than 5 SQL statement keywords = likely a dump.
 */

const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const DAYS = 30;
const SQL_THRESHOLD = 5;
const errors = [];

for (let i = 1; i <= DAYS; i++) {
  const day = String(i).padStart(2, '0');
  const readme = path.join(ROOT, `day-${day}`, 'README.md');

  if (!fs.existsSync(readme)) continue;

  const content = fs.readFileSync(readme, 'utf8');

  // Count SQL DDL/DML keywords that suggest a data dump
  const matches = content.match(/\b(CREATE TABLE|INSERT INTO|DROP TABLE)\b/gi) || [];

  if (matches.length > SQL_THRESHOLD) {
    errors.push(`day-${day}: ${matches.length} SQL statements inline (threshold: ${SQL_THRESHOLD}). Move data to setup.sql.`);
  }
}

if (errors.length > 0) {
  console.error('Inline SQL check FAILED:\n');
  errors.forEach(e => console.error(`  - ${e}`));
  process.exit(1);
} else {
  console.log('Inline SQL check PASSED: no README has excessive inline SQL.');
}
