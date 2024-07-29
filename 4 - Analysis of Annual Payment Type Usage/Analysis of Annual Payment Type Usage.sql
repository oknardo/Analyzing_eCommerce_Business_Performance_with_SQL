-- TUGAS 4 - - Analysis of Annual Payment Type Usage

-- Menampilkan jumlah penggunaan masing-masing tipe pembayaran secara all time
SELECT 'All Time' AS period,
       payment_type,
       COUNT(*) AS total_usage
FROM order_payments_dataset
GROUP BY payment_type
ORDER BY total_usage DESC;

-- Menampilkan detail informasi jumlah penggunaan masing-masing tipe pembayaran untuk setiap tahun
SELECT EXTRACT(YEAR FROM od.order_purchase_timestamp) AS period,
       op.payment_type,
       COUNT(*) AS total_usage
FROM orders_dataset od
JOIN order_payments_dataset op ON od.order_id = op.order_id
GROUP BY period, op.payment_type
ORDER BY period, total_usage DESC;
