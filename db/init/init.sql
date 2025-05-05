-- ========================================================================
-- 📊 Contoso Retail Dataset – PostgreSQL Table Definitions and Imports
-- ========================================================================
--
-- These CREATE TABLE statements define the schema for importing the
-- dummy data included in this project (based on the 100K row sample).
--
-- The data follows the format of Microsoft's Contoso Retail model and
-- includes standard tables like Customers, Products, Orders, and Sales.
--
-- 📦 This schema is compatible with the sample data bundled in this repo.
-- 
-- 🔄 For larger datasets (e.g., 10M or 100M rows), download from:
-- 👉 https://github.com/sql-bi/Contoso-Data-Generator-V2-Data/releases/tag/ready-to-use-data
--
-- Tables:
-- - dim_date
-- - currencyexchange
-- - customer
-- - store
-- - product
-- - orders
-- - orderrows
-- - sales
--
-- Notes:
-- - Foreign key relationships and primary keys are defined.
-- - The "dim_date" table replaces the original "date" table name
--   to avoid conflicts with SQL reserved keywords.
-- - All CSV files must reside in /docker-entrypoint-initdb.d/data/
--   for the COPY commands to work during Docker build/init.
--
-- ========================================================================


-- =====================
-- Table: dim_date
-- =====================
CREATE TABLE dim_date (
    date DATE PRIMARY KEY,
    datekey INTEGER UNIQUE,
    year INTEGER,
    yearquarter TEXT,
    yearquarternumber INTEGER,
    quarter TEXT,
    yearmonth TEXT,
    yearmonthshort TEXT,
    yearmonthnumber INTEGER,
    month TEXT,
    monthshort TEXT,
    monthnumber INTEGER,
    dayofweek TEXT,
    dayofweekshort TEXT,
    dayofweeknumber INTEGER,
    workingday BOOLEAN,
    workingdaynumber INTEGER
);

COPY dim_date FROM '/docker-entrypoint-initdb.d/data/date.csv' WITH (FORMAT csv, HEADER);


-- =====================
-- Table: currencyexchange
-- =====================
CREATE TABLE currencyexchange (
    date DATE REFERENCES dim_date(date),
    from_currency CHAR(3),
    to_currency CHAR(3),
    exchange_rate NUMERIC(10,5),
    PRIMARY KEY (date, from_currency, to_currency)
);

COPY currencyexchange FROM '/docker-entrypoint-initdb.d/data/currencyexchange.csv' WITH (FORMAT csv, HEADER);


-- =====================
-- Table: customer
-- =====================
CREATE TABLE customer (
    customerkey INTEGER PRIMARY KEY,
    geoareakey INTEGER,
    startdt DATE,
    enddt DATE,
    continent TEXT,
    gender TEXT,
    title TEXT,
    givenname TEXT,
    middleinitial CHAR(1),
    surname TEXT,
    streetaddress TEXT,
    city TEXT,
    state TEXT,
    statefull TEXT,
    zipcode TEXT,
    country CHAR(2),
    countryfull TEXT,
    birthday DATE,
    age INTEGER,
    occupation TEXT,
    company TEXT,
    vehicle TEXT,
    latitude NUMERIC(10,6),
    longitude NUMERIC(10,6)
);

COPY customer FROM '/docker-entrypoint-initdb.d/data/customer.csv' WITH (FORMAT csv, HEADER);


-- =====================
-- Table: store
-- =====================
CREATE TABLE store (
    storekey INTEGER PRIMARY KEY,
    storecode TEXT,
    geoareakey INTEGER,
    countrycode CHAR(2),
    countryname TEXT,
    state TEXT,
    opendate DATE,
    closedate DATE,
    description TEXT,
    squaremeters INTEGER,
    status TEXT
);

COPY store FROM '/docker-entrypoint-initdb.d/data/store.csv' WITH (FORMAT csv, HEADER);


-- =====================
-- Table: product
-- =====================
CREATE TABLE product (
    productkey INTEGER PRIMARY KEY,
    productcode TEXT,
    productname TEXT,
    manufacturer TEXT,
    brand TEXT,
    color TEXT,
    weightunit TEXT,
    weight NUMERIC(10,2),
    cost NUMERIC(10,2),
    price NUMERIC(10,2),
    categorykey INTEGER,
    categoryname TEXT,
    subcategorykey INTEGER,
    subcategoryname TEXT
);

COPY product FROM '/docker-entrypoint-initdb.d/data/product.csv' WITH (FORMAT csv, HEADER);


-- =====================
-- Table: orders
-- =====================
CREATE TABLE orders (
    orderkey INTEGER PRIMARY KEY,
    customerkey INTEGER REFERENCES customer(customerkey),
    storekey INTEGER REFERENCES store(storekey),
    orderdate DATE REFERENCES dim_date(date),
    deliverydate DATE REFERENCES dim_date(date),
    currencycode CHAR(3)
);

COPY orders FROM '/docker-entrypoint-initdb.d/data/orders.csv' WITH (FORMAT csv, HEADER);


-- =====================
-- Table: orderrows
-- =====================
CREATE TABLE orderrows (
    orderkey INTEGER,
    linenumber INTEGER,
    productkey INTEGER REFERENCES product(productkey),
    quantity INTEGER,
    unitprice NUMERIC(10,4),
    netprice NUMERIC(10,4),
    unitcost NUMERIC(10,4),
    PRIMARY KEY (orderkey, linenumber),
    FOREIGN KEY (orderkey) REFERENCES orders(orderkey)
);

COPY orderrows FROM '/docker-entrypoint-initdb.d/data/orderrows.csv' WITH (FORMAT csv, HEADER);


-- =====================
-- Table: sales
-- =====================
CREATE TABLE sales (
    orderkey INTEGER,
    linenumber INTEGER,
    orderdate DATE REFERENCES dim_date(date),
    deliverydate DATE REFERENCES dim_date(date),
    customerkey INTEGER REFERENCES customer(customerkey),
    storekey INTEGER REFERENCES stores(storekey),
    productkey INTEGER REFERENCES product(productkey),
    quantity INTEGER,
    unitprice NUMERIC(10,4),
    netprice NUMERIC(10,4),
    unitcost NUMERIC(10,4),
    currencycode CHAR(3),
    exchangerate NUMERIC(10,5),
    PRIMARY KEY (orderkey, linenumber)
);

COPY sales FROM '/docker-entrypoint-initdb.d/data/sales.csv' WITH (FORMAT csv, HEADER);
