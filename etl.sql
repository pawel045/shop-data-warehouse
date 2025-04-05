-- =============================
-- ETL PROCESS FOR DATA WAREHOUSE
-- =============================

-- =============================
-- ETL: product_dim
-- =============================
WITH online_data AS (
    SELECT * FROM store.online_transactions
    WHERE transaction_date::date >= CURRENT_DATE - INTERVAL '1 day'
),
pos_data AS (
    SELECT * FROM store.pos_transactions
    WHERE transaction_date::date >= CURRENT_DATE - INTERVAL '1 day'
)
INSERT INTO store_dwh.product_dim (product_id, product_name, product_group)
SELECT DISTINCT p.product_id, i.product_name, i.product_group
FROM (
    SELECT DISTINCT product_id FROM online_data
    UNION
    SELECT DISTINCT product_id FROM pos_data
) p
JOIN store.product i ON p.product_id = i.product_id
WHERE NOT EXISTS (
    SELECT 1 FROM store_dwh.product_dim pd WHERE pd.product_id = p.product_id
);

-- =============================
-- ETL: supply_dim
-- =============================
WITH supply_data AS (
    SELECT * FROM store.supply_inventory
)
INSERT INTO store_dwh.supply_dim (supply_id, country, city, street, street_num)
SELECT s.supply_id, s.country, s.city, s.street, s.street_num
FROM supply_data s
WHERE NOT EXISTS (
    SELECT 1 FROM store_dwh.supply_dim d WHERE d.supply_id = s.supply_id
);

-- =============================
-- ETL: transaction_dim
-- =============================
WITH online_data AS (
    SELECT * FROM store.online_transactions
    WHERE transaction_date::date >= CURRENT_DATE - INTERVAL '1 day'
)
INSERT INTO store_dwh.transaction_dim (transaction_id, date, nip_number, payment_method, valid_transaction)
SELECT t.transaction_id, DATE(t.transaction_date), NULL AS nip_number, t.payment_method, 
       CASE WHEN t.order_status = 'Cancelled' THEN FALSE ELSE TRUE END
FROM online_data t
WHERE NOT EXISTS (
    SELECT 1 FROM store_dwh.transaction_dim d WHERE d.transaction_id = t.transaction_id
);

WITH pos_data AS (
    SELECT * FROM store.pos_transactions
    WHERE transaction_date::date >= CURRENT_DATE - INTERVAL '1 day'
)
INSERT INTO store_dwh.transaction_dim (transaction_id, date, nip_number, payment_method, valid_transaction)
SELECT t.transaction_id, DATE(t.transaction_date), NULL AS nip_number, t.payment_type, TRUE
FROM pos_data t
WHERE NOT EXISTS (
    SELECT 1 FROM store_dwh.transaction_dim d WHERE d.transaction_id = t.transaction_id
);

-- =============================
-- ETL: store_dim
-- =============================
WITH pos_data AS (
    SELECT * FROM store.pos_transactions
    WHERE transaction_date::date >= CURRENT_DATE - INTERVAL '1 day'
)
INSERT INTO store_dwh.store_dim (store_id, country, city, street, street_num, online_pos)
SELECT DISTINCT s.store_id, 'Poland', 'Warsaw', 'Kubusia Puchatka', '12', FALSE
FROM pos_data s
WHERE NOT EXISTS (
    SELECT 1 FROM store_dwh.store_dim d WHERE d.store_id = s.store_id
);

-- =============================
-- ETL: sale_fact
-- =============================
WITH online_data AS (
    SELECT o.*, p.price FROM store.online_transactions o
	JOIN store.product p ON o.product_id = p.product_id
    WHERE transaction_date::date >= CURRENT_DATE - INTERVAL '1 day'
)
INSERT INTO store_dwh.sale_fact (product_id, supply_id, transaction_id, store_id, price, amount, price_total, amount_supply_rest)
SELECT t.product_id, 1, t.transaction_id, 1, t.price, t.quantity, t.price*t.quantity, 0
FROM online_data t
WHERE NOT EXISTS (
    SELECT 1 FROM store_dwh.sale_fact f WHERE f.transaction_id = t.transaction_id
);

WITH pos_data AS (
    SELECT o.*, p.price FROM store.pos_transactions o
	JOIN store.product p ON o.product_id = p.product_id
    WHERE transaction_date::date >= CURRENT_DATE - INTERVAL '1 day'
)
INSERT INTO store_dwh.sale_fact (product_id, supply_id, transaction_id, store_id, price, amount, price_total, amount_supply_rest)
SELECT t.product_id, 1, t.transaction_id, 1, t.price, t.quantity, t.price*t.quantity, 0
FROM pos_data t
WHERE NOT EXISTS (
    SELECT 1 FROM store_dwh.sale_fact f WHERE f.transaction_id = t.transaction_id
);

-- =============================
-- END OF ETL SCRIPT
-- =============================
