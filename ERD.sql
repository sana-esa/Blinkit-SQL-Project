use blinkit_db;

-- 1. Customers Table
ALTER TABLE blinkit_customers_cleaned
ADD PRIMARY KEY (customer_id);

-- 2. Orders Table (order_id is a large number, so we create an index on it)
ALTER TABLE blinkit_orders_cleaned
ADD PRIMARY KEY (order_id);

-- 3. Products Table
ALTER TABLE blinkit_products_cleaned
ADD PRIMARY KEY (product_id);

-- 4. Order Item Table (It has a composite PK: order_id + product_id)
ALTER TABLE blinkit_order_iteam_cleaned
ADD PRIMARY KEY (order_id, product_id);

-- 5. Feedback Table (if not set yet)
ALTER TABLE blinkit_customer_feedback_cleaned
ADD PRIMARY KEY (feedback_id);

ALTER TABLE blinkit_market_perfomance_cleaned
ADD PRIMARY KEY (campaign_id);

-- 1. blinkit_orders_cleaned (The command should run now)
ALTER TABLE blinkit_orders_cleaned

ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id) 
REFERENCES blinkit_customers_cleaned(customer_id);


-- 2. Order Item Table (The remaining FKs)
ALTER TABLE blinkit_order_iteam_cleaned
ADD CONSTRAINT fk_item_order
FOREIGN KEY (order_id) 
REFERENCES blinkit_orders_cleaned(order_id);

ALTER TABLE blinkit_order_iteam_cleaned
ADD CONSTRAINT fk_item_product
FOREIGN KEY (product_id) 
REFERENCES blinkit_products_cleaned(product_id);

ALTER TABLE blinkit_customer_feedback_cleaned 
ADD CONSTRAINT fk_feedback_customer
FOREIGN KEY (customer_id)  
REFERENCES blinkit_customers_cleaned(customer_id);

-- Step 1: Match the Data Type
ALTER TABLE blinkit_customer_feedback_cleaned
MODIFY order_id BIGINT; 

