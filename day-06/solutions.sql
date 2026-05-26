-- ============================================
-- DAY 6 SOLUTIONS: Primary & Foreign Keys
-- ============================================

-- Q1: Create novapay_merchants table
CREATE TABLE novapay_merchants (
    merchant_id         SERIAL PRIMARY KEY,
    merchant_name       VARCHAR(100) NOT NULL,
    contact_email       VARCHAR(100) NOT NULL UNIQUE,
    category            VARCHAR(20)  NOT NULL CHECK (category IN ('retail', 'hospitality', 'saas', 'marketplace')),
    monthly_volume_limit NUMERIC(12,2) NOT NULL CHECK (monthly_volume_limit > 0),
    onboarded_date      DATE DEFAULT CURRENT_DATE,
    is_active           BOOLEAN DEFAULT TRUE
);

-- Q2: Insert two valid merchants
INSERT INTO novapay_merchants (merchant_name, contact_email, category, monthly_volume_limit)
VALUES
    ('HighStreet Goods', 'ops@highstreetgoods.co.uk', 'retail', 500000.00),
    ('CloudPay Pro', 'hello@cloudpaypro.com', 'saas', 250000.00);

SELECT * FROM novapay_merchants;

-- Q3: Create novapay_transactions table with FK + constraints
CREATE TABLE novapay_transactions (
    transaction_id  SERIAL PRIMARY KEY,
    merchant_id     INTEGER NOT NULL REFERENCES novapay_merchants(merchant_id) ON DELETE CASCADE,
    amount          NUMERIC(10,2) NOT NULL CHECK (amount > 0),
    currency        VARCHAR(3)  NOT NULL CHECK (currency IN ('GBP', 'EUR', 'USD')),
    status          VARCHAR(10) NOT NULL CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
    created_at      TIMESTAMP DEFAULT NOW()
);

-- Q4: Create novapay_employees table with CHECK constraints
CREATE TABLE novapay_employees (
    employee_id  SERIAL PRIMARY KEY,
    full_name    VARCHAR(100) NOT NULL,
    department   VARCHAR(20)  NOT NULL CHECK (department IN ('engineering', 'operations', 'compliance', 'sales')),
    role_level   VARCHAR(10)  NOT NULL CHECK (role_level IN ('junior', 'mid', 'senior', 'lead', 'head')),
    salary       INTEGER      NOT NULL CHECK (salary BETWEEN 25000 AND 250000),
    start_date   DATE         NOT NULL
);

-- Q5: Test constraints (each should fail)

-- Duplicate email - violates UNIQUE
INSERT INTO novapay_merchants (merchant_name, contact_email, category, monthly_volume_limit)
VALUES ('Duplicate Shop', 'ops@highstreetgoods.co.uk', 'retail', 100000);

-- Invalid category - violates CHECK
INSERT INTO novapay_merchants (merchant_name, contact_email, category, monthly_volume_limit)
VALUES ('CryptoTrader', 'info@cryptotrader.com', 'crypto', 100000);

-- Negative amount - violates CHECK
INSERT INTO novapay_transactions (merchant_id, amount, currency, status)
VALUES (1, -50.00, 'GBP', 'pending');

-- Non-existent merchant - violates FK
INSERT INTO novapay_transactions (merchant_id, amount, currency, status)
VALUES (999, 100.00, 'GBP', 'pending');

-- Q6: Test CASCADE delete
-- First add some transactions
INSERT INTO novapay_transactions (merchant_id, amount, currency, status)
VALUES (1, 150.00, 'GBP', 'completed'), (1, 200.00, 'EUR', 'pending');

SELECT COUNT(*) FROM novapay_transactions WHERE merchant_id = 1;
-- Should show 2

DELETE FROM novapay_merchants WHERE merchant_id = 1;

SELECT COUNT(*) FROM novapay_transactions WHERE merchant_id = 1;
-- Should show 0 (CASCADE deleted them)

-- Q7: Add UNIQUE constraint on merchant_id + currency combo
ALTER TABLE novapay_transactions
ADD CONSTRAINT unique_merchant_currency UNIQUE (merchant_id, currency);

-- Test: insert two with same merchant + currency (second should fail)
INSERT INTO novapay_transactions (merchant_id, amount, currency, status)
VALUES (2, 100.00, 'GBP', 'pending');

INSERT INTO novapay_transactions (merchant_id, amount, currency, status)
VALUES (2, 200.00, 'GBP', 'completed');
-- Should fail: duplicate (merchant_id=2, currency='GBP')
