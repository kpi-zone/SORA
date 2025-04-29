-- ============================================================
-- Additional Test Data Inserts for Dimension and Fact Tables
-- ============================================================

-- 1. Dimension Tables Inserts

-- a. dim_accounts: Insert 10 sample accounts
INSERT INTO dim_accounts (account_name, industry, company_size, customer_segment, geography) VALUES
  ('Acme Corporation', 'Technology', 'Large', 'Enterprise', 'North America'),
  ('Beta Industries', 'Manufacturing', 'Medium', 'SMB', 'Europe'),
  ('Gamma Solutions', 'Consulting', 'Small', 'Startup', 'Asia'),
  ('Delta LLC', 'Healthcare', 'Large', 'Enterprise', 'North America'),
  ('Epsilon Enterprises', 'Finance', 'Medium', 'SMB', 'Europe'),
  ('Zeta Co.', 'Retail', 'Large', 'Enterprise', 'Asia Pacific'),
  ('Eta Holdings', 'Energy', 'Large', 'Enterprise', 'Middle East'),
  ('Theta Group', 'Telecommunications', 'Medium', 'SMB', 'Africa'),
  ('Iota Innovations', 'Biotech', 'Small', 'Startup', 'North America'),
  ('Kappa Systems', 'Software', 'Small', 'Startup', 'Europe');

-- b. dim_contacts: Insert multiple contacts; at least two per account for variability.
INSERT INTO dim_contacts (account_id, first_name, last_name, email, job_title, contact_type) VALUES
  (1, 'John', 'Doe', 'john.doe@acme.com', 'CTO', 'Decision Maker'),
  (1, 'Alice', 'Walker', 'alice.walker@acme.com', 'CFO', 'Influencer'),
  (2, 'Jane', 'Smith', 'jane.smith@betaindustries.com', 'Operations Manager', 'Decision Maker'),
  (2, 'Mark', 'Turner', 'mark.turner@betaindustries.com', 'Procurement Lead', 'Influencer'),
  (3, 'Emily', 'Clark', 'emily.clark@gammasolutions.com', 'Founder', 'Decision Maker'),
  (3, 'Robert', 'Brown', 'robert.brown@gammasolutions.com', 'Consultant', 'Advisor'),
  (4, 'Laura', 'Jones', 'laura.jones@deltallc.com', 'Medical Director', 'Decision Maker'),
  (4, 'Peter', 'Miller', 'peter.miller@deltallc.com', 'Finance Manager', 'Influencer'),
  (5, 'Susan', 'Davis', 'susan.davis@epsilon.com', 'CFO', 'Decision Maker'),
  (5, 'Tom', 'Wilson', 'tom.wilson@epsilon.com', 'Operations Lead', 'Influencer'),
  (6, 'Gary', 'Anderson', 'gary.anderson@zetaco.com', 'Head of Retail', 'Decision Maker'),
  (6, 'Nancy', 'Martin', 'nancy.martin@zetaco.com', 'Store Manager', 'Influencer'),
  (7, 'Linda', 'White', 'linda.white@etaholdings.com', 'Chief Engineer', 'Decision Maker'),
  (7, 'Frank', 'Garcia', 'frank.garcia@etaholdings.com', 'Logistics Manager', 'Influencer'),
  (8, 'Karen', 'Martinez', 'karen.martinez@thetagroup.com', 'VP Sales', 'Decision Maker'),
  (8, 'Gary', 'Rodriguez', 'gary.rodriguez@thetagroup.com', 'Marketing Manager', 'Advisor'),
  (9, 'Donna', 'Harris', 'donna.harris@iotainnovations.com', 'CEO', 'Decision Maker'),
  (9, 'Steven', 'Clark', 'steven.clark@iotainnovations.com', 'Technical Lead', 'Influencer'),
  (10, 'Patricia', 'Lewis', 'patricia.lewis@kappasystems.com', 'Founder', 'Decision Maker'),
  (10, 'Kevin', 'Walker', 'kevin.walker@kappasystems.com', 'COO', 'Advisor');

