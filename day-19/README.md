# Day 19 - CTEs (Part 2): Recursive CTEs

[Watch the video](COMING_SOON) | [← Day 18: Normalisation & Denormalisation](../day-18/) | [Day 20: Data Modelling (Star Schema) →](../day-20/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- How recursive CTEs walk through tree-shaped data one level at a time
- The two-part structure: anchor member (starting rows) and recursive member (next level)
- How to traverse org charts, category trees, folder hierarchies, and bill of materials
- How to add safety limits and detect cycles to prevent infinite recursion

## Prerequisites
- Complete Days 1-18
- Day 13 knowledge is essential - you should be comfortable with the `WITH ... AS` syntax, multiple CTEs, and chaining CTEs
- Comfortable with UNION ALL (Day 17)

## Dataset

Run this SQL in pgAdmin to create today's tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS folder_structure;
DROP TABLE IF EXISTS bill_of_materials;
DROP TABLE IF EXISTS product_categories;
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    employee_id     SERIAL PRIMARY KEY,
    full_name       VARCHAR(100)    NOT NULL,
    job_title       VARCHAR(100)    NOT NULL,
    department      VARCHAR(60)     NOT NULL,
    manager_id      INTEGER         REFERENCES employees(employee_id),
    hire_date       DATE            NOT NULL,
    salary          NUMERIC(10, 2)  NOT NULL
);

CREATE TABLE product_categories (
    category_id         SERIAL PRIMARY KEY,
    category_name       VARCHAR(100)    NOT NULL,
    parent_category_id  INTEGER         REFERENCES product_categories(category_id),
    display_order       INTEGER         NOT NULL DEFAULT 0
);

CREATE TABLE bill_of_materials (
    component_id        SERIAL PRIMARY KEY,
    component_name      VARCHAR(150)    NOT NULL,
    parent_component_id INTEGER         REFERENCES bill_of_materials(component_id),
    unit_cost           NUMERIC(10, 2)  NOT NULL DEFAULT 0.00,
    quantity            INTEGER         NOT NULL DEFAULT 1
);

CREATE TABLE folder_structure (
    folder_id           SERIAL PRIMARY KEY,
    folder_name         VARCHAR(100)    NOT NULL,
    parent_folder_id    INTEGER         REFERENCES folder_structure(folder_id),
    created_date        DATE            NOT NULL DEFAULT CURRENT_DATE,
    owner               VARCHAR(100)    NOT NULL
);

-- Level 0: CEO (no manager)
INSERT INTO employees (full_name, job_title, department, manager_id, hire_date, salary) VALUES
('Ade Okonkwo', 'Chief Executive Officer', 'Executive', NULL, '2015-03-10', 185000.00);

-- Level 1: VPs (report to CEO, employee_id = 1)
INSERT INTO employees (full_name, job_title, department, manager_id, hire_date, salary) VALUES
('Isla MacKenzie', 'VP of Engineering', 'Engineering', 1, '2016-07-22', 145000.00),
('Ravi Chakrabarti', 'VP of Sales', 'Sales', 1, '2017-01-15', 140000.00),
('Freya Lindqvist', 'VP of Data', 'Data', 1, '2018-04-02', 142000.00);

-- Level 2: Directors (report to VPs)
INSERT INTO employees (full_name, job_title, department, manager_id, hire_date, salary) VALUES
('Kwame Asante', 'Director of Backend', 'Engineering', 2, '2019-02-11', 120000.00),
('Sienna Moretti', 'Director of Frontend', 'Engineering', 2, '2019-06-03', 118000.00),
('Callum Reeves', 'Director of Sales UK', 'Sales', 3, '2019-09-15', 110000.00),
('Priya Venkatesh', 'Director of Sales EMEA', 'Sales', 3, '2020-01-08', 112000.00),
('Euan Crawford', 'Director of Analytics', 'Data', 4, '2020-03-20', 115000.00),
('Nia Osei', 'Director of Data Engineering', 'Data', 4, '2020-05-14', 117000.00);

-- Level 3: Managers (report to Directors)
INSERT INTO employees (full_name, job_title, department, manager_id, hire_date, salary) VALUES
('Mateo Silva', 'Backend Team Lead', 'Engineering', 5, '2021-01-10', 92000.00),
('Aisha Bello', 'Backend Team Lead', 'Engineering', 5, '2021-03-22', 90000.00),
('Finn O''Sullivan', 'Frontend Team Lead', 'Engineering', 6, '2021-06-15', 88000.00),
('Yuki Tanaka', 'Sales Manager UK North', 'Sales', 7, '2021-08-01', 78000.00),
('Safiya Hassan', 'Sales Manager UK South', 'Sales', 7, '2021-09-20', 76000.00),
('Wei Zhang', 'Analytics Manager', 'Data', 9, '2022-01-10', 85000.00),
('Leila Osman', 'Data Pipeline Manager', 'Data', 10, '2022-03-15', 87000.00),
('Arjun Nair', 'Senior Data Engineer', 'Data', 10, '2022-06-01', 82000.00);

