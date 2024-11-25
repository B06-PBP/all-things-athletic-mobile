# **AllThingsAthletic**

## **Daftar Anggota Kelompok**
- **Anindhyaputri Paramitha** (2306218111)  
- **Aditya Dharma** (2306240074)  
- **Amirah Rizkita Setiadji** (2306275235)  
- **Shafa Amira Azka** (2306214025)  
- **Shalya Naura Lionita** (2306245535)  

---
### Deskripsi Aplikasi

**AllThingsAthletic** adalah platform yang berperan sebagai sumber informasi bagi orang-orang yang ingin mencari produk alat olahraga di kota Jakarta. Aplikasi ini menyediakan informasi yang memuat deskripsi detail, toko-toko yang menjual, rata-rata harga, review dan rating dari pengguna lain, serta artikel edukatif seputar olahraga. Melalui aplikasi ini, pengguna dapat mengetahui keberadaan produk alat olahraga di Jakarta, serta melakukan riset produk secara mendalam sebelum akhirnya memutuskan untuk membeli produk tersebut.

Aplikasi ini dilengkapi dengan berbagai fitur yang memudahkan pengguna untuk menemukan informasi produk olahraga yang mereka inginkan. Berikut beberapa layanan yang tersedia dalam **AllThingsAthletic**:

- **Katalog (Explore)** menampilkan kumpulan data produk olahraga yang tersedia. Pengguna dapat melihat detail produk, seperti nama, deskripsi, toko yang menjual, rating pengguna lain dan kisaran harga.
- **Review & Rating** memungkinkan pengguna untuk memberikan review dan rating terhadap suatu produk serta memberikan rekomendasi kepada pengguna lain.
- **Article** adalah fitur yang menampilkan informasi berupa artikel edukatif seputar olahraga.

#### Manfaat Aplikasi
- Menyediakan informasi mengenai keberadaan alat produk olahraga di Jakarta.
- Fitur yang memudahkan pengguna untuk mengetahui spesifikasi produk yang diminati.
- Wadah untuk berbagi ulasan (review) dan rating terhadap suatu produk.
- Wadah untuk meningkatkan literasi di bidang olahraga.

### Daftar Modul yang Akan Diimplementasikan
Referensi: aplikasi sociolla, shopee, dan female daily

#### 1. **Sign up or Login**
   - **Sign up/Register**
   Terdapat kolom isi data diri, terdiri dari: 
    - First name and last name (untuk nama pengguna)
    - Username (jika sudah ada uname tsb sebelumnya, maka tidak bisa, harus cari nama baru)
    - Password

   - **Login**
   Terdapat kolom untuk isi data yang sudah diregist sebelumnya
    - Username
    - Password

#### 2. **Navbar**
Navbar pada aplikasi ini akan menampilkan kategori olahraga secara langsung, memudahkan pengguna untuk segera memilih cabang olahraga yang diinginkan dan melihat produk terkait. Setiap kategori olahraga akan diatur sebagai menu utama, memungkinkan pengguna untuk menemukan perlengkapan dan aksesori sesuai kebutuhan olahraga favorit mereka hanya dengan satu klik.

### 3. **Katalog Produk (fitur: Beranda)**
**Pembagian Kerja:**  
- **Aditya Dharma**

- Berisi nama, gambar, dan harga produk.
- Ketika produk diklik, selain nama, gambar, dan harga produk, akan muncul deskripsi dan rating produk.

**CRUD (Create, Read, Update, Delete)**
- **Create (C)**: Toko menambahkan produk baru dengan informasi lengkap.
- **Read (R)**: Pengguna melihat detail produk dan bisa menambahkan ke Favorite atau menghubungi toko.
- **Update (U)**: Toko memperbarui informasi produk, termasuk harga dan deskripsi.
- **Delete (D)**: Toko menghapus produk dari katalog jika tidak lagi dijual.

### 4. **Artikel (fitur: Article)**\
**Pembagian Kerja:**  
- **Shalya Naura Lionita**

- Ketika navbar artikel diklik:
   Pengguna akan diarahkan ke halaman yang menampilkan beberapa artikel yang sudah diposting oleh pengembang aplikasi. Artikel-artikel ini ditampilkan dalam bentuk daftar atau grid, dengan judul, gambar thumbnail, dan deskripsi singkat untuk setiap artikel.

