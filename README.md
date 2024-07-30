# Analyzing eCommerce Business Performance with SQL

## Created By:
**Name:** Oknardo Budi Setiawan Tulung  
**Email:** oknardotulung@gmail.com  
**LinkedIn:** [www.linkedin.com/in/oknardo-tulung](https://www.linkedin.com/in/oknardo-tulung)  
**GitHub:** [https://github.com/oknardo](https://github.com/oknardo)

## Dataset
Dataset yang digunakan disediakan oleh Rakamin Academy, Brazilian E-Commerce Public Dataset oleh Olist. Dataset ini dapat diakses di Kaggle. Ini adalah dataset publik e-commerce Brasil dari pesanan yang dilakukan di Olist Store. Dataset ini memiliki informasi data pesanan dari tahun 2016 hingga 2018 yang dilakukan di berbagai marketplace di Brasil.

## Latar Belakang dan Objektif
### Latar Belakang
Perusahaan eCommerce ini ingin mengetahui bagaimana performa bisnisnya dalam beberapa aspek utama yaitu pertumbuhan pelanggan, kualitas produk, dan tipe pembayaran. Perlu dilakukannya analisis untuk mendapatkan insights yang lebih mendalam tentang bagaimana bisnis beroperasi dan bagaimana kinerjanya dapat ditingkatkan.

### Objektif
- Mengukur pertumbuhan pelanggan melalui metrik-metrik seperti jumlah customer aktif, jumlah customer baru, dan jumlah customer yang melakukan repeat order.
- Menilai kualitas produk berdasarkan kategori produk dan pengaruhnya terhadap pendapatan perusahaan.
- Menganalisis performa dari berbagai tipe pembayaran yang digunakan oleh customer dan melihat tren perubahan yang terjadi selama beberapa tahun terakhir.

## Batasan Masalah
- Analisis ini hanya mencakup data yang tersedia dari database perusahaan eCommerce.
- Hanya melakukan analisis terkait pertumbuhan pelanggan, kualitas produk, dan tipe pembayaran.
- Tidak mencakup analisis eksternal seperti tren pasar atau analisis kompetitor.

## Data dan Asumsi
### Data
Data yang digunakan dalam analisis ini terdiri dari beberapa tabel dengan format csv yang mencakup informasi berikut:
- **Customer Data**: Informasi tentang pelanggan, termasuk id, tanggal bergabung, dan aktivitas transaksi.
- **Product Data**: Informasi tentang produk, termasuk id produk, kategori, dan rating.
- **Transaction Data**: Informasi tentang transaksi, termasuk id transaksi, id customer, id produk, jumlah, dan tanggal transaksi.
- **Payment Data**: Informasi tentang tipe pembayaran yang digunakan dalam setiap transaksi.

### Asumsi
- Data yang tersedia akurat dan mencerminkan aktivitas bisnis yang sebenarnya.
- Semua transaksi yang dicatat adalah valid dan telah diverifikasi.

## Analisis Data
### Proses Analisis
1. **Data Preparation**: Memasukkan data mentah dalam format csv ke dalam tabel-tabel database menggunakan PostgreSQL dan membuat entity relationship antar tabel.
2. **Customer Growth Analysis**: Menghitung jumlah customer aktif, jumlah customer baru, jumlah customer yang melakukan repeat order, dan rata-rata transaksi yang dilakukan customer setiap tahun.
3. **Product Quality Analysis**: Menganalisis performa dari masing-masing kategori produk dan bagaimana kaitannya dengan pendapatan perusahaan.
4. **Payment Type Analysis**: Menganalisis tipe-tipe pembayaran yang tersedia dan melihat tren perubahan yang terjadi selama beberapa tahun terakhir.

## Simpulan
- **Customer Growth**: Analisis menunjukkan tren pertumbuhan pelanggan yang positif dengan peningkatan jumlah customer aktif dan repeat order.
- **Product Quality**: Produk dengan rating tinggi dan kategori tertentu berkontribusi signifikan terhadap pendapatan perusahaan.
- **Payment Type**: Tipe pembayaran tertentu lebih populer di kalangan customer dan menunjukkan tren peningkatan yang dapat digunakan untuk strategic partnership.

## Saran
- **Customer Engagement**: Tingkatkan engagement dengan pelanggan yang sudah ada melalui program loyalitas dan penawaran khusus untuk repeat customers.
- **Product Improvement**: Fokus pada peningkatan kualitas produk di kategori yang kurang performa untuk meningkatkan kepuasan dan pendapatan.
- **Payment Options**: Pertimbangkan untuk memperluas opsi pembayaran yang populer dan bekerja sama dengan penyedia layanan pembayaran untuk penawaran yang lebih baik.