-- c. dim_time: Insert a diverse set of dates covering early 2023 to early 2023 April.
-- Ensure that every date used in your fact tables is represented here.
INSERT INTO dim_time (date_key, day, month, quarter, year) VALUES
  ('2023-01-01', 1, 1, 1, 2023),
  ('2023-01-05', 5, 1, 1, 2023),
  ('2023-01-10', 10, 1, 1, 2023),
  ('2023-01-15', 15, 1, 1, 2023),
  ('2023-01-20', 20, 1, 1, 2023),
  ('2023-02-01', 1, 2, 1, 2023),
  ('2023-02-05', 5, 2, 1, 2023),
  ('2023-02-10', 10, 2, 1, 2023),
  ('2023-02-15', 15, 2, 1, 2023),
  ('2023-03-01', 1, 3, 1, 2023),
  ('2023-03-05', 5, 3, 1, 2023),
  ('2023-03-10', 10, 3, 1, 2023),
  ('2023-03-15', 15, 3, 1, 2023),
  ('2023-03-20', 20, 3, 1, 2023),
  ('2023-04-01', 1, 4, 2, 2023);

-- d. dim_product_plans: Insert 4 sample subscription plans
INSERT INTO dim_product_plans (plan_name, pricing_tier, features_included, billing_frequency) VALUES
  ('Basic Plan', 'Low', 'Feature A, Feature B', 'Monthly'),
  ('Standard Plan', 'Medium', 'Feature A, Feature B, Feature C', 'Quarterly'),
  ('Premium Plan', 'High', 'Feature A, Feature B, Feature C, Feature D', 'Annually'),
  ('Enterprise Plan', 'Highest', 'Full Suite of Features, Dedicated Support', 'Annually');

-- e. dim_sales_rep: Insert 4 sample sales representatives
INSERT INTO dim_sales_rep (sales_rep_name, territory, role) VALUES
  ('Alice Johnson', 'North America', 'Senior Sales'),
  ('Bob Smith', 'Europe', 'Sales Representative'),
  ('Carol Lee', 'Asia', 'Account Executive'),
  ('David Kim', 'South America', 'Sales Manager');

-- f. dim_marketing_campaign: Insert 4 marketing campaigns
INSERT INTO dim_marketing_campaign (campaign_name, channel, start_date, end_date, budget, target_audience) VALUES
  ('Spring Promo', 'Email', '2023-01-05', '2023-02-15', 5000.00, 'Existing Customers'),
  ('New Year Blast', 'Social Media', '2023-01-01', '2023-01-31', 10000.00, 'Prospects'),
  ('Summer Kickoff', 'Web', '2023-03-01', '2023-03-31', 8000.00, 'SMB'),
  ('Fall Revival', 'Print', '2023-09-01', '2023-09-30', 6000.00, 'Enterprise');


-- 2. Fact Tables Inserts

-- a. fact_orders: Insert 10 sample orders linking accounts, sales reps, product plans, and dates from dim_time
INSERT INTO fact_orders (account_id, sales_rep_id, plan_id, order_date, start_date, end_date, order_amount, discounts, renewal_status) VALUES
  (1, 1, 1, '2023-01-15', '2023-02-01', '2024-01-15', 1000.00, 50.00, 'Active'),
  (2, 2, 2, '2023-02-10', '2023-02-15', '2024-02-10', 2000.00, 100.00, 'Pending'),
  (3, 3, 3, '2023-03-05', '2023-03-10', '2024-03-10', 1500.00, 75.00, 'Active'),
  (4, 1, 2, '2023-01-15', '2023-02-01', '2024-01-15', 2500.00, 125.00, 'Active'),
  (5, 2, 1, '2023-02-05', '2023-02-10', '2024-02-05', 1200.00, 60.00, 'Inactive'),
  (6, 4, 4, '2023-03-15', '2023-03-20', '2024-03-15', 3000.00, 150.00, 'Active'),
  (7, 3, 2, '2023-01-10', '2023-01-15', '2024-01-10', 1800.00, 90.00, 'Pending'),
  (8, 1, 3, '2023-01-20', '2023-02-01', '2024-01-20', 2200.00, 110.00, 'Active'),
  (9, 2, 1, '2023-02-10', '2023-02-15', '2024-02-10', 1300.00, 65.00, 'Active'),
  (10, 4, 4, '2023-03-01', '2023-03-05', '2024-03-01', 3500.00, 175.00, 'Pending');

