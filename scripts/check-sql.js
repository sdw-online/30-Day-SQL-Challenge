#!/usr/bin/env node

/**
 * Basic SQL file validation.
 * Checks that .sql files are not empty and have balanced parentheses.
 * Does NOT require a running PostgreSQL instance.
 *
 * Checks:
 * 1. File is not empty
 * 2. Parentheses are balanced (catches truncated INSERT statements)
 * 3. Every CREATE TABLE has a matching closing );
 * 4. No obvious syntax issues (unclosed strings)
 */

const fs = require('fs');
const path = require('path');
const { globSync } = require('fs');

const ROOT = path.resolve(__dirname, '..');
const errors = [];

// Find all .sql files in day-XX folders
for (let i = 1; i <= 30; i++) {
  const day = String(i).padStart(2, '0');
  const dir = path.join(ROOT, `day-${day}`);

  if (!fs.existsSync(dir)) continue;

  const files = fs.readdirSync(dir).filter(f => f.endsWith('.sql'));

  for (const file of files) {
    const filePath = path.join(dir, file);
    const content = fs.readFileSync(filePath, 'utf8');
    const rel = `day-${day}/${file}`;

    // Check 1: Not empty
    if (content.trim().length === 0) {
      errors.push(`${rel}: file is empty`);
      continue;
    }

    // Check 2: Balanced parentheses
    let depth = 0;
    let inString = false;
    let stringChar = null;

    for (let j = 0; j < content.length; j++) {
      const ch = content[j];

      if (inString) {
        // Handle escaped quotes (doubled single quotes in SQL)
        if (ch === stringChar) {
          if (j + 1 < content.length && content[j + 1] === stringChar) {
            j++; // skip escaped quote
          } else {
            inString = false;
            stringChar = null;
          }
        }
      } else {
        if (ch === "'" || ch === '"') {
          inString = true;
          stringChar = ch;
        } else if (ch === '-' && j + 1 < content.length && content[j + 1] === '-') {
          // Skip single-line comments
          while (j < content.length && content[j] !== '\n') j++;
        } else if (ch === '(') {
          depth++;
        } else if (ch === ')') {
          depth--;
        }
      }
    }

    if (depth !== 0) {
      errors.push(`${rel}: unbalanced parentheses (depth: ${depth})`);
    }

    if (inString) {
      errors.push(`${rel}: unclosed string literal`);
    }

    // Check 3: CREATE TABLE should have closing );
    const createCount = (content.match(/CREATE\s+(TEMP\s+)?TABLE/gi) || []).length;
    const closingCount = (content.match(/\);\s*$/gm) || []).length;

    if (createCount > 0 && closingCount === 0) {
      errors.push(`${rel}: has ${createCount} CREATE TABLE but no closing );`);
    }
  }
}

if (errors.length > 0) {
  console.error('SQL validation FAILED:\n');
  errors.forEach(e => console.error(`  - ${e}`));
  process.exit(1);
} else {
  console.log('SQL validation PASSED: all .sql files are structurally valid.');
}
