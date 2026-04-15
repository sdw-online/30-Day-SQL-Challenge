window.COURSE_DATA = {
  "meta": {
    "title": "30 Day SQL Challenge",
    "channel": "Stephen | Data",
    "channelUrl": "https://youtube.com/@sdw-online",
    "playlistUrl": null,
    "repoUrl": "https://github.com/sdw-online/30-Day-SQL-Challenge",
    "newsletterUrl": "https://thedatabrief.beehiiv.com"
  },
  "days": [
    {
      "day": 1,
      "title": "Introduction to SQL & Databases",
      "slug": "intro-to-sql",
      "week": 1,
      "weekLabel": "SQL Fundamentals",
      "type": "concept",
      "youtubeId": "mFIMPhiO-N0",
      "githubPath": "day-01",
      "seedSQL": "\nCREATE TABLE gadgets (\n  gadget_id     INTEGER PRIMARY KEY,\n  gadget_name   TEXT    NOT NULL,\n  brand         TEXT    NOT NULL,\n  category      TEXT    NOT NULL,\n  price         REAL    NOT NULL,\n  release_year  INTEGER NOT NULL,\n  in_stock      INTEGER NOT NULL DEFAULT 1\n);\n\nINSERT INTO gadgets VALUES\n  (1,  'ProSound 500',       'Kova',      'Headphones',  89.99,  2022, 1),\n  (2,  'BassMax Elite',      'Zephyr',    'Headphones',  149.99, 2023, 1),\n  (3,  'SlimTab 10',         'Kova',      'Tablets',     299.99, 2021, 0),\n  (4,  'ViewTab Pro',        'Orbit',     'Tablets',     449.99, 2023, 1),\n  (5,  'FitBand 3',          'Pulsar',    'Smartwatches',119.99, 2022, 1),\n  (6,  'ChronoX Watch',      'Orbit',     'Smartwatches',249.99, 2023, 1),\n  (7,  'NovaCam 4K',         'Lenscraft', 'Cameras',     399.99, 2022, 0),\n  (8,  'PocketShot Mini',    'Lenscraft', 'Cameras',     199.99, 2023, 1),\n  (9,  'SoundDock Plus',     'Zephyr',    'Speakers',     79.99, 2021, 1),\n  (10, 'BassBox Pro',        'Kova',      'Speakers',    129.99, 2022, 1),\n  (11, 'SwiftCharge 65W',    'Voltix',    'Chargers',     34.99, 2023, 1),\n  (12, 'TurboCharge 100W',   'Voltix',    'Chargers',     59.99, 2022, 1),\n  (13, 'FoldPad X',          'Orbit',     'Tablets',     599.99, 2023, 0),\n  (14, 'StudioBuds Pro',     'Zephyr',    'Headphones',  199.99, 2023, 1),\n  (15, 'ActiveTrack 2',      'Pulsar',    'Smartwatches', 89.99, 2021, 0);\n",
      "tables": [
        {
          "name": "gadgets",
          "columns": [
            {
              "name": "gadget_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "gadget_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "brand",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "category",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "price",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "release_year",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "in_stock",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 15
        }
      ],
      "quickInsert": [
        "SELECT *",
        "FROM gadgets",
        "WHERE",
        "ORDER BY price"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d01-c01",
          "title": "See Everything",
          "description": "Retrieve every row and every column from the `gadgets` table. This is the most fundamental SQL query - getting a complete look at your data.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "Use SELECT * to select all columns, then specify the table name after FROM.",
          "solution": "SELECT * FROM gadgets;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 15
          }
        },
        {
          "id": "d01-c02",
          "title": "Just the Names and Prices",
          "description": "Select only the `gadget_name` and `price` columns from the `gadgets` table. Column selection keeps results focused and readable.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "List the column names separated by commas after SELECT.",
          "solution": "SELECT gadget_name, price FROM gadgets;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "gadget_name",
              "price"
            ],
            "expectedRowCount": 15
          }
        },
        {
          "id": "d01-c03",
          "title": "Count the Stock",
          "description": "Count how many gadgets are in the table. Use the `COUNT()` aggregate function to get a single number back.",
          "tier": "core",
          "difficulty": 2,
          "hint": "COUNT(*) counts every row. Give your result a clear name using AS.",
          "solution": "SELECT COUNT(*) AS total_gadgets FROM gadgets;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 1
          }
        },
        {
          "id": "d01-c04",
          "title": "Headphones Only",
          "description": "Find all gadgets where the `category` is `'Headphones'`. Use WHERE to filter rows to only the ones you care about.",
          "tier": "core",
          "difficulty": 2,
          "hint": "Add a WHERE clause after FROM and compare the category column to the text value 'Headphones'.",
          "solution": "SELECT * FROM gadgets WHERE category = 'Headphones';",
          "resetBefore": false,
          "validation": {
            "type": "all_match",
            "column": "category",
            "operator": "===",
            "value": "Headphones"
          }
        },
        {
          "id": "d01-c05",
          "title": "Most Expensive First",
          "description": "Retrieve the `gadget_name`, `category`, and `price` of all gadgets, sorted from the highest price to the lowest. This is how you rank results.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "Use ORDER BY price DESC. DESC means descending - largest value first.",
          "solution": "SELECT gadget_name, category, price FROM gadgets ORDER BY price DESC;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "price",
            "direction": "desc"
          }
        }
      ]
    },
    {
      "day": 2,
      "title": "SELECT & WHERE",
      "slug": "select-and-where",
      "week": 1,
      "weekLabel": "SQL Fundamentals",
      "type": "concept",
      "youtubeId": "-0uVBtXCZ_s",
      "githubPath": "day-02",
      "seedSQL": "\nCREATE TABLE bookshop (\n  book_id   INTEGER PRIMARY KEY,\n  title     TEXT    NOT NULL,\n  author    TEXT    NOT NULL,\n  genre     TEXT    NOT NULL,\n  price     REAL    NOT NULL,\n  pages     INTEGER NOT NULL,\n  in_stock  INTEGER NOT NULL DEFAULT 1,\n  rating    REAL    NOT NULL\n);\n\nINSERT INTO bookshop VALUES\n  (1,  'The Silent Hour',         'Amara Osei',        'Thriller',      12.99, 320, 1, 4.2),\n  (2,  'Roots of Ruin',           'James Calloway',    'History',       18.50, 480, 1, 4.5),\n  (3,  'A Quiet Algorithm',       'Priya Nair',        'Sci-Fi',        14.99, 290, 0, 3.8),\n  (4,  'The Baker of Seville',    'Elena Ruiz',        'Fiction',        9.99, 210, 1, 4.1),\n  (5,  'Code and Consequence',    'David Mensah',      'Sci-Fi',        16.99, 380, 1, 4.6),\n  (6,  'Northern Lights Lie',     'Ingrid Solberg',    'Thriller',      11.99, 270, 1, 3.9),\n  (7,  'The Debt of Kings',       'James Calloway',    'History',       22.00, 560, 0, 4.7),\n  (8,  'Midnight in Nairobi',     'Zawadi Mwangi',     'Fiction',       13.50, 305, 1, 4.3),\n  (9,  'Parallel Lives',          'Priya Nair',        'Sci-Fi',        15.99, 410, 1, 4.4),\n  (10, 'Saltwater and Stone',     'Tom Brannigan',     'Poetry',         8.99, 120, 1, 4.0),\n  (11, 'The Glass Republic',      'Amara Osei',        'Thriller',      14.50, 340, 1, 4.5),\n  (12, 'Ember Economics',         'Fatima Al-Rashid',  'Non-Fiction',   19.99, 260, 0, 3.7),\n  (13, 'Hollow Ground',           'Tom Brannigan',     'Fiction',       10.99, 190, 1, 3.6),\n  (14, 'Signals from the Void',   'David Mensah',      'Sci-Fi',        17.50, 450, 1, 4.8),\n  (15, 'The Cartographer',        'Elena Ruiz',        'History',       21.00, 520, 1, 4.6),\n  (16, 'When Rain Returns',       'Zawadi Mwangi',     'Fiction',       12.00, 280, 1, 4.2),\n  (17, 'Binary Ghosts',           'Ingrid Solberg',    'Thriller',      13.99, 310, 0, 4.1),\n  (18, 'The Spice Route Papers',  'Fatima Al-Rashid',  'History',       24.99, 600, 1, 4.9),\n  (19, 'Last Light on Lerna',     'Priya Nair',        'Sci-Fi',        16.00, 370, 1, 4.3),\n  (20, 'An Honest Thief',         'Amara Osei',        'Fiction',       11.50, 230, 1, 3.9);\n",
      "tables": [
        {
          "name": "bookshop",
          "columns": [
            {
              "name": "book_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "title",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "author",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "genre",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "price",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "pages",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "in_stock",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "rating",
              "type": "REAL",
              "pk": false
            }
          ],
          "rowCount": 20
        }
      ],
      "quickInsert": [
        "SELECT *",
        "FROM bookshop",
        "WHERE genre =",
        "AND",
        "OR",
        "NOT"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d02-c01",
          "title": "Thrillers in Stock",
          "description": "Find all books where the `genre` is `'Thriller'`. Return all columns. This is WHERE in its simplest form - a single equality check.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "Use WHERE genre = 'Thriller'. Text comparisons in SQL use single quotes.",
          "solution": "SELECT * FROM bookshop WHERE genre = 'Thriller';",
          "resetBefore": false,
          "validation": {
            "type": "all_match",
            "column": "genre",
            "operator": "===",
            "value": "Thriller"
          }
        },
        {
          "id": "d02-c02",
          "title": "Affordable Non-Fiction",
          "description": "Find books where the `genre` is `'Non-Fiction'` AND the `price` is less than `20`. Both conditions must be true for a row to appear.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "Use AND to combine two conditions: genre = 'Non-Fiction' AND price < 20.",
          "solution": "SELECT * FROM bookshop WHERE genre = 'Non-Fiction' AND price < 20;",
          "resetBefore": false,
          "validation": {
            "type": "all_match",
            "column": "genre",
            "operator": "===",
            "value": "Non-Fiction"
          }
        },
        {
          "id": "d02-c03",
          "title": "Sci-Fi or History",
          "description": "Return all books that belong to either the `'Sci-Fi'` or `'History'` genre. With OR, only one condition needs to be true.",
          "tier": "core",
          "difficulty": 2,
          "hint": "Use WHERE genre = 'Sci-Fi' OR genre = 'History'. You must repeat the column name on both sides of OR.",
          "solution": "SELECT title, author, genre, price FROM bookshop WHERE genre = 'Sci-Fi' OR genre = 'History';",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 9
          }
        },
        {
          "id": "d02-c04",
          "title": "Skip the Poetry",
          "description": "Return all books that are NOT in the `'Poetry'` genre. Retrieve `title`, `genre`, and `price` only.",
          "tier": "core",
          "difficulty": 2,
          "hint": "Use WHERE genre != 'Poetry' or WHERE NOT genre = 'Poetry'. Both work.",
          "solution": "SELECT title, genre, price FROM bookshop WHERE genre != 'Poetry';",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 19
          }
        },
        {
          "id": "d02-c05",
          "title": "Highly Rated and Long",
          "description": "Find books with a `rating` of 4.5 or higher AND more than 400 `pages`. Return `title`, `author`, `pages`, and `rating`.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "Combine two numeric comparisons with AND: rating >= 4.5 AND pages > 400.",
          "solution": "SELECT title, author, pages, rating FROM bookshop WHERE rating >= 4.5 AND pages > 400;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 5
          }
        },
        {
          "id": "d02-c06",
          "title": "Budget Picks with Good Reviews",
          "description": "Find books priced under `$12` with a rating of at least `4.0`, OR books that cost over `$20` regardless of rating. Return `title`, `price`, and `rating`.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "Wrap each condition group in parentheses: (price < 12 AND rating >= 4.0) OR (price > 20). Parentheses control evaluation order.",
          "solution": "SELECT title, price, rating FROM bookshop WHERE (price < 12 AND rating >= 4.0) OR price > 20;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 5
          }
        }
      ]
    },
    {
      "day": 3,
      "title": "ORDER BY & LIMIT",
      "slug": "order-by-and-limit",
      "week": 1,
      "weekLabel": "SQL Fundamentals",
      "type": "concept",
      "youtubeId": "s86nI9dPZqY",
      "githubPath": "day-03",
      "seedSQL": "\nCREATE TABLE destinations (\n  dest_id         INTEGER PRIMARY KEY,\n  city            TEXT    NOT NULL,\n  country         TEXT    NOT NULL,\n  continent       TEXT    NOT NULL,\n  avg_daily_cost  REAL    NOT NULL,\n  rating          REAL    NOT NULL,\n  popular_month   TEXT    NOT NULL,\n  visa_required   INTEGER NOT NULL DEFAULT 0\n);\n\nINSERT INTO destinations VALUES\n  (1,  'Tokyo',          'Japan',          'Asia',          210.00, 4.8, 'March',     0),\n  (2,  'Lisbon',         'Portugal',       'Europe',         95.00, 4.6, 'May',       0),\n  (3,  'Nairobi',        'Kenya',          'Africa',         75.00, 4.4, 'July',      1),\n  (4,  'Buenos Aires',   'Argentina',      'South America',  80.00, 4.5, 'November',  0),\n  (5,  'Bangkok',        'Thailand',       'Asia',           60.00, 4.3, 'December',  0),\n  (6,  'Amsterdam',      'Netherlands',    'Europe',        140.00, 4.6, 'April',     0),\n  (7,  'Cape Town',      'South Africa',   'Africa',        100.00, 4.7, 'January',   0),\n  (8,  'Mexico City',    'Mexico',         'North America',  70.00, 4.2, 'October',   0),\n  (9,  'Seoul',          'South Korea',    'Asia',          130.00, 4.5, 'September', 0),\n  (10, 'Marrakech',      'Morocco',        'Africa',         55.00, 4.4, 'April',     1),\n  (11, 'Vienna',         'Austria',        'Europe',        155.00, 4.7, 'June',      0),\n  (12, 'Bogota',         'Colombia',       'South America',  50.00, 4.1, 'August',    0),\n  (13, 'Singapore',      'Singapore',      'Asia',          200.00, 4.9, 'February',  0),\n  (14, 'Reykjavik',      'Iceland',        'Europe',        230.00, 4.8, 'June',      0),\n  (15, 'Lagos',          'Nigeria',        'Africa',         65.00, 4.0, 'December',  1),\n  (16, 'Kyoto',          'Japan',          'Asia',          170.00, 4.7, 'November',  0),\n  (17, 'Medellin',       'Colombia',       'South America',  45.00, 4.3, 'February',  0),\n  (18, 'Tbilisi',        'Georgia',        'Europe',         55.00, 4.5, 'May',       1);\n",
      "tables": [
        {
          "name": "destinations",
          "columns": [
            {
              "name": "dest_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "city",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "country",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "continent",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "avg_daily_cost",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "rating",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "popular_month",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "visa_required",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 18
        }
      ],
      "quickInsert": [
        "ORDER BY avg_daily_cost",
        "LIMIT 5",
        "DISTINCT continent",
        "LIKE '%a%'",
        "IN (",
        "BETWEEN"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d03-c01",
          "title": "Cheapest Destinations First",
          "description": "Return all columns from `destinations`, ordered by `avg_daily_cost` from lowest to highest. Ascending order is the default in SQL.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "ORDER BY defaults to ascending (ASC). You can write ORDER BY avg_daily_cost or ORDER BY avg_daily_cost ASC - both work.",
          "solution": "SELECT * FROM destinations ORDER BY avg_daily_cost ASC;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "avg_daily_cost",
            "direction": "asc"
          }
        },
        {
          "id": "d03-c02",
          "title": "Top 5 Rated Spots",
          "description": "Return the `city`, `country`, and `rating` of the 5 highest-rated destinations. When you want the best, you sort descending and then limit the result.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "ORDER BY rating DESC puts the highest first, then LIMIT 5 keeps only the top 5 rows.",
          "solution": "SELECT city, country, rating FROM destinations ORDER BY rating DESC LIMIT 5;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 5
          }
        },
        {
          "id": "d03-c03",
          "title": "Which Continents?",
          "description": "Return a unique list of all `continent` values in the table. DISTINCT removes duplicate values so each continent appears only once.",
          "tier": "core",
          "difficulty": 2,
          "hint": "SELECT DISTINCT continent FROM destinations. DISTINCT goes right after SELECT.",
          "solution": "SELECT DISTINCT continent FROM destinations;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 5
          }
        },
        {
          "id": "d03-c04",
          "title": "Cities Ending in 'o'",
          "description": "Find all cities whose name ends with the letter `o`. Use the LIKE operator with a wildcard pattern.",
          "tier": "core",
          "difficulty": 2,
          "hint": "LIKE '%o' matches any string that ends with the letter o. The % wildcard means 'any characters before this'.",
          "solution": "SELECT city, country FROM destinations WHERE city LIKE '%o';",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 2
          }
        },
        {
          "id": "d03-c05",
          "title": "Africa and South America",
          "description": "Return all destinations in `'Africa'` or `'South America'` using the IN operator. IN is a cleaner alternative to writing multiple OR conditions.",
          "tier": "core",
          "difficulty": 2,
          "hint": "WHERE continent IN ('Africa', 'South America') matches rows where continent equals any value in the list.",
          "solution": "SELECT city, country, continent, avg_daily_cost FROM destinations WHERE continent IN ('Africa', 'South America');",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 7
          }
        },
        {
          "id": "d03-c06",
          "title": "Mid-Range Budget",
          "description": "Find destinations where `avg_daily_cost` is between `$80` and `$160` (inclusive). Return `city`, `continent`, and `avg_daily_cost`, ordered by cost.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "BETWEEN is inclusive on both ends: WHERE avg_daily_cost BETWEEN 80 AND 160.",
          "solution": "SELECT city, continent, avg_daily_cost FROM destinations WHERE avg_daily_cost BETWEEN 80 AND 160 ORDER BY avg_daily_cost;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "avg_daily_cost",
            "direction": "asc"
          }
        },
        {
          "id": "d03-c07",
          "title": "Hidden Gems in Asia",
          "description": "Find the 3 cheapest Asian destinations that are rated 4.4 or higher and do not require a visa. Return `city`, `avg_daily_cost`, and `rating`.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "Combine WHERE continent = 'Asia' AND rating >= 4.4 AND visa_required = 0, then ORDER BY avg_daily_cost ASC LIMIT 3.",
          "solution": "SELECT city, avg_daily_cost, rating FROM destinations WHERE continent = 'Asia' AND rating >= 4.4 AND visa_required = 0 ORDER BY avg_daily_cost ASC LIMIT 3;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 3
          }
        }
      ]
    },
    {
      "day": 4,
      "title": "Aggregate Functions & GROUP BY",
      "slug": "aggregate-group-by",
      "week": 1,
      "weekLabel": "SQL Fundamentals",
      "type": "concept",
      "youtubeId": "7IWrvTIrIkg",
      "githubPath": "day-04",
      "seedSQL": "\nCREATE TABLE coffee_orders (\n  order_id      INTEGER PRIMARY KEY,\n  drink_name    TEXT    NOT NULL,\n  size          TEXT    NOT NULL,\n  price         REAL    NOT NULL,\n  milk_type     TEXT    NOT NULL,\n  is_iced       INTEGER NOT NULL DEFAULT 0,\n  order_date    TEXT    NOT NULL,\n  customer_name TEXT    NOT NULL\n);\n\nINSERT INTO coffee_orders VALUES\n  (1,  'Latte',       'Medium', 4.50, 'Oat',   0, '2024-01-08', 'Nadia Clarke'),\n  (2,  'Espresso',    'Small',  2.80, 'None',  0, '2024-01-08', 'Tomasz Wierzbicki'),\n  (3,  'Cappuccino',  'Large',  5.20, 'Whole', 0, '2024-01-09', 'Freya Hansen'),\n  (4,  'Latte',       'Large',  5.50, 'Oat',   1, '2024-01-09', 'Marcus Bell'),\n  (5,  'Flat White',  'Medium', 4.20, 'Whole', 0, '2024-01-09', 'Amara Diallo'),\n  (6,  'Mocha',       'Large',  5.80, 'Oat',   1, '2024-01-10', 'Nadia Clarke'),\n  (7,  'Espresso',    'Small',  2.80, 'None',  0, '2024-01-10', 'Kenji Nakamura'),\n  (8,  'Cappuccino',  'Medium', 4.60, 'Almond',0, '2024-01-10', 'Priya Iyer'),\n  (9,  'Latte',       'Small',  3.80, 'Soy',   0, '2024-01-11', 'Tom Ashby'),\n  (10, 'Flat White',  'Large',  5.00, 'Whole', 0, '2024-01-11', 'Freya Hansen'),\n  (11, 'Mocha',       'Medium', 5.10, 'Whole', 0, '2024-01-11', 'Marcus Bell'),\n  (12, 'Americano',   'Large',  3.90, 'None',  0, '2024-01-12', 'Amara Diallo'),\n  (13, 'Latte',       'Medium', 4.50, 'Oat',   1, '2024-01-12', 'Priya Iyer'),\n  (14, 'Cappuccino',  'Small',  3.70, 'Whole', 0, '2024-01-12', 'Kenji Nakamura'),\n  (15, 'Americano',   'Small',  2.90, 'None',  0, '2024-01-13', 'Tom Ashby'),\n  (16, 'Flat White',  'Medium', 4.20, 'Almond',0, '2024-01-13', 'Nadia Clarke'),\n  (17, 'Mocha',       'Small',  4.30, 'Soy',   1, '2024-01-13', 'Tomasz Wierzbicki'),\n  (18, 'Espresso',    'Small',  2.80, 'None',  0, '2024-01-14', 'Tom Ashby'),\n  (19, 'Latte',       'Large',  5.50, 'Whole', 0, '2024-01-14', 'Freya Hansen'),\n  (20, 'Americano',   'Medium', 3.40, 'None',  0, '2024-01-14', 'Marcus Bell'),\n  (21, 'Cappuccino',  'Large',  5.20, 'Oat',   0, '2024-01-15', 'Amara Diallo'),\n  (22, 'Mocha',       'Large',  5.80, 'Almond',1, '2024-01-15', 'Nadia Clarke'),\n  (23, 'Flat White',  'Small',  3.50, 'Whole', 0, '2024-01-15', 'Kenji Nakamura'),\n  (24, 'Latte',       'Medium', 4.50, 'Soy',   0, '2024-01-15', 'Priya Iyer'),\n  (25, 'Americano',   'Large',  3.90, 'None',  0, '2024-01-15', 'Tomasz Wierzbicki');\n",
      "tables": [
        {
          "name": "coffee_orders",
          "columns": [
            {
              "name": "order_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "drink_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "size",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "price",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "milk_type",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "is_iced",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "order_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "customer_name",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 25
        }
      ],
      "quickInsert": [
        "COUNT(*)",
        "AVG(price)",
        "SUM(price)",
        "GROUP BY drink_name",
        "HAVING COUNT(*) >"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d04-c01",
          "title": "Total Orders",
          "description": "Count the total number of orders in the `coffee_orders` table. Label the result `total_orders`.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "COUNT(*) counts all rows including duplicates. Use AS to give the column a name.",
          "solution": "SELECT COUNT(*) AS total_orders FROM coffee_orders;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 1
          }
        },
        {
          "id": "d04-c02",
          "title": "Average Coffee Price",
          "description": "Calculate the average `price` across all orders. Round to 2 decimal places and label it `avg_price`.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "AVG(price) calculates the mean. Wrap it with ROUND(...::numeric, 2) to limit decimal places.",
          "solution": "SELECT ROUND(AVG(price)::numeric, 2) AS avg_price FROM coffee_orders;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 1
          }
        },
        {
          "id": "d04-c03",
          "title": "Orders Per Drink",
          "description": "Count how many orders each `drink_name` has received. Return `drink_name` and `order_count`, sorted by count descending.",
          "tier": "core",
          "difficulty": 2,
          "hint": "GROUP BY drink_name splits the table into groups. COUNT(*) then counts within each group.",
          "solution": "SELECT drink_name, COUNT(*) AS order_count FROM coffee_orders GROUP BY drink_name ORDER BY order_count DESC;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "order_count",
            "direction": "desc"
          }
        },
        {
          "id": "d04-c04",
          "title": "Revenue by Drink",
          "description": "Calculate the total revenue (SUM of `price`) generated by each `drink_name`. Return `drink_name` and `total_revenue`, rounded to 2 decimal places, ordered by revenue descending.",
          "tier": "core",
          "difficulty": 2,
          "hint": "SUM(price) adds up all prices within each group. Combine with GROUP BY drink_name.",
          "solution": "SELECT drink_name, ROUND(SUM(price)::numeric, 2) AS total_revenue FROM coffee_orders GROUP BY drink_name ORDER BY total_revenue DESC;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "total_revenue",
            "direction": "desc"
          }
        },
        {
          "id": "d04-c05",
          "title": "Popular Drinks Only",
          "description": "Find drinks that have been ordered more than 3 times. Return `drink_name` and `order_count`. HAVING filters groups - it is the WHERE clause for aggregates.",
          "tier": "core",
          "difficulty": 2,
          "hint": "HAVING comes after GROUP BY: GROUP BY drink_name HAVING COUNT(*) > 3. You cannot use WHERE here because WHERE runs before grouping.",
          "solution": "SELECT drink_name, COUNT(*) AS order_count FROM coffee_orders GROUP BY drink_name HAVING COUNT(*) > 3;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 5
          }
        },
        {
          "id": "d04-c06",
          "title": "Cheapest and Priciest Drink",
          "description": "Find the minimum and maximum `price` for each `drink_name`. Return `drink_name`, `min_price`, and `max_price`.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "Use MIN(price) and MAX(price) together in the same SELECT alongside GROUP BY drink_name.",
          "solution": "SELECT drink_name, MIN(price) AS min_price, MAX(price) AS max_price FROM coffee_orders GROUP BY drink_name ORDER BY drink_name;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 6
          }
        },
        {
          "id": "d04-c07",
          "title": "Iced Drink Revenue vs Hot",
          "description": "Compare total revenue between iced orders (`is_iced = 1`) and hot orders (`is_iced = 0`). Return `is_iced`, `order_count`, and `total_revenue` rounded to 2 decimal places.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "GROUP BY is_iced groups all rows into two buckets: iced (1) and hot (0). Then apply COUNT and SUM to each bucket.",
          "solution": "SELECT is_iced, COUNT(*) AS order_count, ROUND(SUM(price)::numeric, 2) AS total_revenue FROM coffee_orders GROUP BY is_iced;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 2
          }
        }
      ]
    },
    {
      "day": 5,
      "title": "INSERT, UPDATE & DELETE",
      "slug": "insert-update-delete",
      "week": 1,
      "weekLabel": "SQL Fundamentals",
      "type": "concept",
      "youtubeId": "NJ4ujmOZt60",
      "githubPath": "day-05",
      "seedSQL": "\nCREATE TABLE vinyl_records (\n  record_id     INTEGER PRIMARY KEY,\n  album_name    TEXT    NOT NULL,\n  artist        TEXT    NOT NULL,\n  genre         TEXT    NOT NULL,\n  year_released INTEGER NOT NULL,\n  condition     TEXT    NOT NULL,\n  price         REAL    NOT NULL\n);\n\nINSERT INTO vinyl_records VALUES\n  (1,  'Kind of Blue',          'Miles Davis',        'Jazz',     1959, 'Excellent', 45.00),\n  (2,  'Purple Rain',           'Prince',             'Pop',      1984, 'Good',      28.00),\n  (3,  'Rumours',               'Fleetwood Mac',      'Rock',     1977, 'Fair',      15.00),\n  (4,  'Thriller',              'Michael Jackson',    'Pop',      1982, 'Excellent', 55.00),\n  (5,  'What''s Going On',      'Marvin Gaye',        'Soul',     1971, 'Good',      32.00),\n  (6,  'Nevermind',             'Nirvana',            'Rock',     1991, 'Fair',      18.00),\n  (7,  'Blue',                  'Joni Mitchell',      'Folk',     1971, 'Excellent', 40.00),\n  (8,  'Innervisions',          'Stevie Wonder',      'Soul',     1973, 'Good',      35.00),\n  (9,  'Appetite for Destruction','Guns N Roses',     'Rock',     1987, 'Fair',      20.00),\n  (10, 'Aja',                   'Steely Dan',         'Jazz',     1977, 'Excellent', 48.00),\n  (11, 'Born to Run',           'Bruce Springsteen',  'Rock',     1975, 'Good',      25.00),\n  (12, 'Debut',                 'Bjork',              'Electronic',1993,'Fair',      22.00);\n",
      "tables": [
        {
          "name": "vinyl_records",
          "columns": [
            {
              "name": "record_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "album_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "artist",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "genre",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "year_released",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "condition",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "price",
              "type": "REAL",
              "pk": false
            }
          ],
          "rowCount": 12
        }
      ],
      "quickInsert": [
        "INSERT INTO vinyl_records",
        "UPDATE vinyl_records SET",
        "DELETE FROM vinyl_records WHERE"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d05-c01",
          "title": "Add a New Record",
          "description": "A new album has arrived: 'Astral Weeks' by Van Morrison, Folk genre, released in 1968, condition 'Excellent', priced at $38.00. Insert it into `vinyl_records` with `record_id = 13`.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "INSERT INTO table_name VALUES (value1, value2, ...) in the exact column order. Text values need single quotes.",
          "solution": "INSERT INTO vinyl_records VALUES (13, 'Astral Weeks', 'Van Morrison', 'Folk', 1968, 'Excellent', 38.00);",
          "resetBefore": false,
          "validation": {
            "type": "mutation",
            "checkSQL": "SELECT COUNT(*) AS c FROM vinyl_records",
            "validation": {
              "type": "row_count",
              "expected": 1
            }
          }
        },
        {
          "id": "d05-c02",
          "title": "Batch Stock Arrival",
          "description": "Insert two new records in a single statement: 'Tapestry' by Carole King (Pop, 1971, Good, $26.00, record_id 14) and 'Bridge Over Troubled Water' by Simon & Garfunkel (Folk, 1970, Excellent, $42.00, record_id 15).",
          "tier": "starter",
          "difficulty": 1,
          "hint": "INSERT INTO ... VALUES (...), (...) - list multiple rows separated by commas after the VALUES keyword.",
          "solution": "INSERT INTO vinyl_records VALUES (14, 'Tapestry', 'Carole King', 'Pop', 1971, 'Good', 26.00), (15, 'Bridge Over Troubled Water', 'Simon & Garfunkel', 'Folk', 1970, 'Excellent', 42.00);",
          "resetBefore": false,
          "validation": {
            "type": "mutation",
            "checkSQL": "SELECT COUNT(*) AS c FROM vinyl_records",
            "validation": {
              "type": "row_count",
              "expected": 1
            }
          }
        },
        {
          "id": "d05-c03",
          "title": "Price Increase for Excellent Condition",
          "description": "The shop is repricing its Excellent-condition stock. Increase the `price` by 10% for all records where `condition = 'Excellent'`. Then SELECT all Excellent records to verify.",
          "tier": "core",
          "difficulty": 2,
          "hint": "UPDATE vinyl_records SET price = price * 1.10 WHERE condition = 'Excellent'. Always include WHERE or every row updates.",
          "solution": "UPDATE vinyl_records SET price = ROUND((price * 1.10)::numeric, 2) WHERE condition = 'Excellent';\nSELECT * FROM vinyl_records WHERE condition = 'Excellent';",
          "resetBefore": true,
          "validation": {
            "type": "all_match",
            "column": "condition",
            "operator": "===",
            "value": "Excellent"
          }
        },
        {
          "id": "d05-c04",
          "title": "Correct a Mistake",
          "description": "The record 'Rumours' by Fleetwood Mac was mis-entered. Update its `condition` to `'Good'` and its `price` to `22.50`. Use `album_name` to identify it.",
          "tier": "core",
          "difficulty": 2,
          "hint": "SET multiple columns by separating them with commas: SET condition = 'Good', price = 22.50. Then verify with a SELECT.",
          "solution": "UPDATE vinyl_records SET condition = 'Good', price = 22.50 WHERE album_name = 'Rumours';\nSELECT * FROM vinyl_records WHERE album_name = 'Rumours';",
          "resetBefore": true,
          "validation": {
            "type": "row_count",
            "expected": 1
          }
        },
        {
          "id": "d05-c05",
          "title": "Remove Damaged Stock",
          "description": "Remove all records in `'Fair'` condition from the inventory - the shop only keeps Good or better. DELETE the affected rows, then SELECT the remaining stock to confirm.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "DELETE FROM vinyl_records WHERE condition = 'Fair'. Never run DELETE without WHERE unless you intend to clear the whole table.",
          "solution": "DELETE FROM vinyl_records WHERE condition = 'Fair';\nSELECT * FROM vinyl_records;",
          "resetBefore": true,
          "validation": {
            "type": "row_count",
            "expected": 8
          }
        },
        {
          "id": "d05-c06",
          "title": "Full Transaction Workflow",
          "description": "Run a complete data correction workflow in order: (1) Insert a new record: record_id 13, 'Giant Steps', 'John Coltrane', 'Jazz', 1960, 'Excellent', $52.00. (2) Update the genre of 'Debut' to 'Alternative' to fix a mis-categorisation. (3) Delete all records released before 1970. (4) SELECT everything to see the final state.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "Run all four statements in sequence. Each statement is independent - INSERT first, then UPDATE, then DELETE, then SELECT.",
          "solution": "INSERT INTO vinyl_records VALUES (13, 'Giant Steps', 'John Coltrane', 'Jazz', 1960, 'Excellent', 52.00);\nUPDATE vinyl_records SET genre = 'Alternative' WHERE album_name = 'Debut';\nDELETE FROM vinyl_records WHERE year_released < 1970;\nSELECT * FROM vinyl_records;",
          "resetBefore": true,
          "validation": {
            "type": "row_count",
            "expected": 11
          }
        }
      ]
    },
    {
      "day": 6,
      "title": "PRIMARY KEY, FOREIGN KEY & Constraints",
      "slug": "primary-key-foreign-key-constraints",
      "week": 1,
      "weekLabel": "SQL Fundamentals",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-06",
      "seedSQL": "\nCREATE TABLE gym_members (\n  member_id       INTEGER PRIMARY KEY,\n  first_name      TEXT    NOT NULL,\n  last_name       TEXT    NOT NULL,\n  email           TEXT    NOT NULL UNIQUE,\n  membership_type TEXT    NOT NULL CHECK (membership_type IN ('Basic', 'Standard', 'Premium')),\n  join_date       TEXT    NOT NULL,\n  is_active       INTEGER NOT NULL DEFAULT 1\n);\n\nCREATE TABLE gym_classes (\n  class_id    INTEGER PRIMARY KEY,\n  class_name  TEXT    NOT NULL,\n  instructor  TEXT    NOT NULL,\n  day_of_week TEXT    NOT NULL,\n  capacity    INTEGER NOT NULL\n);\n\nCREATE TABLE class_bookings (\n  booking_id   INTEGER PRIMARY KEY,\n  member_id    INTEGER NOT NULL REFERENCES gym_members(member_id),\n  class_id     INTEGER NOT NULL REFERENCES gym_classes(class_id),\n  booking_date TEXT    NOT NULL\n);\n\nINSERT INTO gym_members VALUES\n  (1,  'Sophie',   'Adeyemi',   'sophie.adeyemi@mail.com',   'Premium',  '2023-01-15', 1),\n  (2,  'Carlos',   'Reyes',     'carlos.reyes@mail.com',     'Standard', '2023-03-02', 1),\n  (3,  'Ingrid',   'Halvorsen', 'ingrid.h@mail.com',         'Basic',    '2023-04-20', 1),\n  (4,  'Daniel',   'Osei',      'daniel.osei@mail.com',      'Premium',  '2023-06-11', 1),\n  (5,  'Mei',      'Chen',      'mei.chen@mail.com',         'Standard', '2023-07-08', 0),\n  (6,  'Finn',     'Murphy',    'finn.murphy@mail.com',      'Basic',    '2023-08-14', 1),\n  (7,  'Aisha',    'Kamara',    'aisha.kamara@mail.com',     'Premium',  '2023-09-01', 1),\n  (8,  'Lucas',    'Becker',    'lucas.becker@mail.com',     'Standard', '2023-10-22', 1),\n  (9,  'Nour',     'El-Amin',   'nour.elamin@mail.com',      'Basic',    '2023-11-05', 1),\n  (10, 'Preethi',  'Rajan',     'preethi.rajan@mail.com',   'Standard', '2024-01-03', 1);\n\nINSERT INTO gym_classes VALUES\n  (1, 'Yoga Flow',      'Rachel Kim',    'Monday',    20),\n  (2, 'HIIT Blast',     'Marco Pelosi',  'Tuesday',   15),\n  (3, 'Spin Cycle',     'Rachel Kim',    'Wednesday', 18),\n  (4, 'Pilates Core',   'Sasha Novak',   'Thursday',  12),\n  (5, 'Boxing Basics',  'Marco Pelosi',  'Friday',    10),\n  (6, 'Aqua Aerobics',  'Sasha Novak',   'Monday',    25),\n  (7, 'Power Lifting',  'Jamie Okafor',  'Wednesday', 8),\n  (8, 'Zumba Night',    'Rachel Kim',    'Friday',    30);\n\nINSERT INTO class_bookings VALUES\n  (1,  1, 1, '2024-02-05'),\n  (2,  1, 3, '2024-02-07'),\n  (3,  2, 2, '2024-02-06'),\n  (4,  2, 5, '2024-02-09'),\n  (5,  3, 1, '2024-02-05'),\n  (6,  4, 7, '2024-02-07'),\n  (7,  4, 2, '2024-02-06'),\n  (8,  5, 3, '2024-02-07'),\n  (9,  6, 8, '2024-02-09'),\n  (10, 7, 1, '2024-02-05'),\n  (11, 7, 4, '2024-02-08'),\n  (12, 8, 2, '2024-02-06'),\n  (13, 8, 5, '2024-02-09'),\n  (14, 9, 6, '2024-02-05'),\n  (15, 10,8, '2024-02-09');\n",
      "tables": [
        {
          "name": "gym_members",
          "columns": [
            {
              "name": "member_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "first_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "last_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "email",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "membership_type",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "join_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "is_active",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 10
        },
        {
          "name": "gym_classes",
          "columns": [
            {
              "name": "class_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "class_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "instructor",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "day_of_week",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "capacity",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 8
        },
        {
          "name": "class_bookings",
          "columns": [
            {
              "name": "booking_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "member_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "class_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "booking_date",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 15
        }
      ],
      "quickInsert": [
        "JOIN gym_members ON",
        "LEFT JOIN",
        "REFERENCES",
        "UNIQUE",
        "CHECK"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d06-c01",
          "title": "Members and Their Classes",
          "description": "Retrieve a list of all bookings showing the member's `first_name`, `last_name`, the `class_name`, and the `booking_date`. Join all three tables together.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "Start with class_bookings, then JOIN gym_members ON member_id, then JOIN gym_classes ON class_id.",
          "solution": "SELECT m.first_name, m.last_name, c.class_name, b.booking_date FROM class_bookings b JOIN gym_members m ON b.member_id = m.member_id JOIN gym_classes c ON b.class_id = c.class_id ORDER BY m.last_name;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 15
          }
        },
        {
          "id": "d06-c02",
          "title": "Who Has Never Booked?",
          "description": "Find all members who have never made a class booking. Return their `first_name`, `last_name`, and `email`. A LEFT JOIN combined with a NULL check is the classic pattern for this.",
          "tier": "starter",
          "difficulty": 2,
          "hint": "LEFT JOIN class_bookings ON member_id will keep all members. Then WHERE b.booking_id IS NULL filters to those with no match.",
          "solution": "SELECT m.first_name, m.last_name, m.email FROM gym_members m LEFT JOIN class_bookings b ON m.member_id = b.member_id WHERE b.booking_id IS NULL;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 0
          }
        },
        {
          "id": "d06-c03",
          "title": "Membership Counts by Type",
          "description": "Count how many members hold each `membership_type`. Return `membership_type` and `member_count`, ordered from most to least popular.",
          "tier": "core",
          "difficulty": 2,
          "hint": "GROUP BY membership_type on the gym_members table. No joins needed for this one.",
          "solution": "SELECT membership_type, COUNT(*) AS member_count FROM gym_members GROUP BY membership_type ORDER BY member_count DESC;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "member_count",
            "direction": "desc"
          }
        },
        {
          "id": "d06-c04",
          "title": "Most Booked Classes",
          "description": "Find which classes have the most bookings. Return `class_name`, `instructor`, `day_of_week`, and `booking_count`, ordered by booking count descending.",
          "tier": "core",
          "difficulty": 2,
          "hint": "JOIN gym_classes onto class_bookings, then GROUP BY class_id (and class_name, instructor, day_of_week), COUNT(*) as booking_count.",
          "solution": "SELECT c.class_name, c.instructor, c.day_of_week, COUNT(*) AS booking_count FROM class_bookings b JOIN gym_classes c ON b.class_id = c.class_id GROUP BY c.class_id, c.class_name, c.instructor, c.day_of_week ORDER BY booking_count DESC;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "booking_count",
            "direction": "desc"
          }
        },
        {
          "id": "d06-c05",
          "title": "Constraint in Action - Duplicate Email",
          "description": "Try to insert a new member with the email `'sophie.adeyemi@mail.com'` - which already exists. Observe what happens. The UNIQUE constraint on `email` should reject this. Write the INSERT and note the error.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "Write the INSERT normally. The UNIQUE constraint on email will prevent duplicate values - this is expected to fail with a constraint error.",
          "solution": "INSERT INTO gym_members VALUES (11, 'Test', 'User', 'sophie.adeyemi@mail.com', 'Basic', '2024-03-01', 1);",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 10
          }
        },
        {
          "id": "d06-c06",
          "title": "Premium Member Activity Report",
          "description": "For all Premium members, show their full name, how many classes they have booked, and whether they are active (`is_active`). Include members with zero bookings. Order by booking count descending.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "Filter WHERE membership_type = 'Premium' first. LEFT JOIN class_bookings to keep members with zero bookings. GROUP BY member_id, first_name, last_name, is_active.",
          "solution": "SELECT m.first_name, m.last_name, m.is_active, COUNT(b.booking_id) AS booking_count FROM gym_members m LEFT JOIN class_bookings b ON m.member_id = b.member_id WHERE m.membership_type = 'Premium' GROUP BY m.member_id, m.first_name, m.last_name, m.is_active ORDER BY booking_count DESC;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 3
          }
        }
      ]
    },
    {
      "day": 7,
      "title": "Project: Freight & Logistics",
      "slug": "project-freight-logistics",
      "week": 1,
      "weekLabel": "SQL Fundamentals",
      "type": "project",
      "youtubeId": null,
      "githubPath": "day-07",
      "seedSQL": "\nCREATE TABLE depots (\n  depot_id   INTEGER PRIMARY KEY,\n  depot_name TEXT    NOT NULL,\n  city       TEXT    NOT NULL,\n  region     TEXT    NOT NULL\n);\n\nCREATE TABLE drivers (\n  driver_id   INTEGER PRIMARY KEY,\n  first_name  TEXT    NOT NULL,\n  last_name   TEXT    NOT NULL,\n  licence_type TEXT   NOT NULL CHECK (licence_type IN ('Class C', 'Class B', 'Class A')),\n  depot_id    INTEGER NOT NULL REFERENCES depots(depot_id)\n);\n\nCREATE TABLE vehicles (\n  vehicle_id   INTEGER PRIMARY KEY,\n  registration TEXT    NOT NULL UNIQUE,\n  vehicle_type TEXT    NOT NULL,\n  capacity_kg  REAL    NOT NULL,\n  depot_id     INTEGER NOT NULL REFERENCES depots(depot_id)\n);\n\nCREATE TABLE shipments (\n  shipment_id      INTEGER PRIMARY KEY,\n  tracking_code    TEXT    NOT NULL UNIQUE,\n  origin_depot_id  INTEGER NOT NULL REFERENCES depots(depot_id),\n  dest_city        TEXT    NOT NULL,\n  driver_id        INTEGER NOT NULL REFERENCES drivers(driver_id),\n  vehicle_id       INTEGER NOT NULL REFERENCES vehicles(vehicle_id),\n  weight_kg        REAL    NOT NULL,\n  status           TEXT    NOT NULL CHECK (status IN ('Pending', 'In Transit', 'Delivered', 'Failed')),\n  shipped_date     TEXT,\n  delivered_date   TEXT\n);\n\nINSERT INTO depots VALUES\n  (1, 'Northern Hub',   'Manchester', 'North'),\n  (2, 'Southern Hub',   'London',     'South'),\n  (3, 'Midlands Depot', 'Birmingham', 'Midlands'),\n  (4, 'Eastern Depot',  'Norwich',    'East'),\n  (5, 'Western Depot',  'Bristol',    'West');\n\nINSERT INTO drivers VALUES\n  (1,  'Sam',      'Okafor',     'Class A', 1),\n  (2,  'Janet',    'Thornton',   'Class B', 1),\n  (3,  'Kwesi',    'Mensah',     'Class A', 2),\n  (4,  'Maria',    'Lindqvist',  'Class C', 2),\n  (5,  'Brendan',  'Walsh',      'Class B', 3),\n  (6,  'Yuki',     'Tanaka',     'Class A', 3),\n  (7,  'Fatou',    'Diatta',     'Class B', 4),\n  (8,  'Oliver',   'Pearce',     'Class C', 4),\n  (9,  'Chloe',    'Nkemelu',    'Class A', 5),\n  (10, 'Remi',     'Fontaine',   'Class B', 5);\n\nINSERT INTO vehicles VALUES\n  (1,  'MAN-001-A', 'HGV',     18000.0, 1),\n  (2,  'MAN-002-B', 'Van',      3500.0, 1),\n  (3,  'LON-001-A', 'HGV',     20000.0, 2),\n  (4,  'LON-002-C', 'Courier',  1200.0, 2),\n  (5,  'BHM-001-B', 'Van',      4000.0, 3),\n  (6,  'BHM-002-A', 'HGV',     16000.0, 3),\n  (7,  'NOR-001-B', 'Van',      3200.0, 4),\n  (8,  'BRS-001-A', 'HGV',     19000.0, 5);\n\nINSERT INTO shipments VALUES\n  (1,  'TRK-0001', 1, 'Leeds',       1, 1, 12400.0, 'Delivered',  '2024-01-03', '2024-01-04'),\n  (2,  'TRK-0002', 1, 'Sheffield',   2, 2,  1800.0, 'Delivered',  '2024-01-03', '2024-01-04'),\n  (3,  'TRK-0003', 2, 'Brighton',    3, 3, 15000.0, 'Delivered',  '2024-01-04', '2024-01-05'),\n  (4,  'TRK-0004', 2, 'Cambridge',   4, 4,   800.0, 'Delivered',  '2024-01-04', '2024-01-05'),\n  (5,  'TRK-0005', 3, 'Coventry',    5, 5,  3200.0, 'Delivered',  '2024-01-05', '2024-01-06'),\n  (6,  'TRK-0006', 3, 'Leicester',   6, 6, 14500.0, 'Delivered',  '2024-01-05', '2024-01-06'),\n  (7,  'TRK-0007', 4, 'Ipswich',     7, 7,  2100.0, 'Delivered',  '2024-01-06', '2024-01-07'),\n  (8,  'TRK-0008', 5, 'Bath',        9, 8, 17000.0, 'Delivered',  '2024-01-06', '2024-01-07'),\n  (9,  'TRK-0009', 1, 'York',        1, 1, 11200.0, 'Delivered',  '2024-01-08', '2024-01-09'),\n  (10, 'TRK-0010', 2, 'Southampton', 3, 3, 16800.0, 'Failed',     '2024-01-08', NULL),\n  (11, 'TRK-0011', 3, 'Wolverhampton',5,5,  2900.0, 'In Transit', '2024-01-09', NULL),\n  (12, 'TRK-0012', 4, 'Peterborough',7,7,  3100.0, 'In Transit', '2024-01-09', NULL),\n  (13, 'TRK-0013', 5, 'Exeter',      9, 8, 18500.0, 'In Transit', '2024-01-10', NULL),\n  (14, 'TRK-0014', 1, 'Salford',     2, 2,  2200.0, 'Pending',    NULL,         NULL),\n  (15, 'TRK-0015', 2, 'Guildford',   4, 4,   950.0, 'Pending',    NULL,         NULL),\n  (16, 'TRK-0016', 3, 'Nottingham',  6, 6, 13200.0, 'Delivered',  '2024-01-07', '2024-01-08'),\n  (17, 'TRK-0017', 4, 'Cambridge',   8, 7,  1600.0, 'Delivered',  '2024-01-07', '2024-01-09'),\n  (18, 'TRK-0018', 5, 'Cardiff',    10, 8, 16000.0, 'Failed',     '2024-01-07', NULL),\n  (19, 'TRK-0019', 1, 'Liverpool',   1, 1, 10500.0, 'Delivered',  '2024-01-10', '2024-01-11'),\n  (20, 'TRK-0020', 2, 'Oxford',      3, 3, 14200.0, 'Delivered',  '2024-01-10', '2024-01-11'),\n  (21, 'TRK-0021', 3, 'Derby',       5, 5,  3800.0, 'In Transit', '2024-01-11', NULL),\n  (22, 'TRK-0022', 4, 'Norwich',     7, 7,  2700.0, 'Delivered',  '2024-01-11', '2024-01-12'),\n  (23, 'TRK-0023', 5, 'Swindon',     9, 8, 15500.0, 'Delivered',  '2024-01-11', '2024-01-12'),\n  (24, 'TRK-0024', 1, 'Chester',     2, 2,  1400.0, 'Pending',    NULL,         NULL),\n  (25, 'TRK-0025', 2, 'Reading',     4, 4,   700.0, 'Delivered',  '2024-01-12', '2024-01-13'),\n  (26, 'TRK-0026', 3, 'Telford',     6, 6, 12800.0, 'Delivered',  '2024-01-12', '2024-01-13'),\n  (27, 'TRK-0027', 4, 'Bury St Eds', 7, 7,  2400.0, 'Pending',    NULL,         NULL),\n  (28, 'TRK-0028', 5, 'Plymouth',    9, 8, 17800.0, 'In Transit', '2024-01-13', NULL),\n  (29, 'TRK-0029', 1, 'Rochdale',    1, 1, 11800.0, 'Delivered',  '2024-01-13', '2024-01-14'),\n  (30, 'TRK-0030', 2, 'Croydon',     3, 3, 13600.0, 'In Transit', '2024-01-14', NULL);\n",
      "tables": [
        {
          "name": "depots",
          "columns": [
            {
              "name": "depot_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "depot_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "city",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "region",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 5
        },
        {
          "name": "drivers",
          "columns": [
            {
              "name": "driver_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "first_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "last_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "licence_type",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "depot_id",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 10
        },
        {
          "name": "vehicles",
          "columns": [
            {
              "name": "vehicle_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "registration",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "vehicle_type",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "capacity_kg",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "depot_id",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 8
        },
        {
          "name": "shipments",
          "columns": [
            {
              "name": "shipment_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "tracking_code",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "origin_depot_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "dest_city",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "driver_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "vehicle_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "weight_kg",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "status",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "shipped_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "delivered_date",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 30
        }
      ],
      "quickInsert": [
        "SELECT * FROM shipments",
        "JOIN drivers ON",
        "JOIN depots ON",
        "WHERE status =",
        "GROUP BY driver_id",
        "UPDATE shipments SET status ="
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d07-c01",
          "title": "Explore the Shipments",
          "description": "Phase 1: Get to know your data. Select all columns from the `shipments` table and count how many shipments exist in total. Run both queries.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "Run SELECT * FROM shipments to see all data. Then SELECT COUNT(*) AS total_shipments FROM shipments for the count.",
          "solution": "SELECT * FROM shipments;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 30
          }
        },
        {
          "id": "d07-c02",
          "title": "Shipments with Driver Names",
          "description": "Phase 2: Join the data. Return each shipment's `tracking_code`, `dest_city`, `status`, and the driver's `first_name` and `last_name`. Join `shipments` to `drivers`.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "JOIN shipments to drivers ON shipments.driver_id = drivers.driver_id. Use table aliases (s, d) to keep it readable.",
          "solution": "SELECT s.tracking_code, s.dest_city, s.status, d.first_name, d.last_name FROM shipments s JOIN drivers d ON s.driver_id = d.driver_id ORDER BY s.shipment_id;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 30
          }
        },
        {
          "id": "d07-c03",
          "title": "Status Breakdown",
          "description": "Phase 2: How many shipments are in each `status`? Return `status` and `shipment_count`, ordered from most to least. This gives a quick health check on the fleet.",
          "tier": "core",
          "difficulty": 2,
          "hint": "GROUP BY status on the shipments table. COUNT(*) gives the count per group.",
          "solution": "SELECT status, COUNT(*) AS shipment_count FROM shipments GROUP BY status ORDER BY shipment_count DESC;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "shipment_count",
            "direction": "desc"
          }
        },
        {
          "id": "d07-c04",
          "title": "Driver Performance Summary",
          "description": "Phase 2: For each driver, calculate the total number of shipments, total weight handled (`total_kg`), and how many were delivered successfully. Return driver full name, `total_shipments`, `total_kg`, and `delivered_count`. Order by total shipments descending.",
          "tier": "core",
          "difficulty": 2,
          "hint": "JOIN drivers to shipments. Use COUNT(*) for total, SUM(weight_kg) for total_kg, and SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) for delivered_count.",
          "solution": "SELECT d.first_name, d.last_name, COUNT(*) AS total_shipments, ROUND(SUM(s.weight_kg)::numeric, 1) AS total_kg, SUM(CASE WHEN s.status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_count FROM shipments s JOIN drivers d ON s.driver_id = d.driver_id GROUP BY d.driver_id, d.first_name, d.last_name ORDER BY total_shipments DESC;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "total_shipments",
            "direction": "desc"
          }
        },
        {
          "id": "d07-c05",
          "title": "Depot Throughput",
          "description": "Phase 3: Analyse which depots are busiest. For each depot, show `depot_name`, `city`, `region`, total shipments dispatched, and average shipment weight. Join `depots` to `shipments` on `origin_depot_id`. Order by total shipments descending.",
          "tier": "core",
          "difficulty": 2,
          "hint": "JOIN depots to shipments ON depots.depot_id = shipments.origin_depot_id. GROUP BY depot_id, depot_name, city, region.",
          "solution": "SELECT dep.depot_name, dep.city, dep.region, COUNT(*) AS total_dispatched, ROUND(AVG(s.weight_kg)::numeric, 1) AS avg_weight_kg FROM shipments s JOIN depots dep ON s.origin_depot_id = dep.depot_id GROUP BY dep.depot_id, dep.depot_name, dep.city, dep.region ORDER BY total_dispatched DESC;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "total_dispatched",
            "direction": "desc"
          }
        },
        {
          "id": "d07-c06",
          "title": "Fix Failed Shipments",
          "description": "Phase 4: Clean the data. Two shipments failed (TRK-0010 and TRK-0018). The operations team has re-routed them and they are now 'In Transit'. Update the `status` for both tracking codes to `'In Transit'`. Then verify with a SELECT.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "UPDATE shipments SET status = 'In Transit' WHERE tracking_code IN ('TRK-0010', 'TRK-0018'). IN lets you match multiple values in one WHERE clause.",
          "solution": "UPDATE shipments SET status = 'In Transit' WHERE tracking_code IN ('TRK-0010', 'TRK-0018');\nSELECT tracking_code, status FROM shipments WHERE tracking_code IN ('TRK-0010', 'TRK-0018');",
          "resetBefore": true,
          "validation": {
            "type": "row_count",
            "expected": 2
          }
        },
        {
          "id": "d07-c07",
          "title": "Full Delivery Report",
          "description": "Phase 5: Build the summary report. Return all Delivered shipments showing: `tracking_code`, driver full name, origin `depot_name`, `dest_city`, `weight_kg`, `shipped_date`, and `delivered_date`. Join all four tables. Order by `shipped_date`.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "Start from shipments, JOIN drivers, JOIN depots (on origin_depot_id), filter WHERE status = 'Delivered'. You need three JOINs total.",
          "solution": "SELECT s.tracking_code, d.first_name || ' ' || d.last_name AS driver_name, dep.depot_name AS origin_depot, s.dest_city, s.weight_kg, s.shipped_date, s.delivered_date FROM shipments s JOIN drivers d ON s.driver_id = d.driver_id JOIN depots dep ON s.origin_depot_id = dep.depot_id WHERE s.status = 'Delivered' ORDER BY s.shipped_date;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 18
          }
        },
        {
          "id": "d07-c08",
          "title": "Overweight Vehicle Check",
          "description": "Phase 5: Find shipments where the `weight_kg` exceeds the assigned vehicle's `capacity_kg`. This is a data integrity check - these shipments should never have been dispatched. Return `tracking_code`, `vehicle_type`, `capacity_kg`, and `weight_kg`.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "JOIN shipments to vehicles ON vehicle_id. Then WHERE s.weight_kg > v.capacity_kg. This is a self-filtering JOIN condition.",
          "solution": "SELECT s.tracking_code, v.vehicle_type, v.capacity_kg, s.weight_kg FROM shipments s JOIN vehicles v ON s.vehicle_id = v.vehicle_id WHERE s.weight_kg > v.capacity_kg ORDER BY s.weight_kg DESC;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 0
          }
        }
      ]
    },
    {
      "day": 8,
      "title": "NULL Handling",
      "slug": "null-handling",
      "week": 2,
      "weekLabel": "Data Quality & Transformation",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-08",
      "seedSQL": "\nCREATE TABLE IF NOT EXISTS library_books (\n  book_id      INTEGER PRIMARY KEY,\n  title        TEXT    NOT NULL,\n  author       TEXT    NOT NULL,\n  genre        TEXT    NOT NULL,\n  checked_out_by TEXT,\n  due_date     TEXT,\n  return_date  TEXT,\n  condition_notes TEXT\n);\n\nDELETE FROM library_books;\n\nINSERT INTO library_books VALUES\n  (1,  'The Midnight Library',      'Matt Haig',         'Fiction',     'Alice Turner',  '2026-04-20', NULL,         NULL),\n  (2,  'Atomic Habits',             'James Clear',       'Self-Help',   'Ben Okafor',    '2026-04-18', NULL,         'Slight cover wear'),\n  (3,  'Sapiens',                   'Yuval Noah Harari', 'History',     NULL,            NULL,         NULL,         NULL),\n  (4,  'The Alchemist',             'Paulo Coelho',      'Fiction',     'Chloe Patel',   '2026-04-22', NULL,         NULL),\n  (5,  'Thinking Fast and Slow',    'Daniel Kahneman',   'Psychology',  NULL,            NULL,         NULL,         'Spine cracked'),\n  (6,  'Dune',                      'Frank Herbert',     'Sci-Fi',      'David Kim',     '2026-04-15', NULL,         NULL),\n  (7,  'The Great Gatsby',          'F. Scott Fitzgerald','Classic',    NULL,            NULL,         '2026-04-10', NULL),\n  (8,  'Educated',                  'Tara Westover',     'Memoir',      'Emma Nwosu',    '2026-04-25', NULL,         'Pages yellowed'),\n  (9,  'Deep Work',                 'Cal Newport',       'Self-Help',   NULL,            NULL,         NULL,         NULL),\n  (10, 'Brave New World',           'Aldous Huxley',     'Classic',     'Frank Santos',  '2026-04-17', NULL,         NULL),\n  (11, 'The Power of Now',          'Eckhart Tolle',     'Self-Help',   NULL,            NULL,         '2026-04-08', 'Annotation marks'),\n  (12, 'Project Hail Mary',         'Andy Weir',         'Sci-Fi',      'Grace Mensah',  '2026-04-21', NULL,         NULL),\n  (13, 'Quiet',                     'Susan Cain',        'Psychology',  NULL,            NULL,         NULL,         NULL),\n  (14, 'The Lean Startup',          'Eric Ries',         'Business',    'Henry Dubois',  '2026-04-19', NULL,         'Bent corner'),\n  (15, 'Man Search for Meaning',    'Viktor Frankl',     'Philosophy',  NULL,            NULL,         '2026-04-05', NULL),\n  (16, 'Factfulness',               'Hans Rosling',      'Non-Fiction', 'Irene Obi',     '2026-04-23', NULL,         NULL),\n  (17, '1984',                      'George Orwell',     'Classic',     NULL,            NULL,         NULL,         'Cover faded'),\n  (18, 'The Body Keeps the Score',  'Bessel van der Kolk','Psychology', 'James Bell',    '2026-04-16', NULL,         NULL),\n  (19, 'Outliers',                  'Malcolm Gladwell',  'Non-Fiction', NULL,            NULL,         NULL,         NULL),\n  (20, 'Zero to One',               'Peter Thiel',       'Business',    'Karen Asante',  '2026-04-24', NULL,         NULL);\n",
      "tables": [
        {
          "name": "library_books",
          "columns": [
            {
              "name": "book_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "title",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "author",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "genre",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "checked_out_by",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "due_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "return_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "condition_notes",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 20
        }
      ],
      "quickInsert": [
        "IS NULL",
        "IS NOT NULL",
        "COALESCE",
        "NULLIF"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d08-c01",
          "title": "Find Available Books",
          "description": "List all books that are currently NOT checked out. Show the title, author, and genre. A book is available when checked_out_by is NULL.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "Use IS NULL to filter rows where a column has no value.",
          "solution": "SELECT title, author, genre\nFROM library_books\nWHERE checked_out_by IS NULL;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 9
          }
        },
        {
          "id": "d08-c02",
          "title": "Find Checked-Out Books",
          "description": "List all books currently on loan. Show the title, checked_out_by, and due_date. Order by due_date ascending so overdue books appear first.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "Use IS NOT NULL to find rows where checked_out_by has a value.",
          "solution": "SELECT title, checked_out_by, due_date\nFROM library_books\nWHERE checked_out_by IS NOT NULL\nORDER BY due_date ASC;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 11
          }
        },
        {
          "id": "d08-c03",
          "title": "COALESCE Availability Status",
          "description": "For every book, show the title and a column called status. If checked_out_by is NULL, show 'Available'. Otherwise show the borrower name. Use COALESCE.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "COALESCE(column, fallback_value) returns the first non-NULL argument.",
          "solution": "SELECT\n  title,\n  COALESCE(checked_out_by, 'Available') AS status\nFROM library_books;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "title",
              "status"
            ],
            "expectedRowCount": 20
          }
        },
        {
          "id": "d08-c04",
          "title": "NULLIF to Blank Out Placeholders",
          "description": "Some condition_notes may eventually contain the placeholder text 'None'. Use NULLIF to convert any 'None' value in condition_notes to NULL. Show title and the cleaned condition_notes as cleaned_notes.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "NULLIF(column, value) returns NULL when the column equals value, otherwise returns the column.",
          "solution": "SELECT\n  title,\n  NULLIF(condition_notes, 'None') AS cleaned_notes\nFROM library_books;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "title",
              "cleaned_notes"
            ],
            "expectedRowCount": 20
          }
        },
        {
          "id": "d08-c05",
          "title": "COUNT and NULLs",
          "description": "Write a query that shows three counts: total_books (all rows), books_with_notes (rows where condition_notes is not null), and books_without_notes (rows where condition_notes is null). Use COUNT(*) and COUNT(column) in the same query.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "COUNT(*) counts every row. COUNT(column) skips NULLs automatically.",
          "solution": "SELECT\n  COUNT(*)              AS total_books,\n  COUNT(condition_notes) AS books_with_notes,\n  COUNT(*) - COUNT(condition_notes) AS books_without_notes\nFROM library_books;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "total_books",
              "books_with_notes",
              "books_without_notes"
            ],
            "expectedRowCount": 1
          }
        },
        {
          "id": "d08-c06",
          "title": "Full Availability Report",
          "description": "Produce a report showing: title, author, a status column (COALESCE checked_out_by to 'Available'), a due column (COALESCE due_date to 'N/A'), and a notes column (COALESCE condition_notes to 'Good condition'). Order by status so available books appear first.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "Chain multiple COALESCE calls in the same SELECT. Use ORDER BY on the computed status alias.",
          "solution": "SELECT\n  title,\n  author,\n  COALESCE(checked_out_by, 'Available')     AS status,\n  COALESCE(due_date,        'N/A')          AS due,\n  COALESCE(condition_notes, 'Good condition') AS notes\nFROM library_books\nORDER BY status;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "title",
              "author",
              "status",
              "due",
              "notes"
            ],
            "expectedRowCount": 20
          }
        }
      ]
    },
    {
      "day": 9,
      "title": "String & Numeric Functions",
      "slug": "string-numeric-functions",
      "week": 2,
      "weekLabel": "Data Quality & Transformation",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-09",
      "seedSQL": "\nCREATE TABLE IF NOT EXISTS raw_contacts (\n  contact_id  INTEGER PRIMARY KEY,\n  full_name   TEXT,\n  email       TEXT,\n  phone       TEXT,\n  city        TEXT,\n  signup_date TEXT\n);\n\nDELETE FROM raw_contacts;\n\nINSERT INTO raw_contacts VALUES\n  (1,  '  john SMITH  ',       'john.smith@email.com',      '07700 900001', '  london  ',    '2025-01-15'),\n  (2,  'PRIYA sharma',         'PRIYA.S@EMAIL.COM',         '07700 900002', 'MANCHESTER',    '2025-02-03'),\n  (3,  '  alice   WALKER',     'alice.walker@email.com',    '07700 900003', 'birmingham',    '2025-01-28'),\n  (4,  'KWEKU Mensah',         'kweku.m@email.com',         '07700 900004', '  LEEDS  ',     '2025-03-10'),\n  (5,  'sarah JONES  ',        'sarah.jones@EMAIL.com',     '07700 900005', 'bristol',       '2025-02-19'),\n  (6,  '  CARLOS rivera  ',    'carlos.r@email.com',        '07700 900006', '  Cardiff  ',   '2025-01-07'),\n  (7,  'natalie GREEN',        'natalie.g@email.com',       '07700 900007', 'Edinburgh',     '2025-03-22'),\n  (8,  'IBRAHIM al-Hassan',    'ibrahim.h@email.com',       '07700 900008', 'GLASGOW',       '2025-04-01'),\n  (9,  '  emily CLARK  ',      'emily.clark@EMAIL.com',     '07700 900009', 'liverpool',     '2025-02-14'),\n  (10, 'JAMES  Okafor',        'james.o@email.com',         '07700 900010', '  sheffield  ', '2025-01-30'),\n  (11, 'mei LIN',              'mei.lin@email.com',         '07700 900011', 'Newcastle',     '2025-03-05'),\n  (12, '  DAVID Thompson  ',   'david.t@email.com',         '07700 900012', 'NOTTINGHAM',    '2025-02-27'),\n  (13, 'fatima NOUR',          'fatima.n@EMAIL.com',        '07700 900013', 'Leicester',     '2025-04-08'),\n  (14, 'PETER Williams',       'peter.w@email.com',         '07700 900014', '  norwich  ',   '2025-01-20'),\n  (15, '  rachel OSEI  ',      'rachel.osei@email.com',     '07700 900015', 'coventry',      '2025-03-18');\n",
      "tables": [
        {
          "name": "raw_contacts",
          "columns": [
            {
              "name": "contact_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "full_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "email",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "phone",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "city",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "signup_date",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 15
        }
      ],
      "quickInsert": [
        "UPPER",
        "LOWER",
        "TRIM",
        "SUBSTR",
        "LENGTH",
        "REPLACE",
        "ROUND"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d09-c01",
          "title": "Standardise Email Case",
          "description": "All emails should be stored in lowercase. Write a query showing contact_id and a column called clean_email with every email in lowercase.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "LOWER(column) converts text to all lowercase.",
          "solution": "SELECT contact_id, LOWER(email) AS clean_email\nFROM raw_contacts;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "contact_id",
              "clean_email"
            ],
            "expectedRowCount": 15
          }
        },
        {
          "id": "d09-c02",
          "title": "Proper City Names",
          "description": "Cities are a mess - some all caps, some lowercase, some with extra spaces. Show contact_id and a column called clean_city: first TRIM the whitespace, then apply UPPER to standardise to uppercase.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "Wrap one function inside another: UPPER(TRIM(column)).",
          "solution": "SELECT contact_id, UPPER(TRIM(city)) AS clean_city\nFROM raw_contacts;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "contact_id",
              "clean_city"
            ],
            "expectedRowCount": 15
          }
        },
        {
          "id": "d09-c03",
          "title": "Extract Email Domain",
          "description": "Extract just the domain portion from the email address (everything after the '@'). Show contact_id and a column called domain. Use SUBSTR and INSTR (or LENGTH) to find the '@' position.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "INSTR(email, '@') returns the character position of '@'. SUBSTR(email, start) extracts from that position onwards.",
          "solution": "SELECT\n  contact_id,\n  SUBSTR(email, STRPOS(LOWER(email), '@') + 1) AS domain\nFROM raw_contacts;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "contact_id",
              "domain"
            ],
            "expectedRowCount": 15
          }
        },
        {
          "id": "d09-c04",
          "title": "Filter Long Names",
          "description": "Find all contacts whose full_name (after trimming whitespace) is longer than 12 characters. Show contact_id, full_name, and a column called name_length with the trimmed length.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "LENGTH(TRIM(column)) gives you the character count without leading/trailing spaces.",
          "solution": "SELECT\n  contact_id,\n  full_name,\n  LENGTH(TRIM(full_name)) AS name_length\nFROM raw_contacts\nWHERE LENGTH(TRIM(full_name)) > 12;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "contact_id",
              "full_name",
              "name_length"
            ],
            "expectedRowCount": 7
          }
        },
        {
          "id": "d09-c05",
          "title": "Anonymise Phone Numbers",
          "description": "Replace the last 4 digits of every phone number with 'XXXX' to anonymise the data. Show contact_id and a column called masked_phone. Use REPLACE or SUBSTR.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "SUBSTR(phone, 1, LENGTH(phone) - 4) gives everything except the last 4 characters. Concatenate '||' to add 'XXXX' at the end.",
          "solution": "SELECT\n  contact_id,\n  SUBSTR(phone, 1, LENGTH(phone) - 4) || 'XXXX' AS masked_phone\nFROM raw_contacts;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "contact_id",
              "masked_phone"
            ],
            "expectedRowCount": 15
          }
        },
        {
          "id": "d09-c06",
          "title": "Signup Year Extraction",
          "description": "Extract the 4-digit year from signup_date for each contact. Show contact_id and signup_year. Use SUBSTR since signup_date is formatted as YYYY-MM-DD.",
          "tier": "stretch",
          "difficulty": "medium",
          "hint": "signup_date starts with the year in the first 4 characters. SUBSTR(column, 1, 4) extracts them.",
          "solution": "SELECT contact_id, SUBSTR(signup_date, 1, 4) AS signup_year\nFROM raw_contacts;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "contact_id",
              "signup_year"
            ],
            "expectedRowCount": 15
          }
        },
        {
          "id": "d09-c07",
          "title": "Full Clean Record",
          "description": "Combine everything into a single cleaned contacts query. Show: contact_id, clean_name (TRIM + LOWER of full_name), clean_email (LOWER), clean_city (TRIM + UPPER), masked_phone (last 4 digits replaced with XXXX), and signup_year (first 4 chars of signup_date). This is what a real data cleaning pipeline looks like.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "Chain TRIM and LOWER/UPPER together. Use SUBSTR and || for the phone masking. All in one SELECT.",
          "solution": "SELECT\n  contact_id,\n  LOWER(TRIM(full_name))                            AS clean_name,\n  LOWER(email)                                      AS clean_email,\n  UPPER(TRIM(city))                                 AS clean_city,\n  SUBSTR(phone, 1, LENGTH(phone) - 4) || 'XXXX'    AS masked_phone,\n  SUBSTR(signup_date, 1, 4)                         AS signup_year\nFROM raw_contacts;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "contact_id",
              "clean_name",
              "clean_email",
              "clean_city",
              "masked_phone",
              "signup_year"
            ],
            "expectedRowCount": 15
          }
        }
      ]
    },
    {
      "day": 10,
      "title": "Date Functions & CAST",
      "slug": "date-functions-cast",
      "week": 2,
      "weekLabel": "Data Quality & Transformation",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-10",
      "seedSQL": "\nCREATE TABLE IF NOT EXISTS events (\n  event_id      INTEGER PRIMARY KEY,\n  event_name    TEXT    NOT NULL,\n  venue         TEXT    NOT NULL,\n  start_date    TEXT    NOT NULL,\n  end_date      TEXT    NOT NULL,\n  ticket_price  REAL    NOT NULL,\n  capacity      INTEGER NOT NULL,\n  tickets_sold  INTEGER NOT NULL\n);\n\nDELETE FROM events;\n\nINSERT INTO events VALUES\n  (1,  'Spring Data Summit',        'Excel London',         '2026-03-10', '2026-03-12', 299.00, 500, 487),\n  (2,  'Women in Tech Meetup',      'Manchester Central',   '2026-03-18', '2026-03-18',   0.00, 200, 178),\n  (3,  'Cloud Architecture Forum',  'Tobacco Dock, London', '2026-04-02', '2026-04-03', 149.50, 300, 301),\n  (4,  'AI & ML Showcase',          'Birmingham NEC',       '2026-04-14', '2026-04-16', 450.00, 800, 762),\n  (5,  'Startup Pitch Night',       'The Trampery, London', '2026-04-22', '2026-04-22',  25.00, 100,  88),\n  (6,  'Open Source Conf',          'Leeds Town Hall',      '2026-05-05', '2026-05-07',  75.00, 400, 355),\n  (7,  'Data for Good Symposium',   'Bristol Watershed',    '2026-05-14', '2026-05-14',   0.00, 150, 143),\n  (8,  'Cybersecurity Summit',      'Etc. Venues, London',  '2026-05-20', '2026-05-21', 350.00, 600, 598),\n  (9,  'Product Management Day',    'Edinburgh Int. Conf.', '2026-06-03', '2026-06-03', 120.00, 250, 241),\n  (10, 'DevOps Days UK',            'Cardiff City Hall',    '2026-06-10', '2026-06-12', 199.00, 450, 312),\n  (11, 'Analytics Leaders Forum',   'Canary Wharf Hub',     '2026-06-24', '2026-06-25', 500.00, 200, 196),\n  (12, 'Junior Dev Bootcamp',       'Glasgow Science Ctr',  '2026-07-08', '2026-07-10',  50.00, 120, 118),\n  (13, 'FinTech Innovation Week',   'Level39, London',      '2026-07-15', '2026-07-17', 275.00, 350, 299),\n  (14, 'Platform Engineering Conf', 'Liverpool ACC',        '2026-08-04', '2026-08-06', 225.00, 700, 483),\n  (15, 'Diversity in Data Summit',  'Nottingham Conf. Ctr', '2026-08-19', '2026-08-20',   0.00, 300, 267);\n",
      "tables": [
        {
          "name": "events",
          "columns": [
            {
              "name": "event_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "event_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "venue",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "start_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "end_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "ticket_price",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "capacity",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "tickets_sold",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 15
        }
      ],
      "quickInsert": [
        "date()",
        "EXTRACT()",
        "AGE()",
        "CAST"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d10-c01",
          "title": "Extract Event Month",
          "description": "Show event_name, start_date, and a column called event_month containing the month number (e.g. '04' for April). Use EXTRACT().",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "EXTRACT(MONTH FROM date_column::date) extracts the two-digit month number.",
          "solution": "SELECT\n  event_name,\n  start_date,\n  LPAD(EXTRACT(MONTH FROM start_date::date)::text, 2, '0') AS event_month\nFROM events;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "event_name",
              "start_date",
              "event_month"
            ],
            "expectedRowCount": 15
          }
        },
        {
          "id": "d10-c02",
          "title": "Calculate Event Duration",
          "description": "For each event, calculate how many days it runs. Show event_name, start_date, end_date, and duration_days. A single-day event has duration 1.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "(end_date::date - start_date::date) + 1 gives the inclusive day count.",
          "solution": "SELECT\n  event_name,\n  start_date,\n  end_date,\n  (end_date::date - start_date::date + 1) AS duration_days\nFROM events;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "event_name",
              "start_date",
              "end_date",
              "duration_days"
            ],
            "expectedRowCount": 15
          }
        },
        {
          "id": "d10-c03",
          "title": "Upcoming Events",
          "description": "Find all events that start after 2026-05-01. Show event_name, venue, and start_date. Order by start_date ascending.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "Compare start_date directly to a date string - Date strings in YYYY-MM-DD format sort correctly as text.",
          "solution": "SELECT event_name, venue, start_date\nFROM events\nWHERE start_date > '2026-05-01'\nORDER BY start_date ASC;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 10
          }
        },
        {
          "id": "d10-c04",
          "title": "CAST Ticket Revenue",
          "description": "Calculate estimated revenue for each event (ticket_price * tickets_sold). Show event_name, ticket_price, tickets_sold, and revenue rounded to 2 decimal places as a REAL. Use CAST to ensure ticket_price is treated as REAL.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "CAST(column AS REAL) forces numeric type. ROUND(value::numeric, 2) rounds to 2 decimal places.",
          "solution": "SELECT\n  event_name,\n  ticket_price,\n  tickets_sold,\n  ROUND((CAST(ticket_price AS REAL) * tickets_sold)::numeric, 2) AS revenue\nFROM events;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "event_name",
              "ticket_price",
              "tickets_sold",
              "revenue"
            ],
            "expectedRowCount": 15
          }
        },
        {
          "id": "d10-c05",
          "title": "Occupancy Percentage",
          "description": "Calculate the occupancy rate for each event as a percentage: (tickets_sold / capacity) * 100 rounded to 1 decimal place. Show event_name, capacity, tickets_sold, and occupancy_pct. Order by occupancy_pct descending.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "Use CAST to avoid integer division: CAST(tickets_sold AS REAL) / capacity * 100.",
          "solution": "SELECT\n  event_name,\n  capacity,\n  tickets_sold,\n  ROUND((CAST(tickets_sold AS REAL) / capacity * 100)::numeric, 1) AS occupancy_pct\nFROM events\nORDER BY occupancy_pct DESC;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "event_name",
              "capacity",
              "tickets_sold",
              "occupancy_pct"
            ],
            "expectedRowCount": 15
          }
        },
        {
          "id": "d10-c06",
          "title": "Format Dates for Display",
          "description": "Reformat start_date for a user-facing display. Show event_name and a column called display_date formatted as 'DD Mon YYYY' (e.g. '10 Mar 2026'). Use EXTRACT() to extract parts and concatenate them.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "EXTRACT(DAY FROM date::date) gives day, EXTRACT(MONTH FROM date::date) gives month number. You can CASE WHEN the month number to get the abbreviation, or use TO_CHAR for date formatting.",
          "solution": "SELECT\n  event_name,\n  LPAD(EXTRACT(DAY FROM start_date::date)::text, 2, '0') || ' ' ||\n  CASE LPAD(EXTRACT(MONTH FROM start_date::date)::text, 2, '0')\n    WHEN '01' THEN 'Jan' WHEN '02' THEN 'Feb' WHEN '03' THEN 'Mar'\n    WHEN '04' THEN 'Apr' WHEN '05' THEN 'May' WHEN '06' THEN 'Jun'\n    WHEN '07' THEN 'Jul' WHEN '08' THEN 'Aug' WHEN '09' THEN 'Sep'\n    WHEN '10' THEN 'Oct' WHEN '11' THEN 'Nov' WHEN '12' THEN 'Dec'\n  END || ' ' ||\n  EXTRACT(YEAR FROM start_date::date)::text AS display_date\nFROM events;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "event_name",
              "display_date"
            ],
            "expectedRowCount": 15
          }
        }
      ]
    },
    {
      "day": 11,
      "title": "CASE WHEN",
      "slug": "case-when",
      "week": 2,
      "weekLabel": "Data Quality & Transformation",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-11",
      "seedSQL": "\nCREATE TABLE IF NOT EXISTS student_scores (\n  score_id     INTEGER PRIMARY KEY,\n  student_name TEXT    NOT NULL,\n  subject      TEXT    NOT NULL,\n  score        INTEGER NOT NULL,\n  exam_date    TEXT    NOT NULL,\n  semester     TEXT    NOT NULL\n);\n\nDELETE FROM student_scores;\n\nINSERT INTO student_scores VALUES\n  (1,  'Alice Fraser',    'Maths',   88, '2025-11-10', 'Autumn'),\n  (2,  'Alice Fraser',    'English', 74, '2025-11-12', 'Autumn'),\n  (3,  'Alice Fraser',    'Science', 91, '2025-11-14', 'Autumn'),\n  (4,  'Alice Fraser',    'History', 65, '2025-11-16', 'Autumn'),\n  (5,  'Ben Osei',        'Maths',   55, '2025-11-10', 'Autumn'),\n  (6,  'Ben Osei',        'English', 48, '2025-11-12', 'Autumn'),\n  (7,  'Ben Osei',        'Science', 62, '2025-11-14', 'Autumn'),\n  (8,  'Ben Osei',        'History', 71, '2025-11-16', 'Autumn'),\n  (9,  'Chloe Patel',     'Maths',   95, '2025-11-10', 'Autumn'),\n  (10, 'Chloe Patel',     'English', 89, '2025-11-12', 'Autumn'),\n  (11, 'Chloe Patel',     'Science', 97, '2025-11-14', 'Autumn'),\n  (12, 'Chloe Patel',     'History', 83, '2025-11-16', 'Autumn'),\n  (13, 'Daniel Kimura',   'Maths',   72, '2025-11-10', 'Autumn'),\n  (14, 'Daniel Kimura',   'English', 68, '2025-11-12', 'Autumn'),\n  (15, 'Daniel Kimura',   'Science', 79, '2025-11-14', 'Autumn'),\n  (16, 'Daniel Kimura',   'History', 84, '2025-11-16', 'Autumn'),\n  (17, 'Emma Nwosu',      'Maths',   38, '2025-11-10', 'Autumn'),\n  (18, 'Emma Nwosu',      'English', 51, '2025-11-12', 'Autumn'),\n  (19, 'Emma Nwosu',      'Science', 44, '2025-11-14', 'Autumn'),\n  (20, 'Emma Nwosu',      'History', 57, '2025-11-16', 'Autumn'),\n  (21, 'Femi Adeyemi',    'Maths',   80, '2025-11-10', 'Autumn'),\n  (22, 'Femi Adeyemi',    'English', 77, '2025-11-12', 'Autumn'),\n  (23, 'Femi Adeyemi',    'Science', 85, '2025-11-14', 'Autumn'),\n  (24, 'Femi Adeyemi',    'History', 90, '2025-11-16', 'Autumn');\n",
      "tables": [
        {
          "name": "student_scores",
          "columns": [
            {
              "name": "score_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "student_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "subject",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "score",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "exam_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "semester",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 24
        }
      ],
      "quickInsert": [
        "CASE WHEN",
        "THEN",
        "ELSE",
        "END"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d11-c01",
          "title": "Assign Letter Grades",
          "description": "Add a grade column to each score: A (90+), B (80-89), C (70-79), D (60-69), F (below 60). Show student_name, subject, score, and grade.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "Use a searched CASE WHEN with multiple WHEN conditions. Start from the highest threshold and work down.",
          "solution": "SELECT\n  student_name,\n  subject,\n  score,\n  CASE\n    WHEN score >= 90 THEN 'A'\n    WHEN score >= 80 THEN 'B'\n    WHEN score >= 70 THEN 'C'\n    WHEN score >= 60 THEN 'D'\n    ELSE 'F'\n  END AS grade\nFROM student_scores;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "student_name",
              "subject",
              "score",
              "grade"
            ],
            "expectedRowCount": 24
          }
        },
        {
          "id": "d11-c02",
          "title": "Pass or Fail",
          "description": "Classify each result as 'Pass' (score 60 or above) or 'Fail' (below 60). Show student_name, subject, score, and result. Count how many rows are Pass vs Fail total - actually just show the per-row classification.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "A simple two-branch CASE WHEN ... THEN 'Pass' ELSE 'Fail' END does the job.",
          "solution": "SELECT\n  student_name,\n  subject,\n  score,\n  CASE WHEN score >= 60 THEN 'Pass' ELSE 'Fail' END AS result\nFROM student_scores;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "student_name",
              "subject",
              "score",
              "result"
            ],
            "expectedRowCount": 24
          }
        },
        {
          "id": "d11-c03",
          "title": "Sort by Performance Band",
          "description": "List all scores ordered by performance tier rather than raw score. First show top performers (A grade: 90+), then strong (B: 80-89), then average (C/D: 60-79), then struggling (F: below 60). Use CASE WHEN inside ORDER BY.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "You can use a CASE expression directly in ORDER BY to assign a sort number to each band.",
          "solution": "SELECT student_name, subject, score\nFROM student_scores\nORDER BY\n  CASE\n    WHEN score >= 90 THEN 1\n    WHEN score >= 80 THEN 2\n    WHEN score >= 60 THEN 3\n    ELSE 4\n  END,\n  score DESC;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "student_name",
              "subject",
              "score"
            ],
            "expectedRowCount": 24
          }
        },
        {
          "id": "d11-c04",
          "title": "Subject Pass Rate Pivot",
          "description": "For each subject, show how many students passed (score >= 60) and how many failed (score < 60). Show subject, passes, and failures. Use CASE WHEN inside COUNT or SUM.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "SUM(CASE WHEN condition THEN 1 ELSE 0 END) counts rows matching a condition. GROUP BY subject.",
          "solution": "SELECT\n  subject,\n  SUM(CASE WHEN score >= 60 THEN 1 ELSE 0 END) AS passes,\n  SUM(CASE WHEN score <  60 THEN 1 ELSE 0 END) AS failures\nFROM student_scores\nGROUP BY subject;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "subject",
              "passes",
              "failures"
            ],
            "expectedRowCount": 4
          }
        },
        {
          "id": "d11-c05",
          "title": "Average Score by Grade Band",
          "description": "Group students into performance bands and calculate the average score in each band. Show band ('A Students', 'B Students', 'C Students', 'D Students', 'F Students') and avg_score rounded to 1 decimal.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "Use CASE WHEN to create the band label, then GROUP BY that computed column. Wrap in a subquery or use the expression directly.",
          "solution": "SELECT\n  CASE\n    WHEN score >= 90 THEN 'A Students'\n    WHEN score >= 80 THEN 'B Students'\n    WHEN score >= 70 THEN 'C Students'\n    WHEN score >= 60 THEN 'D Students'\n    ELSE 'F Students'\n  END AS band,\n  ROUND(AVG(score)::numeric, 1) AS avg_score\nFROM student_scores\nGROUP BY band\nORDER BY avg_score DESC;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "band",
              "avg_score"
            ],
            "expectedRowCount": 5
          }
        },
        {
          "id": "d11-c06",
          "title": "Flag At-Risk Students",
          "description": "Find students who have at least one failing score (below 60). For each such student, show their name, how many subjects they failed (failures_count), and a risk_level: 'High Risk' if 3+ failures, 'At Risk' if 1-2 failures.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "Use GROUP BY student_name with HAVING to filter for students with failures. Use a CASE on the count of failures for risk_level.",
          "solution": "SELECT\n  student_name,\n  SUM(CASE WHEN score < 60 THEN 1 ELSE 0 END) AS failures_count,\n  CASE\n    WHEN SUM(CASE WHEN score < 60 THEN 1 ELSE 0 END) >= 3 THEN 'High Risk'\n    ELSE 'At Risk'\n  END AS risk_level\nFROM student_scores\nGROUP BY student_name\nHAVING SUM(CASE WHEN score < 60 THEN 1 ELSE 0 END) > 0\nORDER BY failures_count DESC;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "student_name",
              "failures_count",
              "risk_level"
            ],
            "expectedRowCount": 2
          }
        },
        {
          "id": "d11-c07",
          "title": "Full Student Report Card",
          "description": "Produce a full report card showing: student_name, subject, score, grade (A/B/C/D/F), result (Pass/Fail), and a flag called needs_support (1 if score below 60, 0 otherwise). Order by student_name then score descending.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "Combine multiple CASE WHEN expressions in one SELECT. The needs_support flag is a simple CASE WHEN with integer output.",
          "solution": "SELECT\n  student_name,\n  subject,\n  score,\n  CASE\n    WHEN score >= 90 THEN 'A'\n    WHEN score >= 80 THEN 'B'\n    WHEN score >= 70 THEN 'C'\n    WHEN score >= 60 THEN 'D'\n    ELSE 'F'\n  END AS grade,\n  CASE WHEN score >= 60 THEN 'Pass' ELSE 'Fail' END AS result,\n  CASE WHEN score < 60 THEN 1 ELSE 0 END AS needs_support\nFROM student_scores\nORDER BY student_name, score DESC;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "student_name",
              "subject",
              "score",
              "grade",
              "result",
              "needs_support"
            ],
            "expectedRowCount": 24
          }
        }
      ]
    },
    {
      "day": 12,
      "title": "Subqueries & Temp Tables",
      "slug": "subqueries-temp-tables",
      "week": 2,
      "weekLabel": "Data Quality & Transformation",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-12",
      "seedSQL": "\nCREATE TABLE IF NOT EXISTS products (\n  product_id    INTEGER PRIMARY KEY,\n  product_name  TEXT    NOT NULL,\n  category      TEXT    NOT NULL,\n  unit_price    REAL    NOT NULL,\n  stock_qty     INTEGER NOT NULL,\n  supplier      TEXT    NOT NULL,\n  reorder_level INTEGER NOT NULL\n);\n\nDELETE FROM products;\n\nINSERT INTO products VALUES\n  (1,  'Dish Soap',            'Cleaning',   1.89,  320, 'CleanCo',      100),\n  (2,  'Laundry Powder',       'Cleaning',   4.99,   85, 'CleanCo',       50),\n  (3,  'Kitchen Roll',         'Paper',      2.49,  180, 'PaperPlus',     60),\n  (4,  'Bin Liners (50pk)',    'Cleaning',   3.29,   42, 'CleanCo',       40),\n  (5,  'Toilet Paper (9pk)',   'Paper',      3.99,  215, 'PaperPlus',     80),\n  (6,  'Sponge Scourers (5pk)','Cleaning',  1.29,   95, 'ScrubRight',    50),\n  (7,  'Bathroom Cleaner',     'Cleaning',   2.79,   67, 'CleanCo',       30),\n  (8,  'Floor Mop',            'Hardware',  12.99,   28, 'HomeTools Ltd', 10),\n  (9,  'Plastic Bucket',       'Hardware',   5.49,   55, 'HomeTools Ltd', 20),\n  (10, 'Rubber Gloves',        'Safety',     2.19,  110, 'SafeHands',     40),\n  (11, 'Hand Sanitiser',       'Safety',     1.49,  390, 'SafeHands',    100),\n  (12, 'Air Freshener',        'Home',       2.99,   73, 'FreshScent',    30),\n  (13, 'Candle (vanilla)',     'Home',       6.99,   34, 'FreshScent',    15),\n  (14, 'Clothes Pegs (40pk)',  'Hardware',   1.99,  140, 'HomeTools Ltd', 50),\n  (15, 'Washing Up Liquid',    'Cleaning',   1.59,  255, 'CleanCo',       80),\n  (16, 'Oven Cleaner Spray',   'Cleaning',   3.49,   19, 'ScrubRight',    20),\n  (17, 'Ironing Board Cover',  'Hardware',   8.99,   11, 'HomeTools Ltd',  5),\n  (18, 'Fabric Conditioner',   'Cleaning',   4.49,   63, 'CleanCo',       40),\n  (19, 'Paper Towels (6pk)',   'Paper',      2.19,  198, 'PaperPlus',     70),\n  (20, 'Lint Roller',          'Clothing',   2.99,   88, 'CleanCo',       30);\n",
      "tables": [
        {
          "name": "products",
          "columns": [
            {
              "name": "product_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "product_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "category",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "unit_price",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "stock_qty",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "supplier",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "reorder_level",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 20
        }
      ],
      "quickInsert": [
        "SELECT",
        "WHERE",
        "IN",
        "EXISTS",
        "CREATE TEMP TABLE"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d12-c01",
          "title": "Above-Average Price",
          "description": "Find all products priced above the average unit_price across all products. Show product_name, category, and unit_price. Use a subquery in the WHERE clause.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "The subquery (SELECT AVG(unit_price) FROM products) returns the average. Use it directly in your WHERE.",
          "solution": "SELECT product_name, category, unit_price\nFROM products\nWHERE unit_price > (SELECT AVG(unit_price) FROM products)\nORDER BY unit_price DESC;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 7
          }
        },
        {
          "id": "d12-c02",
          "title": "Scalar Subquery in SELECT",
          "description": "For every product, show product_name, unit_price, and price_vs_avg: the difference between this product's price and the overall average, rounded to 2 decimal places. Use a scalar subquery in the SELECT list.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "A scalar subquery in SELECT returns one value per row. Subtract (SELECT AVG(unit_price) FROM products) from unit_price.",
          "solution": "SELECT\n  product_name,\n  unit_price,\n  ROUND((unit_price - (SELECT AVG(unit_price) FROM products))::numeric, 2) AS price_vs_avg\nFROM products\nORDER BY price_vs_avg DESC;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "product_name",
              "unit_price",
              "price_vs_avg"
            ],
            "expectedRowCount": 20
          }
        },
        {
          "id": "d12-c03",
          "title": "Derived Table - Category Summary",
          "description": "Use a subquery in the FROM clause (a derived table) to first calculate the average price per category, then show only categories with an average price above 3.00. Show category and avg_price rounded to 2 decimal places.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "Write the aggregation as a subquery: (SELECT category, AVG(unit_price) AS avg_price FROM products GROUP BY category) and SELECT from it with a WHERE.",
          "solution": "SELECT category, ROUND(avg_price::numeric, 2) AS avg_price\nFROM (\n  SELECT category, AVG(unit_price) AS avg_price\n  FROM products\n  GROUP BY category\n) AS cat_summary\nWHERE avg_price > 3.00\nORDER BY avg_price DESC;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "category",
              "avg_price"
            ],
            "expectedRowCount": 2
          }
        },
        {
          "id": "d12-c04",
          "title": "CREATE TEMP TABLE for Low Stock",
          "description": "Create a temporary table called low_stock containing all products where stock_qty is below or equal to their reorder_level. Then SELECT all columns from low_stock ordered by stock_qty ascending.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "CREATE TEMP TABLE low_stock AS SELECT ... is the pattern. Then run a separate SELECT from it. In this simulator, run both statements together.",
          "solution": "CREATE TEMP TABLE IF NOT EXISTS low_stock AS\nSELECT *\nFROM products\nWHERE stock_qty <= reorder_level;\n\nSELECT * FROM low_stock ORDER BY stock_qty ASC;",
          "resetBefore": true,
          "validation": {
            "type": "row_count",
            "expected": 1
          }
        },
        {
          "id": "d12-c05",
          "title": "Correlated Subquery",
          "description": "For each product, find whether it is the most expensive item in its own category. Show product_name, category, unit_price, and a column called is_category_max (1 if it is the maximum in the category, 0 otherwise). Use a correlated subquery.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "A correlated subquery references the outer query's row. SELECT MAX(unit_price) FROM products WHERE category = p.category returns the max for that product's category.",
          "solution": "SELECT\n  product_name,\n  category,\n  unit_price,\n  CASE\n    WHEN unit_price = (\n      SELECT MAX(unit_price) FROM products WHERE category = p.category\n    ) THEN 1\n    ELSE 0\n  END AS is_category_max\nFROM products p\nORDER BY category, unit_price DESC;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "product_name",
              "category",
              "unit_price",
              "is_category_max"
            ],
            "expectedRowCount": 20
          }
        },
        {
          "id": "d12-c06",
          "title": "Reorder Report with Subquery",
          "description": "Build a reorder report: find all CleanCo products that need restocking (stock_qty <= reorder_level). Show product_name, stock_qty, reorder_level, and a shortfall column (reorder_level - stock_qty). Use a subquery in WHERE with IN to first get CleanCo product IDs, then filter the outer query.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "Use WHERE product_id IN (SELECT product_id FROM products WHERE supplier = 'CleanCo') AND stock_qty <= reorder_level. Then calculate the shortfall.",
          "solution": "SELECT\n  product_name,\n  stock_qty,\n  reorder_level,\n  reorder_level - stock_qty AS shortfall\nFROM products\nWHERE\n  product_id IN (SELECT product_id FROM products WHERE supplier = 'CleanCo')\n  AND stock_qty <= reorder_level\nORDER BY shortfall DESC;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "product_name",
              "stock_qty",
              "reorder_level",
              "shortfall"
            ],
            "expectedRowCount": 0
          }
        }
      ]
    },
    {
      "day": 13,
      "title": "CTEs (Common Table Expressions)",
      "slug": "ctes-part-1",
      "week": 2,
      "weekLabel": "Data Quality & Transformation",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-13",
      "seedSQL": "\nCREATE TABLE IF NOT EXISTS sales_pipeline (\n  deal_id       INTEGER PRIMARY KEY,\n  company_name  TEXT    NOT NULL,\n  contact_name  TEXT    NOT NULL,\n  stage         TEXT    NOT NULL,\n  deal_value    REAL    NOT NULL,\n  created_date  TEXT    NOT NULL,\n  last_activity TEXT    NOT NULL,\n  sales_rep     TEXT    NOT NULL\n);\n\nDELETE FROM sales_pipeline;\n\nINSERT INTO sales_pipeline VALUES\n  (1,  'Apex Logistics',     'Sandra Hughes',   'Won',         45000.00, '2025-10-01', '2026-01-15', 'Marcus Reid'),\n  (2,  'Bright Futures Ltd', 'Tom Adeyemi',     'Lead',         3200.00, '2026-02-10', '2026-04-01', 'Sarah Collins'),\n  (3,  'Clearpath Finance',  'Yvonne Okwu',     'Proposal',    18500.00, '2025-12-05', '2026-03-28', 'Marcus Reid'),\n  (4,  'DeltaSoft',          'James Beresford', 'Negotiation', 67000.00, '2025-11-20', '2026-04-10', 'Priya Sharma'),\n  (5,  'EduReach Africa',    'Nadia Kamau',     'Won',         12000.00, '2026-01-08', '2026-02-20', 'Sarah Collins'),\n  (6,  'FreshMart UK',       'Colin Briggs',    'Lost',         8500.00, '2025-09-15', '2025-12-01', 'Marcus Reid'),\n  (7,  'GreenGrid Energy',   'Amara Diallo',    'Qualified',   34000.00, '2026-01-22', '2026-04-08', 'Priya Sharma'),\n  (8,  'Horizon Health',     'Laura Steele',    'Won',         28000.00, '2025-10-30', '2026-01-28', 'Sarah Collins'),\n  (9,  'Innovatech',         'Ravi Patel',      'Lead',         5500.00, '2026-03-01', '2026-04-05', 'Marcus Reid'),\n  (10, 'JuiceWorks',         'Bella Thompson',  'Lost',         9200.00, '2025-08-20', '2025-11-10', 'Priya Sharma'),\n  (11, 'KleanTech',          'Omar Hassan',     'Proposal',    22000.00, '2026-02-14', '2026-04-09', 'Sarah Collins'),\n  (12, 'LandMark Real Est.', 'Kate Morrison',   'Negotiation', 95000.00, '2025-11-01', '2026-04-11', 'Marcus Reid'),\n  (13, 'MediCore',           'George Asante',   'Qualified',   41000.00, '2026-01-15', '2026-04-03', 'Priya Sharma'),\n  (14, 'NexGen Retail',      'Fatima Al-Sayed', 'Won',         31500.00, '2025-12-10', '2026-02-05', 'Sarah Collins'),\n  (15, 'OceanFreight Ltd',   'Pete Larsson',    'Lead',         7800.00, '2026-03-20', '2026-04-12', 'Marcus Reid'),\n  (16, 'PinPoint Analytics', 'Zoe Chen',        'Proposal',    29000.00, '2026-02-28', '2026-04-07', 'Priya Sharma'),\n  (17, 'QuantumLeap',        'Ian Dubois',      'Negotiation', 55000.00, '2025-12-01', '2026-04-13', 'Sarah Collins'),\n  (18, 'RapidRoute',         'Ada Osei',        'Lost',        14500.00, '2025-07-10', '2025-10-20', 'Marcus Reid'),\n  (19, 'SunStar Media',      'Leo Brennan',     'Won',         19000.00, '2026-01-25', '2026-03-10', 'Priya Sharma'),\n  (20, 'TerraGrow Farms',    'Mercy Acheampong','Qualified',   26000.00, '2026-02-05', '2026-04-06', 'Sarah Collins');\n",
      "tables": [
        {
          "name": "sales_pipeline",
          "columns": [
            {
              "name": "deal_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "company_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "contact_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "stage",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "deal_value",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "created_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "last_activity",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "sales_rep",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 20
        }
      ],
      "quickInsert": [
        "WITH",
        "AS",
        "SELECT"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d13-c01",
          "title": "Your First CTE",
          "description": "Write a CTE called active_deals that contains all deals NOT in the 'Lost' stage. Then SELECT company_name, stage, and deal_value from it, ordered by deal_value descending.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "WITH cte_name AS (SELECT ... FROM ... WHERE ...) SELECT ... FROM cte_name;",
          "solution": "WITH active_deals AS (\n  SELECT *\n  FROM sales_pipeline\n  WHERE stage != 'Lost'\n)\nSELECT company_name, stage, deal_value\nFROM active_deals\nORDER BY deal_value DESC;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 17
          }
        },
        {
          "id": "d13-c02",
          "title": "CTE with Aggregation",
          "description": "Write a CTE called rep_summary that calculates each sales_rep's total won revenue (stage = 'Won') and deal count. Then SELECT all columns from rep_summary ordered by total_won descending.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "Inside the CTE, use SUM(deal_value) and COUNT(*) with GROUP BY sales_rep, filtered to Won stage.",
          "solution": "WITH rep_summary AS (\n  SELECT\n    sales_rep,\n    COUNT(*)       AS deals_won,\n    SUM(deal_value) AS total_won\n  FROM sales_pipeline\n  WHERE stage = 'Won'\n  GROUP BY sales_rep\n)\nSELECT sales_rep, deals_won, ROUND(total_won::numeric, 2) AS total_won\nFROM rep_summary\nORDER BY total_won DESC;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "sales_rep",
              "deals_won",
              "total_won"
            ],
            "expectedRowCount": 3
          }
        },
        {
          "id": "d13-c03",
          "title": "Multiple CTEs",
          "description": "Write two CTEs: won_deals (stage = 'Won') and pipeline_deals (stage IN ('Qualified', 'Proposal', 'Negotiation')). Then write a final SELECT showing the count and total value of each group side by side with columns: group_name, deal_count, total_value.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "WITH cte1 AS (...), cte2 AS (...) SELECT ... Use UNION ALL to combine the two aggregations into one result set.",
          "solution": "WITH won_deals AS (\n  SELECT * FROM sales_pipeline WHERE stage = 'Won'\n),\npipeline_deals AS (\n  SELECT * FROM sales_pipeline WHERE stage IN ('Qualified', 'Proposal', 'Negotiation')\n)\nSELECT 'Won' AS group_name, COUNT(*) AS deal_count, ROUND(SUM(deal_value)::numeric, 2) AS total_value\nFROM won_deals\nUNION ALL\nSELECT 'In Pipeline', COUNT(*), ROUND(SUM(deal_value)::numeric, 2)\nFROM pipeline_deals;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "group_name",
              "deal_count",
              "total_value"
            ],
            "expectedRowCount": 2
          }
        },
        {
          "id": "d13-c04",
          "title": "Chained CTEs",
          "description": "Chain three CTEs: (1) qualified_up: all deals in Qualified, Proposal, or Negotiation. (2) rep_pipeline: sum of deal_value per sales_rep from qualified_up. (3) above_avg_reps: reps whose pipeline value exceeds the average from rep_pipeline. Final SELECT: sales_rep and pipeline_value from above_avg_reps.",
          "tier": "core",
          "difficulty": "hard",
          "hint": "Each CTE can reference the previous one. above_avg_reps references rep_pipeline, which references qualified_up.",
          "solution": "WITH qualified_up AS (\n  SELECT * FROM sales_pipeline\n  WHERE stage IN ('Qualified', 'Proposal', 'Negotiation')\n),\nrep_pipeline AS (\n  SELECT sales_rep, SUM(deal_value) AS pipeline_value\n  FROM qualified_up\n  GROUP BY sales_rep\n),\nabove_avg_reps AS (\n  SELECT *\n  FROM rep_pipeline\n  WHERE pipeline_value > (SELECT AVG(pipeline_value) FROM rep_pipeline)\n)\nSELECT sales_rep, ROUND(pipeline_value::numeric, 2) AS pipeline_value\nFROM above_avg_reps\nORDER BY pipeline_value DESC;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "sales_rep",
              "pipeline_value"
            ],
            "expectedRowCount": 1
          }
        },
        {
          "id": "d13-c05",
          "title": "CTE Replacing a Subquery",
          "description": "Rewrite this subquery approach as a CTE: find all deals whose deal_value is above the average of their own stage group. Show company_name, stage, deal_value, and stage_avg. Use a CTE to pre-calculate stage averages, then JOIN back to the main table.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "CTE: SELECT stage, AVG(deal_value) AS stage_avg FROM sales_pipeline GROUP BY stage. Then JOIN to sales_pipeline ON stage = stage and filter WHERE deal_value > stage_avg.",
          "solution": "WITH stage_avgs AS (\n  SELECT stage, AVG(deal_value) AS stage_avg\n  FROM sales_pipeline\n  GROUP BY stage\n)\nSELECT\n  sp.company_name,\n  sp.stage,\n  ROUND(sp.deal_value::numeric, 2) AS deal_value,\n  ROUND(sa.stage_avg::numeric, 2)  AS stage_avg\nFROM sales_pipeline sp\nJOIN stage_avgs sa ON sp.stage = sa.stage\nWHERE sp.deal_value > sa.stage_avg\nORDER BY sp.deal_value DESC;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "company_name",
              "stage",
              "deal_value",
              "stage_avg"
            ],
            "expectedRowCount": 9
          }
        },
        {
          "id": "d13-c06",
          "title": "Full Pipeline Health Report",
          "description": "Build a pipeline health report using CTEs. Show each stage, its deal_count, total_value, and a health label: 'Strong' if total_value > 50000, 'Moderate' if 20000-50000, 'Weak' if below 20000. Order by total_value descending.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "Use a CTE to aggregate by stage, then apply CASE WHEN in the final SELECT to assign the health label.",
          "solution": "WITH stage_metrics AS (\n  SELECT\n    stage,\n    COUNT(*)        AS deal_count,\n    SUM(deal_value) AS total_value\n  FROM sales_pipeline\n  GROUP BY stage\n)\nSELECT\n  stage,\n  deal_count,\n  ROUND(total_value::numeric, 2) AS total_value,\n  CASE\n    WHEN total_value > 50000  THEN 'Strong'\n    WHEN total_value >= 20000 THEN 'Moderate'\n    ELSE 'Weak'\n  END AS health_label\nFROM stage_metrics\nORDER BY total_value DESC;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "stage",
              "deal_count",
              "total_value",
              "health_label"
            ],
            "expectedRowCount": 6
          }
        }
      ]
    },
    {
      "day": 14,
      "title": "Project: IoT Sensor Data Pipeline",
      "slug": "project-iot-sensor-pipeline",
      "week": 2,
      "weekLabel": "Data Quality & Transformation",
      "type": "project",
      "youtubeId": null,
      "githubPath": "day-14",
      "seedSQL": "\nCREATE TABLE IF NOT EXISTS devices (\n  device_id   INTEGER PRIMARY KEY,\n  device_name TEXT    NOT NULL,\n  location    TEXT    NOT NULL,\n  device_type TEXT    NOT NULL,\n  install_date TEXT   NOT NULL,\n  is_active   INTEGER NOT NULL\n);\n\nCREATE TABLE IF NOT EXISTS sensor_readings (\n  reading_id    INTEGER PRIMARY KEY,\n  device_id     INTEGER NOT NULL,\n  reading_value REAL,\n  reading_unit  TEXT    NOT NULL,\n  recorded_at   TEXT    NOT NULL\n);\n\nCREATE TABLE IF NOT EXISTS alerts (\n  alert_id     INTEGER PRIMARY KEY,\n  device_id    INTEGER NOT NULL,\n  alert_type   TEXT    NOT NULL,\n  severity     TEXT    NOT NULL,\n  triggered_at TEXT    NOT NULL,\n  resolved_at  TEXT\n);\n\nDELETE FROM devices;\nDELETE FROM sensor_readings;\nDELETE FROM alerts;\n\nINSERT INTO devices VALUES\n  (1, 'Temp Sensor A1',     'Warehouse North',  'Temperature', '2024-06-01', 1),\n  (2, 'Temp Sensor A2',     'Warehouse South',  'Temperature', '2024-06-01', 1),\n  (3, 'Humidity Sensor B1', 'Server Room',      'Humidity',    '2024-07-15', 1),\n  (4, 'CO2 Monitor C1',     'Office Floor 1',   'CO2',         '2024-08-01', 1),\n  (5, 'CO2 Monitor C2',     'Office Floor 2',   'CO2',         '2024-08-01', 0),\n  (6, 'Pressure Gauge D1',  'Boiler Room',      'Pressure',    '2024-05-20', 1),\n  (7, 'Temp Sensor A3',     'Cold Storage',     'Temperature', '2024-09-10', 1),\n  (8, 'Humidity Sensor B2', 'Archive Room',     'Humidity',    '2024-10-01', 0);\n\nINSERT INTO sensor_readings VALUES\n  (1,  1, 22.4,  'C',    '2026-04-15 08:00:00'),\n  (2,  1, 23.1,  'C',    '2026-04-15 09:00:00'),\n  (3,  1, NULL,  'C',    '2026-04-15 10:00:00'),\n  (4,  1, 24.8,  'C',    '2026-04-15 11:00:00'),\n  (5,  2, 19.7,  'C',    '2026-04-15 08:00:00'),\n  (6,  2, 20.1,  'C',    '2026-04-15 09:00:00'),\n  (7,  2, NULL,  'C',    '2026-04-15 10:00:00'),\n  (8,  2, 20.9,  'C',    '2026-04-15 11:00:00'),\n  (9,  3, 61.2,  '%RH',  '2026-04-15 08:00:00'),\n  (10, 3, 62.5,  '%RH',  '2026-04-15 09:00:00'),\n  (11, 3, NULL,  '%RH',  '2026-04-15 10:00:00'),\n  (12, 3, 59.8,  '%RH',  '2026-04-15 11:00:00'),\n  (13, 4, 412.0, 'ppm',  '2026-04-15 08:00:00'),\n  (14, 4, 487.5, 'ppm',  '2026-04-15 09:00:00'),\n  (15, 4, 534.2, 'ppm',  '2026-04-15 10:00:00'),\n  (16, 4, 601.7, 'ppm',  '2026-04-15 11:00:00'),\n  (17, 6, 2.1,   'bar',  '2026-04-15 08:00:00'),\n  (18, 6, 2.3,   'bar',  '2026-04-15 09:00:00'),\n  (19, 6, 4.8,   'bar',  '2026-04-15 10:00:00'),\n  (20, 6, 2.2,   'bar',  '2026-04-15 11:00:00'),\n  (21, 7, -5.2,  'C',    '2026-04-15 08:00:00'),\n  (22, 7, -4.9,  'C',    '2026-04-15 09:00:00'),\n  (23, 7, NULL,  'C',    '2026-04-15 10:00:00'),\n  (24, 7, -5.8,  'C',    '2026-04-15 11:00:00'),\n  (25, 1, 25.3,  'C',    '2026-04-15 12:00:00'),\n  (26, 2, 21.4,  'C',    '2026-04-15 12:00:00'),\n  (27, 3, 63.1,  '%RH',  '2026-04-15 12:00:00'),\n  (28, 4, 655.0, 'ppm',  '2026-04-15 12:00:00'),\n  (29, 6, 2.4,   'bar',  '2026-04-15 12:00:00'),\n  (30, 7, -5.5,  'C',    '2026-04-15 12:00:00'),\n  (31, 1, 26.9,  'C',    '2026-04-15 13:00:00'),\n  (32, 2, 22.0,  'C',    '2026-04-15 13:00:00'),\n  (33, 3, NULL,  '%RH',  '2026-04-15 13:00:00'),\n  (34, 4, 710.3, 'ppm',  '2026-04-15 13:00:00'),\n  (35, 6, 2.3,   'bar',  '2026-04-15 13:00:00'),\n  (36, 7, -4.7,  'C',    '2026-04-15 13:00:00'),\n  (37, 1, NULL,  'C',    '2026-04-15 14:00:00'),\n  (38, 2, 22.5,  'C',    '2026-04-15 14:00:00'),\n  (39, 6, 5.2,   'bar',  '2026-04-15 14:00:00'),\n  (40, 7, -5.1,  'C',    '2026-04-15 14:00:00');\n\nINSERT INTO alerts VALUES\n  (1,  4, 'High CO2',          'Warning',  '2026-04-15 10:30:00', '2026-04-15 11:45:00'),\n  (2,  4, 'High CO2',          'Critical', '2026-04-15 12:15:00', NULL),\n  (3,  6, 'High Pressure',     'Critical', '2026-04-15 10:05:00', '2026-04-15 10:55:00'),\n  (4,  6, 'High Pressure',     'Critical', '2026-04-15 14:02:00', NULL),\n  (5,  1, 'High Temperature',  'Warning',  '2026-04-15 12:45:00', NULL),\n  (6,  3, 'Sensor Dropout',    'Warning',  '2026-04-15 10:00:00', '2026-04-15 10:15:00'),\n  (7,  7, 'Temp Rising',       'Info',     '2026-04-15 13:05:00', '2026-04-15 13:30:00'),\n  (8,  5, 'Device Inactive',   'Info',     '2026-04-14 09:00:00', NULL),\n  (9,  8, 'Device Inactive',   'Info',     '2026-04-13 14:00:00', NULL),\n  (10, 1, 'Sensor Dropout',    'Warning',  '2026-04-15 10:00:00', '2026-04-15 10:15:00'),\n  (11, 2, 'Sensor Dropout',    'Warning',  '2026-04-15 10:00:00', '2026-04-15 10:15:00'),\n  (12, 7, 'Sensor Dropout',    'Warning',  '2026-04-15 10:00:00', '2026-04-15 10:15:00');\n",
      "tables": [
        {
          "name": "devices",
          "columns": [
            {
              "name": "device_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "device_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "location",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "device_type",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "install_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "is_active",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 8
        },
        {
          "name": "sensor_readings",
          "columns": [
            {
              "name": "reading_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "device_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "reading_value",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "reading_unit",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "recorded_at",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 40
        },
        {
          "name": "alerts",
          "columns": [
            {
              "name": "alert_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "device_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "alert_type",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "severity",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "triggered_at",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "resolved_at",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 12
        }
      ],
      "quickInsert": [
        "WITH",
        "COALESCE",
        "CASE WHEN",
        "GROUP BY",
        "JOIN"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d14-c01",
          "title": "Explore the Device Fleet",
          "description": "Get an overview of all devices. Show device_name, location, device_type, and a status column: 'Active' if is_active = 1, 'Inactive' if is_active = 0. Order by device_type, then device_name.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "Use CASE WHEN is_active = 1 THEN 'Active' ELSE 'Inactive' END for the status column.",
          "solution": "SELECT\n  device_name,\n  location,\n  device_type,\n  CASE WHEN is_active = 1 THEN 'Active' ELSE 'Inactive' END AS status\nFROM devices\nORDER BY device_type, device_name;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "device_name",
              "location",
              "device_type",
              "status"
            ],
            "expectedRowCount": 8
          }
        },
        {
          "id": "d14-c02",
          "title": "Find NULL Readings",
          "description": "Identify all sensor readings where reading_value is NULL. Show reading_id, device_id, reading_unit, and recorded_at. These are data quality gaps we need to handle.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "Filter WHERE reading_value IS NULL.",
          "solution": "SELECT reading_id, device_id, reading_unit, recorded_at\nFROM sensor_readings\nWHERE reading_value IS NULL\nORDER BY device_id, recorded_at;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 6
          }
        },
        {
          "id": "d14-c03",
          "title": "Clean Readings with COALESCE",
          "description": "Build a cleaned readings view. For every reading, show device_id, recorded_at, reading_unit, and clean_value: the reading_value if available, or -999 as a sentinel value for NULL readings (so downstream systems know a read failed). Round clean_value to 2 decimal places.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "COALESCE(reading_value, -999) replaces NULLs. ROUND the result to 2 decimals.",
          "solution": "SELECT\n  device_id,\n  recorded_at,\n  reading_unit,\n  ROUND(COALESCE(reading_value, -999)::numeric, 2) AS clean_value\nFROM sensor_readings\nORDER BY device_id, recorded_at;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "device_id",
              "recorded_at",
              "reading_unit",
              "clean_value"
            ],
            "expectedRowCount": 40
          }
        },
        {
          "id": "d14-c04",
          "title": "Flag Anomalous Readings",
          "description": "Flag each valid (non-NULL) reading with an anomaly label using CASE WHEN: for device_type 'Temperature' - flag 'High Temp' if reading > 25, 'Low Temp' if reading < -10, else 'Normal'. For 'CO2' - 'High CO2' if > 600, else 'Normal'. For 'Pressure' - 'High Pressure' if > 4, else 'Normal'. For others - 'Normal'. Join to devices to get device_type. Show device_name, device_type, reading_value, recorded_at, anomaly_flag. Exclude NULL readings.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "JOIN sensor_readings to devices on device_id. Use a nested CASE WHEN - outer on device_type, inner on reading_value thresholds.",
          "solution": "SELECT\n  d.device_name,\n  d.device_type,\n  ROUND(sr.reading_value::numeric, 2) AS reading_value,\n  sr.recorded_at,\n  CASE\n    WHEN d.device_type = 'Temperature' AND sr.reading_value > 25  THEN 'High Temp'\n    WHEN d.device_type = 'Temperature' AND sr.reading_value < -10 THEN 'Low Temp'\n    WHEN d.device_type = 'CO2'         AND sr.reading_value > 600 THEN 'High CO2'\n    WHEN d.device_type = 'Pressure'    AND sr.reading_value > 4   THEN 'High Pressure'\n    ELSE 'Normal'\n  END AS anomaly_flag\nFROM sensor_readings sr\nJOIN devices d ON sr.device_id = d.device_id\nWHERE sr.reading_value IS NOT NULL\nORDER BY d.device_name, sr.recorded_at;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "device_name",
              "device_type",
              "reading_value",
              "recorded_at",
              "anomaly_flag"
            ],
            "expectedRowCount": 34
          }
        },
        {
          "id": "d14-c05",
          "title": "Join Devices to Alerts",
          "description": "Join the devices and alerts tables to show every alert with its device context. Show device_name, location, alert_type, severity, triggered_at, and a resolved column: 'Resolved' if resolved_at is not null, 'Open' if it is null. Order by triggered_at descending.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "JOIN alerts to devices on device_id. Use COALESCE or CASE WHEN on resolved_at for the resolved column.",
          "solution": "SELECT\n  d.device_name,\n  d.location,\n  a.alert_type,\n  a.severity,\n  a.triggered_at,\n  CASE WHEN a.resolved_at IS NOT NULL THEN 'Resolved' ELSE 'Open' END AS resolved\nFROM alerts a\nJOIN devices d ON a.device_id = d.device_id\nORDER BY a.triggered_at DESC;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "device_name",
              "location",
              "alert_type",
              "severity",
              "triggered_at",
              "resolved"
            ],
            "expectedRowCount": 12
          }
        },
        {
          "id": "d14-c06",
          "title": "CTE Pipeline: Raw to Cleaned to Aggregated",
          "description": "Build a 3-step CTE pipeline. Step 1 (raw_readings): all sensor_readings joined to devices, including device_name, device_type, reading_value, recorded_at. Step 2 (cleaned_readings): from raw_readings, replace NULL reading_value with -999 using COALESCE, keep only active devices (is_active = 1 from devices). Step 3 (device_summary): from cleaned_readings, GROUP BY device_name and device_type to get total_readings, valid_readings (count where clean_value != -999), and avg_valid_value (avg where clean_value != -999, rounded to 2dp). Final SELECT: all columns from device_summary ordered by device_name.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "Three CTEs chained: raw_readings uses a JOIN, cleaned_readings filters and applies COALESCE, device_summary aggregates. Reference the previous CTE in each subsequent one.",
          "solution": "WITH raw_readings AS (\n  SELECT\n    d.device_name,\n    d.device_type,\n    d.is_active,\n    sr.reading_value,\n    sr.recorded_at\n  FROM sensor_readings sr\n  JOIN devices d ON sr.device_id = d.device_id\n),\ncleaned_readings AS (\n  SELECT\n    device_name,\n    device_type,\n    COALESCE(reading_value, -999) AS clean_value,\n    recorded_at\n  FROM raw_readings\n  WHERE is_active = 1\n),\ndevice_summary AS (\n  SELECT\n    device_name,\n    device_type,\n    COUNT(*)                                                       AS total_readings,\n    SUM(CASE WHEN clean_value != -999 THEN 1 ELSE 0 END)          AS valid_readings,\n    ROUND(AVG(CASE WHEN clean_value != -999 THEN clean_value END)::numeric, 2) AS avg_valid_value\n  FROM cleaned_readings\n  GROUP BY device_name, device_type\n)\nSELECT *\nFROM device_summary\nORDER BY device_name;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "device_name",
              "device_type",
              "total_readings",
              "valid_readings",
              "avg_valid_value"
            ],
            "expectedRowCount": 6
          }
        },
        {
          "id": "d14-c07",
          "title": "Device Health Summary",
          "description": "Produce a device health summary. For each device, show device_name, location, device_type, status (Active/Inactive), open_alerts (count of unresolved alerts for that device), and health_rating: 'Critical' if has a Critical-severity open alert, 'Warning' if has a Warning-severity open alert and no Critical open alerts, 'Good' otherwise. Use CTEs to build this step by step.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "Use a CTE to aggregate open alerts per device (and max severity), then LEFT JOIN to devices. CASE WHEN on the max_severity for health_rating.",
          "solution": "WITH open_alert_summary AS (\n  SELECT\n    device_id,\n    COUNT(*) AS open_alerts,\n    MAX(CASE\n      WHEN severity = 'Critical' THEN 3\n      WHEN severity = 'Warning'  THEN 2\n      WHEN severity = 'Info'     THEN 1\n      ELSE 0\n    END) AS max_severity_rank\n  FROM alerts\n  WHERE resolved_at IS NULL\n  GROUP BY device_id\n)\nSELECT\n  d.device_name,\n  d.location,\n  d.device_type,\n  CASE WHEN d.is_active = 1 THEN 'Active' ELSE 'Inactive' END AS status,\n  COALESCE(oas.open_alerts, 0) AS open_alerts,\n  CASE\n    WHEN oas.max_severity_rank = 3 THEN 'Critical'\n    WHEN oas.max_severity_rank = 2 THEN 'Warning'\n    ELSE 'Good'\n  END AS health_rating\nFROM devices d\nLEFT JOIN open_alert_summary oas ON d.device_id = oas.device_id\nORDER BY oas.max_severity_rank DESC NULLS LAST, d.device_name;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "device_name",
              "location",
              "device_type",
              "status",
              "open_alerts",
              "health_rating"
            ],
            "expectedRowCount": 8
          }
        },
        {
          "id": "d14-c08",
          "title": "Full IoT Operations Report",
          "description": "Write the final operations report combining everything from the week. Use CTEs to produce a single result set with: device_name, device_type, location, status, total_readings, null_pct (percentage of readings that are NULL, rounded to 1dp), avg_reading (average of non-null readings, rounded to 2dp), open_alerts, and a summary_flag: 'Action Required' if open_alerts > 0 OR null_pct > 20, else 'All Clear'. Order by summary_flag then device_name.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "Build CTEs for reading stats and alert counts separately, then LEFT JOIN both to devices in the final SELECT. Calculate null_pct as COUNT(nulls)*100.0/total.",
          "solution": "WITH reading_stats AS (\n  SELECT\n    device_id,\n    COUNT(*) AS total_readings,\n    ROUND(\n      SUM(CASE WHEN reading_value IS NULL THEN 1.0 ELSE 0 END) * 100.0 / COUNT(*),\n      1\n    ) AS null_pct,\n    ROUND(AVG(reading_value)::numeric, 2) AS avg_reading\n  FROM sensor_readings\n  GROUP BY device_id\n),\nopen_alerts AS (\n  SELECT device_id, COUNT(*) AS open_alerts\n  FROM alerts\n  WHERE resolved_at IS NULL\n  GROUP BY device_id\n)\nSELECT\n  d.device_name,\n  d.device_type,\n  d.location,\n  CASE WHEN d.is_active = 1 THEN 'Active' ELSE 'Inactive' END AS status,\n  COALESCE(rs.total_readings, 0)  AS total_readings,\n  COALESCE(rs.null_pct, 0)        AS null_pct,\n  rs.avg_reading,\n  COALESCE(oa.open_alerts, 0)     AS open_alerts,\n  CASE\n    WHEN COALESCE(oa.open_alerts, 0) > 0 OR COALESCE(rs.null_pct, 0) > 20\n      THEN 'Action Required'\n    ELSE 'All Clear'\n  END AS summary_flag\nFROM devices d\nLEFT JOIN reading_stats rs ON d.device_id = rs.device_id\nLEFT JOIN open_alerts   oa ON d.device_id = oa.device_id\nORDER BY summary_flag, d.device_name;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "device_name",
              "device_type",
              "location",
              "status",
              "total_readings",
              "null_pct",
              "avg_reading",
              "open_alerts",
              "summary_flag"
            ],
            "expectedRowCount": 8
          }
        }
      ]
    },
    {
      "day": 15,
      "title": "JOINs Part 1",
      "slug": "joins-part-1",
      "week": 3,
      "weekLabel": "JOINs & Relational Data",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-15",
      "seedSQL": "\nCREATE TABLE IF NOT EXISTS artists (\n  artist_id   INTEGER PRIMARY KEY,\n  artist_name TEXT    NOT NULL,\n  country     TEXT,\n  genre       TEXT,\n  active_since INTEGER\n);\n\nCREATE TABLE IF NOT EXISTS albums (\n  album_id     INTEGER PRIMARY KEY,\n  album_title  TEXT    NOT NULL,\n  artist_id    INTEGER,\n  release_year INTEGER,\n  sales_millions REAL,\n  label        TEXT\n);\n\nINSERT INTO artists VALUES\n  (1,  'The Midnight',       'United States', 'Synthwave',    2012),\n  (2,  'Nour El-Sherif',     'Egypt',         'Pop',          2001),\n  (3,  'Bicep',              'United Kingdom','Electronic',   2009),\n  (4,  'Hania Rani',         'Poland',        'Neoclassical', 2014),\n  (5,  'James Blake',        'United Kingdom','Alternative',  2009),\n  (6,  'Tems',               'Nigeria',       'Afrobeats',    2018),\n  (7,  'FKJ',                'France',        'Nu Jazz',      2012),\n  (8,  'Lucy Dacus',         'United States', 'Indie Rock',   2014),\n  (9,  'Arooj Aftab',        'Pakistan',      'Neoclassical', 2011),\n  (10, 'Jungle',             'United Kingdom','Funk',         2013),\n  (11, 'Hiatus Kaiyote',     'Australia',     'Neo Soul',     2011),\n  (12, 'Amaarae',            'Ghana',         'Afropop',      2017);\n\nINSERT INTO albums VALUES\n  (1,  'Kids',                 1, 2018, 0.4,  'Counter Records'),\n  (2,  'Monsters',             1, 2022, 0.6,  'Counter Records'),\n  (3,  'Rebel Heart',          2, 2019, 1.2,  'Rotana Records'),\n  (4,  'Isles',                3, 2021, 0.9,  'Ninja Tune'),\n  (5,  'Oversteps',            3, 2020, 0.3,  'Ninja Tune'),\n  (6,  'Esja',                 4, 2019, 0.5,  'gondwana records'),\n  (7,  'Ghosts',               4, 2023, 0.3,  'gondwana records'),\n  (8,  'Friends That Break Your Heart', 5, 2021, 0.8, 'Polydor'),\n  (9,  'Overthinker',          5, 2019, 0.6,  'Republic Records'),\n  (10, 'For Broken Ears',      6, 2020, 1.5,  'Since 93'),\n  (11, 'If Orange Was a Place',6, 2021, 2.1,  'Since 93'),\n  (12, 'Vincent',              7, 2019, 0.4,  'FKJMUSIC'),\n  (13, 'Home Grown',           8, 2022, 0.3,  'Matador Records'),\n  (14, 'Vulture Prince',       9, 2021, 0.5,  'Verse Music Group'),\n  (15, 'The Jungle EP',       10, 2022, 0.7,  'CAIOLA Records'),\n  (16, 'Tawk Tomahawk',       11, 2013, 0.4,  'Flying Buddha'),\n  (17, 'Choose to Stay',      11, 2019, 0.6,  'Flying Buddha'),\n  -- album with an artist_id that has no matching artist row (for FULL OUTER JOIN demos)\n  (18, 'Orphaned Album',      99, 2023, 0.1,  'Unknown Label');\n",
      "tables": [
        {
          "name": "artists",
          "columns": [
            {
              "name": "artist_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "artist_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "country",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "genre",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "active_since",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 12
        },
        {
          "name": "albums",
          "columns": [
            {
              "name": "album_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "album_title",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "artist_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "release_year",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "sales_millions",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "label",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 18
        }
      ],
      "quickInsert": [
        "INNER JOIN",
        "LEFT JOIN",
        "RIGHT JOIN",
        "FULL OUTER JOIN",
        "ON"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d15-c01",
          "title": "INNER JOIN basics",
          "description": "Join artists and albums to show each album alongside its artist name and country. Return album_title, artist_name, country, and release_year. Only include albums that have a matching artist.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "Use INNER JOIN artists ON albums.artist_id = artists.artist_id.",
          "solution": "SELECT\n  al.album_title,\n  ar.artist_name,\n  ar.country,\n  al.release_year\nFROM albums al\nINNER JOIN artists ar ON al.artist_id = ar.artist_id\nORDER BY al.release_year;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 17
          }
        },
        {
          "id": "d15-c02",
          "title": "LEFT JOIN - all artists",
          "description": "Show every artist, including those who have no albums in the table. Return artist_name, genre, and album_title. Artists without albums should show NULL for album_title.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "Put artists on the LEFT side of the JOIN so all artists are kept even without a matching album.",
          "solution": "SELECT\n  ar.artist_name,\n  ar.genre,\n  al.album_title\nFROM artists ar\nLEFT JOIN albums al ON ar.artist_id = al.artist_id\nORDER BY ar.artist_name;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "artist_name",
              "genre",
              "album_title"
            ],
            "expectedRowCount": 18
          }
        },
        {
          "id": "d15-c03",
          "title": "Anti-join - artists with no albums",
          "description": "Find every artist who has no albums in the albums table. Return only artist_name and country.",
          "tier": "core",
          "difficulty": 2,
          "hint": "LEFT JOIN albums, then filter WHERE al.album_id IS NULL.",
          "solution": "SELECT\n  ar.artist_name,\n  ar.country\nFROM artists ar\nLEFT JOIN albums al ON ar.artist_id = al.artist_id\nWHERE al.album_id IS NULL\nORDER BY ar.artist_name;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 1
          }
        },
        {
          "id": "d15-c04",
          "title": "RIGHT JOIN: All Albums Including Unmatched",
          "description": "Find every album, including the one whose artist_id does not match any artist. Return album_title, sales_millions, and artist_name (NULL if no match). Use a RIGHT JOIN to achieve the same result.",
          "tier": "core",
          "difficulty": 2,
          "hint": "Use FROM artists ar RIGHT JOIN albums al ON ar.artist_id = al.artist_id",
          "solution": "SELECT\n  al.album_title,\n  al.sales_millions,\n  ar.artist_name\nFROM artists ar\nRIGHT JOIN albums al ON al.artist_id = ar.artist_id\nORDER BY al.album_id;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 18
          }
        },
        {
          "id": "d15-c05",
          "title": "FULL OUTER JOIN: All Artists and All Albums",
          "description": "Combine all artists (even those without albums) and all albums (even those without a matching artist) in one result set. Use a FULL OUTER JOIN to combine all artists and all albums in one result set. Return artist_name and album_title.",
          "tier": "core",
          "difficulty": 3,
          "hint": "Use FROM artists ar FULL OUTER JOIN albums al ON ar.artist_id = al.artist_id. PostgreSQL supports FULL OUTER JOIN natively.",
          "solution": "SELECT ar.artist_name, al.album_title\nFROM artists ar\nFULL OUTER JOIN albums al ON ar.artist_id = al.artist_id\nORDER BY artist_name;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 19
          }
        },
        {
          "id": "d15-c06",
          "title": "Aggregate with JOIN",
          "description": "For each artist who has at least one album, show artist_name, the number of albums they have (as album_count), and their total sales in millions rounded to 1 decimal place (as total_sales). Order by total_sales descending.",
          "tier": "core",
          "difficulty": 2,
          "hint": "JOIN then GROUP BY artist_name, using COUNT() and SUM().",
          "solution": "SELECT\n  ar.artist_name,\n  COUNT(al.album_id)               AS album_count,\n  ROUND(SUM(al.sales_millions)::numeric, 1) AS total_sales\nFROM artists ar\nINNER JOIN albums al ON ar.artist_id = al.artist_id\nGROUP BY ar.artist_name\nORDER BY total_sales DESC;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "total_sales",
            "direction": "desc"
          }
        },
        {
          "id": "d15-c07",
          "title": "Multi-condition JOIN filter",
          "description": "Show albums released after 2020 where the artist is from the United Kingdom. Return album_title, artist_name, release_year, and sales_millions. Order by release_year.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "INNER JOIN, then add WHERE conditions on both tables.",
          "solution": "SELECT\n  al.album_title,\n  ar.artist_name,\n  al.release_year,\n  al.sales_millions\nFROM albums al\nINNER JOIN artists ar ON al.artist_id = ar.artist_id\nWHERE al.release_year > 2020\n  AND ar.country = 'United Kingdom'\nORDER BY al.release_year;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0 && rows.every(r => r.release_year > 2020)"
          }
        }
      ]
    },
    {
      "day": 16,
      "title": "JOINs Part 2",
      "slug": "joins-part-2-cross-self",
      "week": 3,
      "weekLabel": "JOINs & Relational Data",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-16",
      "seedSQL": "\nCREATE TABLE IF NOT EXISTS menu_items (\n  item_id   INTEGER PRIMARY KEY,\n  item_name TEXT    NOT NULL,\n  category  TEXT    CHECK(category IN ('Starter','Main','Dessert')),\n  price     REAL    NOT NULL\n);\n\nCREATE TABLE IF NOT EXISTS employees_org (\n  emp_id     INTEGER PRIMARY KEY,\n  emp_name   TEXT    NOT NULL,\n  role       TEXT,\n  manager_id INTEGER\n);\n\nINSERT INTO menu_items VALUES\n  (1, 'Bruschetta',       'Starter',  6.50),\n  (2, 'Soup of the Day',  'Starter',  5.00),\n  (3, 'Garlic Prawns',    'Starter',  8.50),\n  (4, 'Grilled Salmon',   'Main',    18.00),\n  (5, 'Lamb Tagine',      'Main',    20.00),\n  (6, 'Mushroom Risotto', 'Main',    14.50),\n  (7, 'Panna Cotta',      'Dessert',  7.00),\n  (8, 'Chocolate Fondant','Dessert',  8.50),\n  (9, 'Fruit Sorbet',     'Dessert',  5.50);\n\nINSERT INTO employees_org VALUES\n  (1,  'Sarah Mitchell',  'CEO',              NULL),\n  (2,  'David Okonkwo',   'CTO',              1),\n  (3,  'Rachel Green',    'CFO',              1),\n  (4,  'Liam Torres',     'Engineering Lead', 2),\n  (5,  'Priya Nair',      'Data Lead',        2),\n  (6,  'James Whitfield', 'Finance Manager',  3),\n  (7,  'Amara Diallo',    'Senior Engineer',  4),\n  (8,  'Tom Hartley',     'Data Analyst',     5),\n  (9,  'Yuki Tanaka',     'Data Analyst',     5),\n  (10, 'Fatima Al-Rashid','Junior Engineer',  4);\n",
      "tables": [
        {
          "name": "menu_items",
          "columns": [
            {
              "name": "item_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "item_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "category",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "price",
              "type": "REAL",
              "pk": false
            }
          ],
          "rowCount": 9
        },
        {
          "name": "employees_org",
          "columns": [
            {
              "name": "emp_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "emp_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "role",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "manager_id",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 10
        }
      ],
      "quickInsert": [
        "CROSS JOIN",
        "self JOIN",
        "ON",
        "AS"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d16-c01",
          "title": "CROSS JOIN - starter and main combos",
          "description": "Generate every possible combination of Starter and Main dishes. Return starter_name and main_name. This is a CROSS JOIN between the same table filtered to different categories.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "Self-cross-join menu_items: FROM menu_items s, menu_items m WHERE s.category = 'Starter' AND m.category = 'Main'",
          "solution": "SELECT\n  s.item_name AS starter_name,\n  m.item_name AS main_name\nFROM menu_items s\nCROSS JOIN menu_items m\nWHERE s.category = 'Starter'\n  AND m.category = 'Main'\nORDER BY s.item_name, m.item_name;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 9
          }
        },
        {
          "id": "d16-c02",
          "title": "CROSS JOIN with combined price",
          "description": "For every Starter + Dessert combination, show starter_name, dessert_name, and combined_price (sum of both prices). Only include combos where combined_price is under 16. Order by combined_price ascending.",
          "tier": "core",
          "difficulty": 2,
          "hint": "CROSS JOIN, WHERE s.category = 'Starter' AND d.category = 'Dessert', then filter on s.price + d.price.",
          "solution": "SELECT\n  s.item_name                AS starter_name,\n  d.item_name                AS dessert_name,\n  ROUND((s.price + d.price)::numeric, 2) AS combined_price\nFROM menu_items s\nCROSS JOIN menu_items d\nWHERE s.category = 'Starter'\n  AND d.category = 'Dessert'\n  AND s.price + d.price < 16\nORDER BY combined_price;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "combined_price",
            "direction": "asc"
          }
        },
        {
          "id": "d16-c03",
          "title": "Self-join - employee and manager",
          "description": "Show every employee alongside their manager's name. Return emp_name (as employee) and manager_name. Exclude the CEO (who has no manager).",
          "tier": "core",
          "difficulty": 2,
          "hint": "Alias employees_org twice: e and m. JOIN ON e.manager_id = m.emp_id.",
          "solution": "SELECT\n  e.emp_name AS employee,\n  m.emp_name AS manager_name\nFROM employees_org e\nJOIN employees_org m ON e.manager_id = m.emp_id\nORDER BY e.emp_name;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 9
          }
        },
        {
          "id": "d16-c04",
          "title": "Reporting chain - who reports to the CTO",
          "description": "Find all employees who report directly to the CTO (David Okonkwo). Return emp_name and role.",
          "tier": "core",
          "difficulty": 2,
          "hint": "Self-join to match employees whose manager_id equals the CTO's emp_id.",
          "solution": "SELECT\n  e.emp_name,\n  e.role\nFROM employees_org e\nJOIN employees_org m ON e.manager_id = m.emp_id\nWHERE m.emp_name = 'David Okonkwo'\nORDER BY e.emp_name;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 2
          }
        },
        {
          "id": "d16-c05",
          "title": "Top-level employees - no manager",
          "description": "Find all employees who have no manager (i.e. they are at the top of the hierarchy). Return emp_name and role.",
          "tier": "core",
          "difficulty": 1,
          "hint": "Filter WHERE manager_id IS NULL.",
          "solution": "SELECT\n  emp_name,\n  role\nFROM employees_org\nWHERE manager_id IS NULL;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 1
          }
        },
        {
          "id": "d16-c06",
          "title": "Menu combo under budget",
          "description": "A diner has a budget of 30. Find all Starter + Main + Dessert combinations where the total price of all three is 30 or less. Return starter_name, main_name, dessert_name, and total_price. Order by total_price ascending.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "Triple CROSS JOIN on menu_items aliased s, m, d. Filter each category and total price.",
          "solution": "SELECT\n  s.item_name                          AS starter_name,\n  mn.item_name                         AS main_name,\n  d.item_name                          AS dessert_name,\n  ROUND((s.price + mn.price + d.price)::numeric, 2) AS total_price\nFROM menu_items s\nCROSS JOIN menu_items mn\nCROSS JOIN menu_items d\nWHERE s.category  = 'Starter'\n  AND mn.category = 'Main'\n  AND d.category  = 'Dessert'\n  AND s.price + mn.price + d.price <= 30\nORDER BY total_price;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "total_price",
            "direction": "asc"
          }
        }
      ]
    },
    {
      "day": 17,
      "title": "UNION & UNION ALL",
      "slug": "union-and-union-all",
      "week": 3,
      "weekLabel": "JOINs & Relational Data",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-17",
      "seedSQL": "\nCREATE TABLE IF NOT EXISTS online_sales (\n  sale_id      INTEGER PRIMARY KEY,\n  product_name TEXT    NOT NULL,\n  quantity     INTEGER NOT NULL,\n  sale_amount  REAL    NOT NULL,\n  sale_date    TEXT    NOT NULL,\n  channel      TEXT    DEFAULT 'online'\n);\n\nCREATE TABLE IF NOT EXISTS store_sales (\n  sale_id        INTEGER PRIMARY KEY,\n  product_name   TEXT    NOT NULL,\n  quantity       INTEGER NOT NULL,\n  sale_amount    REAL    NOT NULL,\n  sale_date      TEXT    NOT NULL,\n  store_location TEXT\n);\n\nINSERT INTO online_sales VALUES\n  (1,  'Wireless Headphones',  2, 159.98, '2024-01-05', 'online'),\n  (2,  'Running Shoes',        1,  89.99, '2024-01-07', 'online'),\n  (3,  'Yoga Mat',             3,  89.97, '2024-01-09', 'online'),\n  (4,  'Water Bottle',         5,  74.95, '2024-01-12', 'online'),\n  (5,  'Wireless Headphones',  1,  79.99, '2024-01-14', 'online'),\n  (6,  'Backpack',             2, 119.98, '2024-01-17', 'online'),\n  (7,  'Running Shoes',        2, 179.98, '2024-01-20', 'online'),\n  (8,  'Desk Lamp',            1,  34.99, '2024-01-22', 'online'),\n  (9,  'Notebook Set',         4,  47.96, '2024-01-25', 'online'),\n  (10, 'Yoga Mat',             1,  29.99, '2024-01-28', 'online'),\n  (11, 'Wireless Headphones',  1,  79.99, '2024-02-02', 'online'),\n  (12, 'Backpack',             1,  59.99, '2024-02-06', 'online'),\n  (13, 'Water Bottle',         3,  44.97, '2024-02-10', 'online'),\n  (14, 'Desk Lamp',            2,  69.98, '2024-02-14', 'online'),\n  (15, 'Notebook Set',         2,  23.98, '2024-02-18', 'online');\n\nINSERT INTO store_sales VALUES\n  (1,  'Running Shoes',        3, 269.97, '2024-01-06', 'Manchester'),\n  (2,  'Wireless Headphones',  1,  79.99, '2024-01-08', 'London'),\n  (3,  'Yoga Mat',             2,  59.98, '2024-01-11', 'Birmingham'),\n  (4,  'Backpack',             4, 239.96, '2024-01-15', 'Manchester'),\n  (5,  'Notebook Set',         6,  71.94, '2024-01-18', 'London'),\n  (6,  'Wireless Headphones',  2, 159.98, '2024-01-21', 'Glasgow'),\n  (7,  'Running Shoes',        1,  89.99, '2024-01-24', 'Birmingham'),\n  (8,  'Water Bottle',         8, 119.92, '2024-01-27', 'London'),\n  (9,  'Yoga Mat',             1,  29.99, '2024-02-01', 'Glasgow'),\n  (10, 'Backpack',             2, 119.98, '2024-02-05', 'Manchester'),\n  (11, 'Desk Lamp',            3, 104.97, '2024-02-09', 'London'),\n  (12, 'Running Shoes',        2, 179.98, '2024-02-13', 'Glasgow');\n",
      "tables": [
        {
          "name": "online_sales",
          "columns": [
            {
              "name": "sale_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "product_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "quantity",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "sale_amount",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "sale_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "channel",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 15
        },
        {
          "name": "store_sales",
          "columns": [
            {
              "name": "sale_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "product_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "quantity",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "sale_amount",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "sale_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "store_location",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 12
        }
      ],
      "quickInsert": [
        "UNION",
        "UNION ALL",
        "ORDER BY"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d17-c01",
          "title": "Basic UNION",
          "description": "Combine all product names and sale amounts from both tables into one list, removing duplicates. Return product_name and sale_amount.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "SELECT the same columns from each table, then UNION them.",
          "solution": "SELECT product_name, sale_amount FROM online_sales\nUNION\nSELECT product_name, sale_amount FROM store_sales\nORDER BY product_name;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0"
          }
        },
        {
          "id": "d17-c02",
          "title": "UNION ALL to keep duplicates",
          "description": "Combine all sales from both tables including duplicates. Return product_name, quantity, and sale_amount. How many total rows do you get?",
          "tier": "starter",
          "difficulty": 1,
          "hint": "Use UNION ALL instead of UNION to preserve every row.",
          "solution": "SELECT product_name, quantity, sale_amount FROM online_sales\nUNION ALL\nSELECT product_name, quantity, sale_amount FROM store_sales\nORDER BY product_name;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 27
          }
        },
        {
          "id": "d17-c03",
          "title": "Add a source column",
          "description": "Combine both tables and add a source column showing where each row came from - 'online' for online_sales and 'store' for store_sales. Return product_name, sale_amount, sale_date, and source.",
          "tier": "core",
          "difficulty": 2,
          "hint": "Add a literal string column in each SELECT: SELECT ..., 'online' AS source FROM online_sales",
          "solution": "SELECT product_name, sale_amount, sale_date, 'online' AS source\nFROM online_sales\nUNION ALL\nSELECT product_name, sale_amount, sale_date, 'store' AS source\nFROM store_sales\nORDER BY sale_date;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "product_name",
              "sale_amount",
              "sale_date",
              "source"
            ],
            "expectedRowCount": 27
          }
        },
        {
          "id": "d17-c04",
          "title": "UNION with WHERE filters",
          "description": "Show all Wireless Headphones sales from online_sales, and all Running Shoes sales from store_sales, in one result. Return product_name, sale_amount, and sale_date.",
          "tier": "core",
          "difficulty": 2,
          "hint": "Apply a different WHERE clause to each SELECT before the UNION.",
          "solution": "SELECT product_name, sale_amount, sale_date\nFROM online_sales\nWHERE product_name = 'Wireless Headphones'\n\nUNION ALL\n\nSELECT product_name, sale_amount, sale_date\nFROM store_sales\nWHERE product_name = 'Running Shoes'\nORDER BY sale_date;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0 && rows.every(r => r.product_name === 'Wireless Headphones' || r.product_name === 'Running Shoes')"
          }
        },
        {
          "id": "d17-c05",
          "title": "Combined total by product",
          "description": "Across both tables, calculate the total sale_amount for each product. Return product_name and total_revenue, ordered by total_revenue descending.",
          "tier": "core",
          "difficulty": 2,
          "hint": "Wrap a UNION ALL in a subquery (or CTE), then GROUP BY product_name.",
          "solution": "SELECT\n  product_name,\n  ROUND(SUM(sale_amount)::numeric, 2) AS total_revenue\nFROM (\n  SELECT product_name, sale_amount FROM online_sales\n  UNION ALL\n  SELECT product_name, sale_amount FROM store_sales\n) AS combined\nGROUP BY product_name\nORDER BY total_revenue DESC;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "total_revenue",
            "direction": "desc"
          }
        },
        {
          "id": "d17-c06",
          "title": "Products sold in both channels",
          "description": "Find product names that appear in both online_sales AND store_sales. Return each product name once.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "Use INTERSECT, or use a subquery with IN, or self-join distinct product lists.",
          "solution": "SELECT DISTINCT product_name\nFROM online_sales\nWHERE product_name IN (SELECT product_name FROM store_sales)\nORDER BY product_name;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0 && rows.every(r => r.product_name)"
          }
        }
      ]
    },
    {
      "day": 18,
      "title": "Normalisation & Denormalisation",
      "slug": "normalisation-and-denormalisation",
      "week": 3,
      "weekLabel": "JOINs & Relational Data",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-18",
      "seedSQL": "\nCREATE TABLE IF NOT EXISTS flat_orders (\n  order_id         INTEGER PRIMARY KEY,\n  customer_name    TEXT,\n  customer_email   TEXT,\n  customer_city    TEXT,\n  product_name     TEXT,\n  product_category TEXT,\n  product_price    REAL,\n  quantity         INTEGER,\n  order_date       TEXT\n);\n\nINSERT INTO flat_orders VALUES\n  (1,  'Claire Watkins',  'claire@email.com',   'Leeds',       'Wireless Mouse',    'Electronics',  29.99, 1, '2024-01-10'),\n  (2,  'Marcus Obi',      'marcus@email.com',   'Lagos',       'USB-C Hub',         'Electronics',  49.99, 2, '2024-01-11'),\n  (3,  'Claire Watkins',  'claire@email.com',   'Leeds',       'Laptop Stand',      'Accessories',  39.99, 1, '2024-01-13'),\n  (4,  'Sana Patel',      'sana@email.com',     'Birmingham',  'Wireless Mouse',    'Electronics',  29.99, 1, '2024-01-14'),\n  (5,  'Tom Fletcher',    'tom@email.com',      'Manchester',  'Keyboard',          'Electronics',  79.99, 1, '2024-01-15'),\n  (6,  'Marcus Obi',      'marcus@email.com',   'Lagos',       'Monitor',           'Electronics', 249.99, 1, '2024-01-16'),\n  (7,  'Claire Watkins',  'claire.w@email.com', 'Leeds',       'Webcam',            'Electronics',  59.99, 1, '2024-01-17'),\n  (8,  'Aisha Nkrumah',   'aisha@email.com',    'Accra',       'USB-C Hub',         'Electronics',  49.99, 3, '2024-01-18'),\n  (9,  'Tom Fletcher',    'tom@email.com',       'Manchester', 'Laptop Stand',      'Accessories',  39.99, 2, '2024-01-19'),\n  (10, 'Sana Patel',      'sana@email.com',     'Birmingham',  'Webcam',            'Electronics',  59.99, 1, '2024-01-20'),\n  (11, 'Claire Watkins',  'claire@email.com',   'Leeds',       'Wireless Mouse',    'Electronics',  29.99, 2, '2024-01-21'),\n  (12, 'Yusuf Ibrahim',   'yusuf@email.com',    'Kano',        'Keyboard',          'Electronics',  79.99, 1, '2024-01-22'),\n  (13, 'Marcus Obi',      'marcus2@email.com',  'Lagos',       'Monitor',           'Electronics', 249.99, 1, '2024-01-23'),\n  (14, 'Aisha Nkrumah',   'aisha@email.com',    'Accra',       'Laptop Stand',      'Accessories',  39.99, 1, '2024-01-24'),\n  (15, 'Tom Fletcher',    'tom@email.com',      'Manchester',  'Wireless Mouse',    'Electronics',  29.99, 3, '2024-01-25'),\n  (16, 'Sana Patel',      'sana@email.com',     'Birmingham',  'Keyboard',          'Electronics',  79.99, 1, '2024-01-26'),\n  (17, 'Yusuf Ibrahim',   'yusuf@email.com',    'Kano',        'USB-C Hub',         'Electronics',  49.99, 2, '2024-01-27'),\n  (18, 'Claire Watkins',  'claire@email.com',   'Leeds',       'Webcam',            'Electronics',  59.99, 1, '2024-01-28'),\n  (19, 'Aisha Nkrumah',   'aisha@email.com',    'Accra',       'Monitor',           'Electronics', 249.99, 1, '2024-01-29'),\n  (20, 'Marcus Obi',      'marcus@email.com',   'Lagos',       'Keyboard',          'Electronics',  79.99, 1, '2024-01-30');\n",
      "tables": [
        {
          "name": "flat_orders",
          "columns": [
            {
              "name": "order_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "customer_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "customer_email",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "customer_city",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "product_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "product_category",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "product_price",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "quantity",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "order_date",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 20
        }
      ],
      "quickInsert": [
        "SELECT DISTINCT",
        "GROUP BY",
        "COUNT"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d18-c01",
          "title": "Spot repeated customer data",
          "description": "List each distinct customer_name alongside how many times their data appears in the table (as order_count). Order by order_count descending. This shows how much data is repeated.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "GROUP BY customer_name, COUNT(*).",
          "solution": "SELECT\n  customer_name,\n  COUNT(*) AS order_count\nFROM flat_orders\nGROUP BY customer_name\nORDER BY order_count DESC;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "order_count",
            "direction": "desc"
          }
        },
        {
          "id": "d18-c02",
          "title": "Count distinct customers",
          "description": "How many distinct customers (by customer_name) are in the table? Return a single column called distinct_customers.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "Use COUNT(DISTINCT customer_name).",
          "solution": "SELECT COUNT(DISTINCT customer_name) AS distinct_customers\nFROM flat_orders;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 1
          }
        },
        {
          "id": "d18-c03",
          "title": "Data anomaly - same name, different email",
          "description": "Find customers who appear with more than one distinct email address - a sign of dirty data. Return customer_name and the count of distinct emails (as email_count).",
          "tier": "core",
          "difficulty": 2,
          "hint": "GROUP BY customer_name, HAVING COUNT(DISTINCT customer_email) > 1.",
          "solution": "SELECT\n  customer_name,\n  COUNT(DISTINCT customer_email) AS email_count\nFROM flat_orders\nGROUP BY customer_name\nHAVING COUNT(DISTINCT customer_email) > 1\nORDER BY email_count DESC;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0 && rows.every(r => r.email_count > 1)"
          }
        },
        {
          "id": "d18-c04",
          "title": "Redundancy count",
          "description": "Calculate the total number of rows in the table (as total_rows) and how many distinct products there are (as distinct_products). Use these to estimate how many times each product's data is unnecessarily repeated.",
          "tier": "core",
          "difficulty": 2,
          "hint": "SELECT COUNT(*) AS total_rows, COUNT(DISTINCT product_name) AS distinct_products FROM flat_orders.",
          "solution": "SELECT\n  COUNT(*)                      AS total_rows,\n  COUNT(DISTINCT product_name)  AS distinct_products,\n  COUNT(DISTINCT customer_name) AS distinct_customers,\n  COUNT(*) - COUNT(DISTINCT product_name) AS product_row_redundancy\nFROM flat_orders;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 1
          }
        },
        {
          "id": "d18-c05",
          "title": "Which columns would normalise into their own table?",
          "description": "To understand normalisation, find all distinct product_name + product_category + product_price combinations. This is what a normalised 'products' table would look like. Return the three columns, ordered by product_name.",
          "tier": "stretch",
          "difficulty": 2,
          "hint": "SELECT DISTINCT product_name, product_category, product_price FROM flat_orders.",
          "solution": "SELECT DISTINCT\n  product_name,\n  product_category,\n  product_price\nFROM flat_orders\nORDER BY product_name;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0 && rows.every(r => r.product_name && r.product_category && r.product_price)"
          }
        }
      ]
    },
    {
      "day": 19,
      "title": "Recursive CTEs",
      "slug": "recursive-ctes",
      "week": 3,
      "weekLabel": "JOINs & Relational Data",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-19",
      "seedSQL": "\nCREATE TABLE IF NOT EXISTS org_chart (\n  emp_id     INTEGER PRIMARY KEY,\n  emp_name   TEXT    NOT NULL,\n  role       TEXT,\n  manager_id INTEGER\n);\n\nCREATE TABLE IF NOT EXISTS categories (\n  cat_id    INTEGER PRIMARY KEY,\n  cat_name  TEXT    NOT NULL,\n  parent_id INTEGER\n);\n\nINSERT INTO org_chart VALUES\n  (1,  'Helen Brooks',    'CEO',                  NULL),\n  (2,  'Kevin Mensah',    'VP Engineering',       1),\n  (3,  'Anya Kowalski',   'VP Product',           1),\n  (4,  'Ravi Sharma',     'Engineering Manager',  2),\n  (5,  'Leila Farouk',    'Product Manager',      3),\n  (6,  'Brendan Walsh',   'Senior Engineer',      4),\n  (7,  'Chioma Eze',      'Senior Engineer',      4),\n  (8,  'Noah Kim',        'Junior Engineer',      6),\n  (9,  'Isabelle Durand', 'UX Designer',          5),\n  (10, 'Ahmad Al-Hasan',  'Data Engineer',        4),\n  (11, 'Niamh O''Brien',  'Product Analyst',      5),\n  (12, 'Daniel Reyes',    'Junior Engineer',      7);\n\nINSERT INTO categories VALUES\n  (1,  'Electronics',    NULL),\n  (2,  'Clothing',       NULL),\n  (3,  'Laptops',        1),\n  (4,  'Phones',         1),\n  (5,  'Men''s',         2),\n  (6,  'Women''s',       2),\n  (7,  'Gaming Laptops', 3),\n  (8,  'Ultrabooks',     3),\n  (9,  'Android',        4),\n  (10, 'iOS',            4);\n",
      "tables": [
        {
          "name": "org_chart",
          "columns": [
            {
              "name": "emp_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "emp_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "role",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "manager_id",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 12
        },
        {
          "name": "categories",
          "columns": [
            {
              "name": "cat_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "cat_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "parent_id",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 10
        }
      ],
      "quickInsert": [
        "WITH RECURSIVE",
        "UNION ALL",
        "AS"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d19-c01",
          "title": "Basic recursive hierarchy",
          "description": "Use a recursive CTE to walk the org_chart from the CEO downward. Return emp_id, emp_name, role, and manager_id for all employees in hierarchy order.",
          "tier": "starter",
          "difficulty": 2,
          "hint": "Anchor: SELECT from org_chart WHERE manager_id IS NULL. Recursive: JOIN org_chart on manager_id = previous.emp_id.",
          "solution": "WITH RECURSIVE org_tree AS (\n  -- anchor: start at the top\n  SELECT emp_id, emp_name, role, manager_id\n  FROM org_chart\n  WHERE manager_id IS NULL\n\n  UNION ALL\n\n  -- recursive: join employees whose manager is already in the tree\n  SELECT e.emp_id, e.emp_name, e.role, e.manager_id\n  FROM org_chart e\n  JOIN org_tree ot ON e.manager_id = ot.emp_id\n)\nSELECT emp_id, emp_name, role, manager_id\nFROM org_tree;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 12
          }
        },
        {
          "id": "d19-c02",
          "title": "Full reporting chain with level",
          "description": "Show every employee with their hierarchy level (CEO = 1, VP = 2, etc.) and their manager's name. Return emp_name, level, and manager_name (NULL for the CEO).",
          "tier": "core",
          "difficulty": 3,
          "hint": "Add a level column (starting at 1) to the anchor SELECT and increment it by 1 in the recursive part. Self-join to get manager name.",
          "solution": "WITH RECURSIVE org_tree AS (\n  SELECT\n    emp_id,\n    emp_name,\n    manager_id,\n    1 AS level\n  FROM org_chart\n  WHERE manager_id IS NULL\n\n  UNION ALL\n\n  SELECT\n    e.emp_id,\n    e.emp_name,\n    e.manager_id,\n    ot.level + 1\n  FROM org_chart e\n  JOIN org_tree ot ON e.manager_id = ot.emp_id\n)\nSELECT\n  ot.emp_name,\n  ot.level,\n  m.emp_name AS manager_name\nFROM org_tree ot\nLEFT JOIN org_chart m ON ot.manager_id = m.emp_id\nORDER BY ot.level, ot.emp_name;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "emp_name",
              "level",
              "manager_name"
            ],
            "expectedRowCount": 12
          }
        },
        {
          "id": "d19-c03",
          "title": "Count levels deep",
          "description": "How many distinct hierarchy levels exist in the org chart? Return a single value called max_level.",
          "tier": "core",
          "difficulty": 2,
          "hint": "Wrap the recursive CTE and use MAX(level).",
          "solution": "WITH RECURSIVE org_tree AS (\n  SELECT emp_id, 1 AS level\n  FROM org_chart\n  WHERE manager_id IS NULL\n\n  UNION ALL\n\n  SELECT e.emp_id, ot.level + 1\n  FROM org_chart e\n  JOIN org_tree ot ON e.manager_id = ot.emp_id\n)\nSELECT MAX(level) AS max_level\nFROM org_tree;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 1
          }
        },
        {
          "id": "d19-c04",
          "title": "Category tree traversal",
          "description": "Use a recursive CTE to display the full category hierarchy. Show cat_name and a path string like 'Electronics > Laptops > Gaming Laptops'. Return cat_name and path, ordered by path.",
          "tier": "core",
          "difficulty": 3,
          "hint": "Anchor: WHERE parent_id IS NULL, path = cat_name. Recursive: path = previous.path || ' > ' || cat_name.",
          "solution": "WITH RECURSIVE cat_tree AS (\n  SELECT cat_id, cat_name, parent_id, cat_name AS path\n  FROM categories\n  WHERE parent_id IS NULL\n\n  UNION ALL\n\n  SELECT c.cat_id, c.cat_name, c.parent_id,\n         ct.path || ' > ' || c.cat_name\n  FROM categories c\n  JOIN cat_tree ct ON c.parent_id = ct.cat_id\n)\nSELECT cat_name, path\nFROM cat_tree\nORDER BY path;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "cat_name",
              "path"
            ],
            "expectedRowCount": 10
          }
        },
        {
          "id": "d19-c05",
          "title": "All descendants of a node",
          "description": "Find all categories that are descendants of 'Electronics' (not including Electronics itself). Return cat_name and parent_id.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "Anchor: start from children of Electronics (parent_id = Electronics cat_id). Recursive: keep joining children.",
          "solution": "WITH RECURSIVE descendants AS (\n  -- anchor: direct children of Electronics (cat_id = 1)\n  SELECT cat_id, cat_name, parent_id\n  FROM categories\n  WHERE parent_id = 1\n\n  UNION ALL\n\n  SELECT c.cat_id, c.cat_name, c.parent_id\n  FROM categories c\n  JOIN descendants d ON c.parent_id = d.cat_id\n)\nSELECT cat_name, parent_id\nFROM descendants\nORDER BY cat_name;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0"
          }
        },
        {
          "id": "d19-c06",
          "title": "Generate a number sequence",
          "description": "Use a recursive CTE to generate a sequence of numbers from 1 to 20. Return a single column called n.",
          "tier": "stretch",
          "difficulty": 2,
          "hint": "Anchor: SELECT 1 AS n. Recursive: SELECT n + 1 WHERE n < 20.",
          "solution": "WITH RECURSIVE nums AS (\n  SELECT 1 AS n\n\n  UNION ALL\n\n  SELECT n + 1\n  FROM nums\n  WHERE n < 20\n)\nSELECT n FROM nums;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 20
          }
        }
      ]
    },
    {
      "day": 20,
      "title": "Data Modelling (Star Schema)",
      "slug": "data-modelling-star-schema",
      "week": 3,
      "weekLabel": "JOINs & Relational Data",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-20",
      "seedSQL": "\nCREATE TABLE IF NOT EXISTS dim_date (\n  date_key    INTEGER PRIMARY KEY,\n  full_date   TEXT,\n  day_of_week TEXT,\n  month_name  TEXT,\n  quarter     INTEGER,\n  year        INTEGER\n);\n\nCREATE TABLE IF NOT EXISTS dim_product (\n  product_key  INTEGER PRIMARY KEY,\n  product_name TEXT,\n  category     TEXT,\n  brand        TEXT\n);\n\nCREATE TABLE IF NOT EXISTS dim_store (\n  store_key  INTEGER PRIMARY KEY,\n  store_name TEXT,\n  city       TEXT,\n  region     TEXT\n);\n\nCREATE TABLE IF NOT EXISTS fact_sales (\n  sale_key    INTEGER PRIMARY KEY,\n  date_key    INTEGER,\n  product_key INTEGER,\n  store_key   INTEGER,\n  quantity    INTEGER,\n  unit_price  REAL,\n  total_amount REAL\n);\n\nINSERT INTO dim_date VALUES\n  (20240101, '2024-01-01', 'Monday',    'January',  1, 2024),\n  (20240108, '2024-01-08', 'Monday',    'January',  1, 2024),\n  (20240115, '2024-01-15', 'Monday',    'January',  1, 2024),\n  (20240122, '2024-01-22', 'Monday',    'January',  1, 2024),\n  (20240129, '2024-01-29', 'Monday',    'January',  1, 2024),\n  (20240205, '2024-02-05', 'Monday',    'February', 1, 2024),\n  (20240212, '2024-02-12', 'Monday',    'February', 1, 2024),\n  (20240219, '2024-02-19', 'Monday',    'February', 1, 2024),\n  (20240226, '2024-02-26', 'Monday',    'February', 1, 2024),\n  (20240304, '2024-03-04', 'Monday',    'March',    1, 2024),\n  (20240311, '2024-03-11', 'Monday',    'March',    1, 2024),\n  (20240318, '2024-03-18', 'Monday',    'March',    1, 2024),\n  (20240325, '2024-03-25', 'Monday',    'March',    1, 2024),\n  (20240401, '2024-04-01', 'Monday',    'April',    2, 2024),\n  (20240408, '2024-04-08', 'Monday',    'April',    2, 2024),\n  (20240415, '2024-04-15', 'Monday',    'April',    2, 2024),\n  (20240422, '2024-04-22', 'Monday',    'April',    2, 2024),\n  (20240429, '2024-04-29', 'Monday',    'April',    2, 2024),\n  (20240506, '2024-05-06', 'Monday',    'May',      2, 2024),\n  (20240513, '2024-05-13', 'Monday',    'May',      2, 2024),\n  (20240520, '2024-05-20', 'Monday',    'May',      2, 2024),\n  (20240527, '2024-05-27', 'Monday',    'May',      2, 2024),\n  (20240603, '2024-06-03', 'Monday',    'June',     2, 2024),\n  (20240610, '2024-06-10', 'Monday',    'June',     2, 2024),\n  (20240617, '2024-06-17', 'Monday',    'June',     2, 2024),\n  (20240624, '2024-06-24', 'Monday',    'June',     2, 2024),\n  (20240701, '2024-07-01', 'Monday',    'July',     3, 2024),\n  (20240708, '2024-07-08', 'Monday',    'July',     3, 2024),\n  (20240715, '2024-07-15', 'Monday',    'July',     3, 2024),\n  (20240722, '2024-07-22', 'Monday',    'July',     3, 2024);\n\nINSERT INTO dim_product VALUES\n  (1,  'Wireless Mouse',    'Electronics',  'TechPro'),\n  (2,  'Mechanical Keyboard','Electronics', 'TechPro'),\n  (3,  'Monitor 27\"',        'Electronics', 'ClearView'),\n  (4,  'Laptop Stand',       'Accessories', 'DeskMate'),\n  (5,  'USB-C Hub',          'Electronics', 'TechPro'),\n  (6,  'Webcam HD',          'Electronics', 'ClearView'),\n  (7,  'Desk Mat',           'Accessories', 'DeskMate'),\n  (8,  'LED Desk Lamp',      'Accessories', 'BrightSpace'),\n  (9,  'Noise Cancelling Headphones', 'Electronics', 'SoundWave'),\n  (10, 'Ergonomic Chair Cushion',     'Accessories', 'DeskMate');\n\nINSERT INTO dim_store VALUES\n  (1, 'Kings Cross',    'London',     'South'),\n  (2, 'Piccadilly',     'Manchester', 'North'),\n  (3, 'Buchanan Street','Glasgow',    'Scotland'),\n  (4, 'Bullring',       'Birmingham', 'Midlands'),\n  (5, 'Bond Street',    'London',     'South');\n\nINSERT INTO fact_sales VALUES\n  (1,  20240101, 1,  1, 3,  29.99,  89.97),\n  (2,  20240101, 9,  2, 1, 149.99, 149.99),\n  (3,  20240108, 3,  1, 1, 399.99, 399.99),\n  (4,  20240108, 2,  3, 2,  79.99, 159.98),\n  (5,  20240115, 5,  2, 4,  49.99, 199.96),\n  (6,  20240115, 1,  4, 2,  29.99,  59.98),\n  (7,  20240122, 6,  5, 1,  69.99,  69.99),\n  (8,  20240122, 9,  1, 2, 149.99, 299.98),\n  (9,  20240129, 4,  3, 3,  39.99, 119.97),\n  (10, 20240205, 3,  4, 1, 399.99, 399.99),\n  (11, 20240205, 7,  2, 5,  24.99, 124.95),\n  (12, 20240212, 1,  5, 4,  29.99, 119.96),\n  (13, 20240212, 2,  1, 1,  79.99,  79.99),\n  (14, 20240219, 10, 3, 2,  44.99,  89.98),\n  (15, 20240219, 6,  4, 1,  69.99,  69.99),\n  (16, 20240226, 9,  2, 1, 149.99, 149.99),\n  (17, 20240304, 5,  5, 3,  49.99, 149.97),\n  (18, 20240304, 3,  1, 1, 399.99, 399.99),\n  (19, 20240311, 8,  3, 4,  34.99, 139.96),\n  (20, 20240311, 1,  2, 6,  29.99, 179.94),\n  (21, 20240318, 2,  4, 2,  79.99, 159.98),\n  (22, 20240318, 9,  5, 1, 149.99, 149.99),\n  (23, 20240325, 7,  1, 8,  24.99, 199.92),\n  (24, 20240401, 4,  2, 2,  39.99,  79.98),\n  (25, 20240401, 6,  3, 3,  69.99, 209.97),\n  (26, 20240408, 1,  4, 5,  29.99, 149.95),\n  (27, 20240408, 3,  5, 1, 399.99, 399.99),\n  (28, 20240415, 5,  1, 4,  49.99, 199.96),\n  (29, 20240415, 10, 2, 2,  44.99,  89.98),\n  (30, 20240422, 2,  3, 3,  79.99, 239.97),\n  (31, 20240422, 9,  4, 1, 149.99, 149.99),\n  (32, 20240429, 8,  5, 5,  34.99, 174.95),\n  (33, 20240506, 1,  1, 4,  29.99, 119.96),\n  (34, 20240506, 6,  2, 2,  69.99, 139.98),\n  (35, 20240513, 3,  3, 1, 399.99, 399.99),\n  (36, 20240513, 7,  4, 6,  24.99, 149.94),\n  (37, 20240520, 9,  5, 2, 149.99, 299.98),\n  (38, 20240520, 2,  1, 2,  79.99, 159.98),\n  (39, 20240527, 5,  2, 3,  49.99, 149.97),\n  (40, 20240527, 4,  3, 4,  39.99, 159.96),\n  (41, 20240603, 1,  4, 8,  29.99, 239.92),\n  (42, 20240603, 10, 5, 2,  44.99,  89.98),\n  (43, 20240610, 3,  1, 1, 399.99, 399.99),\n  (44, 20240610, 8,  2, 3,  34.99, 104.97),\n  (45, 20240617, 9,  3, 2, 149.99, 299.98),\n  (46, 20240617, 6,  4, 4,  69.99, 279.96),\n  (47, 20240624, 2,  5, 2,  79.99, 159.98),\n  (48, 20240624, 7,  1, 5,  24.99, 124.95),\n  (49, 20240701, 1,  2, 6,  29.99, 179.94),\n  (50, 20240708, 9,  3, 1, 149.99, 149.99);\n",
      "tables": [
        {
          "name": "dim_date",
          "columns": [
            {
              "name": "date_key",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "full_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "day_of_week",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "month_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "quarter",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "year",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 30
        },
        {
          "name": "dim_product",
          "columns": [
            {
              "name": "product_key",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "product_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "category",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "brand",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 10
        },
        {
          "name": "dim_store",
          "columns": [
            {
              "name": "store_key",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "store_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "city",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "region",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 5
        },
        {
          "name": "fact_sales",
          "columns": [
            {
              "name": "sale_key",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "date_key",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "product_key",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "store_key",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "quantity",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "unit_price",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "total_amount",
              "type": "REAL",
              "pk": false
            }
          ],
          "rowCount": 50
        }
      ],
      "quickInsert": [
        "JOIN",
        "GROUP BY",
        "SUM",
        "WHERE"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d20-c01",
          "title": "Explore the star schema",
          "description": "Get a feel for the data. Show the first 10 rows of fact_sales joined to dim_product. Return sale_key, full_date (join dim_date), product_name, quantity, and total_amount.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "JOIN fact_sales to dim_date ON date_key and to dim_product ON product_key. LIMIT 10.",
          "solution": "SELECT\n  f.sale_key,\n  d.full_date,\n  p.product_name,\n  f.quantity,\n  f.total_amount\nFROM fact_sales f\nJOIN dim_date    d ON f.date_key    = d.date_key\nJOIN dim_product p ON f.product_key = p.product_key\nORDER BY f.sale_key\nLIMIT 10;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 10
          }
        },
        {
          "id": "d20-c02",
          "title": "Join fact to one dimension",
          "description": "Show total revenue by store. Join fact_sales to dim_store and return store_name, city, and total_revenue (sum of total_amount rounded to 2 dp). Order by total_revenue descending.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "JOIN fact_sales f to dim_store s ON f.store_key = s.store_key. GROUP BY store_name, city.",
          "solution": "SELECT\n  s.store_name,\n  s.city,\n  ROUND(SUM(f.total_amount)::numeric, 2) AS total_revenue\nFROM fact_sales f\nJOIN dim_store s ON f.store_key = s.store_key\nGROUP BY s.store_name, s.city\nORDER BY total_revenue DESC;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "total_revenue",
            "direction": "desc"
          }
        },
        {
          "id": "d20-c03",
          "title": "Full star JOIN",
          "description": "Join fact_sales to all three dimension tables. Return month_name, product_name, city, total quantity sold, and total revenue. Order by month_name then product_name.",
          "tier": "core",
          "difficulty": 2,
          "hint": "JOIN dim_date, dim_product, and dim_store all to fact_sales. GROUP BY month_name, product_name, city.",
          "solution": "SELECT\n  d.month_name,\n  p.product_name,\n  s.city,\n  SUM(f.quantity)                AS total_quantity,\n  ROUND(SUM(f.total_amount)::numeric, 2)  AS total_revenue\nFROM fact_sales f\nJOIN dim_date    d ON f.date_key    = d.date_key\nJOIN dim_product p ON f.product_key = p.product_key\nJOIN dim_store   s ON f.store_key   = s.store_key\nGROUP BY d.month_name, p.product_name, s.city\nORDER BY d.month_name, p.product_name;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0 && !!rows[0].month_name && !!rows[0].product_name && !!rows[0].city"
          }
        },
        {
          "id": "d20-c04",
          "title": "Aggregate by time",
          "description": "Show total revenue per month_name and quarter, ordered chronologically (by the first date_key in each month). Return quarter, month_name, and monthly_revenue.",
          "tier": "core",
          "difficulty": 2,
          "hint": "JOIN dim_date, GROUP BY quarter and month_name. Use MIN(d.date_key) to sort correctly.",
          "solution": "SELECT\n  d.quarter,\n  d.month_name,\n  ROUND(SUM(f.total_amount)::numeric, 2) AS monthly_revenue\nFROM fact_sales f\nJOIN dim_date d ON f.date_key = d.date_key\nGROUP BY d.quarter, d.month_name\nORDER BY MIN(d.date_key);",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "quarter",
              "month_name",
              "monthly_revenue"
            ],
            "expectedRowCount": 7
          }
        },
        {
          "id": "d20-c05",
          "title": "Aggregate by product and region",
          "description": "Show total revenue broken down by product category and store region. Return category, region, and total_revenue ordered by total_revenue descending.",
          "tier": "core",
          "difficulty": 2,
          "hint": "JOIN dim_product and dim_store. GROUP BY category and region.",
          "solution": "SELECT\n  p.category,\n  s.region,\n  ROUND(SUM(f.total_amount)::numeric, 2) AS total_revenue\nFROM fact_sales f\nJOIN dim_product p ON f.product_key = p.product_key\nJOIN dim_store   s ON f.store_key   = s.store_key\nGROUP BY p.category, s.region\nORDER BY total_revenue DESC;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "total_revenue",
            "direction": "desc"
          }
        },
        {
          "id": "d20-c06",
          "title": "Top performers query",
          "description": "Find the top 5 best-selling products by total revenue across all stores and dates. Return product_name, brand, total_quantity sold, and total_revenue. Order by total_revenue descending.",
          "tier": "stretch",
          "difficulty": 2,
          "hint": "JOIN fact_sales to dim_product. GROUP BY product_name, brand. LIMIT 5.",
          "solution": "SELECT\n  p.product_name,\n  p.brand,\n  SUM(f.quantity)               AS total_quantity,\n  ROUND(SUM(f.total_amount)::numeric, 2) AS total_revenue\nFROM fact_sales f\nJOIN dim_product p ON f.product_key = p.product_key\nGROUP BY p.product_name, p.brand\nORDER BY total_revenue DESC\nLIMIT 5;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 5
          }
        }
      ]
    },
    {
      "day": 21,
      "title": "Project: SaaS Trial-to-Paid Conversion",
      "slug": "project-saas-trial-conversion",
      "week": 3,
      "weekLabel": "JOINs & Relational Data",
      "type": "project",
      "youtubeId": null,
      "githubPath": "day-21",
      "seedSQL": "\nCREATE TABLE IF NOT EXISTS users (\n  user_id     INTEGER PRIMARY KEY,\n  user_name   TEXT    NOT NULL,\n  email       TEXT    NOT NULL,\n  signup_date TEXT    NOT NULL,\n  country     TEXT\n);\n\nCREATE TABLE IF NOT EXISTS trials (\n  trial_id    INTEGER PRIMARY KEY,\n  user_id     INTEGER NOT NULL,\n  plan_name   TEXT    NOT NULL,\n  start_date  TEXT    NOT NULL,\n  end_date    TEXT    NOT NULL,\n  converted   INTEGER NOT NULL DEFAULT 0\n);\n\nCREATE TABLE IF NOT EXISTS features_used (\n  usage_id     INTEGER PRIMARY KEY,\n  user_id      INTEGER NOT NULL,\n  feature_name TEXT    NOT NULL,\n  usage_count  INTEGER NOT NULL DEFAULT 0,\n  last_used    TEXT\n);\n\nCREATE TABLE IF NOT EXISTS subscriptions (\n  sub_id        INTEGER PRIMARY KEY,\n  user_id       INTEGER NOT NULL,\n  plan_name     TEXT    NOT NULL,\n  start_date    TEXT    NOT NULL,\n  monthly_price REAL    NOT NULL,\n  status        TEXT    NOT NULL\n);\n\nINSERT INTO users VALUES\n  (1,  'Alice Chambers',   'alice@email.com',   '2024-01-02', 'United Kingdom'),\n  (2,  'Ben Okafor',       'ben@email.com',     '2024-01-04', 'Nigeria'),\n  (3,  'Clara Hoffmann',   'clara@email.com',   '2024-01-06', 'Germany'),\n  (4,  'David Park',       'david@email.com',   '2024-01-08', 'South Korea'),\n  (5,  'Emma Walsh',       'emma@email.com',    '2024-01-10', 'Ireland'),\n  (6,  'Femi Adeyemi',     'femi@email.com',    '2024-01-12', 'Nigeria'),\n  (7,  'Grace Liu',        'grace@email.com',   '2024-01-14', 'China'),\n  (8,  'Henry Foster',     'henry@email.com',   '2024-01-16', 'United Kingdom'),\n  (9,  'Isla Macdonald',   'isla@email.com',    '2024-01-18', 'United Kingdom'),\n  (10, 'James Tanaka',     'james@email.com',   '2024-01-20', 'Japan'),\n  (11, 'Kemi Olawale',     'kemi@email.com',    '2024-01-22', 'Nigeria'),\n  (12, 'Luis Morales',     'luis@email.com',    '2024-01-24', 'Mexico'),\n  (13, 'Maya Patel',       'maya@email.com',    '2024-01-26', 'India'),\n  (14, 'Nadia Rousseau',   'nadia@email.com',   '2024-01-28', 'France'),\n  (15, 'Oliver Webb',      'oliver@email.com',  '2024-01-30', 'United Kingdom'),\n  (16, 'Priya Krishnan',   'priya@email.com',   '2024-02-01', 'India'),\n  (17, 'Rashid Al-Farsi',  'rashid@email.com',  '2024-02-03', 'UAE'),\n  (18, 'Sophie Martin',    'sophie@email.com',  '2024-02-05', 'France'),\n  (19, 'Tomas Novak',      'tomas@email.com',   '2024-02-07', 'Czech Republic'),\n  (20, 'Uma Sundaram',     'uma@email.com',     '2024-02-09', 'India');\n\nINSERT INTO trials VALUES\n  (1,  1,  'Pro',     '2024-01-02', '2024-01-16', 1),\n  (2,  2,  'Starter', '2024-01-04', '2024-01-18', 0),\n  (3,  3,  'Pro',     '2024-01-06', '2024-01-20', 1),\n  (4,  4,  'Business','2024-01-08', '2024-01-22', 1),\n  (5,  5,  'Starter', '2024-01-10', '2024-01-24', 0),\n  (6,  6,  'Pro',     '2024-01-12', '2024-01-26', 1),\n  (7,  7,  'Starter', '2024-01-14', '2024-01-28', 0),\n  (8,  8,  'Business','2024-01-16', '2024-01-30', 1),\n  (9,  9,  'Pro',     '2024-01-18', '2024-02-01', 0),\n  (10, 10, 'Starter', '2024-01-20', '2024-02-03', 1),\n  (11, 11, 'Pro',     '2024-01-22', '2024-02-05', 0),\n  (12, 12, 'Business','2024-01-24', '2024-02-07', 1),\n  (13, 13, 'Starter', '2024-01-26', '2024-02-09', 0),\n  (14, 14, 'Pro',     '2024-01-28', '2024-02-11', 1),\n  (15, 15, 'Business','2024-01-30', '2024-02-13', 0),\n  (16, 16, 'Starter', '2024-02-01', '2024-02-15', 1),\n  (17, 17, 'Pro',     '2024-02-03', '2024-02-17', 1),\n  (18, 18, 'Business','2024-02-05', '2024-02-19', 0),\n  (19, 19, 'Starter', '2024-02-07', '2024-02-21', 0),\n  (20, 20, 'Pro',     '2024-02-09', '2024-02-23', 1);\n\nINSERT INTO features_used VALUES\n  (1,  1,  'Dashboard',     45, '2024-01-15'),\n  (2,  1,  'Reports',       30, '2024-01-15'),\n  (3,  1,  'API Access',    12, '2024-01-14'),\n  (4,  2,  'Dashboard',      5, '2024-01-10'),\n  (5,  2,  'Reports',        2, '2024-01-08'),\n  (6,  3,  'Dashboard',     60, '2024-01-19'),\n  (7,  3,  'Reports',       40, '2024-01-19'),\n  (8,  3,  'Integrations',  25, '2024-01-18'),\n  (9,  4,  'Dashboard',     80, '2024-01-21'),\n  (10, 4,  'Reports',       55, '2024-01-21'),\n  (11, 4,  'API Access',    35, '2024-01-20'),\n  (12, 4,  'Integrations',  20, '2024-01-19'),\n  (13, 5,  'Dashboard',      3, '2024-01-12'),\n  (14, 6,  'Dashboard',     50, '2024-01-25'),\n  (15, 6,  'Reports',       35, '2024-01-25'),\n  (16, 6,  'Integrations',  18, '2024-01-24'),\n  (17, 7,  'Dashboard',      8, '2024-01-20'),\n  (18, 7,  'Reports',        3, '2024-01-18'),\n  (19, 8,  'Dashboard',     70, '2024-01-29'),\n  (20, 8,  'Reports',       48, '2024-01-29'),\n  (21, 8,  'API Access',    22, '2024-01-28'),\n  (22, 9,  'Dashboard',     15, '2024-01-28'),\n  (23, 9,  'Reports',        8, '2024-01-25'),\n  (24, 10, 'Dashboard',     25, '2024-02-02'),\n  (25, 10, 'Reports',       18, '2024-02-02'),\n  (26, 11, 'Dashboard',      6, '2024-01-30'),\n  (27, 12, 'Dashboard',     55, '2024-02-06'),\n  (28, 12, 'Reports',       42, '2024-02-06'),\n  (29, 12, 'Integrations',  28, '2024-02-05'),\n  (30, 13, 'Dashboard',      4, '2024-02-01'),\n  (31, 14, 'Dashboard',     65, '2024-02-10'),\n  (32, 14, 'Reports',       50, '2024-02-10'),\n  (33, 14, 'API Access',    20, '2024-02-09'),\n  (34, 15, 'Dashboard',     10, '2024-02-08'),\n  (35, 15, 'Reports',        5, '2024-02-06'),\n  (36, 16, 'Dashboard',     35, '2024-02-14'),\n  (37, 16, 'Reports',       25, '2024-02-14'),\n  (38, 17, 'Dashboard',     58, '2024-02-16'),\n  (39, 17, 'Reports',       40, '2024-02-16'),\n  (40, 17, 'Integrations',  15, '2024-02-15'),\n  (41, 18, 'Dashboard',     12, '2024-02-12'),\n  (42, 19, 'Dashboard',      2, '2024-02-09'),\n  (43, 20, 'Dashboard',     48, '2024-02-22'),\n  (44, 20, 'Reports',       38, '2024-02-22'),\n  (45, 20, 'API Access',    18, '2024-02-21'),\n  (46, 1,  'Integrations',  10, '2024-01-13'),\n  (47, 9,  'API Access',     5, '2024-01-26'),\n  (48, 10, 'API Access',    10, '2024-02-01'),\n  (49, 11, 'Reports',        3, '2024-01-28'),\n  (50, 13, 'Reports',        1, '2024-01-30'),\n  (51, 5,  'Reports',        1, '2024-01-11'),\n  (52, 7,  'Integrations',   1, '2024-01-15'),\n  (53, 18, 'Reports',        6, '2024-02-11'),\n  (54, 19, 'Reports',        1, '2024-02-08'),\n  (55, 2,  'API Access',     0, '2024-01-05'),\n  (56, 13, 'Integrations',   1, '2024-02-03'),\n  (57, 15, 'Integrations',   2, '2024-02-07'),\n  (58, 18, 'Integrations',   3, '2024-02-10'),\n  (59, 11, 'Integrations',   1, '2024-01-29'),\n  (60, 5,  'Integrations',   0, '2024-01-10');\n\nINSERT INTO subscriptions VALUES\n  (1,  1,  'Pro',      '2024-01-17', 49.00,  'active'),\n  (2,  3,  'Pro',      '2024-01-21', 49.00,  'active'),\n  (3,  4,  'Business', '2024-01-23', 99.00,  'active'),\n  (4,  6,  'Pro',      '2024-01-27', 49.00,  'active'),\n  (5,  8,  'Business', '2024-01-31', 99.00,  'active'),\n  (6,  10, 'Starter',  '2024-02-04', 19.00,  'cancelled'),\n  (7,  12, 'Business', '2024-02-08', 99.00,  'active'),\n  (8,  14, 'Pro',      '2024-02-12', 49.00,  'active'),\n  (9,  16, 'Starter',  '2024-02-16', 19.00,  'active'),\n  (10, 17, 'Pro',      '2024-02-18', 49.00,  'active'),\n  (11, 20, 'Pro',      '2024-02-24', 49.00,  'active'),\n  (12, 4,  'Business', '2024-03-01', 99.00,  'active');\n",
      "tables": [
        {
          "name": "users",
          "columns": [
            {
              "name": "user_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "user_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "email",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "signup_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "country",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 20
        },
        {
          "name": "trials",
          "columns": [
            {
              "name": "trial_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "user_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "plan_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "start_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "end_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "converted",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 20
        },
        {
          "name": "features_used",
          "columns": [
            {
              "name": "usage_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "user_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "feature_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "usage_count",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "last_used",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 60
        },
        {
          "name": "subscriptions",
          "columns": [
            {
              "name": "sub_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "user_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "plan_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "start_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "monthly_price",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "status",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 12
        }
      ],
      "quickInsert": [
        "JOIN",
        "LEFT JOIN",
        "CASE WHEN",
        "WITH",
        "GROUP BY"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d21-c01",
          "title": "Explore the data",
          "description": "Get oriented. Show each user's name, trial plan, trial start date, and whether they converted (converted = 1 means yes). Return user_name, plan_name, start_date, and converted.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "JOIN users to trials on user_id.",
          "solution": "SELECT\n  u.user_name,\n  t.plan_name,\n  t.start_date,\n  t.converted\nFROM users u\nJOIN trials t ON u.user_id = t.user_id\nORDER BY t.start_date;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 20
          }
        },
        {
          "id": "d21-c02",
          "title": "Join users and trials",
          "description": "Show each user's name, country, trial plan, and a readable conversion label: 'Converted' if converted = 1, 'Did not convert' if converted = 0. Return user_name, country, plan_name, and conversion_status.",
          "tier": "starter",
          "difficulty": 1,
          "hint": "Use CASE WHEN t.converted = 1 THEN 'Converted' ELSE 'Did not convert' END.",
          "solution": "SELECT\n  u.user_name,\n  u.country,\n  t.plan_name,\n  CASE WHEN t.converted = 1 THEN 'Converted'\n       ELSE 'Did not convert'\n  END AS conversion_status\nFROM users u\nJOIN trials t ON u.user_id = t.user_id\nORDER BY u.user_name;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "user_name",
              "country",
              "plan_name",
              "conversion_status"
            ],
            "expectedRowCount": 20
          }
        },
        {
          "id": "d21-c03",
          "title": "Find non-converting users",
          "description": "Use an anti-join to find users who started a trial but never converted. Return user_name, email, and country.",
          "tier": "core",
          "difficulty": 2,
          "hint": "JOIN trials and filter WHERE converted = 0. Or LEFT JOIN subscriptions WHERE sub_id IS NULL.",
          "solution": "SELECT\n  u.user_name,\n  u.email,\n  u.country\nFROM users u\nJOIN trials t ON u.user_id = t.user_id\nWHERE t.converted = 0\nORDER BY u.user_name;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0"
          }
        },
        {
          "id": "d21-c04",
          "title": "Calculate trial duration",
          "description": "For each user, calculate how many days their trial lasted (end_date minus start_date). Return user_name, plan_name, start_date, end_date, and trial_days. Order by trial_days descending.",
          "tier": "core",
          "difficulty": 2,
          "hint": "Use (end_date::date - start_date::date) for the number of days between two dates.",
          "solution": "SELECT\n  u.user_name,\n  t.plan_name,\n  t.start_date,\n  t.end_date,\n  CAST((t.end_date::date - t.start_date::date) AS INTEGER) AS trial_days\nFROM users u\nJOIN trials t ON u.user_id = t.user_id\nORDER BY trial_days DESC;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "trial_days",
            "direction": "desc"
          }
        },
        {
          "id": "d21-c05",
          "title": "Segment by feature engagement",
          "description": "For each user, calculate their total feature usage across all features (as total_usage). Segment them into: 'High' (total_usage >= 100), 'Medium' (50-99), 'Low' (below 50). Return user_name, total_usage, and engagement_tier. Order by total_usage descending.",
          "tier": "core",
          "difficulty": 2,
          "hint": "LEFT JOIN features_used, SUM(usage_count), then CASE WHEN on the total.",
          "solution": "SELECT\n  u.user_name,\n  COALESCE(SUM(f.usage_count), 0) AS total_usage,\n  CASE\n    WHEN COALESCE(SUM(f.usage_count), 0) >= 100 THEN 'High'\n    WHEN COALESCE(SUM(f.usage_count), 0) >= 50  THEN 'Medium'\n    ELSE 'Low'\n  END AS engagement_tier\nFROM users u\nLEFT JOIN features_used f ON u.user_id = f.user_id\nGROUP BY u.user_name\nORDER BY total_usage DESC;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "total_usage",
            "direction": "desc"
          }
        },
        {
          "id": "d21-c06",
          "title": "Conversion funnel CTE",
          "description": "Build a conversion funnel using a CTE. Step 1: total users who started a trial. Step 2: total who converted. Step 3: total who are currently active subscribers. Return three rows with step_name and count.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "Use three CTEs or one CTE with UNION ALL. COUNT trials, COUNT WHERE converted=1, COUNT subscriptions WHERE status='active'.",
          "solution": "WITH funnel AS (\n  SELECT 'Trial started'     AS step_name, COUNT(*) AS step_count FROM trials\n  UNION ALL\n  SELECT 'Converted to paid' AS step_name, COUNT(*) FROM trials WHERE converted = 1\n  UNION ALL\n  SELECT 'Active subscriber' AS step_name, COUNT(*) FROM subscriptions WHERE status = 'active'\n)\nSELECT step_name, step_count FROM funnel;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 3
          }
        },
        {
          "id": "d21-c07",
          "title": "Revenue by plan",
          "description": "Show total monthly recurring revenue (MRR) broken down by plan_name. Only include active subscriptions. Return plan_name, active_subscribers (count), and total_mrr (sum of monthly_price). Order by total_mrr descending.",
          "tier": "stretch",
          "difficulty": 2,
          "hint": "GROUP BY plan_name, WHERE status = 'active', SUM(monthly_price).",
          "solution": "SELECT\n  plan_name,\n  COUNT(*)           AS active_subscribers,\n  SUM(monthly_price) AS total_mrr\nFROM subscriptions\nWHERE status = 'active'\nGROUP BY plan_name\nORDER BY total_mrr DESC;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "total_mrr",
            "direction": "desc"
          }
        },
        {
          "id": "d21-c08",
          "title": "Full conversion report",
          "description": "Write a single query that shows for each user: user_name, country, trial plan_name, whether they converted (as converted_label: 'Yes'/'No'), their total feature usage (as total_usage), and their subscription status if they have one (as sub_status, NULL if none). Order by total_usage descending.",
          "tier": "stretch",
          "difficulty": 3,
          "hint": "JOIN users, trials, LEFT JOIN features_used (SUM), LEFT JOIN subscriptions. GROUP BY user-level columns.",
          "solution": "SELECT\n  u.user_name,\n  u.country,\n  t.plan_name,\n  CASE WHEN t.converted = 1 THEN 'Yes' ELSE 'No' END AS converted_label,\n  COALESCE(SUM(f.usage_count), 0)                     AS total_usage,\n  s.status                                             AS sub_status\nFROM users u\nJOIN trials        t ON u.user_id = t.user_id\nLEFT JOIN features_used f ON u.user_id = f.user_id\nLEFT JOIN subscriptions s ON u.user_id = s.user_id AND s.status = 'active'\nGROUP BY\n  u.user_name,\n  u.country,\n  t.plan_name,\n  t.converted,\n  s.status\nORDER BY total_usage DESC;",
          "resetBefore": false,
          "validation": {
            "type": "ordered",
            "column": "total_usage",
            "direction": "desc"
          }
        }
      ]
    },
    {
      "day": 22,
      "title": "Window Functions Part 1",
      "slug": "window-functions-part-1",
      "week": 4,
      "weekLabel": "Advanced Analytics & Performance",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-22",
      "seedSQL": "CREATE TABLE IF NOT EXISTS race_results (\n  result_id   INTEGER PRIMARY KEY,\n  runner_name TEXT    NOT NULL,\n  race_name   TEXT    NOT NULL,\n  finish_time_mins REAL NOT NULL,\n  age_group   TEXT    NOT NULL,\n  country     TEXT    NOT NULL\n);\n\nINSERT INTO race_results VALUES\n  (1,  'James Okafor',     '5K Sprint',     18.4, '18-29', 'Nigeria'),\n  (2,  'Sarah Mitchell',   '5K Sprint',     19.1, '30-39', 'UK'),\n  (3,  'Lucas Fernandez',  '5K Sprint',     19.1, '18-29', 'Brazil'),\n  (4,  'Amara Diallo',     '5K Sprint',     20.3, '30-39', 'Senegal'),\n  (5,  'Tom Clarke',       '5K Sprint',     20.3, '40-49', 'UK'),\n  (6,  'Yuki Tanaka',      '5K Sprint',     21.0, '18-29', 'Japan'),\n  (7,  'Fatima Al-Hassan', '5K Sprint',     21.7, '30-39', 'UAE'),\n  (8,  'Ben Adeyemi',      '5K Sprint',     22.1, '40-49', 'Nigeria'),\n  (9,  'Grace Nguyen',     '5K Sprint',     22.5, '18-29', 'Vietnam'),\n  (10, 'Rachel Stone',     '5K Sprint',     23.8, '30-39', 'UK'),\n  (11, 'James Okafor',     '10K Road',      38.2, '18-29', 'Nigeria'),\n  (12, 'Sarah Mitchell',   '10K Road',      40.5, '30-39', 'UK'),\n  (13, 'Lucas Fernandez',  '10K Road',      40.5, '18-29', 'Brazil'),\n  (14, 'Amara Diallo',     '10K Road',      41.0, '30-39', 'Senegal'),\n  (15, 'Tom Clarke',       '10K Road',      42.3, '40-49', 'UK'),\n  (16, 'Yuki Tanaka',      '10K Road',      43.1, '18-29', 'Japan'),\n  (17, 'Fatima Al-Hassan', '10K Road',      44.0, '30-39', 'UAE'),\n  (18, 'Ben Adeyemi',      '10K Road',      45.2, '40-49', 'Nigeria'),\n  (19, 'Grace Nguyen',     '10K Road',      46.7, '18-29', 'Vietnam'),\n  (20, 'Rachel Stone',     '10K Road',      48.3, '30-39', 'UK'),\n  (21, 'James Okafor',     'Half Marathon', 82.0, '18-29', 'Nigeria'),\n  (22, 'Sarah Mitchell',   'Half Marathon', 85.5, '30-39', 'UK'),\n  (23, 'Lucas Fernandez',  'Half Marathon', 85.5, '18-29', 'Brazil'),\n  (24, 'Amara Diallo',     'Half Marathon', 87.2, '30-39', 'Senegal'),\n  (25, 'Tom Clarke',       'Half Marathon', 89.0, '40-49', 'UK'),\n  (26, 'Yuki Tanaka',      'Half Marathon', 91.4, '18-29', 'Japan'),\n  (27, 'Fatima Al-Hassan', 'Half Marathon', 93.0, '30-39', 'UAE'),\n  (28, 'Ben Adeyemi',      'Half Marathon', 95.1, '40-49', 'Nigeria'),\n  (29, 'Grace Nguyen',     'Half Marathon', 97.6, '18-29', 'Vietnam'),\n  (30, 'Rachel Stone',     'Half Marathon',102.3, '30-39', 'UK');",
      "tables": [
        {
          "name": "race_results",
          "columns": [
            {
              "name": "result_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "runner_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "race_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "finish_time_mins",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "age_group",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "country",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 30
        }
      ],
      "quickInsert": [
        "ROW_NUMBER()",
        "RANK()",
        "DENSE_RANK()",
        "NTILE()",
        "OVER",
        "PARTITION BY"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d22-c01",
          "title": "ROW_NUMBER Basics",
          "description": "Assign a sequential row number to every runner in the 5K Sprint, ordered by finish_time_mins ascending. Return runner_name, finish_time_mins, and row_num.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "Use ROW_NUMBER() OVER (ORDER BY finish_time_mins) and filter to race_name = '5K Sprint'.",
          "solution": "SELECT\n  runner_name,\n  finish_time_mins,\n  ROW_NUMBER() OVER (ORDER BY finish_time_mins) AS row_num\nFROM race_results\nWHERE race_name = '5K Sprint'\nORDER BY finish_time_mins;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 10
          }
        },
        {
          "id": "d22-c02",
          "title": "RANK vs DENSE_RANK",
          "description": "For the 10K Road race, show runner_name, finish_time_mins, RANK(), and DENSE_RANK() ordered by finish_time_mins. Notice how ties are handled differently.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "RANK() leaves gaps after ties; DENSE_RANK() does not. Both use OVER (ORDER BY finish_time_mins).",
          "solution": "SELECT\n  runner_name,\n  finish_time_mins,\n  RANK()       OVER (ORDER BY finish_time_mins) AS rnk,\n  DENSE_RANK() OVER (ORDER BY finish_time_mins) AS dense_rnk\nFROM race_results\nWHERE race_name = '10K Road'\nORDER BY finish_time_mins;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "runner_name",
              "finish_time_mins",
              "rnk",
              "dense_rnk"
            ]
          }
        },
        {
          "id": "d22-c03",
          "title": "PARTITION BY Race",
          "description": "Rank all runners within each race separately using RANK(), partitioned by race_name and ordered by finish_time_mins. Return race_name, runner_name, finish_time_mins, and race_rank.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "Use RANK() OVER (PARTITION BY race_name ORDER BY finish_time_mins).",
          "solution": "SELECT\n  race_name,\n  runner_name,\n  finish_time_mins,\n  RANK() OVER (PARTITION BY race_name ORDER BY finish_time_mins) AS race_rank\nFROM race_results\nORDER BY race_name, race_rank;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 30
          }
        },
        {
          "id": "d22-c04",
          "title": "NTILE Quartiles",
          "description": "For the Half Marathon, divide runners into 4 quartiles (NTILE(4)) based on finish_time_mins ascending. Return runner_name, finish_time_mins, and quartile. The fastest runners should be in quartile 1.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "Use NTILE(4) OVER (ORDER BY finish_time_mins) and filter to the Half Marathon.",
          "solution": "SELECT\n  runner_name,\n  finish_time_mins,\n  NTILE(4) OVER (ORDER BY finish_time_mins) AS quartile\nFROM race_results\nWHERE race_name = 'Half Marathon'\nORDER BY finish_time_mins;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "runner_name",
              "finish_time_mins",
              "quartile"
            ]
          }
        },
        {
          "id": "d22-c05",
          "title": "Top Runner Per Race",
          "description": "Find the fastest runner in each race. Use ROW_NUMBER() partitioned by race_name to identify rank 1 per race, then filter to only those rows. Return race_name, runner_name, and finish_time_mins.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "Wrap the ROW_NUMBER() query in a subquery (or CTE), then filter WHERE rn = 1.",
          "solution": "SELECT race_name, runner_name, finish_time_mins\nFROM (\n  SELECT\n    race_name,\n    runner_name,\n    finish_time_mins,\n    ROW_NUMBER() OVER (PARTITION BY race_name ORDER BY finish_time_mins) AS rn\n  FROM race_results\n) ranked\nWHERE rn = 1\nORDER BY race_name;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 3
          }
        },
        {
          "id": "d22-c06",
          "title": "Ranking With Ties",
          "description": "Across all races, use DENSE_RANK() partitioned by race_name to rank runners by finish_time_mins. Then filter to only show runners who share rank 2 with at least one other runner in their race. Return race_name, runner_name, finish_time_mins, and dense_rnk.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "First find which races have ties at rank 2 using a subquery, then join back. Or use COUNT(*) OVER (PARTITION BY race_name, dense_rnk) to find groups with more than 1 runner.",
          "solution": "WITH ranked AS (\n  SELECT\n    race_name,\n    runner_name,\n    finish_time_mins,\n    DENSE_RANK() OVER (PARTITION BY race_name ORDER BY finish_time_mins) AS dense_rnk\n  FROM race_results\n),\ntie_counts AS (\n  SELECT race_name, dense_rnk, COUNT(*) AS tie_count\n  FROM ranked\n  GROUP BY race_name, dense_rnk\n)\nSELECT r.race_name, r.runner_name, r.finish_time_mins, r.dense_rnk\nFROM ranked r\nJOIN tie_counts tc ON r.race_name = tc.race_name AND r.dense_rnk = tc.dense_rnk\nWHERE r.dense_rnk = 2\n  AND tc.tie_count > 1\nORDER BY r.race_name, r.finish_time_mins;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0 && rows.every(r => r.dense_rnk === 2)"
          }
        },
        {
          "id": "d22-c07",
          "title": "Combined Ranking Analysis",
          "description": "For the 5K Sprint, show each runner's runner_name, finish_time_mins, their RANK(), DENSE_RANK(), and which NTILE(3) tercile they fall into. Order by finish_time_mins ascending.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "You can compute multiple window functions in the same SELECT. Each gets its own OVER() clause.",
          "solution": "SELECT\n  runner_name,\n  finish_time_mins,\n  RANK()       OVER (ORDER BY finish_time_mins) AS rnk,\n  DENSE_RANK() OVER (ORDER BY finish_time_mins) AS dense_rnk,\n  NTILE(3)     OVER (ORDER BY finish_time_mins) AS tercile\nFROM race_results\nWHERE race_name = '5K Sprint'\nORDER BY finish_time_mins;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "runner_name",
              "finish_time_mins",
              "rnk",
              "dense_rnk",
              "tercile"
            ]
          }
        }
      ]
    },
    {
      "day": 23,
      "title": "Window Functions Part 2",
      "slug": "window-functions-part-2",
      "week": 4,
      "weekLabel": "Advanced Analytics & Performance",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-23",
      "seedSQL": "CREATE TABLE IF NOT EXISTS daily_revenue (\n  rev_id     INTEGER PRIMARY KEY,\n  sale_date  TEXT    NOT NULL,\n  product    TEXT    NOT NULL,\n  revenue    REAL    NOT NULL,\n  units_sold INTEGER NOT NULL\n);\n\nINSERT INTO daily_revenue VALUES\n  (1,  '2024-01-01', 'Laptop', 1200.00, 2),\n  (2,  '2024-01-01', 'Phone',   450.00, 3),\n  (3,  '2024-01-02', 'Laptop',  900.00, 1),\n  (4,  '2024-01-02', 'Phone',   600.00, 4),\n  (5,  '2024-01-03', 'Laptop', 1500.00, 2),\n  (6,  '2024-01-03', 'Phone',   300.00, 2),\n  (7,  '2024-01-04', 'Laptop',  600.00, 1),\n  (8,  '2024-01-04', 'Phone',   750.00, 5),\n  (9,  '2024-01-05', 'Laptop', 1800.00, 3),\n  (10, '2024-01-05', 'Phone',   450.00, 3),\n  (11, '2024-01-06', 'Laptop',  300.00, 1),\n  (12, '2024-01-06', 'Phone',   900.00, 6),\n  (13, '2024-01-07', 'Laptop', 1200.00, 2),\n  (14, '2024-01-07', 'Phone',   600.00, 4),\n  (15, '2024-01-08', 'Laptop',  750.00, 1),\n  (16, '2024-01-08', 'Phone',   300.00, 2),\n  (17, '2024-01-09', 'Laptop', 2100.00, 3),\n  (18, '2024-01-09', 'Phone',   450.00, 3),\n  (19, '2024-01-10', 'Laptop',  900.00, 1),\n  (20, '2024-01-10', 'Phone',   750.00, 5),\n  (21, '2024-01-11', 'Laptop', 1500.00, 2),\n  (22, '2024-01-11', 'Phone',   600.00, 4),\n  (23, '2024-01-12', 'Laptop',  600.00, 1),\n  (24, '2024-01-12', 'Phone',   450.00, 3),\n  (25, '2024-01-13', 'Laptop', 1200.00, 2),\n  (26, '2024-01-13', 'Phone',   300.00, 2),\n  (27, '2024-01-14', 'Laptop',  900.00, 1),\n  (28, '2024-01-14', 'Phone',   900.00, 6),\n  (29, '2024-01-15', 'Laptop', 1800.00, 3),\n  (30, '2024-01-15', 'Phone',   750.00, 5),\n  (31, '2024-01-16', 'Laptop',  300.00, 1),\n  (32, '2024-01-16', 'Phone',   450.00, 3),\n  (33, '2024-01-17', 'Laptop', 2400.00, 4),\n  (34, '2024-01-17', 'Phone',   600.00, 4),\n  (35, '2024-01-18', 'Laptop', 1200.00, 2),\n  (36, '2024-01-18', 'Phone',   300.00, 2),\n  (37, '2024-01-19', 'Laptop',  600.00, 1),\n  (38, '2024-01-19', 'Phone',   900.00, 6),\n  (39, '2024-01-20', 'Laptop', 1500.00, 2),\n  (40, '2024-01-20', 'Phone',   750.00, 5);",
      "tables": [
        {
          "name": "daily_revenue",
          "columns": [
            {
              "name": "rev_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "sale_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "product",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "revenue",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "units_sold",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 40
        }
      ],
      "quickInsert": [
        "LAG()",
        "LEAD()",
        "SUM() OVER",
        "AVG() OVER",
        "ROWS BETWEEN"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d23-c01",
          "title": "Running Total",
          "description": "For the Laptop product, calculate a running total of revenue ordered by sale_date. Return sale_date, revenue, and running_total.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "Use SUM(revenue) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW).",
          "solution": "SELECT\n  sale_date,\n  revenue,\n  SUM(revenue) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total\nFROM daily_revenue\nWHERE product = 'Laptop'\nORDER BY sale_date;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "sale_date",
              "revenue",
              "running_total"
            ]
          }
        },
        {
          "id": "d23-c02",
          "title": "LAG for Previous Day Revenue",
          "description": "For the Phone product, show each day's revenue alongside the previous day's revenue using LAG(). Return sale_date, revenue, and prev_day_revenue. Rows with no previous day should show NULL.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "Use LAG(revenue, 1) OVER (ORDER BY sale_date) AS prev_day_revenue.",
          "solution": "SELECT\n  sale_date,\n  revenue,\n  LAG(revenue, 1) OVER (ORDER BY sale_date) AS prev_day_revenue\nFROM daily_revenue\nWHERE product = 'Phone'\nORDER BY sale_date;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "sale_date",
              "revenue",
              "prev_day_revenue"
            ]
          }
        },
        {
          "id": "d23-c03",
          "title": "LEAD for Next Day Revenue",
          "description": "For the Laptop product, show each day's revenue and the next day's revenue using LEAD(). Return sale_date, revenue, and next_day_revenue. The last row should show NULL for next_day_revenue.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "Use LEAD(revenue, 1) OVER (ORDER BY sale_date) AS next_day_revenue.",
          "solution": "SELECT\n  sale_date,\n  revenue,\n  LEAD(revenue, 1) OVER (ORDER BY sale_date) AS next_day_revenue\nFROM daily_revenue\nWHERE product = 'Laptop'\nORDER BY sale_date;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "sale_date",
              "revenue",
              "next_day_revenue"
            ]
          }
        },
        {
          "id": "d23-c04",
          "title": "Day-Over-Day Change",
          "description": "For the Phone product, calculate the day-over-day revenue change: today's revenue minus yesterday's revenue. Return sale_date, revenue, prev_revenue, and daily_change. Rows with no previous day should show NULL for daily_change.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "Use LAG() to get prev_revenue, then subtract it from revenue in the outer query using a subquery or CTE.",
          "solution": "SELECT\n  sale_date,\n  revenue,\n  LAG(revenue, 1) OVER (ORDER BY sale_date) AS prev_revenue,\n  revenue - LAG(revenue, 1) OVER (ORDER BY sale_date) AS daily_change\nFROM daily_revenue\nWHERE product = 'Phone'\nORDER BY sale_date;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "sale_date",
              "revenue",
              "prev_revenue",
              "daily_change"
            ]
          }
        },
        {
          "id": "d23-c05",
          "title": "3-Day Moving Average",
          "description": "For the Laptop product, calculate a 3-day moving average of revenue (current row plus the 2 preceding rows). Return sale_date, revenue, and moving_avg_3d rounded to 2 decimal places.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "Use AVG(revenue) OVER (ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW).",
          "solution": "SELECT\n  sale_date,\n  revenue,\n  ROUND(AVG(revenue) OVER (ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)::numeric, 2) AS moving_avg_3d\nFROM daily_revenue\nWHERE product = 'Laptop'\nORDER BY sale_date;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "sale_date",
              "revenue",
              "moving_avg_3d"
            ]
          }
        },
        {
          "id": "d23-c06",
          "title": "Cumulative Revenue Percentage",
          "description": "Across all products combined, aggregate total revenue per sale_date, then calculate each day's cumulative revenue as a percentage of the overall total. Return sale_date, daily_total, and cumulative_pct rounded to 2 decimal places.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "First aggregate SUM(revenue) per sale_date in a subquery. Then use SUM(daily_total) OVER (ORDER BY sale_date) / SUM(daily_total) OVER () * 100.",
          "solution": "SELECT\n  sale_date,\n  daily_total,\n  ROUND(\n    (SUM(daily_total) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)\n    / SUM(daily_total) OVER ()\n    * 100)::numeric,\n    2\n  ) AS cumulative_pct\nFROM (\n  SELECT sale_date, SUM(revenue) AS daily_total\n  FROM daily_revenue\n  GROUP BY sale_date\n) daily\nORDER BY sale_date;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "sale_date",
              "daily_total",
              "cumulative_pct"
            ]
          }
        },
        {
          "id": "d23-c07",
          "title": "Complex Frame Clause",
          "description": "For the Phone product, compute the revenue for each day alongside a 'centred' 3-day window average (1 row preceding, current row, 1 row following). Return sale_date, revenue, and centred_avg rounded to 2 decimal places.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "Use AVG(revenue) OVER (ORDER BY sale_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING). The first and last rows will use fewer rows.",
          "solution": "SELECT\n  sale_date,\n  revenue,\n  ROUND(AVG(revenue) OVER (ORDER BY sale_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)::numeric, 2) AS centred_avg\nFROM daily_revenue\nWHERE product = 'Phone'\nORDER BY sale_date;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "sale_date",
              "revenue",
              "centred_avg"
            ]
          }
        }
      ]
    },
    {
      "day": 24,
      "title": "SCD Types & MERGE",
      "slug": "scd-types-and-merge",
      "week": 4,
      "weekLabel": "Advanced Analytics & Performance",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-24",
      "seedSQL": "CREATE TABLE IF NOT EXISTS customer_dim (\n  customer_id   INTEGER NOT NULL,\n  customer_name TEXT    NOT NULL,\n  email         TEXT    NOT NULL,\n  city          TEXT    NOT NULL,\n  valid_from    TEXT    NOT NULL,\n  valid_to      TEXT,\n  is_current    INTEGER NOT NULL DEFAULT 1\n);\n\nINSERT INTO customer_dim VALUES\n  (1, 'Alice Brown',    'alice@example.com',   'London',     '2022-01-01', '2023-06-30', 0),\n  (1, 'Alice Brown',    'alice@newmail.com',   'London',     '2023-07-01', NULL,         1),\n  (2, 'Ben Osei',       'ben@example.com',     'Manchester', '2022-03-15', NULL,         1),\n  (3, 'Clara Holt',     'clara@example.com',   'Birmingham', '2021-11-01', '2022-09-30', 0),\n  (3, 'Clara Holt',     'clara@example.com',   'Leeds',      '2022-10-01', '2023-12-31', 0),\n  (3, 'Clara Holt',     'clara@example.com',   'Bristol',    '2024-01-01', NULL,         1),\n  (4, 'Daniel Kim',     'daniel@example.com',  'Glasgow',    '2023-02-01', NULL,         1),\n  (5, 'Esi Mensah',     'esi@example.com',     'Cardiff',    '2022-08-01', '2023-03-31', 0),\n  (5, 'Esi Mensah',     'esi@work.com',        'Cardiff',    '2023-04-01', NULL,         1),\n  (6, 'Femi Adewale',   'femi@example.com',    'London',     '2023-05-01', NULL,         1),\n  (7, 'Greta Schmidt',  'greta@example.com',   'Edinburgh',  '2021-06-15', NULL,         1),\n  (8, 'Hiroshi Yamada', 'hiroshi@example.com', 'London',     '2022-12-01', '2024-01-31', 0),\n  (8, 'Hiroshi Yamada', 'h.yamada@example.com','London',     '2024-02-01', NULL,         1),\n  (9, 'Isabel Santos',  'isabel@example.com',  'Bristol',    '2023-09-01', NULL,         1),\n  (10,'James Parker',   'james@example.com',   'Sheffield',  '2022-07-01', NULL,         1);\n\nCREATE TABLE IF NOT EXISTS customer_updates (\n  customer_id   INTEGER NOT NULL,\n  customer_name TEXT    NOT NULL,\n  email         TEXT    NOT NULL,\n  city          TEXT    NOT NULL\n);\n\nINSERT INTO customer_updates VALUES\n  (2,  'Ben Osei',      'ben.osei@newmail.com',  'Liverpool'),\n  (4,  'Daniel Kim',    'daniel@example.com',    'Aberdeen'),\n  (6,  'Femi Adewale',  'femi.a@example.com',    'London'),\n  (11, 'Kate Wilson',   'kate@example.com',      'Newcastle'),\n  (12, 'Luca Rossi',    'luca@example.com',      'London');",
      "tables": [
        {
          "name": "customer_dim",
          "columns": [
            {
              "name": "customer_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "customer_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "email",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "city",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "valid_from",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "valid_to",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "is_current",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 15
        },
        {
          "name": "customer_updates",
          "columns": [
            {
              "name": "customer_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "customer_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "email",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "city",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 5
        }
      ],
      "quickInsert": [
        "INSERT",
        "ON CONFLICT",
        "DO UPDATE",
        "WHERE is_current = 1"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d24-c01",
          "title": "Query Current Records Only",
          "description": "Retrieve only the current version of each customer from customer_dim. Return customer_id, customer_name, email, and city. Order by customer_id.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "Filter WHERE is_current = 1.",
          "solution": "SELECT customer_id, customer_name, email, city\nFROM customer_dim\nWHERE is_current = 1\nORDER BY customer_id;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 10
          }
        },
        {
          "id": "d24-c02",
          "title": "Find Customers With History",
          "description": "Find all customer_ids that have more than one row in customer_dim (i.e. they have been updated at least once). Return customer_id and version_count, ordered by version_count descending.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "GROUP BY customer_id and use HAVING COUNT(*) > 1.",
          "solution": "SELECT customer_id, COUNT(*) AS version_count\nFROM customer_dim\nGROUP BY customer_id\nHAVING COUNT(*) > 1\nORDER BY version_count DESC;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "customer_id",
              "version_count"
            ]
          }
        },
        {
          "id": "d24-c03",
          "title": "SCD Type 1 Update",
          "description": "Apply a Type 1 (overwrite) update: update the city for customer_id 4 to 'Aberdeen' in customer_dim. Then SELECT customer_id, customer_name, city, is_current FROM customer_dim WHERE customer_id = 4.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "A Type 1 update simply overwrites the value in place. Use UPDATE ... SET city = 'Aberdeen' WHERE customer_id = 4 AND is_current = 1. Then SELECT to verify.",
          "solution": "UPDATE customer_dim\nSET city = 'Aberdeen'\nWHERE customer_id = 4\n  AND is_current = 1;\n\nSELECT customer_id, customer_name, city, is_current\nFROM customer_dim\nWHERE customer_id = 4;",
          "resetBefore": true,
          "validation": {
            "type": "custom",
            "fn": "rows.length === 1 && rows[0].city === 'Aberdeen'"
          }
        },
        {
          "id": "d24-c04",
          "title": "Explore the Type 2 Pattern",
          "description": "Clara Holt (customer_id 3) has moved cities twice. Write a query showing all her versions in chronological order - customer_id, city, valid_from, valid_to, is_current - to understand how Type 2 history is stored.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "SELECT all rows for customer_id = 3 ORDER BY valid_from.",
          "solution": "SELECT customer_id, city, valid_from, valid_to, is_current\nFROM customer_dim\nWHERE customer_id = 3\nORDER BY valid_from;",
          "resetBefore": false,
          "validation": {
            "type": "row_count",
            "expected": 3
          }
        },
        {
          "id": "d24-c05",
          "title": "INSERT ON CONFLICT Upsert",
          "description": "Create a simple lookup table called city_info with columns city (TEXT PRIMARY KEY) and region (TEXT). Insert two rows: ('London', 'South East') and ('Manchester', 'North West'). Then use INSERT ... ON CONFLICT (PostgreSQL upsert) to change London's region to 'Greater London'. Finally SELECT all rows from city_info.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "PostgreSQL uses INSERT ... ON CONFLICT DO UPDATE or INSERT INTO ... ON CONFLICT(city) DO UPDATE SET region = excluded.region.",
          "solution": "CREATE TABLE IF NOT EXISTS city_info (\n  city   TEXT PRIMARY KEY,\n  region TEXT NOT NULL\n);\n\nINSERT INTO city_info VALUES ('London', 'South East'), ('Manchester', 'North West');\n\nINSERT INTO city_info (city, region) VALUES ('London', 'Greater London')\nON CONFLICT(city) DO UPDATE SET region = excluded.region;\n\nSELECT * FROM city_info;",
          "resetBefore": true,
          "validation": {
            "type": "custom",
            "fn": "rows.some(r => r.city === 'London' && r.region === 'Greater London')"
          }
        },
        {
          "id": "d24-c06",
          "title": "Historical Point-in-Time Query",
          "description": "Write a point-in-time query to find what city each customer was in on '2023-01-01'. Use customer_dim and return customer_id, customer_name, city, valid_from, valid_to for rows where the date falls within the valid range. A NULL valid_to means the record is still active.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "Filter WHERE valid_from <= '2023-01-01' AND (valid_to IS NULL OR valid_to >= '2023-01-01').",
          "solution": "SELECT customer_id, customer_name, city, valid_from, valid_to\nFROM customer_dim\nWHERE valid_from <= '2023-01-01'\n  AND (valid_to IS NULL OR valid_to >= '2023-01-01')\nORDER BY customer_id;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0 && rows.every(r => r.valid_from <= '2023-01-01')"
          }
        }
      ]
    },
    {
      "day": 25,
      "title": "Views & Materialised Views",
      "slug": "views-and-materialised-views",
      "week": 4,
      "weekLabel": "Advanced Analytics & Performance",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-25",
      "seedSQL": "CREATE TABLE IF NOT EXISTS customers (\n  customer_id   INTEGER PRIMARY KEY,\n  customer_name TEXT    NOT NULL,\n  email         TEXT    NOT NULL,\n  city          TEXT    NOT NULL,\n  signup_date   TEXT    NOT NULL\n);\n\nCREATE TABLE IF NOT EXISTS orders (\n  order_id      INTEGER PRIMARY KEY,\n  customer_id   INTEGER NOT NULL,\n  order_date    TEXT    NOT NULL,\n  total_amount  REAL    NOT NULL,\n  status        TEXT    NOT NULL,\n  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)\n);\n\nCREATE TABLE IF NOT EXISTS order_items (\n  item_id      INTEGER PRIMARY KEY,\n  order_id     INTEGER NOT NULL,\n  product_name TEXT    NOT NULL,\n  quantity     INTEGER NOT NULL,\n  unit_price   REAL    NOT NULL,\n  FOREIGN KEY (order_id) REFERENCES orders(order_id)\n);\n\nINSERT INTO customers VALUES\n  (1,  'Alice Brown',    'alice@example.com',   'London',     '2022-03-10'),\n  (2,  'Ben Osei',       'ben@example.com',     'Manchester', '2022-07-22'),\n  (3,  'Clara Holt',     'clara@example.com',   'Bristol',    '2023-01-05'),\n  (4,  'Daniel Kim',     'daniel@example.com',  'Glasgow',    '2023-04-18'),\n  (5,  'Esi Mensah',     'esi@example.com',     'Cardiff',    '2021-11-30'),\n  (6,  'Femi Adewale',   'femi@example.com',    'London',     '2023-08-14'),\n  (7,  'Greta Schmidt',  'greta@example.com',   'Edinburgh',  '2022-05-09'),\n  (8,  'Hiroshi Yamada', 'hiroshi@example.com', 'London',     '2024-01-01'),\n  (9,  'Isabel Santos',  'isabel@example.com',  'Bristol',    '2023-11-20'),\n  (10, 'James Parker',   'james@example.com',   'Sheffield',  '2022-09-03');\n\nINSERT INTO orders VALUES\n  (1,  1, '2024-01-05', 250.00, 'Completed'),\n  (2,  1, '2024-02-10', 120.00, 'Completed'),\n  (3,  2, '2024-01-18',  85.50, 'Completed'),\n  (4,  2, '2024-03-02', 340.00, 'Pending'),\n  (5,  3, '2024-01-22', 199.99, 'Completed'),\n  (6,  4, '2024-02-14',  60.00, 'Cancelled'),\n  (7,  4, '2024-03-10', 175.50, 'Completed'),\n  (8,  5, '2024-01-08', 480.00, 'Completed'),\n  (9,  5, '2024-02-28', 220.00, 'Completed'),\n  (10, 5, '2024-03-15',  95.00, 'Pending'),\n  (11, 6, '2024-02-01', 310.00, 'Completed'),\n  (12, 7, '2024-01-30', 140.00, 'Completed'),\n  (13, 7, '2024-03-08', 260.00, 'Pending'),\n  (14, 8, '2024-02-20', 510.00, 'Completed'),\n  (15, 9, '2024-01-12',  75.00, 'Completed'),\n  (16, 9, '2024-03-22', 330.00, 'Completed'),\n  (17, 10,'2024-01-25', 415.00, 'Completed'),\n  (18, 10,'2024-02-17',  50.00, 'Cancelled'),\n  (19, 1, '2024-03-28', 180.00, 'Pending'),\n  (20, 3, '2024-03-30', 125.00, 'Completed'),\n  (21, 6, '2024-03-05', 290.00, 'Completed'),\n  (22, 8, '2024-03-12', 640.00, 'Completed'),\n  (23, 2, '2024-04-01', 110.00, 'Completed'),\n  (24, 5, '2024-04-05', 375.00, 'Pending'),\n  (25, 7, '2024-04-08', 195.00, 'Completed');\n\nINSERT INTO order_items VALUES\n  (1,  1,  'Keyboard',   1, 120.00),\n  (2,  1,  'Mouse',      1,  45.00),\n  (3,  1,  'USB Hub',    1,  85.00),\n  (4,  2,  'Mouse Pad',  2,  30.00),\n  (5,  2,  'Cable',      3,  20.00),\n  (6,  3,  'Webcam',     1,  85.50),\n  (7,  4,  'Monitor',    1, 340.00),\n  (8,  5,  'Headset',    1, 199.99),\n  (9,  6,  'Notebook',   3,  20.00),\n  (10, 7,  'Keyboard',   1, 120.00),\n  (11, 7,  'Mouse',      1,  45.00),\n  (12, 7,  'Wrist Rest', 1,  10.50),\n  (13, 8,  'Tablet',     1, 480.00),\n  (14, 9,  'Stylus',     2, 110.00),\n  (15, 10, 'Phone Stand',1,  95.00),\n  (16, 11, 'Laptop Bag', 1, 310.00),\n  (17, 12, 'SSD 256GB',  1, 140.00),\n  (18, 13, 'SSD 512GB',  1, 260.00),\n  (19, 14, 'Smart Watch',1, 510.00),\n  (20, 15, 'Charger',    1,  75.00),\n  (21, 16, 'Laptop Stand',1, 330.00),\n  (22, 17, 'External HDD',1, 415.00),\n  (23, 18, 'Screen Cloth',2,  25.00),\n  (24, 19, 'Keyboard',   1, 120.00),\n  (25, 19, 'Mouse',      1,  45.00),\n  (26, 19, 'Cables',     3,   5.00),\n  (27, 20, 'Mouse',      1,  45.00),\n  (28, 20, 'Mouse Pad',  2,  40.00),\n  (29, 21, 'Webcam',     1, 290.00),\n  (30, 22, 'Monitor',    2, 320.00),\n  (31, 23, 'USB Hub',    1, 110.00),\n  (32, 24, 'Tablet',     1, 375.00),\n  (33, 25, 'Keyboard',   1, 120.00),\n  (34, 25, 'Mouse',      1,  45.00),\n  (35, 25, 'USB Hub',    1,  30.00),\n  (36, 2,  'Cables',     5,  14.00),\n  (37, 3,  'Adaptor',    1,  85.00),\n  (38, 4,  'USB Hub',    1,  60.00),\n  (39, 5,  'Notebook',   4,   8.75),\n  (40, 6,  'Charger',    2,  30.00),\n  (41, 7,  'Notebook',   1,  10.00),\n  (42, 8,  'Phone Case', 1,  95.00),\n  (43, 9,  'Webcam',     1, 185.00),\n  (44, 10, 'Keyboard',   1, 120.00),\n  (45, 11, 'Headset',    1, 140.00),\n  (46, 12, 'SSD 128GB',  1,  90.00),\n  (47, 13, 'SSD 256GB',  1, 140.00),\n  (48, 14, 'Laptop Stand',1, 120.00),\n  (49, 15, 'Mouse Pad',  1,  18.00),\n  (50, 16, 'USB-C Hub',  1, 155.00);",
      "tables": [
        {
          "name": "customers",
          "columns": [
            {
              "name": "customer_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "customer_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "email",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "city",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "signup_date",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 10
        },
        {
          "name": "orders",
          "columns": [
            {
              "name": "order_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "customer_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "order_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "total_amount",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "status",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 25
        },
        {
          "name": "order_items",
          "columns": [
            {
              "name": "item_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "order_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "product_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "quantity",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "unit_price",
              "type": "REAL",
              "pk": false
            }
          ],
          "rowCount": 50
        }
      ],
      "quickInsert": [
        "CREATE VIEW",
        "AS SELECT",
        "DROP VIEW"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d25-c01",
          "title": "Create a Simple View",
          "description": "Create a view called v_london_customers that returns customer_id, customer_name, and email for all customers whose city is 'London'. Then SELECT all rows from the view.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "CREATE VIEW v_london_customers AS SELECT ... FROM customers WHERE city = 'London'.",
          "solution": "CREATE VIEW v_london_customers AS\nSELECT customer_id, customer_name, email\nFROM customers\nWHERE city = 'London';\n\nSELECT * FROM v_london_customers;",
          "resetBefore": true,
          "validation": {
            "type": "row_count",
            "expected": 3
          }
        },
        {
          "id": "d25-c02",
          "title": "Query From a View",
          "description": "The view v_london_customers already exists. Write a SELECT query against it to return only customers whose customer_name starts with 'A' or 'H'. Return customer_id, customer_name, and email.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "SELECT from the view and add a WHERE clause filtering customer_name LIKE 'A%' OR customer_name LIKE 'H%'.",
          "solution": "SELECT customer_id, customer_name, email\nFROM v_london_customers\nWHERE customer_name LIKE 'A%'\n   OR customer_name LIKE 'H%';",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0 && rows.every(r => r.customer_name[0] === 'A' || r.customer_name[0] === 'H')"
          }
        },
        {
          "id": "d25-c03",
          "title": "Customer Order Summary View",
          "description": "Create a view called v_customer_summary that shows, per customer: customer_id, customer_name, city, total_orders (count of orders), and total_spent (sum of total_amount, rounded to 2 decimal places). Only include completed orders. Then SELECT all rows ordered by total_spent descending.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "JOIN customers to orders WHERE status = 'Completed', GROUP BY customer_id, customer_name, city.",
          "solution": "CREATE VIEW v_customer_summary AS\nSELECT\n  c.customer_id,\n  c.customer_name,\n  c.city,\n  COUNT(o.order_id) AS total_orders,\n  ROUND(SUM(o.total_amount)::numeric, 2) AS total_spent\nFROM customers c\nJOIN orders o ON c.customer_id = o.customer_id\nWHERE o.status = 'Completed'\nGROUP BY c.customer_id, c.customer_name, c.city;\n\nSELECT * FROM v_customer_summary\nORDER BY total_spent DESC;",
          "resetBefore": true,
          "validation": {
            "type": "ordered",
            "column": "total_spent",
            "direction": "desc"
          }
        },
        {
          "id": "d25-c04",
          "title": "View With a JOIN",
          "description": "Create a view called v_order_details that joins orders and order_items to show: order_id, order_date, customer_id, status, product_name, quantity, and unit_price. Then SELECT the first 10 rows ordered by order_id, product_name.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "JOIN orders o ON order_items oi WHERE o.order_id = oi.order_id. Include all needed columns in the SELECT.",
          "solution": "CREATE VIEW v_order_details AS\nSELECT\n  o.order_id,\n  o.order_date,\n  o.customer_id,\n  o.status,\n  oi.product_name,\n  oi.quantity,\n  oi.unit_price\nFROM orders o\nJOIN order_items oi ON o.order_id = oi.order_id;\n\nSELECT * FROM v_order_details\nORDER BY order_id, product_name\nLIMIT 10;",
          "resetBefore": true,
          "validation": {
            "type": "row_count",
            "expected": 10
          }
        },
        {
          "id": "d25-c05",
          "title": "Drop and Recreate a View",
          "description": "Drop the view v_london_customers if it exists, then recreate it to also include the city column. SELECT all rows from the recreated view to confirm it works.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "Use DROP VIEW IF EXISTS v_london_customers; then CREATE VIEW v_london_customers AS SELECT customer_id, customer_name, email, city FROM customers WHERE city = 'London'.",
          "solution": "DROP VIEW IF EXISTS v_london_customers;\n\nCREATE VIEW v_london_customers AS\nSELECT customer_id, customer_name, email, city\nFROM customers\nWHERE city = 'London';\n\nSELECT * FROM v_london_customers;",
          "resetBefore": true,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "customer_id",
              "customer_name",
              "email",
              "city"
            ]
          }
        },
        {
          "id": "d25-c06",
          "title": "View for Access Control",
          "description": "Create a view called v_public_customers that exposes only customer_id, customer_name, and city - deliberately excluding the email column. This simulates restricting sensitive data access. Then SELECT all rows from the view and confirm email is absent.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "CREATE VIEW v_public_customers AS SELECT customer_id, customer_name, city FROM customers. A view can hide columns by simply not including them.",
          "solution": "CREATE VIEW v_public_customers AS\nSELECT customer_id, customer_name, city\nFROM customers;\n\nSELECT * FROM v_public_customers\nORDER BY customer_id;",
          "resetBefore": true,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "customer_id",
              "customer_name",
              "city"
            ]
          }
        }
      ]
    },
    {
      "day": 26,
      "title": "Information Schema & Metadata",
      "slug": "information-schema-and-metadata",
      "week": 4,
      "weekLabel": "Advanced Analytics & Performance",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-26",
      "seedSQL": "CREATE TABLE IF NOT EXISTS customers (\n  customer_id   INTEGER PRIMARY KEY,\n  customer_name TEXT    NOT NULL,\n  email         TEXT    NOT NULL,\n  city          TEXT    NOT NULL,\n  signup_date   TEXT    NOT NULL\n);\n\nCREATE TABLE IF NOT EXISTS orders (\n  order_id      INTEGER PRIMARY KEY,\n  customer_id   INTEGER NOT NULL,\n  order_date    TEXT    NOT NULL,\n  total_amount  REAL    NOT NULL,\n  status        TEXT    NOT NULL,\n  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)\n);\n\nCREATE TABLE IF NOT EXISTS order_items (\n  item_id      INTEGER PRIMARY KEY,\n  order_id     INTEGER NOT NULL,\n  product_name TEXT    NOT NULL,\n  quantity     INTEGER NOT NULL,\n  unit_price   REAL    NOT NULL,\n  FOREIGN KEY (order_id) REFERENCES orders(order_id)\n);\n\nCREATE TABLE IF NOT EXISTS products (\n  product_id   INTEGER PRIMARY KEY,\n  product_name TEXT    NOT NULL,\n  category     TEXT    NOT NULL,\n  price        REAL    NOT NULL,\n  stock_qty    INTEGER NOT NULL\n);\n\nCREATE TABLE IF NOT EXISTS suppliers (\n  supplier_id   INTEGER PRIMARY KEY,\n  supplier_name TEXT    NOT NULL,\n  country       TEXT    NOT NULL,\n  contact_email TEXT    NOT NULL\n);\n\nINSERT INTO customers VALUES\n  (1, 'Alice Brown',    'alice@example.com',   'London',     '2022-03-10'),\n  (2, 'Ben Osei',       'ben@example.com',     'Manchester', '2022-07-22'),\n  (3, 'Clara Holt',     'clara@example.com',   'Bristol',    '2023-01-05'),\n  (4, 'Daniel Kim',     'daniel@example.com',  'Glasgow',    '2023-04-18'),\n  (5, 'Esi Mensah',     'esi@example.com',     'Cardiff',    '2021-11-30');\n\nINSERT INTO orders VALUES\n  (1, 1, '2024-01-05', 250.00, 'Completed'),\n  (2, 2, '2024-01-18',  85.50, 'Completed'),\n  (3, 3, '2024-01-22', 199.99, 'Completed');\n\nINSERT INTO order_items VALUES\n  (1, 1, 'Keyboard', 1, 120.00),\n  (2, 1, 'Mouse',    1,  45.00),\n  (3, 2, 'Webcam',   1,  85.50),\n  (4, 3, 'Headset',  1, 199.99);\n\nINSERT INTO products VALUES\n  (1, 'Keyboard',  'Peripherals', 120.00, 50),\n  (2, 'Mouse',     'Peripherals',  45.00, 80),\n  (3, 'Webcam',    'Peripherals',  85.50, 30),\n  (4, 'Headset',   'Audio',       199.99, 20),\n  (5, 'Monitor',   'Displays',    340.00, 15);\n\nINSERT INTO suppliers VALUES\n  (1, 'TechSource Ltd',   'UK',      'supply@techsource.co.uk'),\n  (2, 'Global Parts Inc', 'USA',     'info@globalparts.com'),\n  (3, 'Kemi Electronics', 'Nigeria', 'sales@kemi-elec.com');",
      "tables": [
        {
          "name": "customers",
          "columns": [
            {
              "name": "customer_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "customer_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "email",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "city",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "signup_date",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 5
        },
        {
          "name": "orders",
          "columns": [
            {
              "name": "order_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "customer_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "order_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "total_amount",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "status",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 3
        },
        {
          "name": "order_items",
          "columns": [
            {
              "name": "item_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "order_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "product_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "quantity",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "unit_price",
              "type": "REAL",
              "pk": false
            }
          ],
          "rowCount": 4
        },
        {
          "name": "products",
          "columns": [
            {
              "name": "product_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "product_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "category",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "price",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "stock_qty",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 5
        },
        {
          "name": "suppliers",
          "columns": [
            {
              "name": "supplier_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "supplier_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "country",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "contact_email",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 3
        }
      ],
      "quickInsert": [
        "information_schema.tables",
        "information_schema.columns",
        "information_schema.table_constraints"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d26-c01",
          "title": "List All Tables",
          "description": "Query information_schema.tables to list all tables in the public schema. Return the table_name column only, ordered alphabetically.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE' ORDER BY table_name.",
          "solution": "SELECT table_name\nFROM information_schema.tables\nWHERE table_schema = 'public'\n  AND table_type = 'BASE TABLE'\nORDER BY table_name;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length >= 5 && rows.some(r => r.table_name === 'customers')"
          }
        },
        {
          "id": "d26-c02",
          "title": "Get Column Info for a Table",
          "description": "Query information_schema.columns to retrieve column details for the orders table. Return column_name, data_type, is_nullable, and column_default ordered by ordinal_position.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "SELECT column_name, data_type, is_nullable, column_default FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'orders' ORDER BY ordinal_position;",
          "solution": "SELECT column_name, data_type, is_nullable, column_default\nFROM information_schema.columns\nWHERE table_schema = 'public'\n  AND table_name = 'orders'\nORDER BY ordinal_position;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length === 5 && rows.some(r => r.column_name === 'order_id')"
          }
        },
        {
          "id": "d26-c03",
          "title": "Find Primary Keys",
          "description": "Query information_schema.columns for the customers table. Use a subquery against pg_index to identify primary key columns. Return column_name and data_type.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "Join information_schema.columns with pg_index and pg_attribute to find columns where indisprimary is true for the customers table.",
          "solution": "SELECT column_name, data_type\nFROM information_schema.columns\nWHERE table_schema = 'public'\n  AND table_name = 'customers'\n  AND column_name IN (\n    SELECT a.attname\n    FROM pg_index i\n    JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)\n    WHERE i.indrelid = 'customers'::regclass\n      AND i.indisprimary\n  );",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length === 1 && rows[0].column_name === 'customer_id'"
          }
        },
        {
          "id": "d26-c04",
          "title": "Count Tables in the Database",
          "description": "Query information_schema.tables to count all tables in the public schema. Return the result as table_count.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "SELECT COUNT(*) AS table_count FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE'.",
          "solution": "SELECT COUNT(*) AS table_count\nFROM information_schema.tables\nWHERE table_schema = 'public'\n  AND table_type = 'BASE TABLE';",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length === 1 && rows[0].table_count >= 5"
          }
        },
        {
          "id": "d26-c05",
          "title": "Explore Foreign Keys",
          "description": "Query information_schema.table_constraints, key_column_usage, constraint_column_usage, and referential_constraints to find foreign key relationships on the order_items table.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "Join information_schema.table_constraints with key_column_usage and constraint_column_usage filtering WHERE constraint_type = 'FOREIGN KEY' AND table_name = 'order_items'.",
          "solution": "SELECT\n  kcu.column_name AS \"from\",\n  ccu.table_name AS \"table\",\n  ccu.column_name AS \"to\",\n  rc.update_rule AS on_update,\n  rc.delete_rule AS on_delete\nFROM information_schema.table_constraints tc\nJOIN information_schema.key_column_usage kcu\n  ON tc.constraint_name = kcu.constraint_name\n  AND tc.table_schema = kcu.table_schema\nJOIN information_schema.constraint_column_usage ccu\n  ON ccu.constraint_name = tc.constraint_name\n  AND ccu.table_schema = tc.table_schema\nJOIN information_schema.referential_constraints rc\n  ON tc.constraint_name = rc.constraint_name\nWHERE tc.constraint_type = 'FOREIGN KEY'\n  AND tc.table_schema = 'public'\n  AND tc.table_name = 'order_items';",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length >= 1 && rows.some(r => r['table'] === 'orders')"
          }
        }
      ]
    },
    {
      "day": 27,
      "title": "CREATE FUNCTION (UDFs)",
      "slug": "create-function-udfs",
      "week": 4,
      "weekLabel": "Advanced Analytics & Performance",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-27",
      "seedSQL": "CREATE TABLE IF NOT EXISTS transactions (\n  txn_id      INTEGER PRIMARY KEY,\n  account_id  INTEGER NOT NULL,\n  txn_type    TEXT    NOT NULL,\n  amount      REAL    NOT NULL,\n  txn_date    TEXT    NOT NULL,\n  description TEXT    NOT NULL\n);\n\nINSERT INTO transactions VALUES\n  (1,  101, 'credit', 2500.00, '2024-01-01', 'Salary'),\n  (2,  101, 'debit',   120.00, '2024-01-03', 'Grocery shop'),\n  (3,  101, 'debit',    45.50, '2024-01-05', 'Transport card top-up'),\n  (4,  101, 'credit',  300.00, '2024-01-08', 'Freelance payment'),\n  (5,  101, 'debit',   850.00, '2024-01-10', 'Rent'),\n  (6,  102, 'credit', 3100.00, '2024-01-01', 'Salary'),\n  (7,  102, 'debit',   200.00, '2024-01-04', 'Utility bills'),\n  (8,  102, 'debit',    60.00, '2024-01-06', 'Streaming subscriptions'),\n  (9,  102, 'credit',  150.00, '2024-01-09', 'Refund'),\n  (10, 102, 'debit',   900.00, '2024-01-11', 'Rent'),\n  (11, 103, 'credit', 1800.00, '2024-01-01', 'Salary'),\n  (12, 103, 'debit',    80.00, '2024-01-02', 'Coffee and lunch'),\n  (13, 103, 'debit',   250.00, '2024-01-07', 'Online shopping'),\n  (14, 103, 'credit',  500.00, '2024-01-10', 'Bonus'),\n  (15, 103, 'debit',   600.00, '2024-01-12', 'Rent'),\n  (16, 101, 'debit',    30.00, '2024-01-15', 'Mobile phone bill'),\n  (17, 101, 'credit', 2500.00, '2024-02-01', 'Salary'),\n  (18, 101, 'debit',   135.00, '2024-02-04', 'Grocery shop'),\n  (19, 102, 'debit',    75.00, '2024-02-03', 'Dining out'),\n  (20, 102, 'credit', 3100.00, '2024-02-01', 'Salary');",
      "tables": [
        {
          "name": "transactions",
          "columns": [
            {
              "name": "txn_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "account_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "txn_type",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "amount",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "txn_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "description",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 20
        }
      ],
      "quickInsert": [
        "SELECT",
        "CASE WHEN",
        "ROUND",
        "ABS"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d27-c01",
          "title": "Encapsulate Classification Logic",
          "description": "A UDF called classify_transaction would accept txn_type and amount and return a category. Write that logic as a CASE expression in a SELECT. For each transaction return txn_id, txn_type, amount, and a category column: 'Large Credit' (credit >= 1000), 'Small Credit' (credit < 1000), 'Large Debit' (debit >= 500), 'Small Debit' (debit < 500).",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "Use a nested CASE: first check txn_type, then check amount thresholds within each branch.",
          "solution": "SELECT\n  txn_id,\n  txn_type,\n  amount,\n  CASE\n    WHEN txn_type = 'credit' AND amount >= 1000 THEN 'Large Credit'\n    WHEN txn_type = 'credit' AND amount <  1000 THEN 'Small Credit'\n    WHEN txn_type = 'debit'  AND amount >= 500  THEN 'Large Debit'\n    WHEN txn_type = 'debit'  AND amount <  500  THEN 'Small Debit'\n  END AS category\nFROM transactions\nORDER BY txn_id;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "txn_id",
              "txn_type",
              "amount",
              "category"
            ]
          }
        },
        {
          "id": "d27-c02",
          "title": "Running Balance",
          "description": "Calculate the running account balance for account_id 101. Credits add to the balance; debits subtract. Return txn_id, txn_date, description, amount, txn_type, and running_balance ordered by txn_date, txn_id.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "Use SUM(CASE WHEN txn_type = 'credit' THEN amount ELSE -amount END) OVER (ORDER BY txn_date, txn_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW).",
          "solution": "SELECT\n  txn_id,\n  txn_date,\n  description,\n  amount,\n  txn_type,\n  SUM(\n    CASE WHEN txn_type = 'credit' THEN amount ELSE -amount END\n  ) OVER (ORDER BY txn_date, txn_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_balance\nFROM transactions\nWHERE account_id = 101\nORDER BY txn_date, txn_id;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "txn_id",
              "txn_date",
              "description",
              "amount",
              "txn_type",
              "running_balance"
            ]
          }
        },
        {
          "id": "d27-c03",
          "title": "Tax Calculation Expression",
          "description": "A UDF called calculate_tax would apply a 20% tax rate to credits only. Write this as a SELECT expression. Return txn_id, account_id, amount, txn_type, and tax_amount (0 for debits, ROUND((amount * 0.20)::numeric, 2) for credits). Order by account_id, txn_date.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "Use CASE WHEN txn_type = 'credit' THEN ROUND((amount * 0.20)::numeric, 2) ELSE 0 END AS tax_amount.",
          "solution": "SELECT\n  txn_id,\n  account_id,\n  amount,\n  txn_type,\n  CASE\n    WHEN txn_type = 'credit' THEN ROUND((amount * 0.20)::numeric, 2)\n    ELSE 0\n  END AS tax_amount\nFROM transactions\nORDER BY account_id, txn_date;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "txn_id",
              "account_id",
              "amount",
              "txn_type",
              "tax_amount"
            ]
          }
        },
        {
          "id": "d27-c04",
          "title": "Spend Categorisation by Description",
          "description": "Write a query that categorises each debit transaction by its description keyword. Return txn_id, description, amount, and spend_category: 'Housing' if description contains 'Rent', 'Food' if it contains 'Grocery' or 'lunch' or 'Dining', 'Transport' if it contains 'Transport', 'Bills' if it contains 'bill' or 'subscriptions', 'Other' for anything else. Only include debit transactions.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "Use CASE with LIKE patterns: WHEN description LIKE '%Rent%' THEN 'Housing'. Order matters - put the most specific checks first.",
          "solution": "SELECT\n  txn_id,\n  description,\n  amount,\n  CASE\n    WHEN description LIKE '%Rent%'           THEN 'Housing'\n    WHEN description LIKE '%Grocery%'\n      OR description LIKE '%lunch%'\n      OR description LIKE '%Dining%'         THEN 'Food'\n    WHEN description LIKE '%Transport%'      THEN 'Transport'\n    WHEN description LIKE '%bill%'\n      OR description LIKE '%subscriptions%'  THEN 'Bills'\n    ELSE 'Other'\n  END AS spend_category\nFROM transactions\nWHERE txn_type = 'debit'\nORDER BY txn_id;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "txn_id",
              "description",
              "amount",
              "spend_category"
            ]
          }
        },
        {
          "id": "d27-c05",
          "title": "What Does This PostgreSQL Function Return?",
          "description": "Consider this PostgreSQL function (read it carefully):\n\nCREATE FUNCTION net_position(p_account_id INT) RETURNS NUMERIC AS $$\n  SELECT SUM(CASE WHEN txn_type = 'credit' THEN amount ELSE -amount END)\n  FROM transactions\n  WHERE account_id = p_account_id;\n$$ LANGUAGE SQL;\n\nWrite the equivalent SELECT query for account_id 102 that returns what net_position(102) would return. Name the result net_position.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "The function sums credits and subtracts debits. Write SELECT SUM(CASE WHEN txn_type = 'credit' THEN amount ELSE -amount END) AS net_position FROM transactions WHERE account_id = 102.",
          "solution": "SELECT\n  SUM(CASE WHEN txn_type = 'credit' THEN amount ELSE -amount END) AS net_position\nFROM transactions\nWHERE account_id = 102;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "net_position"
            ]
          }
        }
      ]
    },
    {
      "day": 28,
      "title": "EXPLAIN & Indexing",
      "slug": "explain-and-indexing",
      "week": 4,
      "weekLabel": "Advanced Analytics & Performance",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-28",
      "seedSQL": "CREATE TABLE IF NOT EXISTS large_logs (\n  log_id      INTEGER PRIMARY KEY,\n  event_type  TEXT    NOT NULL,\n  user_id     INTEGER NOT NULL,\n  event_date  TEXT    NOT NULL,\n  duration_ms INTEGER NOT NULL,\n  ip_address  TEXT    NOT NULL,\n  status_code INTEGER NOT NULL\n);\n\nINSERT INTO large_logs VALUES\n  (1,   'page_view',    1001, '2024-01-01', 142,  '192.168.1.10',  200),\n  (2,   'click',        1002, '2024-01-01', 23,   '192.168.1.11',  200),\n  (3,   'form_submit',  1001, '2024-01-01', 880,  '192.168.1.10',  201),\n  (4,   'page_view',    1003, '2024-01-02', 110,  '10.0.0.1',      200),\n  (5,   'api_call',     1004, '2024-01-02', 1450, '10.0.0.2',      500),\n  (6,   'page_view',    1005, '2024-01-02', 95,   '10.0.0.3',      200),\n  (7,   'click',        1001, '2024-01-03', 18,   '192.168.1.10',  200),\n  (8,   'api_call',     1002, '2024-01-03', 2100, '192.168.1.11',  200),\n  (9,   'page_view',    1006, '2024-01-03', 130,  '10.0.1.1',      200),\n  (10,  'error',        1004, '2024-01-03', 5500, '10.0.0.2',      503),\n  (11,  'page_view',    1007, '2024-01-04', 105,  '10.0.1.2',      200),\n  (12,  'click',        1003, '2024-01-04', 30,   '10.0.0.1',      200),\n  (13,  'form_submit',  1005, '2024-01-04', 750,  '10.0.0.3',      201),\n  (14,  'api_call',     1008, '2024-01-04', 980,  '172.16.0.1',    200),\n  (15,  'error',        1001, '2024-01-05', 4200, '192.168.1.10',  500),\n  (16,  'page_view',    1009, '2024-01-05', 88,   '172.16.0.2',    200),\n  (17,  'click',        1010, '2024-01-05', 15,   '172.16.0.3',    200),\n  (18,  'api_call',     1001, '2024-01-05', 1800, '192.168.1.10',  200),\n  (19,  'page_view',    1002, '2024-01-06', 120,  '192.168.1.11',  200),\n  (20,  'form_submit',  1006, '2024-01-06', 640,  '10.0.1.1',      201),\n  (21,  'page_view',    1003, '2024-01-06', 99,   '10.0.0.1',      200),\n  (22,  'click',        1007, '2024-01-07', 25,   '10.0.1.2',      200),\n  (23,  'api_call',     1005, '2024-01-07', 3200, '10.0.0.3',      500),\n  (24,  'page_view',    1008, '2024-01-07', 115,  '172.16.0.1',    200),\n  (25,  'error',        1009, '2024-01-07', 8100, '172.16.0.2',    503),\n  (26,  'page_view',    1010, '2024-01-08', 90,   '172.16.0.3',    200),\n  (27,  'click',        1001, '2024-01-08', 22,   '192.168.1.10',  200),\n  (28,  'form_submit',  1002, '2024-01-08', 560,  '192.168.1.11',  201),\n  (29,  'api_call',     1003, '2024-01-08', 1200, '10.0.0.1',      200),\n  (30,  'page_view',    1004, '2024-01-08', 140,  '10.0.0.2',      200),\n  (31,  'error',        1005, '2024-01-09', 6700, '10.0.0.3',      500),\n  (32,  'page_view',    1006, '2024-01-09', 78,   '10.0.1.1',      200),\n  (33,  'click',        1007, '2024-01-09', 19,   '10.0.1.2',      200),\n  (34,  'api_call',     1008, '2024-01-09', 2400, '172.16.0.1',    200),\n  (35,  'page_view',    1009, '2024-01-09', 103,  '172.16.0.2',    200),\n  (36,  'form_submit',  1010, '2024-01-10', 820,  '172.16.0.3',    201),\n  (37,  'page_view',    1001, '2024-01-10', 135,  '192.168.1.10',  200),\n  (38,  'click',        1002, '2024-01-10', 28,   '192.168.1.11',  200),\n  (39,  'api_call',     1003, '2024-01-10', 910,  '10.0.0.1',      200),\n  (40,  'error',        1004, '2024-01-10', 7300, '10.0.0.2',      503),\n  (41,  'page_view',    1005, '2024-01-11', 88,   '10.0.0.3',      200),\n  (42,  'click',        1006, '2024-01-11', 14,   '10.0.1.1',      200),\n  (43,  'form_submit',  1007, '2024-01-11', 490,  '10.0.1.2',      201),\n  (44,  'api_call',     1008, '2024-01-11', 1650, '172.16.0.1',    200),\n  (45,  'page_view',    1009, '2024-01-11', 92,   '172.16.0.2',    200),\n  (46,  'error',        1010, '2024-01-12', 9200, '172.16.0.3',    500),\n  (47,  'page_view',    1001, '2024-01-12', 118,  '192.168.1.10',  200),\n  (48,  'click',        1002, '2024-01-12', 31,   '192.168.1.11',  200),\n  (49,  'api_call',     1003, '2024-01-12', 1100, '10.0.0.1',      200),\n  (50,  'form_submit',  1004, '2024-01-12', 700,  '10.0.0.2',      201),\n  (51,  'page_view',    1005, '2024-01-13', 97,   '10.0.0.3',      200),\n  (52,  'click',        1006, '2024-01-13', 21,   '10.0.1.1',      200),\n  (53,  'api_call',     1007, '2024-01-13', 2750, '10.0.1.2',      500),\n  (54,  'page_view',    1008, '2024-01-13', 111,  '172.16.0.1',    200),\n  (55,  'error',        1009, '2024-01-13', 5100, '172.16.0.2',    503),\n  (56,  'page_view',    1010, '2024-01-14', 86,   '172.16.0.3',    200),\n  (57,  'click',        1001, '2024-01-14', 17,   '192.168.1.10',  200),\n  (58,  'form_submit',  1002, '2024-01-14', 610,  '192.168.1.11',  201),\n  (59,  'api_call',     1003, '2024-01-14', 830,  '10.0.0.1',      200),\n  (60,  'page_view',    1004, '2024-01-14', 145,  '10.0.0.2',      200),\n  (61,  'error',        1005, '2024-01-15', 7800, '10.0.0.3',      500),\n  (62,  'page_view',    1006, '2024-01-15', 73,   '10.0.1.1',      200),\n  (63,  'click',        1007, '2024-01-15', 26,   '10.0.1.2',      200),\n  (64,  'api_call',     1008, '2024-01-15', 1950, '172.16.0.1',    200),\n  (65,  'page_view',    1009, '2024-01-15', 109,  '172.16.0.2',    200),\n  (66,  'form_submit',  1010, '2024-01-15', 540,  '172.16.0.3',    201),\n  (67,  'page_view',    1001, '2024-01-16', 128,  '192.168.1.10',  200),\n  (68,  'click',        1002, '2024-01-16', 24,   '192.168.1.11',  200),\n  (69,  'api_call',     1003, '2024-01-16', 1350, '10.0.0.1',      200),\n  (70,  'error',        1004, '2024-01-16', 6200, '10.0.0.2',      503),\n  (71,  'page_view',    1005, '2024-01-17', 81,   '10.0.0.3',      200),\n  (72,  'click',        1006, '2024-01-17', 20,   '10.0.1.1',      200),\n  (73,  'form_submit',  1007, '2024-01-17', 680,  '10.0.1.2',      201),\n  (74,  'api_call',     1008, '2024-01-17', 2200, '172.16.0.1',    200),\n  (75,  'page_view',    1009, '2024-01-17', 96,   '172.16.0.2',    200),\n  (76,  'error',        1010, '2024-01-17', 8800, '172.16.0.3',    500),\n  (77,  'page_view',    1001, '2024-01-18', 137,  '192.168.1.10',  200),\n  (78,  'click',        1002, '2024-01-18', 29,   '192.168.1.11',  200),\n  (79,  'api_call',     1003, '2024-01-18', 760,  '10.0.0.1',      200),\n  (80,  'form_submit',  1004, '2024-01-18', 920,  '10.0.0.2',      201),\n  (81,  'page_view',    1005, '2024-01-19', 84,   '10.0.0.3',      200),\n  (82,  'click',        1006, '2024-01-19', 16,   '10.0.1.1',      200),\n  (83,  'api_call',     1007, '2024-01-19', 3100, '10.0.1.2',      500),\n  (84,  'page_view',    1008, '2024-01-19', 122,  '172.16.0.1',    200),\n  (85,  'error',        1009, '2024-01-19', 4900, '172.16.0.2',    503),\n  (86,  'page_view',    1010, '2024-01-20', 90,   '172.16.0.3',    200),\n  (87,  'click',        1001, '2024-01-20', 13,   '192.168.1.10',  200),\n  (88,  'form_submit',  1002, '2024-01-20', 580,  '192.168.1.11',  201),\n  (89,  'api_call',     1003, '2024-01-20', 1070, '10.0.0.1',      200),\n  (90,  'page_view',    1004, '2024-01-20', 148,  '10.0.0.2',      200),\n  (91,  'error',        1005, '2024-01-21', 7100, '10.0.0.3',      500),\n  (92,  'page_view',    1006, '2024-01-21', 76,   '10.0.1.1',      200),\n  (93,  'click',        1007, '2024-01-21', 27,   '10.0.1.2',      200),\n  (94,  'api_call',     1008, '2024-01-21', 1780, '172.16.0.1',    200),\n  (95,  'page_view',    1009, '2024-01-21', 107,  '172.16.0.2',    200),\n  (96,  'form_submit',  1010, '2024-01-21', 460,  '172.16.0.3',    201),\n  (97,  'page_view',    1001, '2024-01-22', 131,  '192.168.1.10',  200),\n  (98,  'click',        1002, '2024-01-22', 23,   '192.168.1.11',  200),\n  (99,  'api_call',     1003, '2024-01-22', 1420, '10.0.0.1',      200),\n  (100, 'error',        1004, '2024-01-22', 6600, '10.0.0.2',      503),\n  (101, 'page_view',    1005, '2024-01-23', 85,   '10.0.0.3',      200),\n  (102, 'click',        1006, '2024-01-23', 18,   '10.0.1.1',      200),\n  (103, 'api_call',     1007, '2024-01-23', 2950, '10.0.1.2',      500),\n  (104, 'page_view',    1008, '2024-01-23', 113,  '172.16.0.1',    200),\n  (105, 'error',        1009, '2024-01-23', 5400, '172.16.0.2',    503),\n  (106, 'page_view',    1010, '2024-01-24', 89,   '172.16.0.3',    200),\n  (107, 'click',        1001, '2024-01-24', 20,   '192.168.1.10',  200),\n  (108, 'form_submit',  1002, '2024-01-24', 630,  '192.168.1.11',  201),\n  (109, 'api_call',     1003, '2024-01-24', 1180, '10.0.0.1',      200),\n  (110, 'page_view',    1004, '2024-01-24', 143,  '10.0.0.2',      200),\n  (111, 'error',        1005, '2024-01-25', 7500, '10.0.0.3',      500),\n  (112, 'page_view',    1006, '2024-01-25', 80,   '10.0.1.1',      200),\n  (113, 'click',        1007, '2024-01-25', 25,   '10.0.1.2',      200),\n  (114, 'api_call',     1008, '2024-01-25', 2050, '172.16.0.1',    200),\n  (115, 'page_view',    1009, '2024-01-25', 101,  '172.16.0.2',    200),\n  (116, 'form_submit',  1010, '2024-01-25', 510,  '172.16.0.3',    201),\n  (117, 'page_view',    1001, '2024-01-26', 126,  '192.168.1.10',  200),\n  (118, 'click',        1002, '2024-01-26', 22,   '192.168.1.11',  200),\n  (119, 'api_call',     1003, '2024-01-26', 990,  '10.0.0.1',      200),\n  (120, 'error',        1004, '2024-01-26', 8400, '10.0.0.2',      503),\n  (121, 'page_view',    1005, '2024-01-27', 82,   '10.0.0.3',      200),\n  (122, 'click',        1006, '2024-01-27', 19,   '10.0.1.1',      200),\n  (123, 'api_call',     1007, '2024-01-27', 2680, '10.0.1.2',      500),\n  (124, 'page_view',    1008, '2024-01-27', 116,  '172.16.0.1',    200),\n  (125, 'error',        1009, '2024-01-27', 5700, '172.16.0.2',    503),\n  (126, 'page_view',    1010, '2024-01-28', 93,   '172.16.0.3',    200),\n  (127, 'click',        1001, '2024-01-28', 16,   '192.168.1.10',  200),\n  (128, 'form_submit',  1002, '2024-01-28', 595,  '192.168.1.11',  201),\n  (129, 'api_call',     1003, '2024-01-28', 1040, '10.0.0.1',      200),\n  (130, 'page_view',    1004, '2024-01-28', 138,  '10.0.0.2',      200),\n  (131, 'error',        1005, '2024-01-29', 6900, '10.0.0.3',      500),\n  (132, 'page_view',    1006, '2024-01-29', 77,   '10.0.1.1',      200),\n  (133, 'click',        1007, '2024-01-29', 24,   '10.0.1.2',      200),\n  (134, 'api_call',     1008, '2024-01-29', 1860, '172.16.0.1',    200),\n  (135, 'page_view',    1009, '2024-01-29', 104,  '172.16.0.2',    200),\n  (136, 'form_submit',  1010, '2024-01-29', 475,  '172.16.0.3',    201),\n  (137, 'page_view',    1001, '2024-01-30', 133,  '192.168.1.10',  200),\n  (138, 'click',        1002, '2024-01-30', 28,   '192.168.1.11',  200),\n  (139, 'api_call',     1003, '2024-01-30', 1310, '10.0.0.1',      200),\n  (140, 'error',        1004, '2024-01-30', 7700, '10.0.0.2',      503),\n  (141, 'page_view',    1005, '2024-01-31', 87,   '10.0.0.3',      200),\n  (142, 'click',        1006, '2024-01-31', 21,   '10.0.1.1',      200),\n  (143, 'api_call',     1007, '2024-01-31', 2830, '10.0.1.2',      500),\n  (144, 'page_view',    1008, '2024-01-31', 119,  '172.16.0.1',    200),\n  (145, 'error',        1009, '2024-01-31', 5300, '172.16.0.2',    503),\n  (146, 'page_view',    1010, '2024-02-01', 91,   '172.16.0.3',    200),\n  (147, 'click',        1001, '2024-02-01', 17,   '192.168.1.10',  200),\n  (148, 'form_submit',  1002, '2024-02-01', 615,  '192.168.1.11',  201),\n  (149, 'api_call',     1003, '2024-02-01', 1090, '10.0.0.1',      200),\n  (150, 'page_view',    1004, '2024-02-01', 141,  '10.0.0.2',      200),\n  (151, 'error',        1005, '2024-02-02', 7200, '10.0.0.3',      500),\n  (152, 'page_view',    1006, '2024-02-02', 79,   '10.0.1.1',      200),\n  (153, 'click',        1007, '2024-02-02', 26,   '10.0.1.2',      200),\n  (154, 'api_call',     1008, '2024-02-02', 1970, '172.16.0.1',    200),\n  (155, 'page_view',    1009, '2024-02-02', 106,  '172.16.0.2',    200),\n  (156, 'form_submit',  1010, '2024-02-02', 525,  '172.16.0.3',    201),\n  (157, 'page_view',    1001, '2024-02-03', 129,  '192.168.1.10',  200),\n  (158, 'click',        1002, '2024-02-03', 23,   '192.168.1.11',  200),\n  (159, 'api_call',     1003, '2024-02-03', 870,  '10.0.0.1',      200),\n  (160, 'error',        1004, '2024-02-03', 8600, '10.0.0.2',      503),\n  (161, 'page_view',    1005, '2024-02-04', 83,   '10.0.0.3',      200),\n  (162, 'click',        1006, '2024-02-04', 18,   '10.0.1.1',      200),\n  (163, 'api_call',     1007, '2024-02-04', 2550, '10.0.1.2',      500),\n  (164, 'page_view',    1008, '2024-02-04', 114,  '172.16.0.1',    200),\n  (165, 'error',        1009, '2024-02-04', 5600, '172.16.0.2',    503),\n  (166, 'page_view',    1010, '2024-02-05', 88,   '172.16.0.3',    200),\n  (167, 'click',        1001, '2024-02-05', 15,   '192.168.1.10',  200),\n  (168, 'form_submit',  1002, '2024-02-05', 645,  '192.168.1.11',  201),\n  (169, 'api_call',     1003, '2024-02-05', 1230, '10.0.0.1',      200),\n  (170, 'page_view',    1004, '2024-02-05', 144,  '10.0.0.2',      200),\n  (171, 'error',        1005, '2024-02-06', 7400, '10.0.0.3',      500),\n  (172, 'page_view',    1006, '2024-02-06', 75,   '10.0.1.1',      200),\n  (173, 'click',        1007, '2024-02-06', 28,   '10.0.1.2',      200),\n  (174, 'api_call',     1008, '2024-02-06', 2120, '172.16.0.1',    200),\n  (175, 'page_view',    1009, '2024-02-06', 102,  '172.16.0.2',    200),\n  (176, 'form_submit',  1010, '2024-02-06', 490,  '172.16.0.3',    201),\n  (177, 'page_view',    1001, '2024-02-07', 134,  '192.168.1.10',  200),\n  (178, 'click',        1002, '2024-02-07', 22,   '192.168.1.11',  200),\n  (179, 'api_call',     1003, '2024-02-07', 1380, '10.0.0.1',      200),\n  (180, 'error',        1004, '2024-02-07', 6400, '10.0.0.2',      503),\n  (181, 'page_view',    1005, '2024-02-08', 86,   '10.0.0.3',      200),\n  (182, 'click',        1006, '2024-02-08', 20,   '10.0.1.1',      200),\n  (183, 'api_call',     1007, '2024-02-08', 2720, '10.0.1.2',      500),\n  (184, 'page_view',    1008, '2024-02-08', 117,  '172.16.0.1',    200),\n  (185, 'error',        1009, '2024-02-08', 5000, '172.16.0.2',    503),\n  (186, 'page_view',    1010, '2024-02-09', 92,   '172.16.0.3',    200),\n  (187, 'click',        1001, '2024-02-09', 14,   '192.168.1.10',  200),\n  (188, 'form_submit',  1002, '2024-02-09', 570,  '192.168.1.11',  201),\n  (189, 'api_call',     1003, '2024-02-09', 950,  '10.0.0.1',      200),\n  (190, 'page_view',    1004, '2024-02-09', 139,  '10.0.0.2',      200),\n  (191, 'error',        1005, '2024-02-10', 7000, '10.0.0.3',      500),\n  (192, 'page_view',    1006, '2024-02-10', 78,   '10.0.1.1',      200),\n  (193, 'click',        1007, '2024-02-10', 27,   '10.0.1.2',      200),\n  (194, 'api_call',     1008, '2024-02-10', 1840, '172.16.0.1',    200),\n  (195, 'page_view',    1009, '2024-02-10', 105,  '172.16.0.2',    200),\n  (196, 'form_submit',  1010, '2024-02-10', 545,  '172.16.0.3',    201),\n  (197, 'page_view',    1001, '2024-02-11', 127,  '192.168.1.10',  200),\n  (198, 'click',        1002, '2024-02-11', 24,   '192.168.1.11',  200),\n  (199, 'api_call',     1003, '2024-02-11', 1050, '10.0.0.1',      200),\n  (200, 'error',        1004, '2024-02-11', 8200, '10.0.0.2',      503);",
      "tables": [
        {
          "name": "large_logs",
          "columns": [
            {
              "name": "log_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "event_type",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "user_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "event_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "duration_ms",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "ip_address",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "status_code",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 200
        }
      ],
      "quickInsert": [
        "EXPLAIN ANALYZE",
        "CREATE INDEX",
        "WHERE"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d28-c01",
          "title": "Run EXPLAIN ANALYZE",
          "description": "Use EXPLAIN ANALYZE to see how PostgreSQL executes a query that filters large_logs by event_type = 'error'. Run the EXPLAIN and observe whether it performs a full table scan.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "Prefix your SELECT with EXPLAIN ANALYZE. The output shows the scan strategy PostgreSQL chooses.",
          "solution": "EXPLAIN ANALYZE\nSELECT *\nFROM large_logs\nWHERE event_type = 'error';",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0"
          }
        },
        {
          "id": "d28-c02",
          "title": "Create an Index",
          "description": "Create an index called idx_event_type on the large_logs table for the event_type column. Then run a SELECT to confirm logs with event_type = 'error' return results.",
          "tier": "starter",
          "difficulty": "easy",
          "hint": "CREATE INDEX idx_event_type ON large_logs(event_type). Then SELECT to verify.",
          "solution": "CREATE INDEX IF NOT EXISTS idx_event_type ON large_logs(event_type);\n\nSELECT log_id, event_type, event_date, duration_ms\nFROM large_logs\nWHERE event_type = 'error'\nORDER BY event_date\nLIMIT 10;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0 && rows.every(r => r.event_type === 'error')"
          }
        },
        {
          "id": "d28-c03",
          "title": "Compare Before and After Index",
          "description": "Run EXPLAIN ANALYZE for a query filtering by user_id = 1003 - first without any index, then create an index called idx_user_id on user_id, then run EXPLAIN ANALYZE again. For this challenge: just create the index and show the second EXPLAIN result.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "CREATE INDEX idx_user_id ON large_logs(user_id); then EXPLAIN ANALYZE SELECT * FROM large_logs WHERE user_id = 1003.",
          "solution": "CREATE INDEX IF NOT EXISTS idx_user_id ON large_logs(user_id);\n\nEXPLAIN ANALYZE\nSELECT *\nFROM large_logs\nWHERE user_id = 1003;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0"
          }
        },
        {
          "id": "d28-c04",
          "title": "Composite Index Scenario",
          "description": "Queries frequently filter by both event_date and event_type together. Create a composite index called idx_date_event on large_logs for (event_date, event_type). Then run EXPLAIN ANALYZE on a query filtering WHERE event_date = '2024-01-10' AND event_type = 'click'.",
          "tier": "core",
          "difficulty": "medium",
          "hint": "CREATE INDEX idx_date_event ON large_logs(event_date, event_type). The column order matters - the first column in the index is the leading column.",
          "solution": "CREATE INDEX IF NOT EXISTS idx_date_event ON large_logs(event_date, event_type);\n\nEXPLAIN ANALYZE\nSELECT log_id, event_type, user_id, event_date, duration_ms\nFROM large_logs\nWHERE event_date = '2024-01-10'\n  AND event_type = 'click';",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0"
          }
        },
        {
          "id": "d28-c05",
          "title": "Find Slow Queries (Full Scans)",
          "description": "Without any index on duration_ms, write a query that identifies the top 10 slowest log events (highest duration_ms). Return log_id, event_type, user_id, event_date, and duration_ms. Then prefix it with EXPLAIN ANALYZE to see that it must scan the full table.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "EXPLAIN ANALYZE SELECT ... FROM large_logs ORDER BY duration_ms DESC LIMIT 10. Without an index on duration_ms, PostgreSQL must scan every row.",
          "solution": "EXPLAIN ANALYZE\nSELECT log_id, event_type, user_id, event_date, duration_ms\nFROM large_logs\nORDER BY duration_ms DESC\nLIMIT 10;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0"
          }
        },
        {
          "id": "d28-c06",
          "title": "Index Strategy Decision",
          "description": "You have three common query patterns on large_logs: (A) WHERE event_type = 'error', (B) WHERE event_date BETWEEN '2024-01-01' AND '2024-01-31', (C) WHERE user_id = 1005 AND status_code = 500. Create the most appropriate indexes for patterns B and C (pattern A already has idx_event_type). Name them idx_event_date and idx_user_status. Then SELECT COUNT(*) from large_logs where status_code = 500 and user_id = 1005 to verify idx_user_status works.",
          "tier": "stretch",
          "difficulty": "hard",
          "hint": "For B: CREATE INDEX idx_event_date ON large_logs(event_date). For C: CREATE INDEX idx_user_status ON large_logs(user_id, status_code) - composite index on both filter columns.",
          "solution": "CREATE INDEX IF NOT EXISTS idx_event_date ON large_logs(event_date);\nCREATE INDEX IF NOT EXISTS idx_user_status ON large_logs(user_id, status_code);\n\nSELECT COUNT(*) AS matching_logs\nFROM large_logs\nWHERE user_id = 1005\n  AND status_code = 500;",
          "resetBefore": false,
          "validation": {
            "type": "columns_match",
            "expectedColumns": [
              "matching_logs"
            ]
          }
        }
      ]
    },
    {
      "day": 29,
      "title": "PostgreSQL Pro Tips & Shortcuts",
      "slug": "postgresql-pro-tips-shortcuts",
      "week": 5,
      "weekLabel": "Performance & Capstone",
      "type": "concept",
      "youtubeId": null,
      "githubPath": "day-29",
      "seedSQL": "CREATE TABLE IF NOT EXISTS employee_sales (\n  emp_id    INTEGER PRIMARY KEY,\n  emp_name  TEXT NOT NULL,\n  department TEXT NOT NULL,\n  sale_date TEXT NOT NULL,\n  sale_amount REAL NOT NULL,\n  product   TEXT NOT NULL,\n  region    TEXT NOT NULL\n);\n\nDELETE FROM employee_sales;\n\nINSERT INTO employee_sales (emp_id, emp_name, department, sale_date, sale_amount, product, region) VALUES\n(1,  'Alice Hartley',    'Software',  '2024-01-05', 4200.00, 'Enterprise Suite',  'North'),\n(2,  'Ben Okafor',       'Software',  '2024-01-12', 3100.00, 'Starter Pack',      'South'),\n(3,  'Clara Mitchell',   'Hardware',  '2024-01-08', 5500.00, 'Server Bundle',     'East'),\n(4,  'David Lowe',       'Hardware',  '2024-01-15', 2800.00, 'Workstation',       'West'),\n(5,  'Evelyn Santos',    'Services',  '2024-01-03', 1900.00, 'Support Contract',  'North'),\n(6,  'Frank Adeyemi',    'Services',  '2024-01-20', 3400.00, 'Consulting Day',    'South'),\n(7,  'Grace Thornton',   'Software',  '2024-02-02', 2700.00, 'Starter Pack',      'East'),\n(8,  'Henry Liu',        'Hardware',  '2024-02-07', 6100.00, 'Enterprise Suite',  'West'),\n(9,  'Isla Fernandez',   'Services',  '2024-02-11', 2200.00, 'Support Contract',  'North'),\n(10, 'Jack Morris',      'Software',  '2024-02-18', 4800.00, 'Enterprise Suite',  'South'),\n(11, 'Karen Nakamura',   'Hardware',  '2024-02-22', 3300.00, 'Workstation',       'East'),\n(12, 'Leo Asante',       'Services',  '2024-02-28', 1700.00, 'Consulting Day',    'West'),\n(13, 'Maya Patel',       'Software',  '2024-03-04', 5200.00, 'Enterprise Suite',  'North'),\n(14, 'Noel Griffiths',   'Hardware',  '2024-03-09', 4100.00, 'Server Bundle',     'South'),\n(15, 'Olivia Bergstrom', 'Services',  '2024-03-14', 2600.00, 'Consulting Day',    'East'),\n(16, 'Peter Osei',       'Software',  '2024-03-19', 3700.00, 'Starter Pack',      'West'),\n(17, 'Quinn Taylor',     'Hardware',  '2024-03-25', 5900.00, 'Server Bundle',     'North'),\n(18, 'Rachel Kim',       'Services',  '2024-04-01', 2100.00, 'Support Contract',  'South'),\n(19, 'Sam Whitfield',    'Software',  '2024-04-06', 4400.00, 'Enterprise Suite',  'East'),\n(20, 'Tina Abubakar',    'Hardware',  '2024-04-11', 3600.00, 'Workstation',       'West'),\n(21, 'Uma Johansson',    'Services',  '2024-04-16', 1500.00, 'Support Contract',  'North'),\n(22, 'Victor Mensah',    'Software',  '2024-04-21', 2900.00, 'Starter Pack',      'South'),\n(23, 'Wendy Clarke',     'Hardware',  '2024-04-26', 4700.00, 'Server Bundle',     'East'),\n(24, 'Xander Howell',    'Services',  '2024-05-01', 3200.00, 'Consulting Day',    'West'),\n(25, 'Yemi Adewale',     'Software',  '2024-05-06', 5100.00, 'Enterprise Suite',  'North'),\n(26, 'Zoe Bancroft',     'Hardware',  '2024-05-11', 2400.00, 'Workstation',       'South'),\n(27, 'Aaron Nkemdirim',  'Services',  '2024-05-16', 1800.00, 'Support Contract',  'East'),\n(28, 'Beth Caldwell',    'Software',  '2024-05-21', 3900.00, 'Starter Pack',      'West'),\n(29, 'Carlos Reyes',     'Hardware',  '2024-05-26', 6400.00, 'Server Bundle',     'North'),\n(30, 'Diana Owusu',      'Services',  '2024-05-31', 2300.00, 'Consulting Day',    'South');",
      "tables": [
        {
          "name": "employee_sales",
          "columns": [
            {
              "name": "emp_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "emp_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "department",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "sale_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "sale_amount",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "product",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "region",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 30
        }
      ],
      "quickInsert": [
        "GROUP BY",
        "ORDER BY",
        "CASE WHEN",
        "STRING_AGG"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d29-c01",
          "title": "First Sale Per Employee (DISTINCT ON)",
          "description": "Use PostgreSQL's DISTINCT ON (emp_name) to get each employee's earliest sale. Return emp_name, department, sale_date, and sale_amount, ordered by emp_name.",
          "tier": "starter",
          "difficulty": "Easy",
          "hint": "SELECT DISTINCT ON (emp_name) emp_name, department, sale_date, sale_amount FROM employee_sales ORDER BY emp_name, sale_date ASC;",
          "solution": "SELECT DISTINCT ON (emp_name)\n  emp_name,\n  department,\n  sale_date,\n  sale_amount\nFROM employee_sales\nORDER BY emp_name, sale_date ASC;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length === 30 && rows[0].hasOwnProperty('emp_name') && rows[0].hasOwnProperty('sale_date')"
          }
        },
        {
          "id": "d29-c02",
          "title": "Conditional Aggregation (FILTER clause)",
          "description": "Use PostgreSQL's SUM(sale_amount) FILTER (WHERE region = 'North') syntax to aggregate only a subset of rows. For each department, show: total_sales (all regions), north_sales (region = 'North' only), and south_sales (region = 'South' only).",
          "tier": "starter",
          "difficulty": "Easy",
          "hint": "Use SUM(sale_amount) FILTER (WHERE region = 'North') for north_sales, and SUM(sale_amount) FILTER (WHERE region = 'South') for south_sales.",
          "solution": "SELECT\n  department,\n  SUM(sale_amount) AS total_sales,\n  SUM(sale_amount) FILTER (WHERE region = 'North') AS north_sales,\n  SUM(sale_amount) FILTER (WHERE region = 'South') AS south_sales\nFROM employee_sales\nGROUP BY department\nORDER BY department;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length === 3 && rows[0].hasOwnProperty('total_sales') && rows[0].hasOwnProperty('north_sales')"
          }
        },
        {
          "id": "d29-c03",
          "title": "Concatenate Products Sold (STRING_AGG)",
          "description": "Use PostgreSQL's STRING_AGG(product, ', ') to concatenate values within a group. For each department, list the distinct products sold as a comma-separated string. Name the column products_sold. Order by department.",
          "tier": "core",
          "difficulty": "Medium",
          "hint": "Use STRING_AGG(DISTINCT product, ',') to collapse multiple product values into one string per department.",
          "solution": "SELECT\n  department,\n  STRING_AGG(DISTINCT product, ',') AS products_sold\nFROM employee_sales\nGROUP BY department\nORDER BY department;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length === 3 && rows[0].hasOwnProperty('products_sold') && rows[0].products_sold.includes(',')"
          }
        },
        {
          "id": "d29-c04",
          "title": "Generate a Date Series (generate_series)",
          "description": "Use PostgreSQL's generate_series() function to generate every month-start date from 2024-01-01 through 2024-06-01 (inclusive), one row per month. Return a single column called month_start.",
          "tier": "core",
          "difficulty": "Medium",
          "hint": "SELECT generate_series::date AS month_start FROM generate_series(DATE '2024-01-01', DATE '2024-06-01', INTERVAL '1 month');",
          "solution": "SELECT generate_series::date AS month_start\nFROM generate_series(\n  DATE '2024-01-01',\n  DATE '2024-06-01',\n  INTERVAL '1 month'\n);",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length === 6 && rows[0].hasOwnProperty('month_start') && JSON.stringify(rows[0].month_start).includes('2024-01-01')"
          }
        },
        {
          "id": "d29-c05",
          "title": "Department Summary Report",
          "description": "Build a department-level summary that shows: department, number of employees (emp_count), total revenue (total_revenue), average deal size rounded to 2 decimal places (avg_deal), the highest single sale (max_sale), and all regions the department sold into as a comma-separated list (regions_covered). Order by total_revenue descending.",
          "tier": "stretch",
          "difficulty": "Hard",
          "hint": "Combine COUNT(DISTINCT emp_name), SUM, ROUND(AVG(...)::numeric, 2), MAX, and STRING_AGG(DISTINCT region, ',') in a single query grouped by department.",
          "solution": "SELECT\n  department,\n  COUNT(DISTINCT emp_name)         AS emp_count,\n  SUM(sale_amount)                 AS total_revenue,\n  ROUND(AVG(sale_amount)::numeric, 2)       AS avg_deal,\n  MAX(sale_amount)                 AS max_sale,\n  STRING_AGG(DISTINCT region, ',')    AS regions_covered\nFROM employee_sales\nGROUP BY department\nORDER BY total_revenue DESC;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length === 3 && rows[0].hasOwnProperty('emp_count') && rows[0].hasOwnProperty('regions_covered')"
          }
        },
        {
          "id": "d29-c06",
          "title": "Advanced Aggregation: Product Performance Bands",
          "description": "Categorise each product by its total revenue into performance bands using CASE WHEN: 'Premium' if total revenue >= 15000, 'Standard' if >= 8000, otherwise 'Entry'. Return product, total_revenue, and performance_band. Order by total_revenue descending.",
          "tier": "stretch",
          "difficulty": "Hard",
          "hint": "Group by product and compute SUM(sale_amount). Wrap the SUM in a CASE WHEN inside the SELECT to assign the band - or use a subquery/CTE and CASE on the pre-computed total.",
          "solution": "SELECT\n  product,\n  SUM(sale_amount) AS total_revenue,\n  CASE\n    WHEN SUM(sale_amount) >= 15000 THEN 'Premium'\n    WHEN SUM(sale_amount) >= 8000  THEN 'Standard'\n    ELSE 'Entry'\n  END AS performance_band\nFROM employee_sales\nGROUP BY product\nORDER BY total_revenue DESC;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0 && rows[0].hasOwnProperty('performance_band') && ['Premium','Standard','Entry'].includes(rows[0].performance_band)"
          }
        }
      ]
    },
    {
      "day": 30,
      "title": "Capstone: FinTech Lending Analytics Platform",
      "slug": "capstone-fintech-lending-analytics",
      "week": 5,
      "weekLabel": "Performance & Capstone",
      "type": "project",
      "youtubeId": null,
      "githubPath": "day-30",
      "seedSQL": "CREATE TABLE IF NOT EXISTS dim_applicants (\n  applicant_id      INTEGER PRIMARY KEY,\n  first_name        TEXT NOT NULL,\n  last_name         TEXT NOT NULL,\n  email             TEXT NOT NULL,\n  city              TEXT NOT NULL,\n  employment_status TEXT NOT NULL,\n  annual_income     REAL NOT NULL,\n  credit_score      INTEGER NOT NULL\n);\n\nCREATE TABLE IF NOT EXISTS dim_products (\n  product_id    INTEGER PRIMARY KEY,\n  product_name  TEXT NOT NULL,\n  product_type  TEXT NOT NULL,\n  min_amount    REAL NOT NULL,\n  max_amount    REAL NOT NULL,\n  interest_rate REAL NOT NULL,\n  term_months   INTEGER NOT NULL\n);\n\nCREATE TABLE IF NOT EXISTS fact_loans (\n  loan_id       INTEGER PRIMARY KEY,\n  applicant_id  INTEGER NOT NULL REFERENCES dim_applicants(applicant_id),\n  product_id    INTEGER NOT NULL REFERENCES dim_products(product_id),\n  loan_amount   REAL NOT NULL,\n  approved_date TEXT NOT NULL,\n  status        TEXT NOT NULL,\n  risk_grade    TEXT NOT NULL\n);\n\nCREATE TABLE IF NOT EXISTS fact_repayments (\n  repayment_id INTEGER PRIMARY KEY,\n  loan_id      INTEGER NOT NULL REFERENCES fact_loans(loan_id),\n  payment_date TEXT NOT NULL,\n  amount_due   REAL NOT NULL,\n  amount_paid  REAL NOT NULL,\n  days_late    INTEGER NOT NULL\n);\n\nDELETE FROM fact_repayments;\nDELETE FROM fact_loans;\nDELETE FROM dim_applicants;\nDELETE FROM dim_products;\n\nINSERT INTO dim_applicants VALUES\n(1,  'Alice',   'Hartley',    'alice.hartley@mail.com',     'London',     'Employed',    62000.00, 720),\n(2,  'Ben',     'Okafor',     'ben.okafor@mail.com',        'Manchester', 'Employed',    45000.00, 680),\n(3,  'Clara',   'Mitchell',   'clara.mitchell@mail.com',    'Birmingham', 'Self-Employed',55000.00, 705),\n(4,  'David',   'Lowe',       'david.lowe@mail.com',        'London',     'Employed',    73000.00, 745),\n(5,  'Evelyn',  'Santos',     'evelyn.santos@mail.com',     'Leeds',      'Employed',    38000.00, 640),\n(6,  'Frank',   'Adeyemi',    'frank.adeyemi@mail.com',     'London',     'Self-Employed',48000.00, 660),\n(7,  'Grace',   'Thornton',   'grace.thornton@mail.com',    'Bristol',    'Employed',    52000.00, 715),\n(8,  'Henry',   'Liu',        'henry.liu@mail.com',         'Manchester', 'Employed',    67000.00, 730),\n(9,  'Isla',    'Fernandez',  'isla.fernandez@mail.com',    'Edinburgh',  'Employed',    41000.00, 670),\n(10, 'Jack',    'Morris',     'jack.morris@mail.com',       'London',     'Employed',    88000.00, 760),\n(11, 'Karen',   'Nakamura',   'karen.nakamura@mail.com',    'Leeds',      'Self-Employed',35000.00, 620),\n(12, 'Leo',     'Asante',     'leo.asante@mail.com',        'Birmingham', 'Employed',    49000.00, 688),\n(13, 'Maya',    'Patel',      'maya.patel@mail.com',        'London',     'Employed',    75000.00, 750),\n(14, 'Noel',    'Griffiths',  'noel.griffiths@mail.com',    'Cardiff',    'Employed',    43000.00, 655),\n(15, 'Olivia',  'Bergstrom',  'olivia.bergstrom@mail.com',  'Bristol',    'Self-Employed',60000.00, 710),\n(16, 'Peter',   'Osei',       'peter.osei@mail.com',        'Manchester', 'Employed',    54000.00, 695),\n(17, 'Quinn',   'Taylor',     'quinn.taylor@mail.com',      'London',     'Employed',    69000.00, 735),\n(18, 'Rachel',  'Kim',        'rachel.kim@mail.com',        'Edinburgh',  'Employed',    47000.00, 678),\n(19, 'Sam',     'Whitfield',  'sam.whitfield@mail.com',     'Leeds',      'Employed',    39000.00, 645),\n(20, 'Tina',    'Abubakar',   'tina.abubakar@mail.com',     'London',     'Self-Employed',58000.00, 700);\n\nINSERT INTO dim_products VALUES\n(1, 'Personal Loan Standard',  'Personal',  1000.00,  25000.00, 9.9,  36),\n(2, 'Personal Loan Premium',   'Personal',  5000.00,  50000.00, 7.4,  48),\n(3, 'Business Starter Loan',   'Business',  5000.00,  75000.00, 11.5, 24),\n(4, 'Business Growth Loan',    'Business', 20000.00, 200000.00, 8.9,  60),\n(5, 'Property Bridge Loan',    'Property', 50000.00, 500000.00, 5.5,  12),\n(6, 'Auto Finance Standard',   'Auto',      3000.00,  40000.00, 6.9,  60);\n\nINSERT INTO fact_loans VALUES\n(1,  1,  1,  12000.00, '2024-01-10', 'Active',   'B'),\n(2,  2,  1,   8500.00, '2024-01-15', 'Active',   'C'),\n(3,  3,  3,  25000.00, '2024-01-20', 'Active',   'B'),\n(4,  4,  2,  30000.00, '2024-01-25', 'Active',   'A'),\n(5,  5,  1,   5000.00, '2024-02-01', 'Default',  'D'),\n(6,  6,  3,  18000.00, '2024-02-05', 'Active',   'C'),\n(7,  7,  2,  22000.00, '2024-02-10', 'Active',   'B'),\n(8,  8,  4,  60000.00, '2024-02-14', 'Active',   'A'),\n(9,  9,  1,   7500.00, '2024-02-20', 'Active',   'C'),\n(10, 10, 2,  45000.00, '2024-02-28', 'Active',   'A'),\n(11, 11, 1,   4000.00, '2024-03-05', 'Default',  'E'),\n(12, 12, 6,  15000.00, '2024-03-10', 'Active',   'C'),\n(13, 13, 4,  80000.00, '2024-03-15', 'Active',   'A'),\n(14, 14, 1,   9000.00, '2024-03-20', 'Closed',   'C'),\n(15, 15, 3,  32000.00, '2024-03-25', 'Active',   'B'),\n(16, 16, 2,  18000.00, '2024-04-01', 'Active',   'B'),\n(17, 17, 5, 150000.00, '2024-04-05', 'Active',   'A'),\n(18, 18, 6,  12000.00, '2024-04-10', 'Active',   'C'),\n(19, 19, 1,   3500.00, '2024-04-15', 'Default',  'D'),\n(20, 20, 3,  21000.00, '2024-04-20', 'Active',   'B'),\n(21, 1,  6,  20000.00, '2024-05-01', 'Active',   'B'),\n(22, 4,  4,  90000.00, '2024-05-05', 'Active',   'A'),\n(23, 10, 5, 200000.00, '2024-05-10', 'Active',   'A'),\n(24, 13, 2,  48000.00, '2024-05-15', 'Active',   'A'),\n(25, 17, 4, 120000.00, '2024-05-20', 'Active',   'A'),\n(26, 2,  6,  10000.00, '2024-06-01', 'Closed',   'C'),\n(27, 7,  1,   6000.00, '2024-06-05', 'Active',   'B'),\n(28, 8,  2,  35000.00, '2024-06-10', 'Active',   'A'),\n(29, 15, 6,  18000.00, '2024-06-15', 'Active',   'B'),\n(30, 3,  4,  55000.00, '2024-06-20', 'Active',   'B'),\n(31, 9,  6,   8000.00, '2024-07-01', 'Active',   'C'),\n(32, 12, 1,   5500.00, '2024-07-05', 'Default',  'D'),\n(33, 16, 3,  28000.00, '2024-07-10', 'Active',   'B'),\n(34, 18, 1,   4500.00, '2024-07-15', 'Active',   'C'),\n(35, 20, 2,  25000.00, '2024-07-20', 'Active',   'B');\n\nINSERT INTO fact_repayments VALUES\n(1,  1,  '2024-02-10', 380.00, 380.00,  0),\n(2,  1,  '2024-03-10', 380.00, 380.00,  0),\n(3,  1,  '2024-04-10', 380.00, 380.00,  0),\n(4,  2,  '2024-02-15', 265.00, 265.00,  0),\n(5,  2,  '2024-03-15', 265.00, 200.00,  7),\n(6,  2,  '2024-04-15', 265.00, 265.00,  0),\n(7,  3,  '2024-02-20', 1100.00, 1100.00, 0),\n(8,  3,  '2024-03-20', 1100.00, 1100.00, 0),\n(9,  4,  '2024-02-25', 700.00, 700.00,  0),\n(10, 4,  '2024-03-25', 700.00, 700.00,  0),\n(11, 5,  '2024-03-01', 155.00,   0.00, 30),\n(12, 5,  '2024-04-01', 155.00,   0.00, 60),\n(13, 6,  '2024-03-05', 840.00, 840.00,  0),\n(14, 6,  '2024-04-05', 840.00, 840.00,  0),\n(15, 7,  '2024-03-10', 510.00, 510.00,  0),\n(16, 7,  '2024-04-10', 510.00, 510.00,  0),\n(17, 8,  '2024-03-14', 1280.00, 1280.00, 0),\n(18, 8,  '2024-04-14', 1280.00, 1280.00, 0),\n(19, 9,  '2024-03-20', 232.00, 232.00,  0),\n(20, 9,  '2024-04-20', 232.00, 200.00, 14),\n(21, 10, '2024-03-28', 1050.00, 1050.00, 0),\n(22, 10, '2024-04-28', 1050.00, 1050.00, 0),\n(23, 11, '2024-04-05', 124.00,   0.00, 45),\n(24, 11, '2024-05-05', 124.00,   0.00, 75),\n(25, 12, '2024-04-10', 340.00, 340.00,  0),\n(26, 12, '2024-05-10', 340.00, 340.00,  0),\n(27, 13, '2024-04-15', 1700.00, 1700.00, 0),\n(28, 13, '2024-05-15', 1700.00, 1700.00, 0),\n(29, 14, '2024-04-20', 280.00, 280.00,  0),\n(30, 14, '2024-05-20', 280.00, 280.00,  0),\n(31, 15, '2024-04-25', 1400.00, 1400.00, 0),\n(32, 15, '2024-05-25', 1400.00, 1400.00, 0),\n(33, 16, '2024-05-01', 420.00, 420.00,  0),\n(34, 16, '2024-06-01', 420.00, 420.00,  0),\n(35, 17, '2024-05-05', 13600.00, 13600.00, 0),\n(36, 18, '2024-05-10', 270.00, 270.00,  0),\n(37, 18, '2024-06-10', 270.00, 270.00,  0),\n(38, 19, '2024-05-15', 109.00,   0.00, 30),\n(39, 19, '2024-06-15', 109.00,   0.00, 60),\n(40, 20, '2024-05-20', 920.00, 920.00,  0),\n(41, 21, '2024-06-01', 450.00, 450.00,  0),\n(42, 21, '2024-07-01', 450.00, 450.00,  0),\n(43, 22, '2024-06-05', 1920.00, 1920.00, 0),\n(44, 22, '2024-07-05', 1920.00, 1920.00, 0),\n(45, 23, '2024-06-10', 18200.00, 18200.00, 0),\n(46, 24, '2024-06-15', 1120.00, 1120.00, 0),\n(47, 24, '2024-07-15', 1120.00, 1120.00, 0),\n(48, 25, '2024-06-20', 2560.00, 2560.00, 0),\n(49, 25, '2024-07-20', 2560.00, 2560.00, 0),\n(50, 26, '2024-07-01', 310.00, 310.00,  0),\n(51, 26, '2024-08-01', 310.00, 310.00,  0),\n(52, 27, '2024-07-05', 187.00, 187.00,  0),\n(53, 27, '2024-08-05', 187.00, 187.00,  0),\n(54, 28, '2024-07-10', 815.00, 815.00,  0),\n(55, 28, '2024-08-10', 815.00, 815.00,  0),\n(56, 29, '2024-07-15', 405.00, 405.00,  0),\n(57, 29, '2024-08-15', 405.00, 405.00,  0),\n(58, 30, '2024-07-20', 1170.00, 1170.00, 0),\n(59, 30, '2024-08-20', 1170.00, 1170.00, 0),\n(60, 31, '2024-08-01', 220.00, 220.00,  0),\n(61, 31, '2024-09-01', 220.00, 180.00, 10),\n(62, 32, '2024-08-05', 170.00,   0.00, 30),\n(63, 32, '2024-09-05', 170.00,   0.00, 60),\n(64, 33, '2024-08-10', 1230.00, 1230.00, 0),\n(65, 33, '2024-09-10', 1230.00, 1230.00, 0),\n(66, 34, '2024-08-15', 140.00, 140.00,  0),\n(67, 34, '2024-09-15', 140.00, 140.00,  0),\n(68, 35, '2024-08-20', 585.00, 585.00,  0),\n(69, 35, '2024-09-20', 585.00, 585.00,  0),\n(70, 1,  '2024-05-10', 380.00, 380.00,  0),\n(71, 4,  '2024-04-25', 700.00, 700.00,  0),\n(72, 7,  '2024-05-10', 510.00, 510.00,  0),\n(73, 10, '2024-05-28', 1050.00, 1050.00, 0),\n(74, 13, '2024-06-15', 1700.00, 1700.00, 0),\n(75, 8,  '2024-05-14', 1280.00, 1280.00, 0),\n(76, 15, '2024-06-25', 1400.00, 1400.00, 0),\n(77, 16, '2024-07-01', 420.00, 420.00,  0),\n(78, 20, '2024-06-20', 920.00, 920.00,  0),\n(79, 3,  '2024-04-20', 1100.00, 1100.00, 0),\n(80, 6,  '2024-05-05', 840.00, 840.00,  0);",
      "tables": [
        {
          "name": "dim_applicants",
          "columns": [
            {
              "name": "applicant_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "first_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "last_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "email",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "city",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "employment_status",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "annual_income",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "credit_score",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 20
        },
        {
          "name": "dim_products",
          "columns": [
            {
              "name": "product_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "product_name",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "product_type",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "min_amount",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "max_amount",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "interest_rate",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "term_months",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 6
        },
        {
          "name": "fact_loans",
          "columns": [
            {
              "name": "loan_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "applicant_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "product_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "loan_amount",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "approved_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "status",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "risk_grade",
              "type": "TEXT",
              "pk": false
            }
          ],
          "rowCount": 35
        },
        {
          "name": "fact_repayments",
          "columns": [
            {
              "name": "repayment_id",
              "type": "INTEGER",
              "pk": true
            },
            {
              "name": "loan_id",
              "type": "INTEGER",
              "pk": false
            },
            {
              "name": "payment_date",
              "type": "TEXT",
              "pk": false
            },
            {
              "name": "amount_due",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "amount_paid",
              "type": "REAL",
              "pk": false
            },
            {
              "name": "days_late",
              "type": "INTEGER",
              "pk": false
            }
          ],
          "rowCount": 80
        }
      ],
      "quickInsert": [
        "JOIN",
        "WITH",
        "CASE WHEN",
        "SUM() OVER",
        "GROUP BY",
        "HAVING"
      ],
      "pgNotes": null,
      "challenges": [
        {
          "id": "d30-c01",
          "title": "Explore the Schema",
          "description": "Start by understanding the data. Write four separate SELECT queries (run them one at a time) to count the rows in each table: dim_applicants, dim_products, fact_loans, and fact_repayments. Use COUNT(*) and alias it as row_count.",
          "tier": "starter",
          "difficulty": "Easy",
          "hint": "Run SELECT COUNT(*) AS row_count FROM dim_applicants; then repeat for each table. Each query returns one row.",
          "solution": "SELECT COUNT(*) AS row_count FROM dim_applicants;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length === 1 && rows[0].hasOwnProperty('row_count') && rows[0].row_count > 0"
          }
        },
        {
          "id": "d30-c02",
          "title": "Join Loans to Applicants",
          "description": "Produce a report showing who borrowed what. Join fact_loans to dim_applicants and dim_products. Return: applicant first_name and last_name (concatenated as full_name), product_name, loan_amount, approved_date, status, and risk_grade. Order by approved_date ascending.",
          "tier": "starter",
          "difficulty": "Easy",
          "hint": "Join fact_loans to dim_applicants on applicant_id, and to dim_products on product_id. Use (a.first_name || ' ' || a.last_name) AS full_name.",
          "solution": "SELECT\n  a.first_name || ' ' || a.last_name AS full_name,\n  p.product_name,\n  l.loan_amount,\n  l.approved_date,\n  l.status,\n  l.risk_grade\nFROM fact_loans l\nJOIN dim_applicants a ON l.applicant_id = a.applicant_id\nJOIN dim_products   p ON l.product_id   = p.product_id\nORDER BY l.approved_date;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length === 35 && rows[0].hasOwnProperty('full_name') && rows[0].hasOwnProperty('product_name')"
          }
        },
        {
          "id": "d30-c03",
          "title": "Default Rate by Product Type",
          "description": "Calculate the default rate for each product type. For each product_type, show: total_loans (all statuses), defaulted_loans (status = 'Default'), and default_rate as a percentage rounded to 1 decimal place. Order by default_rate descending.",
          "tier": "core",
          "difficulty": "Medium",
          "hint": "Join fact_loans to dim_products. Use COUNT(*) for total_loans and SUM(CASE WHEN l.status = 'Default' THEN 1 ELSE 0 END) for defaulted_loans. Compute default_rate as (defaulted_loans * 100.0 / total_loans).",
          "solution": "SELECT\n  p.product_type,\n  COUNT(*)                                                                      AS total_loans,\n  SUM(CASE WHEN l.status = 'Default' THEN 1 ELSE 0 END)                        AS defaulted_loans,\n  ROUND((SUM(CASE WHEN l.status = 'Default' THEN 1 ELSE 0 END) * 100.0 / COUNT(*))::numeric, 1) AS default_rate\nFROM fact_loans l\nJOIN dim_products p ON l.product_id = p.product_id\nGROUP BY p.product_type\nORDER BY default_rate DESC;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0 && rows[0].hasOwnProperty('default_rate') && rows[0].hasOwnProperty('total_loans')"
          }
        },
        {
          "id": "d30-c04",
          "title": "Applicants with Multiple Loans",
          "description": "Find applicants who have taken out more than one loan. Use a subquery or GROUP BY with HAVING. Return: applicant_id, full_name (first_name || ' ' || last_name), and loan_count. Order by loan_count descending.",
          "tier": "core",
          "difficulty": "Medium",
          "hint": "Group fact_loans by applicant_id and use HAVING COUNT(*) > 1 to filter. Then join to dim_applicants to get the name.",
          "solution": "SELECT\n  a.applicant_id,\n  a.first_name || ' ' || a.last_name AS full_name,\n  COUNT(l.loan_id) AS loan_count\nFROM fact_loans l\nJOIN dim_applicants a ON l.applicant_id = a.applicant_id\nGROUP BY a.applicant_id, a.first_name, a.last_name\nHAVING COUNT(l.loan_id) > 1\nORDER BY loan_count DESC;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0 && rows[0].loan_count >= 2 && rows[0].hasOwnProperty('full_name')"
          }
        },
        {
          "id": "d30-c05",
          "title": "Repayment Performance CTE",
          "description": "Build a CTE called repayment_summary that classifies each repayment row as 'On Time' (days_late = 0), 'Late' (days_late between 1 and 29), or 'Missed' (days_late >= 30 OR amount_paid = 0). Then query the CTE to return: status_category, payment_count, total_due, total_paid, and shortfall (total_due - total_paid). Order by payment_count descending.",
          "tier": "core",
          "difficulty": "Medium",
          "hint": "Define the CTE with a CASE WHEN on days_late and amount_paid. In the outer query, GROUP BY status_category and use SUM for the money columns.",
          "solution": "WITH repayment_summary AS (\n  SELECT\n    CASE\n      WHEN days_late = 0 THEN 'On Time'\n      WHEN days_late BETWEEN 1 AND 29 THEN 'Late'\n      ELSE 'Missed'\n    END AS status_category,\n    amount_due,\n    amount_paid\n  FROM fact_repayments\n)\nSELECT\n  status_category,\n  COUNT(*)                       AS payment_count,\n  ROUND(SUM(amount_due)::numeric, 2)     AS total_due,\n  ROUND(SUM(amount_paid)::numeric, 2)    AS total_paid,\n  ROUND(SUM(amount_due - amount_paid)::numeric, 2) AS shortfall\nFROM repayment_summary\nGROUP BY status_category\nORDER BY payment_count DESC;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0 && rows[0].hasOwnProperty('status_category') && rows[0].hasOwnProperty('shortfall')"
          }
        },
        {
          "id": "d30-c06",
          "title": "Window Function: Rank Applicants by Total Borrowed Within City",
          "description": "Using a window function, rank each applicant by their total loan amount within their city (highest total = rank 1). Return: city, full_name, total_borrowed (SUM of all their loan amounts), and city_rank. Only show applicants who have at least one loan. Order by city, then city_rank.",
          "tier": "stretch",
          "difficulty": "Hard",
          "hint": "Join fact_loans to dim_applicants, GROUP BY applicant and city to get total_borrowed per applicant, then apply RANK() OVER (PARTITION BY city ORDER BY total_borrowed DESC).",
          "solution": "SELECT\n  a.city,\n  a.first_name || ' ' || a.last_name AS full_name,\n  SUM(l.loan_amount)                  AS total_borrowed,\n  RANK() OVER (\n    PARTITION BY a.city\n    ORDER BY SUM(l.loan_amount) DESC\n  ) AS city_rank\nFROM fact_loans l\nJOIN dim_applicants a ON l.applicant_id = a.applicant_id\nGROUP BY a.applicant_id, a.first_name, a.last_name, a.city\nORDER BY a.city, city_rank;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0 && rows[0].hasOwnProperty('city_rank') && rows[0].hasOwnProperty('total_borrowed')"
          }
        },
        {
          "id": "d30-c07",
          "title": "Full Pipeline: Raw to Scored",
          "description": "Build a 3-step CTE chain: (1) raw_loans: join fact_loans, dim_applicants, dim_products into one flat row per loan with all relevant columns. (2) cleaned_loans: filter raw_loans to only Active or Closed loans (exclude Defaults). (3) scored_loans: add a risk_score column using CASE WHEN on risk_grade (A=5, B=4, C=3, D=2, E=1). Final SELECT: product_type, AVG(risk_score) rounded to 2dp as avg_risk_score, COUNT(*) as loan_count. Order by avg_risk_score descending.",
          "tier": "stretch",
          "difficulty": "Hard",
          "hint": "Chain three CTEs. In the final SELECT, group by product_type from the scored_loans CTE.",
          "solution": "WITH raw_loans AS (\n  SELECT\n    l.loan_id,\n    a.first_name || ' ' || a.last_name AS full_name,\n    a.city,\n    a.credit_score,\n    p.product_type,\n    l.loan_amount,\n    l.status,\n    l.risk_grade\n  FROM fact_loans l\n  JOIN dim_applicants a ON l.applicant_id = a.applicant_id\n  JOIN dim_products   p ON l.product_id   = p.product_id\n),\ncleaned_loans AS (\n  SELECT * FROM raw_loans\n  WHERE status IN ('Active', 'Closed')\n),\nscored_loans AS (\n  SELECT *,\n    CASE risk_grade\n      WHEN 'A' THEN 5\n      WHEN 'B' THEN 4\n      WHEN 'C' THEN 3\n      WHEN 'D' THEN 2\n      WHEN 'E' THEN 1\n      ELSE 0\n    END AS risk_score\n  FROM cleaned_loans\n)\nSELECT\n  product_type,\n  ROUND(AVG(risk_score)::numeric, 2) AS avg_risk_score,\n  COUNT(*)                  AS loan_count\nFROM scored_loans\nGROUP BY product_type\nORDER BY avg_risk_score DESC;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0 && rows[0].hasOwnProperty('avg_risk_score') && rows[0].hasOwnProperty('loan_count')"
          }
        },
        {
          "id": "d30-c08",
          "title": "Executive Summary: Key Metrics Across All Dimensions",
          "description": "The final challenge. Write a single query (use CTEs freely) that produces an executive summary with these metrics - one row per product_type: total_loans, total_disbursed (sum of loan_amount), active_loans, default_rate (% rounded to 1dp), total_repayments_collected (sum of amount_paid across all repayments for loans in that product type), and avg_applicant_credit_score (rounded to 0dp). Use JOINs, CTEs, CASE WHEN, GROUP BY, and aggregates. Order by total_disbursed descending.",
          "tier": "stretch",
          "difficulty": "Hard",
          "hint": "Start with a CTE that joins all four tables (fact_repayments -> fact_loans -> dim_products -> dim_applicants). Then aggregate in the outer query. Be careful not to double-count loan_amount when there are multiple repayment rows per loan - aggregate repayments separately first.",
          "solution": "WITH loan_base AS (\n  SELECT\n    l.loan_id,\n    l.applicant_id,\n    l.loan_amount,\n    l.status,\n    p.product_type,\n    a.credit_score\n  FROM fact_loans l\n  JOIN dim_products   p ON l.product_id   = p.product_id\n  JOIN dim_applicants a ON l.applicant_id = a.applicant_id\n),\nrepayment_totals AS (\n  SELECT\n    l.loan_id,\n    SUM(r.amount_paid) AS collected\n  FROM fact_repayments r\n  JOIN fact_loans l ON r.loan_id = l.loan_id\n  GROUP BY l.loan_id\n),\ncombined AS (\n  SELECT\n    lb.product_type,\n    lb.loan_id,\n    lb.loan_amount,\n    lb.status,\n    lb.credit_score,\n    COALESCE(rt.collected, 0) AS collected\n  FROM loan_base lb\n  LEFT JOIN repayment_totals rt ON lb.loan_id = rt.loan_id\n)\nSELECT\n  product_type,\n  COUNT(*)                                                                        AS total_loans,\n  ROUND(SUM(loan_amount)::numeric, 2)                                                     AS total_disbursed,\n  SUM(CASE WHEN status = 'Active'  THEN 1 ELSE 0 END)                           AS active_loans,\n  ROUND(SUM(CASE WHEN status = 'Default' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)::numeric, 1) AS default_rate,\n  ROUND(SUM(collected)::numeric, 2)                                                       AS total_repayments_collected,\n  ROUND(AVG(credit_score)::numeric, 0)                                                    AS avg_applicant_credit_score\nFROM combined\nGROUP BY product_type\nORDER BY total_disbursed DESC;",
          "resetBefore": false,
          "validation": {
            "type": "custom",
            "fn": "rows.length > 0 && rows[0].hasOwnProperty('total_disbursed') && rows[0].hasOwnProperty('default_rate') && rows[0].hasOwnProperty('total_repayments_collected')"
          }
        }
      ]
    }
  ]
};
