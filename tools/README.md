# tools

## render-questions.py

Regenerates every `day-NN/questions.md`.

```bash
python tools/render-questions.py
```

**The question pages are GENERATED. Do not hand-edit them** - the next run overwrites your changes.
Edit the content in `questions-content.py` and re-render.

### Why it is split in two

| File | Holds |
|---|---|
| `questions-content.py` | the scenarios and questions - the writing |
| `render-questions.py` | the layout - badges, checklist, diagram, callouts |

Changing how a page looks should not risk the wording, and rewording a question should not mean
touching HTML. Twelve pages by hand is also twelve chances for one of them to drift out of step.

### The ER diagrams come from the DDL

Each page's mermaid diagram is parsed out of that day's `exercise.sql`, falling back to `setup.sql`
where the exercise reuses the teaching tables. Columns, primary keys and foreign keys are read from
the real `CREATE TABLE` statements, so a diagram cannot quietly disagree with the schema a learner
actually runs. Change the DDL, re-render, and the picture follows.

Tables with no foreign key simply get no relationship line. That is not a gap - on Day 15,
`hospital_capacity` joins on matching text rather than a key, and the absence of a line is exactly
what question 4 is about.

### Design decisions worth keeping

- **The technique is never named.** Working out which tool a question needs is most of the skill,
  and the day READMEs already give it away ("Use COALESCE", "Write a CTE called `stage_costs`").
- **Expected results are hidden behind `<details>`.** A row count sitting on the page is a spoiler.
- **No solutions on the page**, only a link to `solutions.sql`.
- **Every page closes on defending the choice**, not on the answer.

### Coverage

12 of 30 days: 8-13, 15-20. The rest have no task definitions to derive from and need authoring
from the lesson before they can be added.
