# all_things_athletic_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# **AllThingsAthletic-Mobile**

## **1. Daftar Anggota Kelompok**
- **Anindhyaputri Paramitha** (2306218111)  
- **Aditya Dharma** (2306240074)  
- **Amirah Rizkita Setiadji** (2306275235)  
- **Shafa Amira Azka** (2306214025)  
- **Shalya Naura Lionita** (2306245535)  

---

## **2. Deskripsi Aplikasi**

### **Nama Aplikasi**:  
**AllThingsAthletic**  

### **Fungsi Aplikasi**:  
AllThingsAthletic adalah platform yang berperan sebagai sumber informasi bagi masyarakat yang mencari produk alat olahraga di kota Jakarta. Aplikasi ini membantu pengguna melakukan riset produk secara mendalam sebelum membeli melalui fitur-fitur berikut:  

- **Katalog Produk (Explore):** Menyediakan detail produk seperti deskripsi, harga, rating, dan toko penjual.  
- **Review & Rating:** Wadah untuk berbagi ulasan dan rekomendasi produk.  
- **Artikel:** Artikel edukatif tentang olahraga.  

### **Manfaat Aplikasi**:  
- Menyediakan informasi keberadaan alat olahraga di Jakarta.  
- Mempermudah pengguna mengetahui spesifikasi produk.  
- Menjadi wadah berbagi ulasan dan meningkatkan literasi di bidang olahraga.  

---

## **3. Daftar Modul dan Pembagian Kerja**

### **1. Sign Up/Login**
**Deskripsi Fitur:**  
- **Sign Up:** Pengguna dapat mendaftar dengan nama, username (unik), dan password.  
- **Login:** Pengguna masuk dengan username dan password yang telah terdaftar.  

**Pembagian Kerja:**  
- **[Nama Anggota]**

### **2. Navbar**
**Deskripsi Fitur:**  
Navbar menyediakan kategori olahraga untuk memudahkan pencarian produk terkait.  

**Pembagian Kerja:**  
- **[Nama Anggota]**

### **3. Katalog Produk**
**Fitur:**  
- **Read:** Melihat detail produk (nama, gambar, harga, deskripsi, rating).  
- **Create:** Menambahkan produk baru.  
- **Update:** Memperbarui informasi produk.  
- **Delete:** Menghapus produk.  

**Pembagian Kerja:**  
- **[Nama Anggota]**

### **4. Artikel**
**Fitur:**  
- **Read:** Melihat artikel edukatif tentang olahraga.  
- **Create:** Menulis artikel baru.  
- **Update:** Mengedit artikel.  
- **Delete:** Menghapus artikel.  

**Pembagian Kerja:**  
- **[Nama Anggota]**

### **5. My Profile**
**Fitur:**  
- Menampilkan nama akun dan riwayat review.  
- CRUD pada review dan rating.  

**Pembagian Kerja:**  
- **[Nama Anggota]**

### **6. Search Produk**
**Deskripsi Fitur:**  
Fitur pencarian produk berdasarkan nama atau kata kunci.  

**Pembagian Kerja:**  
- **[Nama Anggota]**

### **7. Review & Rating**
**Fitur:**  
- Pengguna dapat menulis review, memberikan rating, serta mengedit atau menghapusnya.  

**Pembagian Kerja:**  
- **[Nama Anggota]**

---

## **4. Peran Pengguna Aplikasi**

### **1. Admin**
Tugas:  
- Mengelola data produk (CRUD).  
- Mengelola artikel (CRUD).  
- Melihat dan menghapus review serta rating.  

### **2. Pengguna**
Tugas:  
- Mencari dan melihat informasi produk olahraga.  
- Memberikan review dan rating produk.  
- Mengakses artikel edukatif tentang olahraga.  

---

## **5. Integrasi dengan Web Service**  
Berikut adalah penjelasan penting dan rinci mengenai proses **fetching data dari internet** di Flutter berdasarkan dokumentasi yang disediakan:

---

## *1. Menambahkan Paket `http`*
Paket `http` adalah cara termudah untuk melakukan request data dari internet di Flutter.

### Langkah:
1. Tambahkan dependensi dengan perintah:
   ```bash
   flutter pub add http
   ```
2. Import paket dalam kode:
   
3. **Izinkan akses internet**:
   - **Android**: Tambahkan izin di `AndroidManifest.xml`:
     ```xml
     <uses-permission android:name="android.permission.INTERNET" />
     ```
   - **macOS**: Tambahkan entri di file `DebugProfile.entitlements` dan `Release.entitlements`:
     ```xml
     <key>com.apple.security.network.client</key>
     <true/>
     ```

---

## *2. Membuat Network Request*
Gunakan metode `http.get()` untuk mengambil data dari URL tertentu. Berikut contoh request untuk mendapatkan data **album** dari [JSONPlaceholder](https://jsonplaceholder.typicode.com).

### Penjelasan:
- **`Future`**: Objek yang mewakili operasi asinkron, memberikan nilai atau error di masa depan.
- **`http.Response`**: Objek yang berisi data dari server setelah request berhasil.

---

## *3. Mengonversi Response Menjadi Objek Dart*
Untuk mempermudah manipulasi data, ubah respons JSON menjadi objek Dart.

### *Langkah:*
1. **Membuat kelas `Album`**:

2. **Mengupdate `fetchAlbum` untuk mengembalikan `Future<Album>`**:

---

## *4. Mengambil Data di Aplikasi*
Panggil metode `fetchAlbum` dalam `initState` agar data hanya diambil sekali saat widget pertama kali dibuat.

---

## *5. Menampilkan Data*
Gunakan widget `FutureBuilder` untuk menampilkan data di layar, bergantung pada status `Future`:
- **Sedang Loading**: Tampilkan spinner (`CircularProgressIndicator`).
- **Berhasil**: Tampilkan data.
- **Error**: Tampilkan pesan kesalahan.

---

## *Mengapa `fetchAlbum` Dipanggil di `initState`?*
Menempatkan panggilan API di `build()` **tidak disarankan** karena metode ini dipanggil berkali-kali saat tampilan diperbarui, yang menyebabkan request berulang. Dengan menyimpannya di `initState`, request hanya dilakukan sekali dan hasilnya di-cache.

---
