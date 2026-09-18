USE retail_analysis;

SELECT
    p.product_name,
    p.product_line,
    SUM(f.units_sold) AS total_units_sold,
    SUM(f.net_sales) AS total_revenue
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.product_name, p.product_line
ORDER BY total_revenue DESC
LIMIT 10;


SELECT
    p.product_line,
    COUNT(*) AS num_transactions,
    SUM(f.units_sold) AS total_units_sold,
    SUM(f.net_sales) AS total_revenue,
    ROUND(SUM(f.net_sales) / COUNT(*), 0) AS avg_revenue_per_transaction
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.product_line
ORDER BY total_revenue DESC;

SELECT
    DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,
    SUM(net_sales) AS monthly_revenue,
    COUNT(*) AS num_transactions
FROM fact_sales
GROUP BY sale_month
ORDER BY sale_month;

SELECT
    CASE WHEN f.promotion_id IS NULL THEN 'No Promotion' ELSE pr.promotion_name END AS promotion,
    COUNT(*) AS num_transactions,
    SUM(f.units_sold) AS total_units_sold,
    ROUND(AVG(f.units_sold), 2) AS avg_units_per_transaction,
    SUM(f.net_sales) AS total_revenue
FROM fact_sales f
LEFT JOIN dim_promotion pr ON f.promotion_id = pr.promotion_id
GROUP BY promotion
ORDER BY total_revenue DESC;

SELECT
    c.city,
    c.state,
    COUNT(*) AS num_transactions,
    SUM(f.net_sales) AS total_revenue
FROM fact_sales f
JOIN dim_customers c ON f.customer_id = c.customer_id
GROUP BY c.city, c.state
ORDER BY total_revenue DESC
LIMIT 10;