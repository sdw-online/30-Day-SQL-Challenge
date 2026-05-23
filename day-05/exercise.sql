-- Day 05: INSERT, UPDATE & DELETE - Exercise Script

-- ============================================
-- products
-- ============================================
DROP TABLE IF EXISTS support_tickets;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id      SERIAL PRIMARY KEY,
    product_name    VARCHAR(100)    NOT NULL,
    category        VARCHAR(50)     NOT NULL,
    price_monthly   NUMERIC(8, 2)   NOT NULL,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE,
    launch_date     DATE            NOT NULL,
    max_users       INTEGER         NOT NULL,
    region          VARCHAR(50)     NOT NULL DEFAULT 'Global'
);

INSERT INTO products (product_name, category, price_monthly, is_active, launch_date, max_users, region)
VALUES
    ('Starter Dashboard',       'Core Plan',    29.00,   TRUE,   '2024-01-15',   5,      'Global'),
    ('Growth Dashboard',        'Core Plan',    79.00,   TRUE,   '2024-01-15',   25,     'Global'),
    ('Enterprise Dashboard',    'Core Plan',    199.00,  TRUE,   '2024-01-15',   100,    'Global'),
    ('Real-Time Alerts',        'Add-On',       15.00,   TRUE,   '2024-03-01',   25,     'Global'),
    ('Custom Reports',          'Add-On',       25.00,   TRUE,   '2024-03-01',   25,     'Global'),
    ('API Access',              'Add-On',       45.00,   TRUE,   '2024-06-10',   50,     'Global'),
    ('White-Label Branding',    'Add-On',       35.00,   TRUE,   '2024-06-10',   10,     'Global'),
    ('Heatmap Tracker',         'Analytics',    19.00,   TRUE,   '2024-09-01',   25,     'UK'),
    ('SEO Audit Tool',          'Analytics',    39.00,   TRUE,   '2024-09-01',   10,     'UK'),
    ('Funnel Analyser',         'Analytics',    49.00,   TRUE,   '2025-01-10',   50,     'Global'),
    ('Session Replay',          'Analytics',    29.00,   FALSE,  '2024-04-15',   25,     'UK'),
    ('Legacy Tracker',          'Deprecated',   0.00,    FALSE,  '2023-06-01',   5,      'UK'),
    ('Beta Uptime Monitor',     'Beta',         0.00,    TRUE,   '2025-02-01',   10,     'Global'),
    ('A/B Test Runner',         'Analytics',    55.00,   TRUE,   '2025-03-01',   25,     'Global'),
    ('GDPR Compliance Pack',    'Add-On',       20.00,   TRUE,   '2025-01-20',   100,    'EU'),
    ('Downtime Detector',       'Core Plan',    49.00,   TRUE,   '2024-11-01',   25,     'Global'),
    ('Form Analytics',          'Analytics',    29.00,   TRUE,   '2025-01-15',   25,     'UK'),
    ('Social Media Dashboard',  'Core Plan',    35.00,   TRUE,   '2025-02-01',   50,     'Global'),
    ('Email Campaign Tracker',  'Analytics',    25.00,   TRUE,   '2025-01-10',   25,     'UK'),
    ('Revenue Attribution',     'Analytics',    79.00,   TRUE,   '2025-02-15',   50,     'Global'),
    ('Churn Predictor',         'Beta',         0.00,    TRUE,   '2025-02-01',   10,     'Global'),
    ('Data Pipeline Monitor',   'Core Plan',    149.00,  TRUE,   '2025-01-15',   100,    'Global'),
    ('Customer Health Score',   'Analytics',    45.00,   TRUE,   '2024-12-01',   25,     'Global'),
    ('Integration Hub',         'Core Plan',    30.00,   TRUE,   '2025-02-01',   100,    'Global'),
    ('Cohort Analyser',         'Analytics',    55.00,   TRUE,   '2025-01-10',   50,     'Global'),
    ('Legacy Reports',          'Deprecated',   0.00,    FALSE,  '2023-01-15',   5,      'UK'),
    ('Survey Builder',          'Analytics',    19.00,   TRUE,   '2025-02-15',   25,     'Global'),
    ('User Onboarding Flow',    'Analytics',    39.00,   TRUE,   '2025-02-01',   50,     'Global'),
    ('Error Log Analyser',      'Beta',         0.00,    TRUE,   '2025-03-01',   10,     'UK'),
    ('Traffic Source Tracker',  'Analytics',    35.00,   TRUE,   '2025-01-20',   25,     'Global');

-- ============================================
-- support_tickets (250 rows)
-- ============================================
CREATE TABLE support_tickets (
    ticket_id       SERIAL PRIMARY KEY,
    customer_name   VARCHAR(100)    NOT NULL,
    customer_email  VARCHAR(150)    NOT NULL,
    subject         VARCHAR(200)    NOT NULL,
    priority        VARCHAR(20)     NOT NULL,
    status          VARCHAR(20)     NOT NULL DEFAULT 'Open',
    assigned_to     VARCHAR(100),
    created_date    DATE            NOT NULL,
    product_name    VARCHAR(100)    NOT NULL
);

