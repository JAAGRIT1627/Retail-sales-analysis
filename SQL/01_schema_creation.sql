-- Retail Sales & Promotion Analysis
-- Schema creation: star schema with 3 dimension tables + 1 fact table

CREATE DATABASE retail_analysis;
USE retail_analysis;

-- Dimension: Customers
CREATE TABLE dim_customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    pincode VARCHAR(10),
    email VARCHAR(100),
    phone VARCHAR(15)
);

-- Dimension: Products
CREATE TABLE dim_product (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100),
    product_line VARCHAR(50),
    price_inr INT
);

-- Dimension: Promotions
CREATE TABLE dim_promotion (
    promotion_id VARCHAR(10) PRIMARY KEY,
    promotion_name VARCHAR(100),
    ad_type VARCHAR(50),
    coupon_code VARCHAR(20),
    price_reduction_type VARCHAR(30)
);

-- Fact table: sales transactions
CREATE TABLE fact_sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_date DATE,
    customer_id INT,
    promotion_id VARCHAR(10) NULL,
    product_id VARCHAR(10),
    units_sold INT,
    price_per_unit INT,
    total_sales INT,
    discount_percentage INT,
    discount_value INT,
    net_sales INT,
    FOREIGN KEY (customer_id) REFERENCES dim_customers(customer_id),
    FOREIGN KEY (promotion_id) REFERENCES dim_promotion(promotion_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
);