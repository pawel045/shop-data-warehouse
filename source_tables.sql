CREATE SCHEMA store;

-- SOURCE TABLES
CREATE TABLE online_transactions (
    transaction_id SERIAL PRIMARY KEY,
    transaction_date TIMESTAMP NOT NULL,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    payment_method VARCHAR(50) CHECK (payment_method IN ('Credit Card', 'PayPal', 'Bank Transfer')),
    order_status VARCHAR(20) CHECK (order_status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

CREATE TABLE pos_transactions (
    transaction_id SERIAL PRIMARY KEY,
    transaction_date TIMESTAMP NOT NULL,
    store_id INT NOT NULL,
    product_id INT NOT NULL,
    cashier_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    payment_type VARCHAR(20) CHECK (payment_type IN ('Cash', 'Card', 'Mobile Payment'))
);

CREATE TABLE supply_inventory (
    supply_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    supplier_name VARCHAR(255) NOT NULL,
    country VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    street VARCHAR(255) NOT NULL,
    street_num VARCHAR(50) NOT NULL,
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    product_group VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0)
);

-- INSERTING DATA
INSERT INTO online_transactions (transaction_date, customer_id, product_id, quantity, payment_method, order_status) 
VALUES 
('2024-03-01 10:15:00', 101, 1, 2, 'Credit Card', 'Shipped'),
('2024-03-02 14:30:00', 102, 3, 1, 'PayPal', 'Delivered'),
('2024-03-03 18:45:00', 103, 2, 5, 'Bank Transfer', 'Pending'),
('2024-03-04 09:00:00', 104, 4, 3, 'Credit Card', 'Cancelled'),
('2024-03-05 20:20:00', 105, 1, 1, 'PayPal', 'Delivered'),
('2024-03-06 11:10:00', 106, 5, 2, 'Credit Card', 'Shipped'),
('2024-03-07 15:45:00', 107, 2, 4, 'Bank Transfer', 'Pending'),
('2024-03-08 08:30:00', 108, 3, 3, 'Credit Card', 'Delivered'),
('2024-03-09 22:00:00', 109, 4, 2, 'PayPal', 'Cancelled'),
('2024-03-10 13:25:00', 110, 1, 1, 'Bank Transfer', 'Shipped');

INSERT INTO pos_transactions (transaction_date, store_id, product_id, cashier_id, quantity, payment_type) 
VALUES 
('2024-03-01 11:00:00', 1, 2, 201, 1, 'Cash'),
('2024-03-02 13:15:00', 2, 4, 202, 2, 'Card'),
('2024-03-03 15:45:00', 1, 1, 203, 3, 'Mobile Payment'),
('2024-03-04 17:30:00', 3, 3, 204, 1, 'Card'),
('2024-03-05 19:00:00', 2, 2, 205, 4, 'Cash'),
('2024-03-06 14:40:00', 1, 5, 206, 2, 'Mobile Payment'),
('2024-03-07 12:30:00', 3, 1, 207, 1, 'Card'),
('2024-03-08 16:55:00', 2, 3, 208, 5, 'Cash'),
('2024-03-09 10:10:00', 1, 4, 209, 3, 'Mobile Payment'),
('2024-03-10 20:20:00', 3, 5, 210, 2, 'Card');

INSERT INTO supply_inventory (product_id, supplier_name, country, city, street, street_num, stock_quantity) 
VALUES 
(1, 'Supplier A', 'USA', 'New York', '5th Avenue', '10A', 100),
(2, 'Supplier B', 'Germany', 'Berlin', 'Alexanderplatz', '45', 200),
(3, 'Supplier C', 'UK', 'London', 'Baker Street', '221B', 50),
(4, 'Supplier D', 'France', 'Paris', 'Champs-Élysées', '15', 75),
(5, 'Supplier E', 'Italy', 'Rome', 'Via del Corso', '30', 120),
(1, 'Supplier F', 'Spain', 'Madrid', 'Gran Via', '18', 80),
(2, 'Supplier G', 'Canada', 'Toronto', 'Yonge Street', '99', 150),
(3, 'Supplier H', 'Australia', 'Sydney', 'George Street', '22', 90),
(4, 'Supplier I', 'Japan', 'Tokyo', 'Shibuya', '8-12', 60),
(5, 'Supplier J', 'Brazil', 'Sao Paulo', 'Paulista Avenue', '500', 110);

INSERT INTO product (product_id, product_name, product_group, price) 
VALUES 
(1, 'Laptop', 'Electronics', 899.99),
(2, 'Smartphone', 'Electronics', 499.50),
(3, 'Headphones', 'Accessories', 79.99),
(4, 'Office Chair', 'Furniture', 199.99),
(5, 'Desk Lamp', 'Furniture', 39.99);