-- BLOCK 1: Open tickets, assigned to agents (60 rows)
INSERT INTO support_tickets (customer_name, customer_email, subject, priority, status, assigned_to, created_date, product_name)
VALUES
    -- Nkechi Eze (15 tickets)
    ('Olumide Adeyemi',     'olumide@adeyemidigital.co.uk',     'Dashboard not loading',            'High',     'Open',     'Nkechi Eze',       '2025-03-01',   'Starter Dashboard'),
    ('Bronwen Lloyd',       'bronwen@lloydcreative.co.uk',      'Heatmap data missing',             'High',     'Open',     'Nkechi Eze',       '2025-03-02',   'Heatmap Tracker'),
    ('Soren Hedlund',       'soren@hedlundmedia.com',           'API rate limit exceeded',          'Medium',   'Open',     'Nkechi Eze',       '2025-03-04',   'API Access'),
    ('Thandiwe Mabaso',     'thandiwe@mabasoconsulting.co.uk',  'Funnel drop-off not tracking',     'High',     'Open',     'Nkechi Eze',       '2025-03-06',   'Funnel Analyser'),
    ('Petra Kovar',         'petra@kovardesign.eu',             'SSO login failing',                'Medium',   'Open',     'Nkechi Eze',       '2025-03-08',   'Enterprise Dashboard'),
    ('Reuben Glass',        'reuben@glassarchitects.co.uk',     'Dashboard slow on mobile',         'Low',      'Open',     'Nkechi Eze',       '2025-03-10',   'Growth Dashboard'),
    ('Chidinma Agu',        'chidinma@agusolutions.com',        'Heatmap colours not showing',      'High',     'Open',     'Nkechi Eze',       '2025-03-11',   'Heatmap Tracker'),
    ('Viggo Lindgren',      'viggo@lindgrenventures.com',       'Alert emails going to spam',       'Medium',   'Open',     'Nkechi Eze',       '2025-03-13',   'Real-Time Alerts'),
    ('Esme Whitworth',      'esme@whitworthevents.co.uk',       'Cannot export PDF reports',        'Low',      'Open',     'Nkechi Eze',       '2025-03-15',   'Custom Reports'),
    ('Haruto Kimura',       'haruto@kimurastudio.io',           'A/B test results inconsistent',    'High',     'Open',     'Nkechi Eze',       '2025-03-17',   'A/B Test Runner'),
    ('Binta Diallo',        'binta@diallotrading.co.uk',        'Heatmap data missing',             'High',     'Open',     'Nkechi Eze',       '2025-03-19',   'Heatmap Tracker'),
    ('Gethin Parry',        'gethin@parryengineering.co.uk',    'Pipeline alert delayed',           'Medium',   'Open',     'Nkechi Eze',       '2025-03-22',   'Data Pipeline Monitor'),
    ('Yusra Mahdi',         'yusra@mahdipartners.co.uk',        'Downtime alert not firing',        'High',     'Open',     'Nkechi Eze',       '2025-03-25',   'Downtime Detector'),
    ('Stellan Borg',        'stellan@borgcapital.com',          'Social feed not loading',          'Low',      'Open',     'Nkechi Eze',       '2025-03-28',   'Social Media Dashboard'),
    ('Adaeze Okoro',        'adaeze@okorofinance.co.uk',        'Form submission not tracked',      'Medium',   'Open',     'Nkechi Eze',       '2025-04-01',   'Form Analytics'),

    -- Jaime Ruiz (15 tickets)
    ('Rhodri Evans',        'rhodri@evanslogistics.co.uk',      'SEO audit timing out',             'High',     'Open',     'Jaime Ruiz',       '2025-03-01',   'SEO Audit Tool'),
    ('Ingrid Dahl',         'ingrid@dahlconsulting.eu',         'Heatmap colours not showing',      'High',     'Open',     'Jaime Ruiz',       '2025-03-03',   'Heatmap Tracker'),
    ('Emeka Nwosu',         'emeka@nwosutechnologies.com',      'Cannot add team members',          'Medium',   'Open',     'Jaime Ruiz',       '2025-03-05',   'Growth Dashboard'),
    ('Katja Brandt',        'katja@brandtmedia.eu',             'White-label logo not rendering',   'High',     'Open',     'Jaime Ruiz',       '2025-03-07',   'White-Label Branding'),
    ('Lorcan Murphy',       'lorcan@murphycraft.co.uk',         'Billing discrepancy',              'Low',      'Open',     'Jaime Ruiz',       '2025-03-09',   'Starter Dashboard'),
    ('Nalini Prasad',       'nalini@prasadanalytics.io',        'Heatmap data missing',             'High',     'Open',     'Jaime Ruiz',       '2025-03-12',   'Heatmap Tracker'),
    ('Torben Eriksen',      'torben@eriksensystems.com',        'Revenue not matching CRM',         'Medium',   'Open',     'Jaime Ruiz',       '2025-03-14',   'Revenue Attribution'),
    ('Grainne Doyle',       'grainne@doylepartners.co.uk',      'Cookie consent issue',             'Low',      'Open',     'Jaime Ruiz',       '2025-03-16',   'GDPR Compliance Pack'),
    ('Kolade Bello',        'kolade@belloinnovations.com',      'Click tracking inaccurate',        'High',     'Open',     'Jaime Ruiz',       '2025-03-18',   'Heatmap Tracker'),
    ('Maren Schultz',       'maren@schultzdesign.eu',           'Custom report filter broken',      'Medium',   'Open',     'Jaime Ruiz',       '2025-03-20',   'Custom Reports'),
    ('Ffion Hughes',        'ffion@hughescatering.co.uk',       'Uptime monitor false alarm',       'Low',      'Open',     'Jaime Ruiz',       '2025-03-23',   'Beta Uptime Monitor'),
    ('Ade Ogunlade',        'ade@ogunladeconsulting.co.uk',     'Scroll depth wrong',               'High',     'Open',     'Jaime Ruiz',       '2025-03-26',   'Heatmap Tracker'),
    ('Elina Virtanen',      'elina@virtanenmedia.eu',           'Open rate not updating',           'Medium',   'Open',     'Jaime Ruiz',       '2025-03-30',   'Email Campaign Tracker'),
    ('Cillian Walsh',       'cillian@walshdesign.co.uk',        'Cohort grouping incorrect',        'High',     'Open',     'Jaime Ruiz',       '2025-04-02',   'Cohort Analyser'),
    ('Amaka Eze',           'amaka@ezeproperties.co.uk',        'Health score not calculating',     'Medium',   'Open',     'Jaime Ruiz',       '2025-04-05',   'Customer Health Score'),

    -- Lena Bergstrom (15 tickets)
    ('Henrik Johansson',    'henrik@johanssontech.com',         'Invoice not matching usage',       'High',     'Open',     'Lena Bergstrom',   '2025-03-02',   'Enterprise Dashboard'),
    ('Nneka Obi',           'nneka@obimarketing.co.uk',         'Real-time alert delay',            'Medium',   'Open',     'Lena Bergstrom',   '2025-03-04',   'Real-Time Alerts'),
    ('Caoimhe Brennan',     'caoimhe@brennanlegal.co.uk',       'Slow page load',                   'Low',      'Open',     'Lena Bergstrom',   '2025-03-06',   'Starter Dashboard'),
    ('Folake Adewale',      'folake@adewalecreative.com',       'Heatmap data missing',             'High',     'Open',     'Lena Bergstrom',   '2025-03-08',   'Heatmap Tracker'),
    ('Aleksi Nieminen',     'aleksi@nieminencapital.eu',        'Widget not rendering',             'Medium',   'Open',     'Lena Bergstrom',   '2025-03-10',   'Growth Dashboard'),
    ('Morwenna Trelawny',   'morwenna@trelawnydesign.co.uk',    'Authentication token expired',     'High',     'Open',     'Lena Bergstrom',   '2025-03-11',   'API Access'),
    ('Dakarai Moyo',        'dakarai@moyopartners.co.uk',       'SEO tool missing pages',           'Medium',   'Open',     'Lena Bergstrom',   '2025-03-13',   'SEO Audit Tool'),
    ('Siiri Koppel',        'siiri@koppelconsulting.eu',        'Test not starting',                'Low',      'Open',     'Lena Bergstrom',   '2025-03-15',   'A/B Test Runner'),
    ('Oisin Gallagher',     'oisin@gallaghermedia.co.uk',       'Data sync delay',                  'High',     'Open',     'Lena Bergstrom',   '2025-03-17',   'Growth Dashboard'),
    ('Tomoko Hayashi',      'tomoko@hayashimedia.co.uk',        'Heatmap colours not showing',      'Medium',   'Open',     'Lena Bergstrom',   '2025-03-12',   'Heatmap Tracker'),
    ('Ekundayo Fashola',    'ekundayo@fasholasystems.com',      'Funnel setup wizard broken',       'High',     'Open',     'Lena Bergstrom',   '2025-03-20',   'Funnel Analyser'),
    ('Astrid Nyman',        'astrid@nymanarchitects.eu',        'Role permissions issue',           'Medium',   'Open',     'Lena Bergstrom',   '2025-03-23',   'Enterprise Dashboard'),
    ('Ife Balogun',         'ife@balogunventures.co.uk',        'Click tracking inaccurate',        'High',     'Open',     'Lena Bergstrom',   '2025-03-26',   'Heatmap Tracker'),
    ('Ronan Tierney',       'ronan@tierneyconsulting.co.uk',    'Salesforce sync broken',           'Low',      'Open',     'Lena Bergstrom',   '2025-03-29',   'Integration Hub'),
    ('Kemisola Ajayi',      'kemisola@ajayimedia.co.uk',        'Prediction score inaccurate',      'Medium',   'Open',     'Lena Bergstrom',   '2025-04-02',   'Churn Predictor'),

    -- Dimitri Kallas (15 tickets)
    ('Blessing Igwe',       'blessing@igwetrading.co.uk',       'Heatmap data missing',             'High',     'Open',     'Dimitri Kallas',   '2025-03-01',   'Heatmap Tracker'),
    ('Anwen Price',         'anwen@priceandco.co.uk',           'False positive alerts',            'Medium',   'Open',     'Dimitri Kallas',   '2025-03-03',   'Real-Time Alerts'),
    ('Ilkka Makkonen',      'ilkka@makkonensystems.eu',         'Dashboard timeout',                'High',     'Open',     'Dimitri Kallas',   '2025-03-05',   'Enterprise Dashboard'),
    ('Bolaji Oladipo',      'bolaji@oladipodesign.com',         'Cannot reset password',            'Low',      'Open',     'Dimitri Kallas',   '2025-03-07',   'Starter Dashboard'),
    ('Saoirse Quinn',       'saoirse@quinncommunications.co.uk','Report scheduling failed',         'Medium',   'Open',     'Dimitri Kallas',   '2025-03-09',   'Custom Reports'),
    ('Tunde Bakare',        'tunde@bakareconsulting.co.uk',     'Heatmap colours not showing',      'High',     'Open',     'Dimitri Kallas',   '2025-03-11',   'Heatmap Tracker'),
    ('Liselotte Voss',      'liselotte@vossmedia.eu',           'Survey not publishing',            'Medium',   'Open',     'Dimitri Kallas',   '2025-03-14',   'Survey Builder'),
    ('Obinna Chukwuma',     'obinna@chukwumalogistics.com',     'Webhook not firing',               'High',     'Open',     'Dimitri Kallas',   '2025-03-17',   'API Access'),
    ('Eirlys Morgan',       'eirlys@morganpartners.co.uk',      'Onboarding steps skipped',         'Low',      'Open',     'Dimitri Kallas',   '2025-03-19',   'User Onboarding Flow'),
    ('Jide Afolabi',        'jide@afolabicapital.co.uk',        'Log parsing failing',              'High',     'Open',     'Dimitri Kallas',   '2025-03-21',   'Error Log Analyser'),
    ('Tuula Lahti',         'tuula@lahtisolutions.eu',          'Source attribution wrong',         'Medium',   'Open',     'Dimitri Kallas',   '2025-03-24',   'Traffic Source Tracker'),
    ('Chidi Emenike',       'chidi@emenikefinance.co.uk',       'Custom domain not working',        'Low',      'Open',     'Dimitri Kallas',   '2025-03-27',   'White-Label Branding'),
    ('Nerys Griffiths',     'nerys@griffithshr.co.uk',          'Engagement metrics wrong',         'High',     'Open',     'Dimitri Kallas',   '2025-03-30',   'Social Media Dashboard'),
    ('Ayodeji Fasanya',     'ayodeji@fasanyatech.com',          'Retention chart wrong',            'Medium',   'Open',     'Dimitri Kallas',   '2025-04-03',   'Cohort Analyser'),
    ('Bethan Rees',         'bethan@reescreative.co.uk',        'Drop-off rate incorrect',          'High',     'Open',     'Dimitri Kallas',   '2025-04-06',   'Form Analytics');

