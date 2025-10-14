use blinkit_db;

/*Q1: Average Order Value*/

SELECT
    AVG(order_total) AS Average_Order_Value
FROM
    blinkit_orders_cleaned;
    
 /*Q2: Top 3 Categories*/
 
 SELECT
    p.category,
    SUM(oi.quantity) AS Total_Quantity_Sold
FROM
    blinkit_order_iteam_cleaned oi
JOIN
    blinkit_products_cleaned p ON oi.product_id = p.product_id
GROUP BY
    p.category
ORDER BY
    Total_Quantity_Sold DESC
LIMIT 3;

/*Q3: Highest Revenue Channel*/

SELECT
    channel,
    SUM(revenue_generated) AS Total_Revenue_Generated
FROM
    blinkit_market_perfomance_cleaned
GROUP BY
    channel
ORDER BY
    Total_Revenue_Generated DESC
LIMIT 1;

/*4. Sales Performance (Orders Table)
Question: What is the total revenue generated from all orders in the entire dataset?*/

SELECT
    SUM(order_total) AS Total_Revenue
FROM
    blinkit_orders_cleaned;
    
/*5. Sales Performance (Orders Table)
Question: What is the total revenue generated from all orders in the entire dataset?*/
SELECT
    SUM(order_total) AS Total_Revenue
FROM
    blinkit_orders_cleaned;
    
/*6. Customer Segmentation (Customers Table)
Question: How many customers belong to the 'Premium' customer segment?  */

SELECT
    COUNT(customer_id) AS Premium_Customer_Count
FROM
    blinkit_customers_cleaned
WHERE
    customer_segment = 'Premium';
    
 /*7. Product Popularity (Products & Order Items)
Question: Which single product has been sold the highest number of units (quantity)?*/

SELECT
    p.product_name,
    SUM(oi.quantity) AS Total_Units_Sold
FROM
    blinkit_order_iteam_cleaned oi
JOIN
    blinkit_products_cleaned p ON oi.product_id = p.product_id
GROUP BY
    p.product_name
ORDER BY
    Total_Units_Sold DESC
LIMIT 1;

/*8. Customer Satisfaction (Feedback Table)
Question: What is the average rating given by customers across all feedback entries?*/

SELECT
    AVG(rating) AS Average_Customer_Rating
FROM
    blinkit_customer_feedback_cleaned;
    
/*9. Sales Performance (Orders Table)
Question: What is the total revenue generated from all orders in the entire dataset?*/
SELECT
    SUM(order_total) AS Total_Revenue
FROM
    blinkit_orders_cleaned;
/*10. Customer Segmentation (Customers Table)
Question: How many customers belong to the 'Premium' customer segment?*/
SELECT
    COUNT(customer_id) AS Premium_Customer_Count
FROM
    blinkit_customers_cleaned
WHERE
    customer_segment = 'Premium';
/*11. Product Popularity (Products & Order Items)
Question: Which single product has been sold the highest number of units (quantity)?*/

SELECT
    p.product_name,
    SUM(oi.quantity) AS Total_Units_Sold
FROM
    blinkit_order_iteam_cleaned oi
JOIN
    blinkit_products_cleaned p ON oi.product_id = p.product_id
GROUP BY
    p.product_name
ORDER BY
    Total_Units_Sold DESC
LIMIT 1;

/*12. Customer Satisfaction (Feedback Table)
Question: What is the average rating given by customers across all feedback entries?*/
SELECT
    AVG(rating) AS Average_Customer_Rating
FROM
    blinkit_customer_feedback_cleaned;
    
/*13. Marketing Efficiency (Market Performance Table)
Question: What was the total conversion count achieved by all campaigns that targeted the 'New Users' audience?*/

SELECT
    SUM(conversions) AS Total_New_User_Conversions
FROM
    blinkit_market_perfomance_cleaned
WHERE
    target_audience = 'New Users';
    
    
    
    
    

    
