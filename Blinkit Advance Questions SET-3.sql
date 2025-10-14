Use blinkit_db;

/*1. Customer Churn & Frequency Analysis
Question: Calculate the average time (in days) between a customer's first order and 
their second order. This is a key metric for understanding immediate retention/churn.*/

WITH CustomerOrderRanks AS (
    SELECT
        customer_id,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) as order_rank
    FROM
        blinkit_orders_cleaned
)
SELECT
    AVG(DATEDIFF(o2.order_date, o1.order_date)) AS Avg_Days_Between_First_Two_Orders
FROM
    CustomerOrderRanks o1
JOIN
    CustomerOrderRanks o2 
    ON o1.customer_id = o2.customer_id
WHERE
    o1.order_rank = 1 AND o2.order_rank = 2;
    
    /*2. Dynamic Stock Forecasting
Question: Identify the top 5 products that have the highest cumulative sales 
revenue in the latest month of the dataset and whose current stock_level is 
less than their min_stock_level. (This alerts for high-demand, low-stock items).*/

WITH LatestMonthSales AS (
    SELECT
        oi.product_id,
        SUM(oi.quantity * oi.unit_price) AS latest_month_revenue
    FROM
        blinkit_order_iteam_cleaned oi
    JOIN
        blinkit_orders_cleaned o ON oi.order_id = o.order_id
    WHERE
        o.order_date >= DATE_SUB((SELECT MAX(order_date) FROM blinkit_orders_cleaned), INTERVAL 30 DAY)
    GROUP BY
        oi.product_id
)
SELECT
    p.product_name,
    p.category,
    p.min_stock_level AS Min_Stock_Level,
    lms.latest_month_revenue
FROM
    blinkit_products_cleaned p
JOIN
    LatestMonthSales lms ON p.product_id = lms.product_id
WHERE
    p.min_stock_level > 0
ORDER BY
    lms.latest_month_revenue DESC
LIMIT 5;

/*3.That's the final level! Advanced SQL questions on a dataset like Blinkit require sophisticated 
techniques like Window Functions, Subqueries, and Complex Date Arithmetic to model real-world business 
scenarios like churn, LTV, and cohort analysis.*/

SELECT
    o.customer_id,
    o.order_date,
    SUM(oi.quantity * oi.unit_price) OVER (
        PARTITION BY o.customer_id
        ORDER BY o.order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_spend
FROM blinkit_orders_cleaned o
JOIN blinkit_order_iteam_cleaned oi
    ON o.order_id = oi.order_id 
ORDER BY o.customer_id, o.order_date;

/*4. Customer Churn & Frequency Analysis
Question: Calculate the average time (in days) between a customer's first order and their 
second order. This is a key metric for understanding immediate retention/churn.*/

WITH CustomerOrderRanks AS (
    SELECT
        customer_id,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) as order_rank
    FROM
        blinkit_orders_cleaned
)
SELECT
    AVG(DATEDIFF(o2.order_date, o1.order_date)) AS Avg_Days_Between_First_Two_Orders
FROM
    CustomerOrderRanks o1
JOIN
    CustomerOrderRanks o2 
    ON o1.customer_id = o2.customer_id
WHERE
    o1.order_rank = 1 AND o2.order_rank = 2;
    
/*5. Dynamic Stock Forecasting
Question: Identify the top 5 products that have the highest cumulative sales 
revenue in the latest month of the dataset and whose current stock_level is 
less than their min_stock_level. (This alerts for high-demand, low-stock items).*/

WITH LatestMonthSales AS (
    -- Find the total revenue per product in the latest recorded month
    SELECT
        oi.product_id,
        SUM(oi.quantity * oi.unit_price) AS latest_month_revenue
    FROM
        blinkit_order_iteam_cleaned oi
    JOIN
        blinkit_orders_cleaned o ON oi.order_id = o.order_id
    WHERE
        o.order_date >= DATE_SUB((SELECT MAX(order_date) FROM blinkit_orders_cleaned), INTERVAL 30 DAY)
    GROUP BY
        oi.product_id
)
SELECT
    p.product_name,
    p.category,
    p.min_stock_level - p.stock_level AS Stock_Deficit,
    lms.latest_month_revenue
FROM
    blinkit_products_cleaned p
JOIN
    LatestMonthSales lms ON p.product_id = lms.product_id
WHERE
    p.stock_level < p.min_stock_level
ORDER BY
    lms.latest_month_revenue DESC
LIMIT 5;

/*3. Customer Lifetime Value (LTV) Approximation
Question: Calculate the running cumulative revenue for each customer, 
ordered by their order date. This gives a step-by-step view of their 
total contribution over time (a key component of LTV).*/

SELECT
    customer_id,
    order_date,
    order_total,
    SUM(order_total) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS Cumulative_Revenue_LTV
FROM
    blinkit_orders_cleaned
ORDER BY
    customer_id, order_date;
    
    /*4. Delivery Partner Performance Ranking
Question: Within Store ID 4771 (or any specific high-volume store), 
rank the delivery partners based on their average delivery speed. 
Delivery speed is defined as the time (in minutes) from order_date
 to actual_delivery_time.*/
 
 SELECT
    delivery_partner_id,
    AVG(TIMESTAMPDIFF(MINUTE, order_date, actual_delivery_time)) AS Avg_Delivery_Time_Mins,
    RANK() OVER (ORDER BY AVG(TIMESTAMPDIFF(MINUTE, order_date, actual_delivery_time)) ASC) AS Speed_Rank
FROM
    blinkit_orders_cleaned
WHERE
    store_id = 4771
GROUP BY
    delivery_partner_id;
    
    /*5. or each brand, calculate:
The total number of feedback entries.
The percentage of feedback that is positive.
The percentage of feedback that is negative.
Display all brands, but also identify brands that have more than 5 feedback entries. 
Sort the results by the percentage of positive feedback in descending order.*/

SELECT  
    p.brand,
    COUNT(f.feedback_id) AS Total_Feedback_Count,
    (SUM(CASE WHEN f.sentiment = 'Positive' THEN 1 ELSE 0 END) * 100.0 / COUNT(f.feedback_id)) AS Pct_Positive,
    (SUM(CASE WHEN f.sentiment = 'Negative' THEN 1 ELSE 0 END) * 100.0 / COUNT(f.feedback_id)) AS Pct_Negative
FROM blinkit_customer_feedback_cleaned f
JOIN blinkit_orders_cleaned o ON f.order_id = o.order_id
JOIN blinkit_order_iteam_cleaned oi ON o.order_id = oi.order_id
JOIN blinkit_products_cleaned p ON oi.product_id = p.product_id
GROUP BY p.brand
HAVING Total_Feedback_Count > 5
ORDER BY Pct_Positive DESC;

SELECT  
    p.brand,
    COUNT(f.feedback_id) AS Total_Feedback_Count,
    (SUM(CASE WHEN f.sentiment = 'Positive' THEN 1 ELSE 0 END) * 100.0 / COUNT(f.feedback_id)) AS Pct_Positive,
    (SUM(CASE WHEN f.sentiment = 'Negative' THEN 1 ELSE 0 END) * 100.0 / COUNT(f.feedback_id)) AS Pct_Negative
FROM blinkit_customer_feedback_cleaned f
JOIN blinkit_orders_cleaned o ON f.order_id = o.order_id
JOIN blinkit_order_iteam_cleaned oi ON o.order_id = oi.order_id
JOIN blinkit_products_cleaned p ON oi.product_id = p.product_id
GROUP BY p.brand
ORDER BY Pct_Positive DESC;