-- BLOCK 2: Open tickets, unassigned (45 rows)
INSERT INTO support_tickets (customer_name, customer_email, subject, priority, status, assigned_to, created_date, product_name)
VALUES
    -- High priority (14 tickets)
    ('Obiageli Nwachukwu',  'obiageli@nwachukwulaw.co.uk',      'Heatmap data missing',             'High',     'Open',     NULL,   '2025-03-02',   'Heatmap Tracker'),
    ('Padraig Connolly',    'padraig@connollybuilders.co.uk',   'Dashboard not loading',            'High',     'Open',     NULL,   '2025-03-05',   'Starter Dashboard'),
    ('Nnamdi Okeke',        'nnamdi@okekeconsulting.com',       'SSO login failing',                'High',     'Open',     NULL,   '2025-03-08',   'Enterprise Dashboard'),
    ('Brigitte Larsson',    'brigitte@larssongroup.eu',         'Heatmap colours not showing',      'High',     'Open',     NULL,   '2025-03-11',   'Heatmap Tracker'),
    ('Declan Kavanagh',     'declan@kavanaghdesign.co.uk',      'A/B test results inconsistent',    'High',     'Open',     NULL,   '2025-03-14',   'A/B Test Runner'),
    ('Kelechi Amadi',       'kelechi@amadipartners.co.uk',      'API rate limit exceeded',          'High',     'Open',     NULL,   '2025-03-16',   'API Access'),
    ('Helga Petersen',      'helga@petersenmarine.eu',          'Pipeline alert delayed',           'High',     'Open',     NULL,   '2025-03-19',   'Data Pipeline Monitor'),
    ('Ifeanyi Okafor',      'ifeanyi@okaforventures.com',       'Funnel drop-off not tracking',     'High',     'Open',     NULL,   '2025-03-22',   'Funnel Analyser'),
    ('Niamh Flaherty',      'niamh@flahertymedia.co.uk',        'Real-time alert delay',            'High',     'Open',     NULL,   '2025-03-25',   'Real-Time Alerts'),
    ('Chukwuemeka Ibe',     'chukwuemeka@ibetechnologies.com',  'SEO audit timing out',             'High',     'Open',     NULL,   '2025-03-28',   'SEO Audit Tool'),
    ('Iestyn Thomas',       'iestyn@thomasengineering.co.uk',   'Revenue not matching CRM',         'High',     'Open',     NULL,   '2025-04-01',   'Revenue Attribution'),
    ('Adannaya Udo',        'adannaya@udoservices.co.uk',       'Click tracking inaccurate',        'High',     'Open',     NULL,   '2025-04-04',   'Heatmap Tracker'),
    ('Tadgh O''Sullivan',   'tadgh@osullivanlaw.co.uk',         'Job failure not reported',         'High',     'Open',     NULL,   '2025-04-07',   'Data Pipeline Monitor'),
    ('Chiamaka Onyeka',     'chiamaka@onyekadesign.com',        'Alert not triggering',             'High',     'Open',     NULL,   '2025-04-10',   'Real-Time Alerts'),

    -- Medium priority (21 tickets)
    ('Einar Magnusson',     'einar@magnussongroup.eu',          'Custom report filter broken',      'Medium',   'Open',     NULL,   '2025-03-01',   'Custom Reports'),
    ('Oluwatobi Adeniyi',   'oluwatobi@adeniyimedia.co.uk',     'Status page not updating',         'Medium',   'Open',     NULL,   '2025-03-03',   'Beta Uptime Monitor'),
    ('Cerys Davies',        'cerys@daviescatering.co.uk',       'Brand colours not applied',        'Medium',   'Open',     NULL,   '2025-03-05',   'White-Label Branding'),
    ('Emem Bassey',         'emem@basseyconsulting.com',        'Dashboard slow on mobile',         'Medium',   'Open',     NULL,   '2025-03-07',   'Growth Dashboard'),
    ('Tuomas Lahtinen',     'tuomas@lahtinensystems.eu',        'GDPR report format question',      'Medium',   'Open',     NULL,   '2025-03-09',   'GDPR Compliance Pack'),
    ('Oluwafemi Ogunbiyi',  'oluwafemi@ogunbiyitech.co.uk',    'Conversion goal miscounted',       'Medium',   'Open',     NULL,   '2025-03-11',   'Funnel Analyser'),
    ('Mairead Doherty',     'mairead@dohertylegal.co.uk',       'Chart rendering issue',            'Medium',   'Open',     NULL,   '2025-03-13',   'Custom Reports'),
    ('Ikenna Egbuna',       'ikenna@egbunasolutions.com',       'False downtime alert',             'Medium',   'Open',     NULL,   '2025-03-15',   'Downtime Detector'),
    ('Svenja Krause',       'svenja@krausedesign.eu',           'Field-level data missing',         'Medium',   'Open',     NULL,   '2025-03-17',   'Form Analytics'),
    ('Chinyere Arinze',     'chinyere@arinzeconsulting.co.uk',  'Platform connection lost',         'Medium',   'Open',     NULL,   '2025-03-19',   'Social Media Dashboard'),
    ('Eirik Hauge',         'eirik@haugemarine.eu',             'Click tracking broken',            'Medium',   'Open',     NULL,   '2025-03-21',   'Email Campaign Tracker'),
    ('Adaugo Ekwueme',      'adaugo@ekwuemepartners.co.uk',    'Channel mismatch detected',        'Medium',   'Open',     NULL,   '2025-03-23',   'Revenue Attribution'),
    ('Rhiannon Pritchard',  'rhiannon@pritchardmedia.co.uk',   'Model not updating',               'Medium',   'Open',     NULL,   '2025-03-25',   'Churn Predictor'),
    ('Chimezie Uzo',        'chimezie@uzologistics.com',       'Dashboard data stale',             'Medium',   'Open',     NULL,   '2025-03-27',   'Data Pipeline Monitor'),
    ('Ailbhe Maguire',      'ailbhe@maguiredesign.co.uk',      'Score threshold incorrect',        'Medium',   'Open',     NULL,   '2025-03-29',   'Customer Health Score'),
    ('Nonso Okwu',          'nonso@okwuventures.co.uk',        'HubSpot connection lost',          'Medium',   'Open',     NULL,   '2025-04-01',   'Integration Hub'),
    ('Elowen Tresize',      'elowen@tresizeevents.co.uk',      'Date range filter broken',         'Medium',   'Open',     NULL,   '2025-04-03',   'Cohort Analyser'),
    ('Ogechi Nwankwo',      'ogechi@nwankwomedia.com',          'Response data missing',            'Medium',   'Open',     NULL,   '2025-04-05',   'Survey Builder'),
    ('Tadhg Mulcahy',       'tadhg@mulcahypartners.co.uk',     'Progress not saving',              'Medium',   'Open',     NULL,   '2025-04-08',   'User Onboarding Flow'),
    ('Ebele Ihejirika',     'ebele@ihejirikaconsulting.co.uk',  'Error grouping incorrect',         'Medium',   'Open',     NULL,   '2025-04-11',   'Error Log Analyser'),
    ('Ragnhild Strand',     'ragnhild@strandmedia.eu',         'Referral data missing',            'Medium',   'Open',     NULL,   '2025-04-14',   'Traffic Source Tracker'),

    -- Low priority (10 tickets)
    ('Oluwadamilola Bamisile','oluwadamilola@bamisiledesign.com','Ping frequency too low',          'Low',      'Open',     NULL,   '2025-03-04',   'Beta Uptime Monitor'),
    ('Gareth Bowen',        'gareth@bowenandco.co.uk',          'Cannot reset password',            'Low',      'Open',     NULL,   '2025-03-10',   'Starter Dashboard'),
    ('Adaeze Dim',          'adaeze@dimservices.co.uk',         'Data deletion request',            'Low',      'Open',     NULL,   '2025-03-16',   'GDPR Compliance Pack'),
    ('Fiadh Kelleher',      'fiadh@kelleherstudio.co.uk',       'Scheduled post failed',            'Low',      'Open',     NULL,   '2025-03-22',   'Social Media Dashboard'),
    ('Chisom Eze',          'chisom@ezeanalytics.com',          'Campaign report delayed',          'Low',      'Open',     NULL,   '2025-03-28',   'Email Campaign Tracker'),
    ('Oskar Norberg',       'oskar@norbergcapital.eu',          'UTM tracking broken',              'Low',      'Open',     NULL,   '2025-04-03',   'Revenue Attribution'),
    ('Uchenna Maduka',      'uchenna@madukalogistics.co.uk',    'Data feed disconnected',           'Low',      'Open',     NULL,   '2025-04-06',   'Churn Predictor'),
    ('Carys Llewellyn',     'carys@llewellynpartners.co.uk',    'Slack notification failed',        'Low',      'Open',     NULL,   '2025-04-09',   'Integration Hub'),
    ('Uzoma Obiora',        'uzoma@obioraconsulting.com',       'Logic branching broken',           'Low',      'Open',     NULL,   '2025-04-12',   'Survey Builder'),
    ('Anja Vestergaard',    'anja@vestergaardmedia.eu',         'Checklist not loading',            'Low',      'Open',     NULL,   '2025-04-15',   'User Onboarding Flow');

