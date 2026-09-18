-- Populate fact_sales: join cleaned staging data with dim_product
-- (for price) and dim_promotion (for discount rules) to calculate
-- total_sales, discount_percentage, discount_value, and net_sales.

USE retail_analysis;

INSERT INTO fact_sales (sale_date, customer_id, promotion_id, product_id, units_sold,
                         price_per_unit, total_sales, discount_percentage, discount_value, net_sales)
SELECT
    s.sale_date_fixed,
    s.customer_id,
    s.promotion_id,
    s.product_id,
    s.units_sold,
    p.price_inr AS price_per_unit,
    (p.price_inr * s.units_sold) AS total_sales,
    CASE
        WHEN pr.price_reduction_type LIKE '%off' THEN CAST(REPLACE(pr.price_reduction_type, '% off', '') AS DECIMAL(5,2))
        ELSE 0
    END AS discount_percentage,
    CASE
        WHEN pr.price_reduction_type LIKE '%off' THEN (p.price_inr * s.units_sold) * (CAST(REPLACE(pr.price_reduction_type, '% off', '') AS DECIMAL(5,2)) / 100)
        ELSE 0
    END AS discount_value,
    (p.price_inr * s.units_sold) -
    CASE
        WHEN pr.price_reduction_type LIKE '%off' THEN (p.price_inr * s.units_sold) * (CAST(REPLACE(pr.price_reduction_type, '% off', '') AS DECIMAL(5,2)) / 100)
        ELSE 0
    END AS net_sales
FROM staging_fact_sales s
JOIN dim_product p ON s.product_id = p.product_id
LEFT JOIN dim_promotion pr ON s.promotion_id = pr.promotion_id;

-- Verify: should return 3510
SELECT COUNT(*) FROM fact_sales;