- Ketika salah satu artikel diklik:
   Pengguna akan masuk ke halaman detail artikel yang dipilih. Di halaman ini, pengguna dapat membaca artikel secara lengkap. Informasi yang biasanya ditampilkan mencakup:
   - **Judul Artikel**: Menarik perhatian dan memberikan gambaran topik utama artikel.
   - **Gambar atau Media Pendukung**: Menyertakan gambar, video, atau media lain yang relevan untuk memperjelas isi artikel.
   - **Isi Artikel**: Teks lengkap artikel yang menjelaskan topik secara detail.
   - **Tombol untuk Kembali**: Memudahkan pengguna kembali ke daftar artikel atau melanjutkan membaca artikel terkait lainnya.

#### CRUD pada Fitur Artikel:
- **Create (C)**: Pengembang aplikasi dapat membuat artikel baru yang terkait dengan topik olahraga. Pengembang akan mengisi form yang berisi judul, isi artikel, gambar pendukung, dan kategori artikel. Setelah disimpan, artikel akan muncul di dashboard dan dapat dilihat oleh pengguna.
- **Read (R)**: Pengguna dapat melihat daftar artikel yang tersedia di dashboard. Ketika simbol artikel diklik, pengguna akan melihat beberapa artikel yang sudah diposting. Pengguna dapat mengklik salah satu artikel untuk membaca isi lengkapnya, termasuk detail seperti gambar, tanggal publikasi, dan informasi penulis.
- **Update (U)**: Pengembang aplikasi dapat memperbarui artikel yang sudah ada, misalnya untuk menambahkan informasi terbaru atau mengubah konten agar lebih relevan. Pengembang bisa mengedit artikel melalui form yang memungkinkan perubahan judul, isi, gambar, dan kategori. Setelah disimpan, pembaruan akan langsung terlihat oleh pengguna.
- **Delete (D)**: Pengembang memiliki opsi untuk menghapus artikel yang sudah tidak relevan atau tidak diperlukan lagi dari dashboard. Setelah artikel dihapus, artikel tersebut tidak akan tampil di daftar artikel yang dapat diakses oleh pengguna.

### 5. **Profile (fitur: My Profile)**
**Pembagian Kerja:**  
- **Shafa Amira Azka**

- Berisi informasi terkait pengguna, seperti nama akun dan riwayat review.

#### CRUD pada Fitur My Profile:
- **Create (C)**: Pengguna dapat membuat akun baru dengan mengisi informasi seperti nama dan detail lainnya. Pengguna juga dapat menambahkan review dan rating baru untuk produk yang telah mereka gunakan.
- **Read (R)**: Pengguna dapat melihat data profil mereka, termasuk Nama, riwayat review, dan riwayat rating pada halaman My Profile.
- **Update (U)**: Pengguna dapat memperbarui atau mengedit review dan rating yang sudah mereka buat.
- **Delete (D)**: Pengguna dapat menghapus review dan rating jika tidak lagi relevan.


### 6. **Fitur Search Nama Produk (fitur: Search)**
- Fitur Search memungkinkan pengguna untuk mencari produk berdasarkan nama. Saat pengguna memasukkan kata kunci, aplikasi akan menampilkan hasil pencarian yang relevan beserta detail dasar produk seperti nama, gambar, dan harga.


### 7. **Fitur Rating (fitur: Rate Product)** 
**Pembagian Kerja:**  
- **Amirah Rizkita Setiadji**

- Fitur ini membantu calon pembeli lain dalam menilai kualitas produk berdasarkan pengalaman pengguna lain. Setiap produk dapat diberi rating, yang nantinya akan tampil di halaman produk sebagai acuan bagi pengguna lain.

#### CRUD pada Fitur Rating:
- **Create (C)**: Pengguna memberikan rating dengan memberikan nilai berupa bintang dan/atau komentar.
- **Read (R)**: Pengguna dan calon pembeli dapat melihat rating rata-rata serta ulasan individual pada halaman produk.
- **Update (U)**: Pengguna dapat memperbarui rating yang telah diberikan, misalnya menambah komentar atau mengubah nilai bintang berdasarkan pengalaman baru.
- **Delete (D)**: Pengguna dapat menghapus rating yang telah diberikan, sehingga rating tersebut tidak lagi ditampilkan pada halaman produk.