-- BLOCK 3: In Progress tickets (60 rows)
INSERT INTO support_tickets (customer_name, customer_email, subject, priority, status, assigned_to, created_date, product_name)
VALUES
    -- Nkechi Eze (15 In Progress)
    ('Damilare Akinola',    'damilare@akinoladigital.com',      'Monitoring gap detected',          'High',     'In Progress',  'Nkechi Eze',       '2025-03-01',   'Downtime Detector'),
    ('Eleri Hopkins',       'eleri@hopkinsmedia.co.uk',         'Form version mismatch',            'Medium',   'In Progress',  'Nkechi Eze',       '2025-03-03',   'Form Analytics'),
    ('Olayinka Bamgbose',   'olayinka@bamgbosetech.com',        'Engagement metrics wrong',         'High',     'In Progress',  'Nkechi Eze',       '2025-03-05',   'Social Media Dashboard'),
    ('Ragnar Holm',         'ragnar@holmsystems.eu',            'Campaign report delayed',          'Low',      'In Progress',  'Nkechi Eze',       '2025-03-07',   'Email Campaign Tracker'),
    ('Yetunde Fashanu',     'yetunde@fashanuconsulting.co.uk',  'Attribution model wrong',          'High',     'In Progress',  'Nkechi Eze',       '2025-03-10',   'Revenue Attribution'),
    ('Aled Pugh',           'aled@pughengineering.co.uk',       'Threshold setting issue',          'Medium',   'In Progress',  'Nkechi Eze',       '2025-03-13',   'Churn Predictor'),
    ('Ifeoma Udoh',         'ifeoma@udohpartners.co.uk',        'Log aggregation broken',           'High',     'In Progress',  'Nkechi Eze',       '2025-03-16',   'Data Pipeline Monitor'),
    ('Birgitta Nordin',     'birgitta@nordinconsulting.eu',      'Weekly digest missing',            'Low',      'In Progress',  'Nkechi Eze',       '2025-03-19',   'Customer Health Score'),
    ('Babajide Olamide',    'babajide@olamideventures.com',     'Zapier webhook error',             'Medium',   'In Progress',  'Nkechi Eze',       '2025-03-22',   'Integration Hub'),
    ('Dilwen Probert',      'dilwen@probertmedia.co.uk',        'Export format issue',              'Low',      'In Progress',  'Nkechi Eze',       '2025-03-25',   'Cohort Analyser'),
    ('Aminu Akpan',         'aminu@akpanservices.co.uk',        'Thank-you page error',             'Medium',   'In Progress',  'Nkechi Eze',       '2025-03-28',   'Survey Builder'),
    ('Eilif Svensson',      'eilif@svenssondesign.eu',          'Welcome email missing',            'High',     'In Progress',  'Nkechi Eze',       '2025-04-01',   'User Onboarding Flow'),
    ('Ozioma Ibe',          'ozioma@ibeanalytics.co.uk',        'Alert threshold too low',          'Medium',   'In Progress',  'Nkechi Eze',       '2025-04-05',   'Error Log Analyser'),
    ('Tegwen Watkins',      'tegwen@watkinslaw.co.uk',          'UTM parameters lost',              'Low',      'In Progress',  'Nkechi Eze',       '2025-04-09',   'Traffic Source Tracker'),
    ('Adaobi Nwogu',        'adaobi@nwogumedia.com',            'Step labels missing',              'High',     'In Progress',  'Nkechi Eze',       '2025-04-12',   'Funnel Analyser'),

    -- Jaime Ruiz (15 In Progress)
    ('Seamus Byrne',        'seamus@byrneassociates.co.uk',     'Billing discrepancy',              'Medium',   'In Progress',  'Jaime Ruiz',       '2025-03-02',   'Starter Dashboard'),
    ('Titilayo Oni',        'titilayo@onicreative.co.uk',       'API documentation unclear',        'Low',      'In Progress',  'Jaime Ruiz',       '2025-03-04',   'API Access'),
    ('Celyn James',         'celyn@jamesconsulting.co.uk',      'Crawl budget exceeded',            'High',     'In Progress',  'Jaime Ruiz',       '2025-03-06',   'SEO Audit Tool'),
    ('Chinonso Ikeh',       'chinonso@ikehsolutions.com',       'Brand colours not applied',        'Medium',   'In Progress',  'Jaime Ruiz',       '2025-03-09',   'White-Label Branding'),
    ('Dagny Frederiksen',   'dagny@frederiksengroup.eu',        'Sample size too small',            'High',     'In Progress',  'Jaime Ruiz',       '2025-03-12',   'A/B Test Runner'),
    ('Ikemefuna Agu',       'ikemefuna@aguventures.com',        'Privacy policy template',          'Low',      'In Progress',  'Jaime Ruiz',       '2025-03-15',   'GDPR Compliance Pack'),
    ('Hefin Richards',      'hefin@richardsdesign.co.uk',       'Status page sync issue',           'Medium',   'In Progress',  'Jaime Ruiz',       '2025-03-18',   'Downtime Detector'),
    ('Oluwaseyi Bashorun',  'oluwaseyi@bashoruncapital.com',    'Drop-off rate incorrect',          'High',     'In Progress',  'Jaime Ruiz',       '2025-03-21',   'Form Analytics'),
    ('Sigrid Andersen',     'sigrid@andersenmarine.eu',         'Platform connection lost',         'Medium',   'In Progress',  'Jaime Ruiz',       '2025-03-24',   'Social Media Dashboard'),
    ('Onyekachi Ani',       'onyekachi@anisystems.co.uk',       'Bounce rate inflated',             'Low',      'In Progress',  'Jaime Ruiz',       '2025-03-27',   'Email Campaign Tracker'),
    ('Bedwyr Owen',         'bedwyr@owenarchitects.co.uk',      'Channel mismatch detected',        'High',     'In Progress',  'Jaime Ruiz',       '2025-03-30',   'Revenue Attribution'),
    ('Adetola Olaniyan',    'adetola@olaniyanconsulting.com',   'Data feed disconnected',           'Medium',   'In Progress',  'Jaime Ruiz',       '2025-04-03',   'Churn Predictor'),
    ('Marit Gulbrandsen',   'marit@gulbrandsendesign.eu',       'Dashboard data stale',             'Low',      'In Progress',  'Jaime Ruiz',       '2025-04-06',   'Data Pipeline Monitor'),
    ('Ugochukwu Nwobi',     'ugochukwu@nwobipartners.com',      'Slack notification failed',        'High',     'In Progress',  'Jaime Ruiz',       '2025-04-09',   'Integration Hub'),
    ('Glenys Roberts',      'glenys@robertsevents.co.uk',       'Retention chart wrong',            'Medium',   'In Progress',  'Jaime Ruiz',       '2025-04-13',   'Cohort Analyser'),

    -- Lena Bergstrom (15 In Progress)
    ('Olamiposi Adebayo',   'olamiposi@adebayodesign.com',      'Widget not rendering',             'High',     'In Progress',  'Lena Bergstrom',   '2025-03-01',   'Growth Dashboard'),
    ('Trystan Lewis',       'trystan@lewismedia.co.uk',         'SSL check failing',                'Medium',   'In Progress',  'Lena Bergstrom',   '2025-03-04',   'Beta Uptime Monitor'),
    ('Chinelo Ogbonna',     'chinelo@ogbonnaconsulting.co.uk',  'Footer text missing',              'Low',      'In Progress',  'Lena Bergstrom',   '2025-03-07',   'White-Label Branding'),
    ('Gunnar Soderberg',    'gunnar@soderbergtech.eu',          'Meta tag analysis wrong',          'High',     'In Progress',  'Lena Bergstrom',   '2025-03-10',   'SEO Audit Tool'),
    ('Ebunoluwa Ajakaiye',  'ebunoluwa@ajakaiyemedia.com',      'Variant not loading',              'Medium',   'In Progress',  'Lena Bergstrom',   '2025-03-13',   'A/B Test Runner'),
    ('Delyth Rowlands',     'delyth@rowlandshr.co.uk',          'Data deletion request',            'Low',      'In Progress',  'Lena Bergstrom',   '2025-03-16',   'GDPR Compliance Pack'),
    ('Somtochukwu Agha',    'somtochukwu@aghasolutions.com',    'False downtime alert',             'High',     'In Progress',  'Lena Bergstrom',   '2025-03-19',   'Downtime Detector'),
    ('Anneli Wikstrom',     'anneli@wikstromgroup.eu',          'Scheduled post failed',            'Medium',   'In Progress',  'Lena Bergstrom',   '2025-03-22',   'Social Media Dashboard'),
    ('Obiora Nnaji',        'obiora@nnajilogistics.co.uk',      'Open rate not updating',           'Low',      'In Progress',  'Lena Bergstrom',   '2025-03-25',   'Email Campaign Tracker'),
    ('Glenda Harries',      'glenda@harriespartners.co.uk',     'UTM tracking broken',              'High',     'In Progress',  'Lena Bergstrom',   '2025-03-28',   'Revenue Attribution'),
    ('Chibueze Nwafor',     'chibueze@nwaforventures.com',      'Prediction score inaccurate',      'Medium',   'In Progress',  'Lena Bergstrom',   '2025-04-01',   'Churn Predictor'),
    ('Solveig Haugen',      'solveig@haugenconsulting.eu',      'Job failure not reported',         'High',     'In Progress',  'Lena Bergstrom',   '2025-04-04',   'Data Pipeline Monitor'),
    ('Azubuike Obi',        'azubuike@obicapital.co.uk',        'Data source disconnected',         'Low',      'In Progress',  'Lena Bergstrom',   '2025-04-07',   'Customer Health Score'),
    ('Myfanwy Jenkins',     'myfanwy@jenkinsmedia.co.uk',       'Response data missing',            'Medium',   'In Progress',  'Lena Bergstrom',   '2025-04-10',   'Survey Builder'),
    ('Ikechukwu Dimgba',    'ikechukwu@dimgbasystems.com',      'Stack trace truncated',            'High',     'In Progress',  'Lena Bergstrom',   '2025-04-14',   'Error Log Analyser'),

    -- Dimitri Kallas (15 In Progress)
    ('Nkem Uchegbu',        'nkem@uchegbudesign.co.uk',         'Report scheduling failed',         'High',     'In Progress',  'Dimitri Kallas',   '2025-03-02',   'Custom Reports'),
    ('Catrin Williams',     'catrin@williamsandco.co.uk',        'Slow page load',                   'Medium',   'In Progress',  'Dimitri Kallas',   '2025-03-05',   'Starter Dashboard'),
    ('Oluwabunmi Alabi',    'oluwabunmi@alabipartners.com',     'Dashboard not loading',            'High',     'In Progress',  'Dimitri Kallas',   '2025-03-08',   'Starter Dashboard'),
    ('Halvard Nilsen',      'halvard@nilsengroup.eu',           'Role permissions issue',           'Low',      'In Progress',  'Dimitri Kallas',   '2025-03-11',   'Enterprise Dashboard'),
    ('Chinwe Ezeh',         'chinwe@ezehconsulting.co.uk',      'Alert not triggering',             'Medium',   'In Progress',  'Dimitri Kallas',   '2025-03-14',   'Real-Time Alerts'),
    ('Gwilym Parry',        'gwilym@parryconstruction.co.uk',   'Funnel setup wizard broken',       'High',     'In Progress',  'Dimitri Kallas',   '2025-03-17',   'Funnel Analyser'),
    ('Adaolisa Okafor',     'adaolisa@okaformedia.com',         'Cookie consent issue',             'Low',      'In Progress',  'Dimitri Kallas',   '2025-03-20',   'GDPR Compliance Pack'),
    ('Vidar Bergman',       'vidar@bergmancapital.eu',          'Monitoring gap detected',          'Medium',   'In Progress',  'Dimitri Kallas',   '2025-03-23',   'Downtime Detector'),
    ('Onyinye Mgbemena',    'onyinye@mgbemenasystems.co.uk',    'Field-level data missing',         'High',     'In Progress',  'Dimitri Kallas',   '2025-03-26',   'Form Analytics'),
    ('Owain Griffith',      'owain@griffithdesign.co.uk',       'Bounce rate inflated',             'Low',      'In Progress',  'Dimitri Kallas',   '2025-03-29',   'Email Campaign Tracker'),
    ('Mmadubugwu Eze',      'mmadubugwu@ezesolutions.com',     'Score threshold incorrect',        'Medium',   'In Progress',  'Dimitri Kallas',   '2025-04-02',   'Customer Health Score'),
    ('Astri Johannessen',   'astri@johannessendesign.eu',       'HubSpot connection lost',          'High',     'In Progress',  'Dimitri Kallas',   '2025-04-05',   'Integration Hub'),
    ('Ugonna Aneke',        'ugonna@anekeventures.co.uk',       'Cohort grouping incorrect',        'Low',      'In Progress',  'Dimitri Kallas',   '2025-04-08',   'Cohort Analyser'),
    ('Lowri Jenkins',       'lowri@jenkinslaw.co.uk',           'Onboarding steps skipped',         'Medium',   'In Progress',  'Dimitri Kallas',   '2025-04-11',   'User Onboarding Flow'),
    ('Ekene Okoye',         'ekene@okoyepartners.com',          'Campaign grouping broken',         'High',     'In Progress',  'Dimitri Kallas',   '2025-04-15',   'Traffic Source Tracker');

