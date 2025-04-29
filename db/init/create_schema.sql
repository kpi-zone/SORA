-- 1. Dimension Tables

-- a. Accounts (Companies/Customers)
CREATE TABLE IF NOT EXISTS dim_accounts (
  account_id SERIAL PRIMARY KEY,
  account_name VARCHAR(255) NOT NULL,
  industry VARCHAR(255),
  company_size VARCHAR(50),
  customer_segment VARCHAR(50),
  geography VARCHAR(255)
);

-- b. Contacts (Individuals at Accounts)
CREATE TABLE IF NOT EXISTS dim_contacts (
  contact_id SERIAL PRIMARY KEY,
  account_id INT NOT NULL,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  job_title VARCHAR(255),
  contact_type VARCHAR(255),
  CONSTRAINT fk_dim_accounts
    FOREIGN KEY (account_id) REFERENCES dim_accounts(account_id)
);

-- c. Time Dimension
CREATE TABLE IF NOT EXISTS dim_time (
  date_key DATE PRIMARY KEY,
  day INT,
  month INT,
  quarter INT,
  year INT
);

-- d. Product Plans (Subscription/Pricing Plans)
CREATE TABLE IF NOT EXISTS dim_product_plans (
  plan_id SERIAL PRIMARY KEY,
  plan_name VARCHAR(255) NOT NULL,
  pricing_tier VARCHAR(50),
  features_included TEXT,
  billing_frequency VARCHAR(50)
);

-- e. Sales Representatives
CREATE TABLE IF NOT EXISTS dim_sales_rep (
  sales_rep_id SERIAL PRIMARY KEY,
  sales_rep_name VARCHAR(255) NOT NULL,
  territory VARCHAR(255),
  role VARCHAR(255)
);

-- f. Marketing Campaigns
CREATE TABLE IF NOT EXISTS dim_marketing_campaign (
  campaign_id SERIAL PRIMARY KEY,
  campaign_name VARCHAR(255) NOT NULL,
  channel VARCHAR(255),
  start_date DATE,
  end_date DATE,
  budget DECIMAL(10,2),
  target_audience VARCHAR(255)
);

-- 2. Fact Tables

-- a. Orders / Subscriptions
CREATE TABLE IF NOT EXISTS fact_orders (
  order_id SERIAL PRIMARY KEY,
  account_id INT NOT NULL,
  sales_rep_id INT,
  plan_id INT,
  order_date DATE NOT NULL,
  start_date DATE,
  end_date DATE,
  order_amount DECIMAL(12,2),
  discounts DECIMAL(12,2),
  renewal_status VARCHAR(50),
  CONSTRAINT fk_order_account
    FOREIGN KEY (account_id) REFERENCES dim_accounts(account_id),
  CONSTRAINT fk_order_sales_rep
    FOREIGN KEY (sales_rep_id) REFERENCES dim_sales_rep(sales_rep_id),
  CONSTRAINT fk_order_plan
    FOREIGN KEY (plan_id) REFERENCES dim_product_plans(plan_id),
  CONSTRAINT fk_order_date
    FOREIGN KEY (order_date) REFERENCES dim_time(date_key)
);

-- b. Sales Deals / Pipeline
CREATE TABLE IF NOT EXISTS fact_sales_deals (
  deal_id SERIAL PRIMARY KEY,
  account_id INT NOT NULL,
  sales_rep_id INT,
  deal_stage VARCHAR(50),
  deal_value DECIMAL(12,2),
  created_date DATE NOT NULL,
  close_date DATE,
  CONSTRAINT fk_deal_account
    FOREIGN KEY (account_id) REFERENCES dim_accounts(account_id),
  CONSTRAINT fk_deal_sales_rep
    FOREIGN KEY (sales_rep_id) REFERENCES dim_sales_rep(sales_rep_id),
  CONSTRAINT fk_deal_created_date
    FOREIGN KEY (created_date) REFERENCES dim_time(date_key),
  CONSTRAINT fk_deal_close_date
    FOREIGN KEY (close_date) REFERENCES dim_time(date_key)
);

-- c. Marketing Interactions / Leads
CREATE TABLE IF NOT EXISTS fact_marketing_interactions (
  interaction_id SERIAL PRIMARY KEY,
  campaign_id INT,
  account_id INT,
  interaction_type VARCHAR(255),
  interaction_date DATE,
  engagement_score DECIMAL(10,2),
  CONSTRAINT fk_interaction_campaign
    FOREIGN KEY (campaign_id) REFERENCES dim_marketing_campaign(campaign_id),
  CONSTRAINT fk_interaction_account
    FOREIGN KEY (account_id) REFERENCES dim_accounts(account_id),
  CONSTRAINT fk_interaction_date
    FOREIGN KEY (interaction_date) REFERENCES dim_time(date_key)
);

-- d. Product Usage / Engagement
CREATE TABLE IF NOT EXISTS fact_product_usage (
  usage_id SERIAL PRIMARY KEY,
  account_id INT,
  session_id VARCHAR(255),
  event_type VARCHAR(255),
  event_timestamp TIMESTAMP,
  event_date DATE,
  feature_name VARCHAR(255),
  duration INT,
  CONSTRAINT fk_usage_account
    FOREIGN KEY (account_id) REFERENCES dim_accounts(account_id),
  CONSTRAINT fk_usage_date
    FOREIGN KEY (event_date) REFERENCES dim_time(date_key)
);

-- 3. Insert into dim_time safely
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM dim_time) THEN
    INSERT INTO dim_time (date_key, day, month, quarter, year)
    SELECT current_date + s.a,
           EXTRACT(DAY FROM current_date + s.a) AS day,
           EXTRACT(MONTH FROM current_date + s.a) AS month,
           EXTRACT(QUARTER FROM current_date + s.a) AS quarter,
           EXTRACT(YEAR FROM current_date + s.a) AS year
    FROM generate_series(0, 365*5) AS s(a);
  END IF;
END
$$;