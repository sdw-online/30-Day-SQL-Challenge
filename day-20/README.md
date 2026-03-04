# Day 20 - Data Modelling (Star Schema)

[Watch the video](COMING_SOON) | [← Day 19: Recursive CTEs](../day-19/) | [Day 21: SaaS Trial-to-Paid Conversion →](../day-21/)

---

### Contents
- [What You'll Learn](#what-youll-learn)
- [Dataset](#dataset)
- [Exercises](#exercises)
- [Key Concepts Covered](#key-concepts-covered)

---

## What You'll Learn
- What a star schema is and why it is the industry standard for analytics
- The difference between fact tables (measurable events) and dimension tables (descriptive context)
- Why grain is the most critical design decision in any data model
- How surrogate keys, summary tables, and date dimensions make analytical queries fast and reliable

## Prerequisites
- Complete Days 1-19
- Day 18 (normalisation) is essential - today builds directly on that foundation
- Comfortable with JOINs (Days 15-16), CTEs (Day 13), and aggregation (Days 5-6)

## Dataset

Today's dataset requires a Python script to generate 10,000+ rows of realistic data. The scenario is **Pulse Commerce**, a UK-based e-commerce company selling consumer electronics.

First, run this SQL in pgAdmin to create the star schema tables.

<details>
<summary>Click to expand dataset SQL</summary>

```sql
-- Drop tables if they already exist (safe to re-run)
DROP TABLE IF EXISTS fact_orders;
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_geography;

CREATE TABLE dim_geography (
    geography_key   SERIAL PRIMARY KEY,
    city            VARCHAR(100)   NOT NULL,
    region          VARCHAR(100)   NOT NULL,
    country         VARCHAR(50)    NOT NULL,
    country_code    CHAR(2)        NOT NULL,
    timezone        VARCHAR(50)
);

CREATE TABLE dim_customer (
    customer_key        SERIAL PRIMARY KEY,
    customer_id         VARCHAR(20)    NOT NULL UNIQUE,
    customer_name       VARCHAR(100)   NOT NULL,
    email               VARCHAR(150)   NOT NULL,
    segment             VARCHAR(30)    NOT NULL,
    loyalty_tier        VARCHAR(20)    NOT NULL,
    signup_date         DATE           NOT NULL,
    geography_key       INTEGER        REFERENCES dim_geography(geography_key)
);

CREATE TABLE dim_product (
    product_key         SERIAL PRIMARY KEY,
    product_code        VARCHAR(20)    NOT NULL UNIQUE,
    product_name        VARCHAR(200)   NOT NULL,
    category            VARCHAR(50)    NOT NULL,
    subcategory         VARCHAR(50)    NOT NULL,
    brand               VARCHAR(100)   NOT NULL,
    unit_cost_gbp       NUMERIC(10,2)  NOT NULL,
    unit_price_gbp      NUMERIC(10,2)  NOT NULL,
    is_active           BOOLEAN        DEFAULT TRUE
);

CREATE TABLE dim_date (
    date_key            INTEGER PRIMARY KEY,  -- YYYYMMDD format
    full_date           DATE           NOT NULL UNIQUE,
    day_of_week         INTEGER        NOT NULL,
    day_name            VARCHAR(10)    NOT NULL,
    day_of_month        INTEGER        NOT NULL,
    day_of_year         INTEGER        NOT NULL,
    week_of_year        INTEGER        NOT NULL,
    month_number        INTEGER        NOT NULL,
    month_name          VARCHAR(10)    NOT NULL,
    quarter             INTEGER        NOT NULL,
    quarter_name        CHAR(2)        NOT NULL,
    year                INTEGER        NOT NULL,
    is_weekend          BOOLEAN        NOT NULL,
    is_month_start      BOOLEAN        NOT NULL,
    is_month_end        BOOLEAN        NOT NULL,
    fiscal_year         INTEGER        NOT NULL,
    fiscal_quarter      INTEGER        NOT NULL
);

CREATE TABLE fact_orders (
    order_line_key      SERIAL PRIMARY KEY,
    order_id            VARCHAR(20)    NOT NULL,
    order_line_number   INTEGER        NOT NULL,
    date_key            INTEGER        NOT NULL REFERENCES dim_date(date_key),
    customer_key        INTEGER        NOT NULL REFERENCES dim_customer(customer_key),
    product_key         INTEGER        NOT NULL REFERENCES dim_product(product_key),
    geography_key       INTEGER        NOT NULL REFERENCES dim_geography(geography_key),
    quantity            INTEGER        NOT NULL,
    unit_price_gbp      NUMERIC(10,2)  NOT NULL,
    discount_pct        NUMERIC(5,2)   DEFAULT 0,
    line_total_gbp      NUMERIC(12,2)  NOT NULL,
    shipping_cost_gbp   NUMERIC(8,2)   DEFAULT 0,
    order_channel       VARCHAR(20)    NOT NULL,
    payment_method      VARCHAR(20)    NOT NULL
);
```

Then populate the tables using the Python script below. Save it as `day_20_seed.py`, update the connection details, and run it with `python day_20_seed.py`:

```python
import psycopg2
import random
from datetime import date, timedelta
from faker import Faker

DB_HOST = 'localhost'
DB_PORT = 5432
DB_NAME = 'sql_challenge'
DB_USER = 'postgres'
DB_PASSWORD = 'your_password'   # <-- Update this

GEOGRAPHY_COUNT = 30
CUSTOMER_COUNT = 500
PRODUCT_COUNT = 80
DATE_START = date(2024, 1, 1)
DATE_END = date(2025, 12, 31)
FACT_ROW_COUNT = 10000

random.seed(20)
fake = Faker('en_GB')
Faker.seed(20)

conn = psycopg2.connect(host=DB_HOST, port=DB_PORT, dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD)
conn.autocommit = False
cursor = conn.cursor()

GEOGRAPHIES = [
    ('London','Greater London','United Kingdom','GB','Europe/London'),
    ('Manchester','North West','United Kingdom','GB','Europe/London'),
    ('Birmingham','West Midlands','United Kingdom','GB','Europe/London'),
    ('Edinburgh','Scotland','United Kingdom','GB','Europe/London'),
    ('Bristol','South West','United Kingdom','GB','Europe/London'),
    ('Leeds','Yorkshire','United Kingdom','GB','Europe/London'),
    ('Glasgow','Scotland','United Kingdom','GB','Europe/London'),
    ('Cardiff','Wales','United Kingdom','GB','Europe/London'),
    ('Belfast','Northern Ireland','United Kingdom','GB','Europe/London'),
    ('Liverpool','North West','United Kingdom','GB','Europe/London'),
    ('Dublin','Leinster','Ireland','IE','Europe/Dublin'),
    ('Cork','Munster','Ireland','IE','Europe/Dublin'),
    ('Galway','Connacht','Ireland','IE','Europe/Dublin'),
    ('Amsterdam','North Holland','Netherlands','NL','Europe/Amsterdam'),
    ('Rotterdam','South Holland','Netherlands','NL','Europe/Amsterdam'),
    ('Berlin','Berlin','Germany','DE','Europe/Berlin'),
    ('Munich','Bavaria','Germany','DE','Europe/Berlin'),
    ('Hamburg','Hamburg','Germany','DE','Europe/Berlin'),
    ('Frankfurt','Hesse','Germany','DE','Europe/Berlin'),
    ('Cologne','North Rhine-Westphalia','Germany','DE','Europe/Berlin'),
    ('Paris','Ile-de-France','France','FR','Europe/Paris'),
    ('Lyon','Auvergne-Rhone-Alpes','France','FR','Europe/Paris'),
    ('Marseille','Provence-Alpes-Cote d\'Azur','France','FR','Europe/Paris'),
    ('Toulouse','Occitanie','France','FR','Europe/Paris'),
    ('Stockholm','Stockholm','Sweden','SE','Europe/Stockholm'),
    ('Gothenburg','Vastra Gotaland','Sweden','SE','Europe/Stockholm'),
    ('Malmo','Skane','Sweden','SE','Europe/Stockholm'),
    ('Oslo','Oslo','Norway','NO','Europe/Oslo'),
    ('Bergen','Vestland','Norway','NO','Europe/Oslo'),
    ('Stavanger','Rogaland','Norway','NO','Europe/Oslo'),
]

CATEGORIES = {
    'Laptops': {'subcategories':['Business','Gaming','Ultrabook'],'brands':['Dell','Lenovo','HP','ASUS'],'cost_range':(400,900),'margin':0.25},
    'Smartphones': {'subcategories':['Flagship','Mid-Range','Budget'],'brands':['Samsung','Apple','Google','OnePlus'],'cost_range':(150,700),'margin':0.30},
    'Headphones': {'subcategories':['Over-Ear','In-Ear','True Wireless'],'brands':['Sony','Bose','Sennheiser','JBL'],'cost_range':(20,200),'margin':0.40},
    'Tablets': {'subcategories':['Standard','Pro','Kids'],'brands':['Apple','Samsung','Lenovo','Amazon'],'cost_range':(80,500),'margin':0.28},
    'Monitors': {'subcategories':['4K','Ultrawide','Portable'],'brands':['LG','Dell','Samsung','BenQ'],'cost_range':(100,600),'margin':0.22},
    'Keyboards': {'subcategories':['Mechanical','Wireless','Ergonomic'],'brands':['Logitech','Corsair','Keychron','Razer'],'cost_range':(25,120),'margin':0.45},
    'Storage': {'subcategories':['SSD','External HDD','USB Drive'],'brands':['Samsung','Western Digital','Seagate','SanDisk'],'cost_range':(15,150),'margin':0.35},
    'Cameras': {'subcategories':['Mirrorless','Action','Webcam'],'brands':['Sony','Canon','GoPro','Logitech'],'cost_range':(40,800),'margin':0.20},
}

SEGMENTS = ['Consumer','Small Business','Enterprise','Education']
LOYALTY_TIERS = ['Bronze','Silver','Gold','Platinum']
ORDER_CHANNELS = ['web','mobile','in-store']
PAYMENT_METHODS = ['card','paypal','bank_transfer']

for geo in GEOGRAPHIES:
    cursor.execute("INSERT INTO dim_geography (city,region,country,country_code,timezone) VALUES (%s,%s,%s,%s,%s)", geo)
geography_count = len(GEOGRAPHIES)

current_date = DATE_START
date_count = 0
while current_date <= DATE_END:
    date_key = int(current_date.strftime('%Y%m%d'))
    day_of_week = current_date.weekday()
    day_name = current_date.strftime('%A')
    day_of_month = current_date.day
    day_of_year = current_date.timetuple().tm_yday
    week_of_year = current_date.isocalendar()[1]
    month_number = current_date.month
    month_name = current_date.strftime('%B')
    quarter = (current_date.month - 1) // 3 + 1
    quarter_name = f'Q{quarter}'
    year = current_date.year
    is_weekend = day_of_week >= 5
    is_month_start = current_date.day == 1
    next_day = current_date + timedelta(days=1)
    is_month_end = next_day.month != current_date.month
    if current_date.month >= 4:
        fiscal_year = current_date.year
    else:
        fiscal_year = current_date.year - 1
    fiscal_month = (current_date.month - 4) % 12 + 1
    fiscal_quarter = (fiscal_month - 1) // 3 + 1
    cursor.execute(
        "INSERT INTO dim_date (date_key,full_date,day_of_week,day_name,day_of_month,day_of_year,week_of_year,month_number,month_name,quarter,quarter_name,year,is_weekend,is_month_start,is_month_end,fiscal_year,fiscal_quarter) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",
        (date_key,current_date,day_of_week,day_name,day_of_month,day_of_year,week_of_year,month_number,month_name,quarter,quarter_name,year,is_weekend,is_month_start,is_month_end,fiscal_year,fiscal_quarter)
    )
    date_count += 1
    current_date += timedelta(days=1)

products = []
product_idx = 1
for category, config in CATEGORIES.items():
    for subcategory in config['subcategories']:
        for brand in config['brands'][:3]:
            if product_idx > PRODUCT_COUNT: break
            cost_low, cost_high = config['cost_range']
            unit_cost = round(random.uniform(cost_low, cost_high), 2)
            unit_price = round(unit_cost * (1 + config['margin']), 2)
            product_code = f"PC-{product_idx:04d}"
            product_name = f"{brand} {subcategory} {category[:-1] if category.endswith('s') else category}"
            cursor.execute(
                "INSERT INTO dim_product (product_code,product_name,category,subcategory,brand,unit_cost_gbp,unit_price_gbp,is_active) VALUES (%s,%s,%s,%s,%s,%s,%s,%s)",
                (product_code,product_name,category,subcategory,brand,unit_cost,unit_price,random.random()>0.05)
            )
            products.append(product_idx)
            product_idx += 1
        if product_idx > PRODUCT_COUNT: break
    if product_idx > PRODUCT_COUNT: break
actual_product_count = product_idx - 1

for i in range(1, CUSTOMER_COUNT + 1):
    customer_id = f"CUST-{i:05d}"
    customer_name = fake.name()
    email = fake.email()
    segment = random.choice(SEGMENTS)
    loyalty_tier = random.choices(LOYALTY_TIERS, weights=[40,30,20,10], k=1)[0]
    signup_date = DATE_START + timedelta(days=random.randint(0, 365))
    geography_key = random.randint(1, geography_count)
    cursor.execute(
        "INSERT INTO dim_customer (customer_id,customer_name,email,segment,loyalty_tier,signup_date,geography_key) VALUES (%s,%s,%s,%s,%s,%s,%s)",
        (customer_id,customer_name,email,segment,loyalty_tier,signup_date,geography_key)
    )

order_start = date(2024, 3, 1)
order_end = date(2025, 10, 31)
valid_date_keys = []
d = order_start
while d <= order_end:
    valid_date_keys.append(int(d.strftime('%Y%m%d')))
    d += timedelta(days=1)

inserted_lines = 0
order_number = 1
while inserted_lines < FACT_ROW_COUNT:
    num_lines = random.randint(1, 5)
    date_key = random.choice(valid_date_keys)
    customer_key = random.randint(1, CUSTOMER_COUNT)
    geography_key = random.randint(1, geography_count)
    channel = random.choice(ORDER_CHANNELS)
    payment = random.choice(PAYMENT_METHODS)
    order_id = f"ORD-{order_number:06d}"
    for line_num in range(1, num_lines + 1):
        if inserted_lines >= FACT_ROW_COUNT: break
        product_key = random.randint(1, actual_product_count)
        quantity = random.randint(1, 4)
        unit_price = round(random.uniform(15.00, 999.99), 2)
        discount_pct = random.choices([0,5,10,15,20], weights=[50,20,15,10,5], k=1)[0]
        line_total = round(quantity * unit_price * (1 - discount_pct / 100), 2)
        shipping = round(random.uniform(0, 12.99), 2) if line_num == 1 else 0
        cursor.execute(
            "INSERT INTO fact_orders (order_id,order_line_number,date_key,customer_key,product_key,geography_key,quantity,unit_price_gbp,discount_pct,line_total_gbp,shipping_cost_gbp,order_channel,payment_method) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",
            (order_id,line_num,date_key,customer_key,product_key,geography_key,quantity,unit_price,discount_pct,line_total,shipping,channel,payment)
        )
        inserted_lines += 1
    order_number += 1

conn.commit()
cursor.close()
conn.close()
print(f"Star schema populated: {geography_count} geographies, {CUSTOMER_COUNT} customers, {actual_product_count} products, {date_count} dates, {inserted_lines} fact rows.")
```

</details>

### Verify Your Setup

```sql
SELECT 'dim_geography' AS table_name, COUNT(*) AS row_count FROM dim_geography
UNION ALL
SELECT 'dim_customer',  COUNT(*) FROM dim_customer
UNION ALL
SELECT 'dim_product',   COUNT(*) FROM dim_product
UNION ALL
SELECT 'dim_date',      COUNT(*) FROM dim_date
UNION ALL
SELECT 'fact_orders',   COUNT(*) FROM fact_orders
ORDER BY table_name;

-- Expected:
-- dim_customer:   500 rows
-- dim_date:       731 rows
-- dim_geography:  30 rows
-- dim_product:    ~72-80 rows
-- fact_orders:    10,000 rows
```

## Exercises

You are an analytics engineer at a UK-based online retailer. The head of data, Ravi, has just called you into a meeting. He wants you to prove that the star schema you have built actually works - by answering real business questions from different teams.

The board is reviewing the data team's infrastructure budget next week. If these queries do not return clean, fast, useful answers, Ravi's case for keeping the data warehouse falls apart.

Using the dataset above, answer these questions:

### 🟢 Warm-Up

**Q1:** Write a query that joins `fact_orders` to `dim_product` and shows total revenue (`SUM(line_total_gbp)`) per product category. Which category generates the most revenue across all time?

**Q2:** Validate the star schema's grain - confirm that no combination of (`order_id`, `order_line_number`) appears more than once in `fact_orders`. How many duplicates are there?

### 🟡 Practice

**Q3:** The merchandising team wants revenue by product category for 2025 only. Join the fact table to `dim_product` and `dim_date`, filter to 2025, and show total orders, units sold, total revenue, and average line value per category. Which category generates the most revenue in 2025?

**Q4:** The marketing team wants the average order value by customer segment and loyalty tier. Remember: the fact table's grain is order-line level, so you need to aggregate to order level first (using a CTE), then average across orders. Which segment-tier combination has the highest average order value?

**Q5:** The finance team needs monthly revenue trends with month-over-month percentage change. Use `LAG()` to compare each month to the previous month. Which month showed the largest percentage increase?

### 🔴 Challenge

**Q6:** Create a summary table called `summary_monthly_category` that pre-aggregates revenue by year, month, and product category. Then verify that the total revenue in the summary matches the total revenue in the fact table. Do the two totals match exactly?

**Q7:** Write a query that joins `fact_orders` to all four dimensions (`dim_date`, `dim_product`, `dim_customer`, `dim_geography`) and produces a quarterly executive report for 2025 showing: quarter, product category, customer segment, country, total orders, total revenue, and average discount. Which quarter-category-segment combination generates the most revenue?

## Key Concepts Covered
- **Star schema:** A fact table in the centre surrounded by dimension tables - designed for fast, simple analytical queries with minimal joins
- **Fact tables:** Store measurable events (the numbers you aggregate) with foreign keys pointing to each dimension
- **Dimension tables:** Store descriptive context (the labels you filter and group by) - who, what, where, when
- **Grain:** What one row in the fact table represents - the most critical design decision. Always choose the finest grain; you can aggregate up but never disaggregate down
- **Surrogate keys:** Generated integer IDs used instead of natural identifiers - faster joins, source independence, and historical tracking
- **Date dimensions:** Pre-computed calendar attributes (fiscal year, quarter, weekend flags) that eliminate inconsistent date logic across queries

---

[← Day 19: Recursive CTEs](../day-19/) | [Day 21: SaaS Trial-to-Paid Conversion →](../day-21/)