-- BLOCK 4: Resolved tickets (60 rows)
INSERT INTO support_tickets (customer_name, customer_email, subject, priority, status, assigned_to, created_date, product_name)
VALUES
    -- Nkechi Eze (15 Resolved)
    ('Ifunanya Igbokwe',    'ifunanya@igbokweconsulting.co.uk', 'Cannot export PDF reports',        'Medium',   'Resolved',     'Nkechi Eze',       '2025-03-01',   'Custom Reports'),
    ('Bryn Meredith',       'bryn@meredithdesign.co.uk',        'Heatmap data missing',             'High',     'Resolved',     'Nkechi Eze',       '2025-03-03',   'Heatmap Tracker'),
    ('Wumi Adewusi',        'wumi@adewusicreative.com',         'Dashboard slow on mobile',         'Medium',   'Resolved',     'Nkechi Eze',       '2025-03-05',   'Growth Dashboard'),
    ('Arvid Lindqvist',     'arvid@lindqvistmarine.eu',         'API documentation unclear',        'Low',      'Resolved',     'Nkechi Eze',       '2025-03-08',   'API Access'),
    ('Obianuju Eze',        'obianuju@ezemedia.co.uk',          'Invoice not matching usage',       'High',     'Resolved',     'Nkechi Eze',       '2025-03-11',   'Enterprise Dashboard'),
    ('Enfys Powell',        'enfys@powellpartners.co.uk',       'SEO tool missing pages',           'Medium',   'Resolved',     'Nkechi Eze',       '2025-03-14',   'SEO Audit Tool'),
    ('Dike Okonkwo',        'dike@okonkwoventures.com',         'Test not starting',                'Low',      'Resolved',     'Nkechi Eze',       '2025-03-17',   'A/B Test Runner'),
    ('Gudrun Eriksson',     'gudrun@erikssonconsulting.eu',      'Privacy policy template',          'Medium',   'Resolved',     'Nkechi Eze',       '2025-03-20',   'GDPR Compliance Pack'),
    ('Osinachi Amaechi',    'osinachi@amaechisolutions.co.uk',  'Alert emails going to spam',       'High',     'Resolved',     'Nkechi Eze',       '2025-03-23',   'Real-Time Alerts'),
    ('Mererid Ellis',       'mererid@ellisevents.co.uk',        'Form submission not tracked',      'Medium',   'Resolved',     'Nkechi Eze',       '2025-03-26',   'Form Analytics'),
    ('Udochukwu Nweze',     'udochukwu@nwezecapital.com',       'False downtime alert',             'Low',      'Resolved',     'Nkechi Eze',       '2025-03-29',   'Downtime Detector'),
    ('Sigrun Jakobsen',     'sigrun@jakobsengroup.eu',          'Social feed not loading',          'High',     'Resolved',     'Nkechi Eze',       '2025-04-02',   'Social Media Dashboard'),
    ('Tochukwu Obi',        'tochukwu@obisystems.co.uk',        'Zapier webhook error',             'Medium',   'Resolved',     'Nkechi Eze',       '2025-04-05',   'Integration Hub'),
    ('Gwennan Rees',        'gwennan@reesandco.co.uk',          'Survey not publishing',            'Low',      'Resolved',     'Nkechi Eze',       '2025-04-09',   'Survey Builder'),
    ('Kamsi Okonkwo',       'kamsi@okonkwomedia.com',           'Source attribution wrong',         'High',     'Resolved',     'Nkechi Eze',       '2025-04-12',   'Traffic Source Tracker'),

    -- Jaime Ruiz (15 Resolved)
    ('Uchechukwu Ilozue',   'uchechukwu@ilozueconsulting.com',  'Dashboard not loading',            'High',     'Resolved',     'Jaime Ruiz',       '2025-03-02',   'Starter Dashboard'),
    ('Olwen Bevan',         'olwen@bevanpartners.co.uk',        'White-label logo not rendering',   'Medium',   'Resolved',     'Jaime Ruiz',       '2025-03-04',   'White-Label Branding'),
    ('Nkemdirim Eze',       'nkemdirim@ezefinance.co.uk',       'Funnel drop-off not tracking',     'High',     'Resolved',     'Jaime Ruiz',       '2025-03-07',   'Funnel Analyser'),
    ('Leif Gustafsson',     'leif@gustafssondesign.eu',         'Billing discrepancy',              'Low',      'Resolved',     'Jaime Ruiz',       '2025-03-10',   'Starter Dashboard'),
    ('Chidera Adigwe',      'chidera@adigweconsulting.co.uk',   'SSO login failing',                'High',     'Resolved',     'Jaime Ruiz',       '2025-03-13',   'Enterprise Dashboard'),
    ('Angharad Thomas',     'angharad@thomascatering.co.uk',    'Cannot add team members',          'Medium',   'Resolved',     'Jaime Ruiz',       '2025-03-16',   'Growth Dashboard'),
    ('Somto Ibe',           'somto@ibelogistics.com',           'Real-time alert delay',            'Low',      'Resolved',     'Jaime Ruiz',       '2025-03-19',   'Real-Time Alerts'),
    ('Magnhild Lund',       'magnhild@lundconsulting.eu',       'Crawl budget exceeded',            'High',     'Resolved',     'Jaime Ruiz',       '2025-03-22',   'SEO Audit Tool'),
    ('Emeka Okechukwu',     'emeka@okechukwuventures.com',      'Sample size too small',            'Medium',   'Resolved',     'Jaime Ruiz',       '2025-03-25',   'A/B Test Runner'),
    ('Sioned Williams',     'sioned@williamslaw.co.uk',         'GDPR report format question',      'Low',      'Resolved',     'Jaime Ruiz',       '2025-03-28',   'GDPR Compliance Pack'),
    ('Tobenna Madubuko',    'tobenna@madubukosystems.com',      'Revenue not matching CRM',         'High',     'Resolved',     'Jaime Ruiz',       '2025-04-01',   'Revenue Attribution'),
    ('Eira Morris',         'eira@morrismedia.co.uk',           'Data feed disconnected',           'Medium',   'Resolved',     'Jaime Ruiz',       '2025-04-04',   'Churn Predictor'),
    ('Adedotun Lawal',      'adedotun@lawalpartners.com',       'Job failure not reported',         'High',     'Resolved',     'Jaime Ruiz',       '2025-04-07',   'Data Pipeline Monitor'),
    ('Hedda Kristiansen',   'hedda@kristiansenhr.eu',           'Onboarding steps skipped',         'Low',      'Resolved',     'Jaime Ruiz',       '2025-04-10',   'User Onboarding Flow'),
    ('Nkeiru Chukwu',       'nkeiru@chukwudesign.co.uk',        'Error grouping incorrect',         'Medium',   'Resolved',     'Jaime Ruiz',       '2025-04-14',   'Error Log Analyser'),

    -- Lena Bergstrom (15 Resolved)
    ('Chigozie Nnamdi',     'chigozie@nnamdiconsulting.co.uk',  'Authentication token expired',     'High',     'Resolved',     'Lena Bergstrom',   '2025-03-01',   'API Access'),
    ('Berwyn Hughes',       'berwyn@hughesbuilders.co.uk',      'Dashboard timeout',                'Medium',   'Resolved',     'Lena Bergstrom',   '2025-03-04',   'Enterprise Dashboard'),
    ('Kasarachi Ogu',       'kasarachi@ogupartners.co.uk',      'Heatmap colours not showing',      'High',     'Resolved',     'Lena Bergstrom',   '2025-03-07',   'Heatmap Tracker'),
    ('Tove Sandstrom',      'tove@sandstromcapital.eu',         'Report scheduling failed',         'Low',      'Resolved',     'Lena Bergstrom',   '2025-03-10',   'Custom Reports'),
    ('Ugoeze Ngwu',         'ugoeze@ngwuventures.co.uk',        'False positive alerts',            'Medium',   'Resolved',     'Lena Bergstrom',   '2025-03-13',   'Real-Time Alerts'),
    ('Llewelyn Chambers',   'llewelyn@chambersmedia.co.uk',     'SEO audit timing out',             'High',     'Resolved',     'Lena Bergstrom',   '2025-03-16',   'SEO Audit Tool'),
    ('Chukwudi Eze',        'chukwudi@ezesolutions.co.uk',      'Conversion goal miscounted',       'Low',      'Resolved',     'Lena Bergstrom',   '2025-03-19',   'Funnel Analyser'),
    ('Yrsa Lindstrom',      'yrsa@lindstromdesign.eu',          'Variant not loading',              'Medium',   'Resolved',     'Lena Bergstrom',   '2025-03-22',   'A/B Test Runner'),
    ('Adaudo Ezeilo',       'adaudo@ezeilocreative.com',        'Status page not updating',         'High',     'Resolved',     'Lena Bergstrom',   '2025-03-25',   'Beta Uptime Monitor'),
    ('Iwan Griffiths',      'iwan@griffithslegal.co.uk',        'Monitoring gap detected',          'Low',      'Resolved',     'Lena Bergstrom',   '2025-03-28',   'Downtime Detector'),
    ('Nwadiuto Emeh',       'nwadiuto@emehanalytics.co.uk',     'Engagement metrics wrong',         'Medium',   'Resolved',     'Lena Bergstrom',   '2025-04-01',   'Social Media Dashboard'),
    ('Stina Karlsson',      'stina@karlssonconsulting.eu',       'Open rate not updating',           'High',     'Resolved',     'Lena Bergstrom',   '2025-04-04',   'Email Campaign Tracker'),
    ('Ndubuisi Nweke',      'ndubuisi@nwekesystems.com',        'Score threshold incorrect',        'Medium',   'Resolved',     'Lena Bergstrom',   '2025-04-07',   'Customer Health Score'),
    ('Gwyndaf Owens',       'gwyndaf@owensmedia.co.uk',         'Cohort grouping incorrect',        'Low',      'Resolved',     'Lena Bergstrom',   '2025-04-10',   'Cohort Analyser'),
    ('Ogechi Ekezie',       'ogechi@ekeziemedia.co.uk',         'Welcome email missing',            'High',     'Resolved',     'Lena Bergstrom',   '2025-04-14',   'User Onboarding Flow'),

    -- Dimitri Kallas (15 Resolved)
    ('Onyedikachi Uche',    'onyedikachi@ucheconsulting.com',   'Cannot reset password',            'Medium',   'Resolved',     'Dimitri Kallas',   '2025-03-02',   'Starter Dashboard'),
    ('Elen Pritchard',      'elen@pritchardpartners.co.uk',     'Data sync delay',                  'High',     'Resolved',     'Dimitri Kallas',   '2025-03-05',   'Growth Dashboard'),
    ('Obieze Chinaka',      'obieze@chinakatech.com',           'Webhook not firing',               'Medium',   'Resolved',     'Dimitri Kallas',   '2025-03-08',   'API Access'),
    ('Nils Holmberg',       'nils@holmbergmarine.eu',           'Chart rendering issue',            'Low',      'Resolved',     'Dimitri Kallas',   '2025-03-11',   'Custom Reports'),
    ('Zimuzo Nwokedi',      'zimuzo@nwokedicapital.co.uk',      'Click tracking inaccurate',        'High',     'Resolved',     'Dimitri Kallas',   '2025-03-14',   'Heatmap Tracker'),
    ('Meinir Lewis',        'meinir@lewisconsulting.co.uk',     'Funnel setup wizard broken',       'Medium',   'Resolved',     'Dimitri Kallas',   '2025-03-17',   'Funnel Analyser'),
    ('Ndidi Ofoegbu',       'ndidi@ofoegbuservices.com',        'Privacy policy template',          'Low',      'Resolved',     'Dimitri Kallas',   '2025-03-20',   'GDPR Compliance Pack'),
    ('Torbjorn Hakansson',  'torbjorn@hakanssongroup.eu',       'Downtime alert not firing',        'High',     'Resolved',     'Dimitri Kallas',   '2025-03-23',   'Downtime Detector'),
    ('Uloma Oguejiofor',    'uloma@oguejioforlaw.co.uk',        'Field-level data missing',         'Medium',   'Resolved',     'Dimitri Kallas',   '2025-03-26',   'Form Analytics'),
    ('Dai Humphreys',       'dai@humphreysdesign.co.uk',        'Click tracking broken',            'Low',      'Resolved',     'Dimitri Kallas',   '2025-03-29',   'Email Campaign Tracker'),
    ('Adaugo Ume',          'adaugo@umepartners.co.uk',         'Attribution model wrong',          'High',     'Resolved',     'Dimitri Kallas',   '2025-04-02',   'Revenue Attribution'),
    ('Sindre Aas',          'sindre@aassystems.eu',             'Model not updating',               'Medium',   'Resolved',     'Dimitri Kallas',   '2025-04-05',   'Churn Predictor'),
    ('Nneka Okafor',        'nneka@okaforanalytics.co.uk',      'Log aggregation broken',           'Low',      'Resolved',     'Dimitri Kallas',   '2025-04-08',   'Data Pipeline Monitor'),
    ('Hefina Rhys',         'hefina@rhysmedia.co.uk',           'Thank-you page error',             'High',     'Resolved',     'Dimitri Kallas',   '2025-04-11',   'Survey Builder'),
    ('Chiamaka Eze',        'chiamaka@ezeventures.co.uk',       'Campaign grouping broken',         'Medium',   'Resolved',     'Dimitri Kallas',   '2025-04-15',   'Traffic Source Tracker');