-- b. fact_sales_deals: Insert 9 sample sales deals ensuring proper date keys in dim_time
INSERT INTO fact_sales_deals (account_id, sales_rep_id, deal_stage, deal_value, created_date, close_date) VALUES
  (1, 1, 'Negotiation', 5000.00, '2023-01-20', '2023-03-15'),
  (3, 2, 'Proposal', 8000.00, '2023-02-10', '2023-03-15'),
  (2, 2, 'Qualification', 4000.00, '2023-01-05', '2023-01-20'),
  (4, 1, 'Proposal', 6000.00, '2023-02-10', '2023-03-15'),
  (5, 2, 'Negotiation', 5500.00, '2023-02-15', '2023-03-05'),
  (6, 4, 'Won', 7000.00, '2023-03-01', '2023-03-10'),
  (7, 3, 'Lost', 3000.00, '2023-01-10', '2023-01-15'),
  (8, 1, 'Proposal', 4800.00, '2023-01-20', '2023-02-05'),
  (9, 2, 'Qualification', 3200.00, '2023-03-05', '2023-03-20');

-- c. fact_marketing_interactions: Insert 10 marketing interactions for different campaigns and accounts
INSERT INTO fact_marketing_interactions (campaign_id, account_id, interaction_type, interaction_date, engagement_score) VALUES
  (1, 1, 'Email Open', '2023-01-10', 85.00),
  (2, 2, 'Click', '2023-01-20', 75.00),
  (1, 3, 'Email Click', '2023-01-15', 80.00),
  (1, 4, 'Email Open', '2023-01-10', 82.50),
  (2, 5, 'Ad Impression', '2023-01-05', 70.00),
  (3, 6, 'Web Visit', '2023-03-05', 88.00),
  (3, 7, 'Email Open', '2023-03-10', 75.50),
  (2, 8, 'Click', '2023-01-20', 77.00),
  (1, 9, 'Email Click', '2023-01-15', 85.00),
  (3, 10, 'Web Visit', '2023-03-15', 90.00);

-- d. fact_product_usage: Insert 10 product usage events with varied event types and timestamps
INSERT INTO fact_product_usage (account_id, session_id, event_type, event_timestamp, event_date, feature_name, duration) VALUES
  (1, 'sess001', 'Login', '2023-01-15 09:00:00', '2023-01-15', 'Dashboard', 15),
  (2, 'sess002', 'Usage', '2023-02-05 14:30:00', '2023-02-05', 'Reporting', 30),
  (3, 'sess003', 'Login', '2023-03-05 08:45:00', '2023-03-05', 'Dashboard', 10),
  (4, 'sess004', 'Usage', '2023-03-10 11:30:00', '2023-03-10', 'Analytics', 25),
  (5, 'sess005', 'Logout', '2023-02-05 16:00:00', '2023-02-05', 'Dashboard', 5),
  (6, 'sess006', 'Usage', '2023-03-15 13:15:00', '2023-03-15', 'Reports', 30),
  (7, 'sess007', 'Login', '2023-01-15 09:00:00', '2023-01-15', 'Dashboard', 12),
  (8, 'sess008', 'Usage', '2023-02-10 14:00:00', '2023-02-10', 'Data Export', 20),
  (9, 'sess009', 'Login', '2023-03-20 10:00:00', '2023-03-20', 'Dashboard', 15),
  (10, 'sess010', 'Usage', '2023-04-01 15:30:00', '2023-04-01', 'Advanced Analytics', 40);
