# -*- coding: utf-8 -*-
"""
Re-render every questions.md with a proper visual layout.

The content was already right; the page was flat. This adds, in order:
  - a badge row and an at-a-glance progress checklist with anchor links
  - a mermaid ER diagram GENERATED FROM THE ACTUAL DDL, so it cannot drift
  - GitHub alert callouts for the scenario and the trap
  - each "check yourself" collapsed behind <details>, which is both tidier and
    better pedagogy: the expected row count is a spoiler if it sits on the page

Run:  python render_questions.py
"""
import io, os, re, sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import importlib.util as _u
_s=_u.spec_from_file_location("qc", os.path.join(os.path.dirname(os.path.abspath(__file__)),"questions-content.py"))
_m=_u.module_from_spec(_s); _s.loader.exec_module(_m)
DATA, META = _m.DATA, _m.META  # reuse the authored content, unchanged

# Day 15 was hand-written before the generator existed. Fold it in so all 12 match.
META['15'] = ('day-15-joins.svg', 'https://youtu.be/wtBxs_iDLo4', 'JOINs Part 1', 'Advanced')
DATA['15'] = dict(
 scenario=("An emergency response service logs incidents, dispatches responder units to them, and tracks "
           "which hospitals have capacity."),
 tables=[("incidents", "one reported incident"),
         ("responder_units", "one unit that can be sent"),
         ("dispatches", "one unit being sent to one incident"),
         ("hospital_capacity", "one hospital and its current capacity")],
 note=("Note the shape before you start: an incident can have many dispatches, and some incidents have "
       "none at all. That is the whole point of the day."),
 qs=[
  ("Who attended what",
   "Control wants a line for every incident a unit was actually sent to, showing the incident type, its "
   "severity, which unit attended, when it was dispatched and when it arrived.",
   "**Return:** incident id, incident type, severity, unit name, unit type, dispatched at, arrived at, "
   "ordered by when the incident was reported.",
   "Incidents that nobody was sent to must not appear."),
  ("Every incident, attended or not",
   "Now the opposite: every incident on the books, whether or not a unit was ever sent, with the dispatch "
   "details where they exist and blanks where they do not.",
   "**Return:** incident id, incident type, severity, status, dispatch id, unit name, ordered by when the "
   "incident was reported.",
   "This must return more rows than question 1. If it returns the same number, something in your query is "
   "quietly filtering the unattended incidents back out."),
  ("The ones nobody went to",
   "From that same list, produce only the incidents with no dispatch at all. This is the report that gets "
   "escalated, so it must not miss any.",
   "**Return:** incident id, incident type, severity, status, when it was reported.",
   "4 rows. The exercise script's own validation queries agree with that number."),
  ("Which hospitals could actually take them",
   "Each incident has a location, and each hospital serves an area - you will need to pull the area out of "
   "the text rather than compare the whole string. For every incident, show the hospitals in the matching "
   "area with their available capacity.",
   "**Return:** incident id, incident type, location, hospital name, available beds, ordered by incident "
   "then hospital.",
   "An incident in an area with no listed hospital should still tell you something useful. Decide whether "
   "it belongs in your result, and be ready to say why."),
 ])

TYPE_MAP = [(r'^(VARCHAR|CHAR|TEXT).*', 'text'), (r'^(INT|INTEGER|SERIAL|BIGINT|SMALLINT).*', 'int'),
            (r'^(NUMERIC|DECIMAL|REAL|DOUBLE|FLOAT).*', 'numeric'), (r'^BOOL.*', 'boolean'),
            (r'^TIMESTAMP.*', 'timestamp'), (r'^DATE.*', 'date')]


def simple_type(raw):
    r = raw.strip().upper()
    for pat, out in TYPE_MAP:
        if re.match(pat, r):
            return out
    return re.sub(r'[^A-Za-z]', '', r).lower() or 'text'


def parse_ddl(day, wanted):
    """Pull columns and foreign keys for the named tables out of the day's DDL."""
    tables, fks = {}, []
    for fname in ('exercise.sql', 'setup.sql'):
        path = os.path.join(REPO, 'day-%s' % day, fname)
        if not os.path.exists(path):
            continue
        sql = io.open(path, encoding='utf-8', errors='replace').read()
        for m in re.finditer(r'CREATE TABLE\s+(?:IF NOT EXISTS\s+)?(\w+)\s*\((.*?)\n\);', sql, re.S | re.I):
            name, body = m.group(1), m.group(2)
            if name not in wanted or name in tables:
                continue
            cols = []
            for line in body.split('\n'):
                line = line.split('--')[0].strip().rstrip(',')
                if not line or re.match(r'^(PRIMARY|FOREIGN|UNIQUE|CHECK|CONSTRAINT)\b', line, re.I):
                    continue
                parts = line.split()
                if len(parts) < 2:
                    continue
                col, typ = parts[0], simple_type(parts[1])
                key = 'PK' if re.search(r'PRIMARY KEY', line, re.I) else ''
                ref = re.search(r'REFERENCES\s+(\w+)', line, re.I)
                if ref:
                    key = 'FK'
                    fks.append((ref.group(1), name))
                cols.append((col, typ, key))
            tables[name] = cols
    return tables, fks