-- BLOCK 5: Cancelled tickets (25 rows)
INSERT INTO support_tickets (customer_name, customer_email, subject, priority, status, assigned_to, created_date, product_name)
VALUES
    -- Assigned Cancelled (10 tickets)
    ('Eberechi Udofia',     'eberechi@udofiamedia.co.uk',       'Legacy tracker data export',       'Low',      'Cancelled',    'Nkechi Eze',       '2025-03-03',   'Legacy Tracker'),
    ('Cadwgan Parry',       'cadwgan@parrysolutions.co.uk',     'Legacy report not exporting',      'Low',      'Cancelled',    'Nkechi Eze',       '2025-03-08',   'Legacy Reports'),
    ('Kolawole Adegoke',    'kolawole@adegokecapital.com',      'Session replay not recording',     'High',     'Cancelled',    'Nkechi Eze',       '2025-03-15',   'Session Replay'),
    ('Elin Fitzgerald',     'elin@fitzgeraldmedia.co.uk',       'Replay playback glitching',        'Medium',   'Cancelled',    'Jaime Ruiz',       '2025-03-06',   'Session Replay'),
    ('Dozie Obi',           'dozie@obiconsulting.co.uk',        'Migration assistance needed',      'Low',      'Cancelled',    'Jaime Ruiz',       '2025-03-12',   'Legacy Tracker'),
    ('Silje Haugen',        'silje@haugensystems.eu',           'Report format outdated',           'Medium',   'Cancelled',    'Jaime Ruiz',       '2025-03-20',   'Legacy Reports'),
    ('Nwabueze Azikiwe',    'nwabueze@azikiwedesign.com',       'Session data missing',             'High',     'Cancelled',    'Lena Bergstrom',   '2025-03-09',   'Session Replay'),
    ('Gwynfor Edwards',     'gwynfor@edwardslaw.co.uk',         'Dashboard not loading',            'Medium',   'Cancelled',    'Lena Bergstrom',   '2025-03-18',   'Starter Dashboard'),
    ('Ugochinyere Agu',     'ugochinyere@aguventures.co.uk',    'Widget not rendering',             'Low',      'Cancelled',    'Dimitri Kallas',   '2025-03-14',   'Growth Dashboard'),
    ('Osian Bevan',         'osian@bevancreative.co.uk',        'Cannot export PDF reports',        'Medium',   'Cancelled',    'Dimitri Kallas',   '2025-03-22',   'Custom Reports'),

    -- Unassigned Cancelled (15 tickets)
    ('Chinaecherem Oti',    'chinaecherem@otiservices.com',     'Billing discrepancy',              'Medium',   'Cancelled',    NULL,               '2025-03-02',   'Starter Dashboard'),
    ('Tanwen Bebb',         'tanwen@bebbassociates.co.uk',      'Billing discrepancy',              'Low',      'Cancelled',    NULL,               '2025-03-05',   'Starter Dashboard'),
    ('Nnaemeka Okorie',     'nnaemeka@okorietech.com',          'Dashboard slow on mobile',         'Medium',   'Cancelled',    NULL,               '2025-03-08',   'Growth Dashboard'),
    ('Elsa Fredriksson',    'elsa@fredrikssoncapital.eu',       'API rate limit exceeded',          'High',     'Cancelled',    NULL,               '2025-03-11',   'API Access'),
    ('Tobechukwu Osei',     'tobechukwu@oseiconsulting.co.uk',  'Alert emails going to spam',       'Medium',   'Cancelled',    NULL,               '2025-03-13',   'Real-Time Alerts'),
    ('Eurig Watkins',       'eurig@watkinsbuilders.co.uk',      'SEO tool missing pages',           'Low',      'Cancelled',    NULL,               '2025-03-16',   'SEO Audit Tool'),
    ('Elise Moreau',        'elise@moreauconsulting.com',       'Session replay not recording',     'Medium',   'Cancelled',    NULL,               '2025-03-18',   'Session Replay'),
    ('Obiajulu Nwachukwu',  'obiajulu@nwachukwulaw.co.uk',      'Funnel drop-off not tracking',     'High',     'Cancelled',    NULL,               '2025-03-20',   'Funnel Analyser'),
    ('Rashid Hamed',        'rashid@hamedlogistics.co.uk',      'Need to cancel subscription',      'Low',      'Cancelled',    NULL,               '2025-03-20',   'Starter Dashboard'),
    ('Annest Rhys',         'annest@rhyscreative.co.uk',        'Custom domain not working',        'Medium',   'Cancelled',    NULL,               '2025-03-23',   'White-Label Branding'),
    ('Ugonna Nwoke',        'ugonna@nwokesystems.co.uk',        'SSO login failing',                'High',     'Cancelled',    NULL,               '2025-03-26',   'Enterprise Dashboard'),
    ('Filippa Eklund',      'filippa@eklunddesign.eu',          'Conversion goal miscounted',       'Low',      'Cancelled',    NULL,               '2025-03-29',   'Funnel Analyser'),
    ('Kosisochukwu Nwora',  'kosisochukwu@nworamedia.com',     'Status page not updating',         'Medium',   'Cancelled',    NULL,               '2025-04-02',   'Beta Uptime Monitor'),
    ('Dyfrig Owen',         'dyfrig@owenpartners.co.uk',        'Dashboard data stale',             'Low',      'Cancelled',    NULL,               '2025-04-06',   'Data Pipeline Monitor'),
    ('Ogochukwu Eze',       'ogochukwu@ezeassociates.co.uk',   'Stack trace truncated',            'High',     'Cancelled',    NULL,               '2025-04-10',   'Error Log Analyser');

