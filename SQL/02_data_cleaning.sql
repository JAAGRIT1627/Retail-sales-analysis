-- Data cleaning: raw sales data loaded into staging first,
-- then cleaned (date format fix, promotion NULL fix) before
-- moving into the final fact_sales table.

USE retail_analysis;
SET SQL_SAFE_UPDATES = 0;

-- Staging table accepts raw data as-is (text columns to avoid import errors
-- on empty calculated fields and comma-formatted prices)
CREATE TABLE staging_fact_sales (
    sale_date VARCHAR(20),
    customer_id INT,
    promotion_id VARCHAR(10),
    product_id VARCHAR(10),
    units_sold INT,
    price_per_unit VARCHAR(20),
    total_sales VARCHAR(20),
    discount_percentage VARCHAR(20),
    discount_value VARCHAR(20),
    net_sales VARCHAR(20)
);

-- (Raw Sheet3 data imported here via MySQL Workbench's Table Data Import Wizard)

-- Fix 1: dates were stored as m/d/yyyy despite the column header claiming
-- dd/mm/yyyy -- confirmed by rows with day values above 12 (e.g. 12/13/2022)
ALTER TABLE staging_fact_sales ADD COLUMN sale_date_fixed DATE;

UPDATE staging_fact_sales
SET sale_date_fixed = STR_TO_DATE(sale_date, '%m/%d/%Y');

-- Fix 2: promotion_id of '0' represents "no promotion", not a real ID --
-- convert to NULL so it doesn't violate the fact_sales foreign key
UPDATE staging_fact_sales
SET promotion_id = NULL
WHERE promotion_id = '0';

-- Fix 3: dim_product prices had commas as thousands separators
-- (e.g. "1,299.00"), which broke CSV parsing on import. Cleaned here
-- after loading price_inr as text, then converted the column to INT.
UPDATE dim_product
SET price_inr = REPLACE(price_inr, ',', '');

ALTER TABLE dim_product
MODIFY COLUMN price_inr INT;

-- Fix 4: trailing whitespace in customer city/state from the original Excel export
UPDATE dim_customers
SET city = TRIM(city),
    state = TRIM(state);