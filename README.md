# Tugas Kelompok D-01

## HouseHunt Mobile App

### Anggota Kelompok

- Tristan Agra Yudhistira (2306245112)
- Daffa Naufal Rahadian (2306213003)
- Siti Shofi Nadhifa (2306152172)
- Favian Zhafif Rizqullah Permana (2306274996)
- Muhammad Fayyed As Shidqi (2306230395)
- M. Alvin Rheinaldy G. Z. (2306275866)

### Deskripsi Aplikasi

Aplikasi ini bernama HouseHunt. Aplikasi ini bertujuan membantu masyarakat, baik penduduk lokal maupun pendatang, untuk menemukan informasi seputar rumah yang dijual di Bekasi. Ketika seseorang pindah atau berencana membeli rumah di Bekasi, sering kali mereka kesulitan mendapatkan informasi lengkap tentang harga, lokasi, dan detail properti dari berbagai sumber yang terpecah-pecah. Dengan HouseHunt, pengguna dapat mengakses database lengkap yang berisi daftar harga rumah di berbagai wilayah Bekasi beserta detail seperti luas bangunan, tipe rumah, jumlah kamar, dan harga.

Aplikasi ini memberikan keuntungan dengan menyediakan semua informasi dalam satu tempat yang mudah diakses, membantu pengguna membuat keputusan yang lebih baik tentang pembelian rumah. Selain itu, aplikasi ini mendukung pencarian berdasarkan kriteria spesifik seperti harga maksimal, luas tanah, atau lokasi, sehingga pengguna dapat dengan mudah menemukan rumah sesuai dengan kebutuhan mereka.

Fitur - fitur yang akan ada di HouseHunt:

- Menampilkan daftar rumah dan filter
- Menampilkan detail spesifikasi rumah
- Wishlist menu yang berisi rumah - rumah yang ingin dibeli
- Melakukan pemesanan rumah secara online
- Melakukan appointment untuk bertemu dengan penjual
- Mempromosikan rumah dengan iklan

### Daftar Modul

#### Rumah

##### Dikerjakan oleh: M. Alvin Rheinaldy G. Z. (2306275866)

Modul ini berfungsi untuk menampilkan rumah - rumah yang akan dijual. User juga dapat melakukan filter dan search sesuai yang diinginkan.
Pembeli|Penjual
-|-
Pembeli dapat memesan dan melihat rumah yang sedang dijual | CRUD rumah untuk dijual

#### Wishlist

##### Dikerjakan oleh: Siti Shofi Nadhifa (2306152172)

Modul ini berfungsi untuk user dapat menambahkan wishlist rumah yang ingin dibeli dan dapat menampilkan rumah - rumah yang ada di wishlist user.
Pembeli | Penjual
-|-
Pembeli dapat menambahkan wishlist dan melihat rumah apa saja yang sudah ada di wishlist | -

#### Diskusi

##### Dikerjakan oleh: Muhammad Fayyed As Shidqi (2306230395)

Modul ini berfungsi untuk pembeli dapat menanyakan pertanyaan kepada penjual
Pembeli | Penjual
-|-
Mengepost diskusi pada halaman detail rumah | Membalas diskusi pada halaman detail rumah

#### Cek Rumah

##### Dikerjakan oleh: Daffa Naufal Rahadian (2306213003)

Modul ini berfungsi untuk membuat appointment antara pembeli dan penjual untuk melakukan pengecekan secara offline. Nantinya pembeli dapat memilih tanggal sesuai yang sudah penjual sediakan. Pembeli dan penjual juga dapat membatalkan dan mengedit tanggal appointment yang diinginkan.
Pembeli | Penjual
-|-
Memilih appointment dan membuat appointment | Membuat kapan saja appointment dapat dilakukan dan menyetujui appointment yang dibuat oleh pembeli

#### Iklan

##### Dikerjakan oleh: Favian Zhafif Rizqullah Permana (2306274996)

Modul ini berfungsi untuk seller memasang iklan di halaman web. Nantinya seller dapat memilih rumah mana yang mau diiklankan di halaman web. Iklan akan lebih dipertontonkan dibandingkan rumah yang tidak diiklankan. Seller dapat mengedit rumah mana yang diiklankan kapan saja dan seller dapat meng-upload banner untuk kebutuhan iklan.
Pembeli | Penjual
-|-
Melihat iklan | Membuat, mengedit, menghapus iklan

