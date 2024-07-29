-- TUGAS 1 - DATA PREPARATION

-- Membuat Table

-- Table customer_dataset
CREATE TABLE customers_dataset (
	customer_id varchar(50) NOT NULL,
	customer_unique_id varchar(50) NULL,
	customer_zip_code_prefix varchar(50) NULL,
	customer_city varchar(50) NULL,
	customer_state varchar(50) NULL,
	CONSTRAINT customers_dataset_pk PRIMARY KEY (customer_id)
);

-- Table geolocation_dataset
CREATE TABLE geolocation_dataset (
	geolocation_zip_code_prefix varchar(50) NULL,
	geolocation_lat float8 NULL,
	geolocation_lng float8 NULL,
	geolocation_city varchar(50) NULL,
	geolocation_state varchar(50) NULL
);

-- Table order_items_dataset
CREATE TABLE order_items_dataset (
	order_id varchar(50) NULL,
	order_item_id int4 NULL,
	product_id varchar(50) NULL,
	seller_id varchar(50) NULL,
	shipping_limit_date timestamp NULL,
	price float8 NULL,
	freight_value float8 NULL
);

-- Table order_payments_dataset
CREATE TABLE order_payments_dataset (
	order_id varchar(50) NULL,
	payment_sequential int4 NULL,
	payment_type varchar(50) NULL,
	payment_installments int4 NULL,
	payment_value float8 NULL
);

-- Table order_reviews_dataset
CREATE TABLE order_reviews_dataset (
	review_id varchar(100) NULL,
	order_id varchar(100) NULL,
	review_score int4 NULL,
	review_comment_title varchar(100) NULL,
	review_comment_message varchar(400) NULL,
	review_creation_date timestamp NULL,
	review_answer_timestamp timestamp NULL
);

-- Table orders_dataset
CREATE TABLE orders_dataset (
	order_id varchar(50) NOT NULL,
	customer_id varchar(50) NULL,
	order_status varchar(50) NULL,
	order_purchase_timestamp timestamp NULL,
	order_approved_at timestamp NULL,
	order_delivered_carrier_date timestamp NULL,
	order_delivered_customer_date timestamp NULL,
	order_estimated_delivery_date timestamp NULL,
	CONSTRAINT orders_dataset_pk PRIMARY KEY (order_id)
);

-- Table products_dataset
CREATE TABLE products_dataset (
	column1 int4 NULL,
	product_id varchar(50) NOT NULL,
	product_category_name varchar(50) NULL,
	product_name_lenght float8 NULL,
	product_description_lenght float8 NULL,
	product_photos_qty float8 NULL,
	product_weight_g float8 NULL,
	product_length_cm float8 NULL,
	product_height_cm float8 NULL,
	product_width_cm float8 NULL,
	CONSTRAINT products_dataset_pk PRIMARY KEY (product_id)
);

-- Table sellers_dataset
CREATE TABLE sellers_dataset (
	seller_id varchar(50) NOT NULL,
	seller_zip_code_prefix varchar(50) NULL,
	seller_city varchar(50) NULL,
	seller_state varchar(50) NULL,
	CONSTRAINT sellers_dataset_pk PRIMARY KEY (seller_id)
);


