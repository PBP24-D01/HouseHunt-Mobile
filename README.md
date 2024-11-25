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
Memasang rumah untuk dilelang dan menghapus rumah dari daftar lelang jika belum waktu lelang | Mengikuti lelang dengan menaikan harga bid dan berebut dengan pembeli lain

#### Authentifikasi

##### Dikerjakan oleh: Tristan Agra Yudhistira (2306245112)

Modul ini berfungsi untuk user dapat register dan login. Nantinya akan ada super user yang diberi role sabagai penjual untuk dapat menambahkan rumah, meng-update status pesanan, serta membalas diskusi pembeli.

### Role User

Terdapat dua role, yaitu pembeli dan penjual. Untuk peran apa saja yang bisa dilakukan keduanya, sudah dijelaskan di atas.

### Alur pengintegrasian dengan aplikasi web
1. Menyelaraskan tampilan pada *mobile app* dengan *web app*
2. Menggunakan library `pbp_django_auth` untuk mendukung fungsi autentikasi berbasis cookie, seperti login, logout, dan postJson
3. Mengimplementasikan Django REST API untuk mensikronisasi data pada *web app* dan *mobile app* dengan memanfaatkan format JSON
4. Melakukan integrasi antara front-end dan back-end dengan asynchronous HTTP

<details>
<summary>
    ### Alur Pengintegrasian dengan Aplikasi Flutter untuk Modul Cek Rumah
</summary>

#### **1. Menyelaraskan Tampilan**
Tampilan *mobile app* diselaraskan dengan *web app* agar konsisten. Elemen UI seperti warna, font, dan tata letak dibuat seragam untuk pengalaman pengguna yang sama. Misalnya seperti, bagaimana penyajian `Appointment` dan `Availability` untuk `seller`.

#### **2. Menggunakan Library `pbp_django_auth`**
Library `pbp_django_auth` mempermudah autentikasi berbasis cookie. Cookie menyimpan sesi pengguna untuk login, logout, dan pengiriman data JSON (*postJson*), memastikan setiap request terautentikasi.

##### **Contoh:**
```dart
final request = context.watch<CookieRequest>();
final response = await request.get('http://localhost:8000/cekrumah/json');  // contoh jika dari localhost
```

#### **3. Menggunakan Django REST API**
Django REST API bertindak sebagai perantara untuk sinkronisasi data antara web app dan mobile app dalam format JSON.
GET Request: Mengambil data dari server.
POST Request: Mengirim data pengguna ke server.

#### **4. Proses Request dari Flutter**
Fetch Data (GET Request):
Flutter mengirim HTTP GET dengan cookie autentikasi.
Server memvalidasi cookie, mengambil data, dan merespons JSON.
Flutter menampilkan data di UI.

Ilustrasi Fetch Data:
Flutter App  ->  GET Request  ->  Django Server
Flutter App  <-  JSON Response <-  Django Server

Post Data (POST Request):
Flutter mengirim HTTP POST dengan data pengguna.
Server memvalidasi data, menyimpan ke database, dan merespons status.
Flutter menampilkan respon ke pengguna.

Ilustrasi Post Data:
Flutter App  ->  POST Request ->  Django Server
Flutter App  <-  Response     <-  Django Server

#### **5. Pentingnya CookieRequest**
CookieRequest mengelola sesi pengguna secara otomatis:
Menyisipkan cookie ke setiap permintaan.
Memastikan pengguna tetap terautentikasi tanpa login ulang.
Digunakan di semua komponen aplikasi untuk menjaga konsistensi.

#### **6. Feedback ke Pengguna**
Berhasil: Data baru ditampilkan di UI.
Gagal: Pesan error ditampilkan, seperti masalah jaringan atau autentikasi.
Contoh:
```dart
ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Gagal menghubungi server.')),
);
```
</details>