#### Lelang

##### Dikerjakan oleh: Tristan Agra Yudhistira (2306245112)

Modul ini berfungsi untuk seller melelang rumahnya. Nantinya pembeli dapat menaikan harga bid dan berebut dengan pembeli yang lainnya. Rumah yang sedang dilelang dapat dihapus dari daftar lelang jika belum memasuki waktu lelang. Rumah yang dilelang tidak bisa dijual karena statusnya onAuction.
Pembeli | Penjual
-|-
Mengikuti lelang dengan menaikan harga bid dan berebut dengan pembeli lain  | Memasang rumah untuk dilelang dan menghapus rumah dari daftar lelang jika belum waktu lelang 

#### Authentifikasi

##### Dikerjakan oleh: Tristan Agra Yudhistira (2306245112)

Modul ini berfungsi untuk user dapat register dan login. Nantinya akan ada super user yang diberi role sabagai penjual untuk dapat menambahkan rumah, meng-update status pesanan, serta membalas diskusi pembeli.

### Role User

Terdapat dua role, yaitu pembeli dan penjual. Untuk peran apa saja yang bisa dilakukan keduanya, sudah dijelaskan di atas. Berikut tampilan secara diagram:
![HouseHuntFlow](https://github.com/user-attachments/assets/48d2a50e-85ad-476d-ab8a-3376fca46692)

### Alur pengintegrasian dengan *web service* untuk terhubung dengan aplikasi web yang sudah dibuat saat Proyek Tengah Semester
Pada proyek Django:
1. Melakukan instalasi Django CORS Headers dengan menjalankan `pip install django-cors-headers` untuk menangani permintaan CORS dan menambahkan `corsheaders` ke `INSTALLED_APPS` dan `MIDDLEWARE`.
2. Menambahkan konfigurasi CORS pada `settings.py`.
    ```python
    CORS_ALLOW_ALL_ORIGINS = True
    CORS_ALLOW_CREDENTIALS = True
    CSRF_COOKIE_SECURE = True
    SESSION_COOKIE_SECURE = True
    CSRF_COOKIE_SAMESITE = 'None'
    SESSION_COOKIE_SAMESITE = 'None'
    ```
3. Menambahkan aplikasi `authentication` yang menangani dan memproses endpoint login dan register.
Pada proyek Flutter:
1. Melakukan instalasi terhadap library yang dibutuhkan.
    ```bash
    flutter pub add provider
    flutter pub add pbp_django_auth
    flutter pub add http
    ```
2. Memodifikasi berkas pada proyek Flutter untuk menyediakan `CookieRequest` ke seluruh aplikasi menggunakan `Provider`.
3. Membuat halaman `login.dart` untuk menangani input user dan autentikasi menggunakan `pbp_django_auth`.
4. Membuat halaman `register.dart` untuk mendaftarkan user baru melalui endpoint Django. Validasi input user dilakukan dengan memberikan umpan balik langsung pada sisi Flutter dan keamanan tambahan pada sisi Django

![/alur-integrasi/](/img/AlurIntegrasiDjangodanFlutter.png)
Alur pengintegrasian request dan response pada Flutter:
1. Flutter mengirimkan HTTP request ke Django melalui endpoint yang disediakan (`api/resource/`).
    `GET`: Mengambil data dari server.
    `POST`: Mengirim data baru ke server.
    `PUT` atau `PATCH`: Memperbarui data yang sudah ada.
    `DELETE`: Menghapus data di server.
    Contoh:
    ```dart
    final request = context.watch<CookieRequest>();
    final response = await request.get('http://localhost:8000/cekrumah/json');  // contoh jika dari localhost
    ```
2. Django menerima permintaan melalui endpoint yang sesuai ( `/api/resource/`).
3. Django akan memvalidasi autentikasi dan CORS.
4. View (views.py) akan menangani request dan mengolah data dari request.
5. Django akan mengakses model (models.py) jika diperlukan untuk membaca, membuat, memperbarui, atau menghapus data.
6. Django akan mengirimkan HTTP response ke Flutter yang berisi status code dan data dalam format JSON.
7. Flutter menerima respons dari Django dan memprosesnya.
    - Flutter akan menampilkan data jika respons berupa data dengan menampilkannya di UI.
    - Flutter akan menangani error dengan mengembalikan umpan balik berupa pesan error atau dialog.
    - Flutter akan memperbarui state.