def mermaid(day, spec):
    wanted = [t for t, _ in spec['tables']]
    tables, fks = parse_ddl(day, set(wanted))
    if not tables:
        return ''
    lines = ['```mermaid', 'erDiagram']
    for parent, child in dict.fromkeys(fks):
        if parent in tables and child in tables:
            lines.append('    %s ||--o{ %s : ""' % (parent, child))
    for t in wanted:
        if t not in tables:
            continue
        lines.append('    %s {' % t)
        for col, typ, key in tables[t]:
            lines.append('        %s %s%s' % (typ, col, ' ' + key if key else ''))
        lines.append('    }')
    lines.append('```')
    return '\n'.join(lines)


def slug(s):
    return re.sub(r'[^a-z0-9 -]', '', s.lower()).replace(' ', '-')


HDR = '''<p align="center">
  <a href="{vid}"><img src="../assets/banners/{banner}" width="800" alt="Day {n} - {title}"></a>
</p>

<p align="center">
  <a href="{vid}"><img src="https://img.shields.io/badge/Watch_Lesson-YouTube-red?logo=youtube" alt="Watch on YouTube"></a>
  <img src="https://img.shields.io/badge/Day-{n}_of_30-1f6feb" alt="Day {n}">
  <img src="https://img.shields.io/badge/Questions-{q}-2da44e" alt="{q} questions">
  <img src="https://img.shields.io/badge/Difficulty-{diff}-orange" alt="{diff}">
  <img src="https://img.shields.io/badge/Solutions-not_on_this_page-8250df" alt="No solutions">
</p>

<h1 align="center">Day {n} &middot; Exercise Questions</h1>

<p align="center">
  <a href="README.md">&#8592; Back to Day {n}</a> &nbsp;&middot;&nbsp;
  <a href="exercise.sql">Exercise tables</a> &nbsp;&middot;&nbsp;
  <a href="solutions.sql">Solutions</a>
</p>

---

> [!NOTE]
> **How to use this page.** Run [`exercise.sql`](exercise.sql) first to create the tables and load the
> data, then answer the questions below **without opening the solutions**. Each one tells you what to
> return, and hides the expected result behind a toggle so you can check yourself once you have tried.
>
> The technique is deliberately not named. Working out which tool the question needs is most of the skill.

### Your run

{checklist}

---

## The scenario

{scenario}

{diagram}

| Table | One row is |
|---|---|
{tbl}

> [!IMPORTANT]
> {note}

---

'''

Q = '''<a id="q{i}"></a>

### {i}. {title}

{ask}

{ret}

<details>
<summary><b>Check yourself</b></summary>

<br>

{chk}

</details>

---

'''

FTR = '''## When you are done

Compare against [`solutions.sql`](solutions.sql). If your query returns the right rows by a different
route, that is not a mistake - there is usually more than one correct answer.

> [!TIP]
> What matters is whether you can say **why you chose yours**, what it costs, and what would have to be
> true about the data for it to break. That question, not the syntax, is the one interviews are
> actually testing.

<p align="center">
  <a href="../day-{prevp}/">&#8592; Day {prev}</a> &nbsp;&middot;&nbsp;
  <a href="README.md">Back to Day {n}</a> &nbsp;&middot;&nbsp;
  <a href="../day-{nxtp}/">Day {nxt} &#8594;</a>
</p>
'''

count = 0
for d in sorted(DATA):
    banner, vid, title, diff = META[d]
    spec, n, qs = DATA[d], str(int(d)), DATA[d]['qs']
    checklist = '\n'.join('- [ ] [%d. %s](#q%d)' % (i, q[0], i) for i, q in enumerate(qs, 1))
    tbl = '\n'.join('| `%s` | %s |' % (t, desc) for t, desc in spec['tables'])
    body = HDR.format(vid=vid, banner=banner, n=n, title=title, q=len(qs), diff=diff,
                      scenario=spec['scenario'], tbl=tbl, note=spec['note'],
                      checklist=checklist, diagram=mermaid(d, spec))
    for i, (qt, ask, ret, chk) in enumerate(qs, 1):
        body += Q.format(i=i, title=qt, ask=ask, ret=ret, chk=chk)
    prev, nxt = int(n) - 1, int(n) + 1
    body += FTR.format(prev=prev, prevp='%02d' % prev, nxt=nxt, nxtp='%02d' % nxt, n=n)
    body = re.sub(r'\n{4,}', '\n\n\n', body)
    for ch in ('\u2014', '\u2013'):
        assert ch not in body, (d, ch)
    io.open(os.path.join(REPO, 'day-%s' % d, 'questions.md'), 'w', encoding='utf-8', newline='').write(body)
    has_d = 'yes' if mermaid(d, spec) else 'NO DIAGRAM'
    print('day-%s  %d questions  diagram: %s' % (d, len(qs), has_d))
    count += 1
print('%d pages rendered' % count)