-- ============================================
-- staging_daily_metrics
-- ============================================
DROP TABLE IF EXISTS staging_daily_metrics;

CREATE TABLE staging_daily_metrics (
    metric_id       SERIAL PRIMARY KEY,
    metric_date     DATE            NOT NULL,
    page_views      INTEGER         NOT NULL,
    unique_visitors INTEGER         NOT NULL,
    bounce_rate     NUMERIC(5, 2)   NOT NULL,
    avg_session_sec INTEGER         NOT NULL
);

INSERT INTO staging_daily_metrics (metric_date, page_views, unique_visitors, bounce_rate, avg_session_sec)
VALUES
    ('2025-03-17', 12450, 8320, 42.50, 185),
    ('2025-03-18', 13100, 8750, 38.20, 192),
    ('2025-03-19', 11890, 7940, 45.10, 178),
    ('2025-03-20', 14200, 9100, 36.80, 201),
    ('2025-03-21', 10560, 7200, 48.30, 165),
    ('2025-03-22',  8900, 5800, 52.10, 145),
    ('2025-03-23',  9200, 6100, 50.40, 152);

-- ============================================
-- staging_user_sessions
-- ============================================
DROP TABLE IF EXISTS staging_user_sessions;

CREATE TABLE staging_user_sessions (
    session_id      SERIAL PRIMARY KEY,
    user_email      VARCHAR(150)    NOT NULL,
    session_start   TIMESTAMP       NOT NULL,
    session_end     TIMESTAMP,
    pages_visited   INTEGER         NOT NULL DEFAULT 1,
    device_type     VARCHAR(20)     NOT NULL
);

