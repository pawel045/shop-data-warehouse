CREATE SCHEMA store_dwh

-- Product Dimension Table
CREATE TABLE store_dwh.product_dim (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    product_group VARCHAR(255) NOT NULL
);

-- Supply Dimension Table
CREATE TABLE store_dwh.supply_dim (
    supply_id SERIAL PRIMARY KEY,
    country VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    street VARCHAR(255) NOT NULL,
    street_num VARCHAR(50) NOT NULL
);

-- Transaction Dimension Table
CREATE TABLE store_dwh.transaction_dim (
    transaction_id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    nip_number VARCHAR(50),
    payment_method VARCHAR(50) NOT NULL,
    valid_transaction BOOLEAN NOT NULL
);

-- Store Dimension Table
CREATE TABLE store_dwh.store_dim (
    store_id SERIAL PRIMARY KEY,
    country VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    street VARCHAR(255) NOT NULL,
    street_num VARCHAR(50) NOT NULL,
    online_pos BOOLEAN NOT NULL
);

-- Fact Sales Table
CREATE TABLE store_dwh.sale_fact (
    sale_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES product_dim(product_id) ON DELETE CASCADE,
    supply_id INT REFERENCES supply_dim(supply_id) ON DELETE CASCADE,
    transaction_id INT REFERENCES transaction_dim(transaction_id) ON DELETE CASCADE,
    store_id INT REFERENCES store_dim(store_id) ON DELETE CASCADE,
    price DECIMAL(10,2) NOT NULL,
    amount INT NOT NULL,
    price_total DECIMAL(10,2) NOT NULL,
    amount_supply_rest INT NOT NULL
);
