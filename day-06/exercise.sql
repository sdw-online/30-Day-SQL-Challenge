-- Day 06: PRIMARY KEY, FOREIGN KEY & Constraints - Exercise Script
-- NovaPay Payment Schema Design
--
-- The exercise for Day 6 is to CREATE these tables yourself with proper constraints.
-- Watch the video for the full requirements, then try building them before checking below.

-- ============================================
-- SOLUTIONS (try the exercise first!)
-- ============================================

-- Task 1: Create the merchants table
DROP TABLE IF EXISTS novapay_transactions;
DROP TABLE IF EXISTS novapay_employees;
DROP TABLE IF EXISTS novapay_merchants;

CREATE TABLE novapay_merchants (
    merchant_id          SERIAL          PRIMARY KEY,
    merchant_name        VARCHAR(100)    NOT NULL,
    contact_email        VARCHAR(150)    NOT NULL UNIQUE,
    category             VARCHAR(20)     NOT NULL
                         CHECK (category IN ('retail', 'hospitality', 'saas', 'marketplace')),
    monthly_volume_limit NUMERIC(12, 2)  NOT NULL CHECK (monthly_volume_limit > 0),
    onboarded_date       DATE            NOT NULL DEFAULT CURRENT_DATE,
    is_active            BOOLEAN         NOT NULL DEFAULT TRUE
);

INSERT INTO novapay_merchants (merchant_name, contact_email, category, monthly_volume_limit)
VALUES
    ('Bean & Brew',   'hello@beanandbrew.co.uk', 'hospitality', 25000.00),
    ('TechStack Ltd', 'admin@techstack.io',      'saas',        100000.00);

-- Task 2: Create the transactions table
CREATE TABLE novapay_transactions (
    transaction_id  SERIAL          PRIMARY KEY,
    merchant_id     INTEGER         NOT NULL
                    REFERENCES novapay_merchants(merchant_id)
                    ON DELETE CASCADE,
    amount          NUMERIC(12, 2)  NOT NULL CHECK (amount > 0),
    currency        VARCHAR(3)      NOT NULL DEFAULT 'GBP'
                    CHECK (currency IN ('GBP', 'EUR', 'USD')),
    status          VARCHAR(20)     NOT NULL
                    CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);

INSERT INTO novapay_transactions (merchant_id, amount, currency, status)
VALUES
    (1, 49.99,  'GBP', 'completed'),
    (1, 120.00, 'GBP', 'pending');

-- Task 3: Create the employees table
CREATE TABLE novapay_employees (
    employee_id  SERIAL          PRIMARY KEY,
    full_name    VARCHAR(100)    NOT NULL,
    email        VARCHAR(150)    NOT NULL UNIQUE,
    department   VARCHAR(30)     NOT NULL
                 CHECK (department IN ('engineering', 'operations', 'compliance', 'sales')),
    role_level   VARCHAR(20)     NOT NULL
                 CHECK (role_level IN ('junior', 'mid', 'senior', 'lead', 'head')),
    salary       NUMERIC(10, 2)  NOT NULL
                 CHECK (salary >= 25000 AND salary <= 250000),
    start_date   DATE            NOT NULL DEFAULT CURRENT_DATE,
    is_active    BOOLEAN         NOT NULL DEFAULT TRUE
);

INSERT INTO novapay_employees (full_name, email, department, role_level, salary)
VALUES
    ('Tariq Hassan',  'tariq@novapay.co.uk',  'engineering', 'senior', 75000.00),
    ('Priya Sharma',  'priya@novapay.co.uk',  'compliance',  'lead',   85000.00);