-- Level 4: Individual contributors (report to Managers)
INSERT INTO employees (full_name, job_title, department, manager_id, hire_date, salary) VALUES
('Zara Ahmed', 'Software Engineer', 'Engineering', 11, '2023-02-15', 65000.00),
('Idris Mensah', 'Software Engineer', 'Engineering', 12, '2023-04-10', 63000.00),
('Mei Nakamura', 'Frontend Developer', 'Engineering', 13, '2023-07-22', 62000.00),
('Quinn Byrne', 'Sales Executive', 'Sales', 14, '2023-09-05', 45000.00),
('River Adeyemi', 'Sales Executive', 'Sales', 15, '2024-01-15', 44000.00),
('Sage Mwangi', 'Data Analyst', 'Data', 17, '2024-03-10', 55000.00),
('Phoenix Okafor', 'Junior Data Engineer', 'Data', 18, '2024-06-01', 48000.00);

-- Product categories (3-level tree)
INSERT INTO product_categories (category_name, parent_category_id, display_order) VALUES
('Electronics', NULL, 1),
('Clothing', NULL, 2),
('Home & Garden', NULL, 3);

INSERT INTO product_categories (category_name, parent_category_id, display_order) VALUES
('Computers', 1, 1),
('Mobile Phones', 1, 2),
('Audio', 1, 3),
('Men''s Wear', 2, 1),
('Women''s Wear', 2, 2),
('Children''s Wear', 2, 3),
('Furniture', 3, 1),
('Kitchen', 3, 2),
('Garden Tools', 3, 3);

INSERT INTO product_categories (category_name, parent_category_id, display_order) VALUES
('Laptops', 4, 1),
('Desktops', 4, 2),
('Tablets', 4, 3),
('Headphones', 6, 1),
('Speakers', 6, 2),
('Sofas', 10, 1);

-- Bill of materials (3-level assembly)
INSERT INTO bill_of_materials (component_name, parent_component_id, unit_cost, quantity) VALUES
('Enterprise Workstation', NULL, 0.00, 1),
('Developer Laptop Kit', NULL, 0.00, 1);

INSERT INTO bill_of_materials (component_name, parent_component_id, unit_cost, quantity) VALUES
('CPU Module', 1, 0.00, 1),
('Memory Module', 1, 0.00, 1),
('Storage Module', 1, 0.00, 1),
('Display Assembly', 1, 0.00, 1);

INSERT INTO bill_of_materials (component_name, parent_component_id, unit_cost, quantity) VALUES
('Laptop Unit', 2, 0.00, 1),
('Peripheral Pack', 2, 0.00, 1);

INSERT INTO bill_of_materials (component_name, parent_component_id, unit_cost, quantity) VALUES
('Intel i9-14900K Processor', 3, 489.99, 1),
('CPU Cooler (240mm AIO)', 3, 89.99, 1),
('Thermal Paste', 3, 8.50, 1);

INSERT INTO bill_of_materials (component_name, parent_component_id, unit_cost, quantity) VALUES
('32GB DDR5 RAM Stick', 4, 74.99, 2),
('RAM Heat Spreader', 4, 12.50, 2);

INSERT INTO bill_of_materials (component_name, parent_component_id, unit_cost, quantity) VALUES
('2TB NVMe SSD', 5, 149.99, 1),
('4TB HDD', 5, 79.99, 1);

INSERT INTO bill_of_materials (component_name, parent_component_id, unit_cost, quantity) VALUES
('27" 4K Monitor', 6, 379.99, 2),
('Monitor Arm (Dual)', 6, 69.99, 1);

INSERT INTO bill_of_materials (component_name, parent_component_id, unit_cost, quantity) VALUES
('MacBook Pro 16" M3 Max', 7, 2899.00, 1);

INSERT INTO bill_of_materials (component_name, parent_component_id, unit_cost, quantity) VALUES
('Mechanical Keyboard', 8, 129.99, 1),
('Wireless Mouse', 8, 59.99, 1),
('USB-C Dock', 8, 149.99, 1);

-- Folder structure (4-level hierarchy)
INSERT INTO folder_structure (folder_name, parent_folder_id, created_date, owner) VALUES
('company-drive', NULL, '2024-01-05', 'Ade Okonkwo'),
('shared-resources', NULL, '2024-01-05', 'Ade Okonkwo');

INSERT INTO folder_structure (folder_name, parent_folder_id, created_date, owner) VALUES
('engineering', 1, '2024-01-10', 'Isla MacKenzie'),
('sales', 1, '2024-01-10', 'Ravi Chakrabarti'),
('data-team', 1, '2024-01-10', 'Freya Lindqvist');

INSERT INTO folder_structure (folder_name, parent_folder_id, created_date, owner) VALUES
('templates', 2, '2024-01-12', 'Ade Okonkwo'),
('onboarding', 2, '2024-01-12', 'Ade Okonkwo');

