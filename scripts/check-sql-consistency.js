#!/usr/bin/env node
// QA gate: every base table a day's solutions.sql / exercise.sql references must
// actually be CREATEd by that day's setup.sql / exercise.sql (or be a CTE / temp
// table defined in the same file). Catches the Day-14-class bug where solutions
// described a different project (IoT) than setup created (fleet), so the exercise
// could never run. Strips comments + string literals to avoid false positives.
const fs = require('fs');
const path = require('path');
const ROOT = path.resolve(__dirname, '..');

const KEYWORDS = new Set([
  'select', 'where', 'group', 'order', 'having', 'limit', 'union', 'all',
  'on', 'as', 'and', 'or', 'with', 'lateral', 'using', 'natural', 'cross',
  'inner', 'left', 'right', 'full', 'outer', 'join', 'from', 'dual',
]);

function strip(sql) {
  let s = sql
    .replace(/--[^\n]*/g, ' ')          // line comments
    .replace(/\/\*[\s\S]*?\*\//g, ' ')  // block comments
    .replace(/'(?:[^']|'')*'/g, "''")   // string literals
    .replace(/"(?:[^"]|"")*"/g, '""');  // quoted identifiers
  // Neutralise functions that use the FROM keyword internally (EXTRACT(x FROM col),
  // SUBSTRING(s FROM a FOR b), TRIM(... FROM s), POSITION/OVERLAY) so their inner
  // FROM is not mistaken for a table reference. Run twice for one level of nesting.
  const fn = /\b(?:EXTRACT|SUBSTRING|SUBSTR|TRIM|OVERLAY|POSITION)\s*\([^()]*\)/ig;
  s = s.replace(fn, ' fn() ').replace(fn, ' fn() ');
  return s;
}
function created(sql) {
  const s = new Set();
  for (const m of strip(sql).matchAll(/CREATE\s+(?:TEMP(?:ORARY)?\s+)?TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?([a-z_][a-z0-9_]*)/ig)) s.add(m[1].toLowerCase());
  return s;
}
function ctes(sql) {
  const s = new Set();
  for (const m of strip(sql).matchAll(/(?:\bWITH\b|,)\s+([a-z_][a-z0-9_]*)\s+AS\s*\(/ig)) s.add(m[1].toLowerCase());
  return s;
}
function refs(sql) {
  const s = new Set();
  for (const m of strip(sql).matchAll(/\b(?:FROM|JOIN)\s+([a-z_][a-z0-9_]*)/ig)) {
    const t = m[1].toLowerCase();
    if (!KEYWORDS.has(t)) s.add(t);
  }
  return s;
}

const failures = [];
for (let d = 1; d <= 30; d++) {
  const dd = String(d).padStart(2, '0');
  const dir = path.join(ROOT, `day-${dd}`);
  const read = f => { try { return fs.readFileSync(path.join(dir, f), 'utf8'); } catch { return ''; } };
  const setup = read('setup.sql'), exer = read('exercise.sql'), sol = read('solutions.sql');
  if (!sol && !exer) continue; // unpublished stub days have no SQL yet

  const createdAll = new Set([...created(setup), ...created(exer), ...created(sol)]);
  const cteAll = new Set([...ctes(sol), ...ctes(exer)]);
  for (const [label, body] of [['solutions.sql', sol], ['exercise.sql', exer]]) {
    if (!body) continue;
    const missing = [...refs(body)].filter(t => !createdAll.has(t) && !cteAll.has(t));
    if (missing.length) failures.push(`day-${dd}/${label}: references table(s) nothing creates: ${missing.join(', ')}`);
  }
}

if (failures.length) {
  console.error('SQL consistency check FAILED:\n');
  for (const f of failures) console.error('  - ' + f);
  console.error('\nEvery table a solution/exercise queries must be created by setup.sql (or be a CTE).');
  process.exit(1);
}
console.log('SQL consistency check PASSED: every referenced base table is created by its setup.');