-- Table geolocation_dataset2, Filter karakter khusus
CREATE TABLE geolocation_dataset2 AS
SELECT geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, 
REPLACE(REPLACE(REPLACE(
TRANSLATE(TRANSLATE(TRANSLATE(TRANSLATE(
TRANSLATE(TRANSLATE(TRANSLATE(TRANSLATE(
    geolocation_city, '£,³,´,.', ''), '`', ''''), 
    'é,ê', 'e,e'), 'á,â,ã', 'a,a,a'), 'ô,ó,õ', 'o,o,o'),
	'ç', 'c'), 'ú,ü', 'u,u'), 'í', 'i'), 
	'4o', '4º'), '* ', ''), '%26apos%3b', ''''
) AS geolocation_city, geolocation_state
from geolocation_dataset gd;

-- Table geolocation_dataset3 Filtering & Remove Duplicate
CREATE TABLE geolocation_dataset3 AS
WITH geolocation_dataset3 AS (
    -- Mengambil satu baris untuk setiap geolocation_zip_code_prefix dari geolocation_dataset2
    SELECT geolocation_zip_code_prefix,
           geolocation_lat, 
           geolocation_lng, 
           geolocation_city, 
           geolocation_state 
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (
                   PARTITION BY geolocation_zip_code_prefix
               ) AS ROW_NUMBER
        FROM geolocation_dataset2 
    ) TEMP
    WHERE ROW_NUMBER = 1
),
custgeo AS (
    -- Mengambil satu baris untuk setiap customer_zip_code_prefix yang tidak ada di geolocation_dataset3
    SELECT customer_zip_code_prefix, 
           geolocation_lat, 
           geolocation_lng, 
           customer_city, 
           customer_state 
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (
                   PARTITION BY customer_zip_code_prefix
               ) AS ROW_NUMBER
        FROM (
            SELECT customer_zip_code_prefix, 
                   geolocation_lat, 
                   geolocation_lng, 
                   customer_city, 
                   customer_state
            FROM customers_dataset cd 
            LEFT JOIN geolocation_dataset gdd 
            ON customer_city = geolocation_city
            AND customer_state = geolocation_state
            WHERE customer_zip_code_prefix NOT IN (
                SELECT geolocation_zip_code_prefix
                FROM geolocation_dataset3 gd 
            )
        ) geo
    ) TEMP
    WHERE ROW_NUMBER = 1
),
sellgeo AS (
    -- Mengambil satu baris untuk setiap seller_zip_code_prefix yang tidak ada di geolocation_dataset3 atau custgeo
    SELECT seller_zip_code_prefix, 
           geolocation_lat, 
           geolocation_lng, 
           seller_city, 
           seller_state 
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (
                   PARTITION BY seller_zip_code_prefix
               ) AS ROW_NUMBER
        FROM (
            SELECT seller_zip_code_prefix, 
                   geolocation_lat, 
                   geolocation_lng, 
                   seller_city, 
                   seller_state
            FROM sellers_dataset cd 
            LEFT JOIN geolocation_dataset gdd 
            ON seller_city = geolocation_city
            AND seller_state = geolocation_state
            WHERE seller_zip_code_prefix NOT IN (
                SELECT geolocation_zip_code_prefix
                FROM geolocation_dataset3 gd 
                UNION
                SELECT customer_zip_code_prefix
                FROM custgeo cd 
            )
        ) geo
    ) TEMP
    WHERE ROW_NUMBER = 1
)
-- Menggabungkan hasil dari geolocation_dataset3, custgeo, dan sellgeo
SELECT * 
FROM geolocation_dataset3
UNION
SELECT * 
FROM custgeo
UNION
SELECT * 
FROM sellgeo;
ALTER TABLE geolocation_dataset3 ADD CONSTRAINT geolocation_dataset3_pk PRIMARY KEY (geolocation_zip_code_prefix);



-- Membuat Constraint dan Foreign Key

-- products -> order_items
ALTER TABLE order_items_dataset 
ADD CONSTRAINT order_items_dataset_fk_product 
FOREIGN KEY (product_id) REFERENCES products_dataset(product_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- sellers -> order_items
ALTER TABLE order_items_dataset 
ADD CONSTRAINT order_items_dataset_fk_seller 
FOREIGN KEY (seller_id) REFERENCES sellers_dataset(seller_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- orders -> order_items
ALTER TABLE order_items_dataset 
ADD CONSTRAINT order_items_dataset_fk_order 
FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- orders -> order_payments
ALTER TABLE order_payments_dataset 
ADD CONSTRAINT order_payments_dataset_fk 
FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- orders -> order_reviews
ALTER TABLE order_reviews_dataset 
ADD CONSTRAINT order_reviews_dataset_fk 
FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- customers -> orders
ALTER TABLE orders_dataset 
ADD CONSTRAINT orders_dataset_fk 
FOREIGN KEY (customer_id) REFERENCES customers_dataset(customer_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- geolocation -> customers
ALTER TABLE customers_dataset 
ADD CONSTRAINT customers_dataset_fk 
FOREIGN KEY (customer_zip_code_prefix) REFERENCES geolocation_dataset3(geolocation_zip_code_prefix) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- geolocation -> sellers
ALTER TABLE sellers_dataset 
ADD CONSTRAINT sellers_dataset_fk 
FOREIGN KEY (seller_zip_code_prefix) REFERENCES geolocation_dataset3(geolocation_zip_code_prefix) 
ON DELETE CASCADE ON UPDATE CASCADE;