### **Fitur Review (fitur: Review Product)**
**Pembagian Kerja:**  
- **Anindhyaputri Paramitha**

- Fitur review memungkinkan pengguna untuk memberikan umpan balik mengenai produk yang telah dibeli. Fitur ini membantu calon pembeli untuk memahami pengalaman pengguna lain dan membuat keputusan yang lebih baik saat berbelanja.

#### CRUD pada Fitur Review:
- **Create (C)**: Pengguna dapat menulis dan mengirim review baru untuk suatu produk. Review ini biasanya terdiri dari teks 
dan terdapat beberapa pilihan review yang dapat dipilih
- Materialnya berkualitas
- Warna dan ukuran sesuai
- Pelayanan penjualnya ramah
- Barangnya original
- Harganya terjangkau
Admin tidak memiliki akses untuk membuat review, karena peran admin adalah memoderasi review, bukan memberikan ulasan.
- **Read (R)**: Pengguna dapat melihat semua review yang telah ditulis untuk suatu produk, termasuk nama penulis (username) dan teks review. Untuk review yang ditulis oleh pengguna sendiri, akan ada tanda khusus (misalnya label "Review Saya") agar mudah dikenali. Admin juga dapat melihat semua review dari semua pengguna.
- **Update (U)**: Pengguna hanya bisa mengedit review yang telah mereka buat sendiri. Tombol edit akan tersedia hanya pada review milik pengguna yang sedang login. Review milik pengguna lain tidak dapat diubah. Admin tidak memiliki akses untuk mengedit review, karena hanya pengguna yang dapat mengubah pendapat atau pengalaman mereka sendiri.
- **Delete (D)**: Pengguna hanya bisa menghapus review yang telah mereka buat sendiri. Tombol delete hanya akan muncul pada review milik pengguna yang sedang login. Review milik pengguna lain tidak dapat dihapus. Admin memiliki akses penuh untuk menghapus review dari pengguna lain. Tombol delete tersedia di setiap review, dengan syarat tindakan penghapusan dilakukan untuk menjaga integritas platform, seperti menghapus review spam, ofensif, atau melanggar aturan komunitas.

### Jenis Pengguna (Role)
1. **Admin**
Admin bertanggung jawab untuk memastikan kelengkapan dan keakuratan informasi di aplikasi. Beberapa tugas utama admin meliputi:
   - Pengelolaan informasi (menambahkan, mengedit, dan menghapus informasi).
   - Melihat dan menghapus review dan rating yang diberikan oleh pengguna terhadap suatu produk.

2. **Pengguna (User)**
Pengguna AllThingsAthletic memiliki akses dan kemampuan yang berbeda dengan admin dalam memanfaatkan fitur-fitur aplikasi. Beberapa hal yang bisa dilakukan oleh pengguna meliputi:
   - Mengakses informasi produk olahraga berdasarkan filter kategori.
   - Memberikan dan melihat review dan rating terhadap suatu produk.
   - Mengakses informasi seputar olahraga melalui artikel edukatif.

## **Integrasi dengan Web Service**  
Pengintegrasian web service dan aplikasi web dilakukan dengan cara:
1. Menggunakan library http untuk menghubungkan aplikasi mobile dengan aplikasi web dengan pengiriman request.
2. Memanfaatkan library pbp_django_auth untuk mengelola cookie dan juga untuk memastikan tiap request yang dikirim ke server sudah terautentikasi dan terotorisasi.
3. Membuat model sesuai dengan respons JSON dari web service serta menggunakan QuickType untuk membantu pembuatan models dari app dengan mengubah data JSON menjadi Dart.
4. Di aplikasi Flutter, menggunakan FutureBuilder untuk menampilkan data melalui FutureBuilder dengan sebelumnya memastikan data telah dikonversi ke model yang sesuai.

### Tautan Deployment Aplikasi
[AllThingsAthletic](http://pbp.cs.ui.ac.id/amirah.setiadji/allthingsathletic)