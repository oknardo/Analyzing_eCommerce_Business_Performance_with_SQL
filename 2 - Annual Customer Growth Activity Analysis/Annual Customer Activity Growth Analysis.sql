-- TUGAS 2 - ANNUAL CUSTOMER ACTIVITY GROWTH ANALYSIS

-- Menampilkan rata-rata jumlah active customer per tahun (avg_monthly_active_user)
SELECT 
    year, 
    floor(avg(n_customers)) AS avg_monthly_active_user
FROM (
    SELECT 
        date_part('year', o.order_purchase_timestamp) AS year,
        date_part('month', o.order_purchase_timestamp) AS month,
        count(DISTINCT c.customer_unique_id) AS n_customers
    FROM orders_dataset o
    JOIN customers_dataset c 
    ON o.customer_id = c.customer_id 
    GROUP BY 1, 2
) monthly
GROUP BY 1
ORDER BY 1;

-- Menampilkan jumlah customer baru pada masing-masing tahun
SELECT 
    date_part('year', first_date_order) AS year,
    count(customer_unique_id) AS new_customers
FROM (
    SELECT 
        c.customer_unique_id, 
        min(o.order_purchase_timestamp) AS first_date_order
    FROM orders_dataset o 
    JOIN customers_dataset c 
    ON o.customer_id = c.customer_id 
    GROUP BY c.customer_unique_id
) first_order
GROUP BY 1
ORDER BY 1;

-- Menampilkan jumlah customer yang melakukan pembelian lebih dari satu kali 
-- (repeat order) pada masing-masing tahun
SELECT 
    year,
    count(DISTINCT customer_unique_id) AS repeat_customers
FROM (
    SELECT 
        date_part('year', o.order_purchase_timestamp) AS year,
        c.customer_unique_id,
        count(o.order_id) AS n_order
    FROM orders_dataset o 
    JOIN customers_dataset c 
    ON o.customer_id = c.customer_id 
    GROUP BY 1, 2
    HAVING count(o.order_id) > 1
) repeat_order
GROUP BY 1
ORDER BY 1;

-- Menampilkan rata-rata jumlah order yang dilakukan customer untuk masing-masing tahun
SELECT 
    year,
    round(avg(n_order), 2) AS avg_num_orders
FROM (
    SELECT 
        date_part('year', o.order_purchase_timestamp) AS year,
        c.customer_unique_id,
        count(o.order_id) AS n_order
    FROM orders_dataset o 
    JOIN customers_dataset c 
    ON o.customer_id = c.customer_id 
    GROUP BY 1, 2
) order_customer
GROUP BY 1
ORDER BY 1;

-- Membuat table gabungan
WITH tbl_mau AS (
    SELECT 
        year, 
        floor(avg(n_customers)) AS avg_monthly_active_user
    FROM (
        SELECT 
            date_part('year', o.order_purchase_timestamp) AS year,
            date_part('month', o.order_purchase_timestamp) AS month,
            count(DISTINCT c.customer_unique_id) AS n_customers
        FROM orders_dataset o
        JOIN customers_dataset c 
        ON o.customer_id = c.customer_id 
        GROUP BY 1, 2
    ) monthly
    GROUP BY 1
),
tbl_newcust AS (
    SELECT 
        date_part('year', first_date_order) AS year,
        count(customer_unique_id) AS new_customers
    FROM (
        SELECT 
            c.customer_unique_id, 
            min(o.order_purchase_timestamp) AS first_date_order
        FROM orders_dataset o 
        JOIN customers_dataset c 
        ON o.customer_id = c.customer_id 
        GROUP BY c.customer_unique_id
    ) first_order
    GROUP BY 1
),
tbl_repcust AS (
    SELECT 
        year,
        count(DISTINCT customer_unique_id) AS repeat_customers
    FROM (
        SELECT 
            date_part('year', o.order_purchase_timestamp) AS year,
            c.customer_unique_id,
            count(o.order_id) AS n_order
        FROM orders_dataset o 
        JOIN customers_dataset c 
        ON o.customer_id = c.customer_id 
        GROUP BY 1, 2
        HAVING count(o.order_id) > 1
    ) repeat_order
    GROUP BY 1
),
tbl_avgorder AS (
    SELECT 
        year,
        round(avg(n_order), 2) AS avg_num_orders
    FROM (
        SELECT 
            date_part('year', o.order_purchase_timestamp) AS year,
            c.customer_unique_id,
            count(o.order_id) AS n_order
        FROM orders_dataset o 
        JOIN customers_dataset c 
        ON o.customer_id = c.customer_id 
        GROUP BY 1, 2
    ) order_customer
    GROUP BY 1
)
SELECT 
    tm.year, 
    tm.avg_monthly_active_user, 
    tn.new_customers, 
    tr.repeat_customers, 
    ta.avg_num_orders
FROM tbl_mau tm
JOIN tbl_newcust tn
ON tm.year = tn.year 
JOIN tbl_repcust tr
ON tm.year = tr.year 
JOIN tbl_avgorder ta
ON tm.year = ta.year 
ORDER BY 1;