INSERT INTO staging_user_sessions (user_email, session_start, session_end, pages_visited, device_type)
VALUES
    ('alex@demo.com',       '2025-03-23 09:15:00', '2025-03-23 09:32:00', 8,  'Desktop'),
    ('beth@sample.co.uk',   '2025-03-23 10:05:00', '2025-03-23 10:18:00', 5,  'Mobile'),
    ('carl@test.io',        '2025-03-23 11:22:00', '2025-03-23 11:45:00', 12, 'Desktop'),
    ('dana@example.com',    '2025-03-23 13:00:00', '2025-03-23 13:08:00', 3,  'Tablet'),
    ('eric@webdev.com',     '2025-03-23 14:30:00', NULL,                  1,  'Mobile'),
    ('faye@startup.io',     '2025-03-23 15:45:00', '2025-03-23 16:02:00', 7,  'Desktop');

-- ============================================
-- legacy_ticket_categories
-- ============================================
DROP TABLE IF EXISTS legacy_ticket_categories;

CREATE TABLE legacy_ticket_categories (
    category_id     SERIAL PRIMARY KEY,
    category_name   VARCHAR(100)    NOT NULL,
    description     VARCHAR(200),
    created_date    DATE            NOT NULL,
    is_active       BOOLEAN         NOT NULL DEFAULT FALSE
);

INSERT INTO legacy_ticket_categories (category_name, description, created_date, is_active)
VALUES
    ('Billing Query',   'Questions about invoices and payments',    '2022-06-01', FALSE),
    ('Feature Request', 'New feature suggestions from customers',   '2022-06-01', FALSE),
    ('Bug Report',      'Software defects and errors',              '2022-06-01', FALSE),
    ('Account Access',  'Login issues and password resets',          '2022-06-01', FALSE),
    ('General Enquiry', 'Miscellaneous customer questions',          '2022-06-01', FALSE);

-- ============================================
-- legacy_pricing_v1
-- ============================================
DROP TABLE IF EXISTS legacy_pricing_v1;

CREATE TABLE legacy_pricing_v1 (
    pricing_id      SERIAL PRIMARY KEY,
    tier_name       VARCHAR(50)     NOT NULL,
    monthly_cost    NUMERIC(8, 2)   NOT NULL,
    annual_cost     NUMERIC(8, 2)   NOT NULL,
    max_users       INTEGER         NOT NULL,
    effective_from  DATE            NOT NULL,
    effective_to    DATE
);

INSERT INTO legacy_pricing_v1 (tier_name, monthly_cost, annual_cost, max_users, effective_from, effective_to)
VALUES
    ('Free',        0.00,     0.00,    2,  '2022-01-01', '2024-01-14'),
    ('Starter',    19.00,   190.00,    5,  '2022-01-01', '2024-01-14'),
    ('Growth',     49.00,   490.00,   25,  '2022-01-01', '2024-01-14'),
    ('Enterprise',149.00, 1490.00,  100,  '2022-01-01', '2024-01-14');
