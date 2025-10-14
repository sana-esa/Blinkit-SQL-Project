create database blinkit_db;
use blinkit_db;

select* from blinkit_market_perfomance_cleaned;
select* from blinkit_customers_cleaned;
select* from blinkit_order_iteam_cleaned;
select* from blinkit_products_cleaned;
select* from blinkit_orders_cleaned;
select* from blinkit_customer_feedback_cleaned;
describe blinkit_customer_feedback_cleaned;
describe blinkit_orders_cleaned;
describe blinkit_products_cleaned;
describe blinkit_market_perfomance_cleaned;
describe blinkit_customers_cleaned;
describe blinkit_customer_feedback_cleaned;

-- Step 1: Disable Safe Update Mode
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE blinkit_customers_cleaned
MODIFY registration_date DATE;
-- Step 3: Enable Safe Update Mode again for safety)
SET SQL_SAFE_UPDATES = 1; 
SET SQL_SAFE_UPDATES = 0;
-- 1. Correct the Date/Time columns (TEXT to DATETIME)
UPDATE blinkit_orders_cleaned
SET 
    order_date = STR_TO_DATE(order_date, '%d-%m-%Y %H:%i'),
    promised_delivery_time = STR_TO_DATE(promised_delivery_time, '%d-%m-%Y %H:%i'),
    actual_delivery_time = STR_TO_DATE(actual_delivery_time, '%d-%m-%Y %H:%i');
SET SQL_SAFE_UPDATES = 1; 
-- 2. Fixing data types for columns)
ALTER TABLE blinkit_orders_cleaned
MODIFY order_id BIGINT PRIMARY KEY,
MODIFY order_date DATETIME,
MODIFY promised_delivery_time DATETIME,
MODIFY actual_delivery_time DATETIME,
MODIFY delivery_status VARCHAR(50),
MODIFY order_total DECIMAL(10, 2);

-- 2. Fixing data types for columns)
ALTER TABLE blinkit_order_iteam_cleaned
MODIFY order_id BIGINT,
MODIFY product_id INT,
MODIFY unit_price DECIMAL(10, 2);
SET SQL_SAFE_UPDATES = 0; 
-- 1. Remove whitespace from Text columns
UPDATE blinkit_products_cleaned
SET 
    product_name = TRIM(product_name),
    category = TRIM(category),
    brand = TRIM(brand);
SET SQL_SAFE_UPDATES = 1; 

ALTER TABLE blinkit_products_cleaned
MODIFY product_name VARCHAR(255),
MODIFY category VARCHAR(100),
MODIFY brand VARCHAR(100),
MODIFY price DECIMAL(10, 2),
MODIFY mrp DECIMAL(10, 2);
-- 2. Fixing data types for columns)
SET SQL_SAFE_UPDATES = 0;
-- 1. Fixing the data type for the date column)
UPDATE blinkit_market_perfomance_cleaned
SET date = STR_TO_DATE(date, '%d-%m-%Y')
WHERE date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$';
SET SQL_SAFE_UPDATES = 1;
-- 2. Fixing data types for columns)
ALTER TABLE blinkit_market_perfomance_cleaned
MODIFY date DATE,
MODIFY campaign_name VARCHAR(255),
MODIFY spend DECIMAL(10, 2),
MODIFY revenue_generated DECIMAL(10, 2),
MODIFY roas DECIMAL(10, 2);
SET SQL_SAFE_UPDATES = 0;
-- Fixing the data type for the Feedback Date column
UPDATE blinkit_customer_feedback_cleaned
SET feedback_date = STR_TO_DATE(feedback_date, '%d-%m-%Y')
WHERE feedback_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$';
SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;
-- 2. Remove whitespace from Text columns
UPDATE blinkit_customer_feedback_cleaned
SET 
    feedback_category = TRIM(feedback_category),
    sentiment = TRIM(sentiment);
    SET SQL_SAFE_UPDATES = 1;

-- 3. Fixing data types for columns)
ALTER TABLE blinkit_customer_feedback_cleaned
MODIFY feedback_id BIGINT PRIMARY KEY,
MODIFY feedback_date DATE,
MODIFY feedback_category VARCHAR(100),
MODIFY sentiment VARCHAR(50);
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE blinkit_customer_feedback_cleaned
MODIFY order_id BIGINT; 