INSERT INTO folder_structure (folder_name, parent_folder_id, created_date, owner) VALUES
('backend', 3, '2024-02-01', 'Kwame Asante'),
('frontend', 3, '2024-02-01', 'Sienna Moretti'),
('devops', 3, '2024-02-15', 'Isla MacKenzie');

INSERT INTO folder_structure (folder_name, parent_folder_id, created_date, owner) VALUES
('proposals', 4, '2024-02-10', 'Callum Reeves'),
('contracts', 4, '2024-02-10', 'Priya Venkatesh');

INSERT INTO folder_structure (folder_name, parent_folder_id, created_date, owner) VALUES
('analytics', 5, '2024-02-05', 'Euan Crawford'),
('pipelines', 5, '2024-02-05', 'Nia Osei'),
('documentation', 5, '2024-03-01', 'Freya Lindqvist');

INSERT INTO folder_structure (folder_name, parent_folder_id, created_date, owner) VALUES
('api-v2', 8, '2024-03-10', 'Mateo Silva'),
('microservices', 8, '2024-04-01', 'Aisha Bello');

INSERT INTO folder_structure (folder_name, parent_folder_id, created_date, owner) VALUES
('dashboards', 13, '2024-03-15', 'Wei Zhang'),
('ad-hoc-reports', 13, '2024-04-10', 'Wei Zhang');

INSERT INTO folder_structure (folder_name, parent_folder_id, created_date, owner) VALUES
('auth-module', 16, '2024-05-01', 'Zara Ahmed');
```

</details>

### Verify Your Setup

```sql
SELECT COUNT(*) FROM employees;
-- Expected: 25 rows

SELECT COUNT(*) FROM product_categories;
-- Expected: 18 rows

SELECT COUNT(*) FROM bill_of_materials;
-- Expected: 20 rows

SELECT COUNT(*) FROM folder_structure;
-- Expected: 20 rows
```

## Exercises

You are a data engineer at Meridian Systems - a UK tech consultancy that is growing fast. The CTO, Ade, has asked you for two things before the board meeting on Thursday.

First, a complete map of the company's folder hierarchy with full file paths. The security team needs to audit who owns what before they roll out new access controls.

Second, a total cost breakdown for the Enterprise Workstation build. Procurement needs to know exact costs before they submit the hardware budget.

Using the dataset above, answer these questions:

### 🟢 Warm-Up

**Q1:** Write a recursive CTE that counts from 1 to 10. This has no business meaning - it simply demonstrates the anchor-plus-recursive structure. How many rows does it return?

**Q2:** Write a recursive CTE that walks just one level of the org chart - find the CEO and all employees who report directly to the CEO. Include a `depth` column (CEO = 0, direct reports = 1). How many direct reports does the CEO have?

### 🟡 Practice

**Q3:** Write a recursive CTE that walks the entire org chart from the CEO down to the most junior employee. Include a `depth` column, an indented name column using `REPEAT('  ', depth)`, and a `management_chain` column showing the full path (e.g. "Ade Okonkwo > Freya Lindqvist > Euan Crawford"). How many levels deep is the hierarchy?

**Q4:** Build full folder paths for every folder in the `folder_structure` table using a recursive CTE. The path should start with a forward slash (e.g. "/company-drive/engineering/backend/api-v2/auth-module"). What is the deepest folder, and how many levels deep is it?

**Q5:** Write a recursive CTE that walks the bill of materials for the Enterprise Workstation, calculating the effective cost (`unit_cost * quantity`) at each level. What is the total build cost of the Enterprise Workstation?

### 🔴 Challenge

**Q6:** Write a recursive CTE that starts at a specific employee (e.g. employee_id = 24, Sage Mwangi) and walks **up** the tree to the CEO. Show each person in the chain with their job title and the number of steps from the starting employee. How many steps is it from Sage to the CEO?

**Q7:** Write a recursive CTE that calculates total salary cost for each manager, including everyone below them in the hierarchy. The CEO's total should include the entire company payroll. Which manager (excluding the CEO) has the highest total subtree salary cost?

## Key Concepts Covered
- **Recursive CTE structure:** An anchor member (starting rows) connected to a recursive member (next level) by UNION ALL - the recursive member references the CTE's own name
- **Walking down a tree:** The join condition `child.parent_id = cte.id` finds children of rows already discovered
- **Walking up a tree:** Flipping the join to `parent.id = cte.parent_id` traverses from a leaf node up to the root
- **Depth tracking:** Adding a counter column (`depth + 1`) in the recursive member to track how many levels deep each row sits
- **Path building:** Concatenating names with a separator (e.g. `' > '`) to build breadcrumb trails like management chains or file paths
- **Safety limits:** Always include a `WHERE depth < N` clause or use PostgreSQL 14's `CYCLE` clause to prevent infinite recursion

---

[← Day 18: Normalisation & Denormalisation](../day-18/) | [Day 20: Data Modelling (Star Schema) →](../day-20/)
