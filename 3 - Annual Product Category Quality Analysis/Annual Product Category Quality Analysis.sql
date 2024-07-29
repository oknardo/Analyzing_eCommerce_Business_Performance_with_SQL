-- Menghitung revenue per tahun
WITH yearly_revenue AS (
    SELECT 
        EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
        SUM(oi.price) AS revenue
    FROM 
        orders_dataset o
    JOIN 
        order_items_dataset oi ON o.order_id = oi.order_id
    WHERE 
        o.order_status = 'delivered'
    GROUP BY 
        year
),
-- Menghitung jumlah cancel order per tahun
yearly_cancel_order AS (
    SELECT 
        EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
        COUNT(o.order_id) AS cancel_order_count
    FROM 
        orders_dataset o
    WHERE 
        o.order_status = 'canceled'
    GROUP BY 
        year
),
-- Menghitung top kategori yang menghasilkan revenue terbesar per tahun
yearly_top_revenue_category AS (
    SELECT 
        EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
        p.product_category_name,
        SUM(oi.price) AS category_revenue,
        ROW_NUMBER() OVER (PARTITION BY EXTRACT(YEAR FROM o.order_purchase_timestamp) ORDER BY SUM(oi.price) DESC) AS rn
    FROM 
        orders_dataset o
    JOIN 
        order_items_dataset oi ON o.order_id = oi.order_id
    JOIN 
        products_dataset p ON oi.product_id = p.product_id
    WHERE 
        o.order_status = 'delivered'
    GROUP BY 
        year, p.product_category_name
),
-- Menghitung kategori yang mengalami cancel order terbanyak per tahun
yearly_top_cancel_category AS (
    SELECT 
        EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
        p.product_category_name,
        COUNT(o.order_id) AS cancel_category_count,
        ROW_NUMBER() OVER (PARTITION BY EXTRACT(YEAR FROM o.order_purchase_timestamp) ORDER BY COUNT(o.order_id) DESC) AS rn
    FROM 
        orders_dataset o
    JOIN 
        order_items_dataset oi ON o.order_id = oi.order_id
    JOIN 
        products_dataset p ON oi.product_id = p.product_id
    WHERE 
        o.order_status = 'canceled'
    GROUP BY 
        year, p.product_category_name
)

-- Menggabungkan hasil
SELECT 
    yr.year,
    yr.revenue,
    yco.cancel_order_count,
    ytrc.product_category_name AS top_revenue_category,
    ytrc.category_revenue AS top_revenue_category_revenue,
    ytcc.product_category_name AS top_cancel_category,
    ytcc.cancel_category_count AS top_cancel_category_count
FROM 
    yearly_revenue yr
LEFT JOIN 
    yearly_cancel_order yco ON yr.year = yco.year
LEFT JOIN 
    yearly_top_revenue_category ytrc ON yr.year = ytrc.year AND ytrc.rn = 1
LEFT JOIN 
    yearly_top_cancel_category ytcc ON yr.year = ytcc.year AND ytcc.rn = 1
ORDER BY 
    yr.year;
