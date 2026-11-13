# KosFinder - Mamikos Mobile Mini Project (UTS Pemrograman Mobile)

[![Flutter](https://img.shields.io/badge/Flutter-3.47.3-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.3-0175C2?logo=dart)](https://dart.dev)
[![State Management](https://img.shields.io/badge/Provider-6.1.2-brightgreen)](https://pub.dev/packages/provider)
[![Backend](https://img.shields.io/badge/Database-Supabase%20%2F%20PostgreSQL-3ECF8E?logo=supabase)](https://supabase.com)
[![Status](https://img.shields.io/badge/UTS-100%25%20Complete-success)]()

Aplikasi mobile pencarian dan manajemen catatan kos berbasis Flutter yang terinspirasi dari antarmuka modern **Mamikos**. Project ini dikembangkan sebagai pemenuhan **Ujian Tengah Semester (UTS)** mata kuliah **Pemrograman Mobile** dengan menerapkan arsitektur modular yang rapi (*Clean Architecture*), *State Management Provider*, konsumsi *REST API*, serta *Database CRUD* (Supabase).

---

## Identitas Mahasiswa & Pengumpulan UTS

| Informasi | Keterangan |
| :--- | :--- |
| **Nama Mahasiswa** | **Jack Rich Loro** |
| **NIM** | **2415051101** |
| **Kelas / Program Studi** | Pendidikan Teknik Informatika (PTI)  |
| **Universitas** | Universitas Pendidikan Ganesha (Undiksha) |
| **Mata Kuliah** | Pemrograman Mobile |
| **Dosen Pengampu** | Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom |
| **Teaching Assistant** | Made Yuda Sadewa, S.Pd. |
| **Tema Project** | **KosFinder** (Mamikos-Style Finder) |
| **Repository GitHub** | [https://github.com/kepalarusa2022-sketch/uts_2415051101_jack_rich_loro](https://github.com/kepalarusa2022-sketch/uts_2415051101_jack_rich_loro) |
| **Branch Utama** | `main` |
| **File APK UTS** | `UTS_2415051101_Jack_Rich_Loro.apk` |

---

## Ringkasan Fitur Aplikasi

1. **Dashboard / Explore Screen (Mamikos-Style UI)**:
   - Header hijau khas Mamikos dengan logo `mamikos.com`, avatar pengguna, dan notifikasi badge (99+).
   - Headline pencarian *"Kamu mau ngekos dimana ?"*.
   - Kotak pencarian rounded interaktif.
   - Banner promo carousel (*"Pesan Kost Lewat Booking di KosFinder - Diskon Rp 50K - Kode Voucher: BISABOOKING"*) dengan pagination dots.
   - Menu kategori interaktif: *Kamar Kos*, *Apartemen*, *Barang & Jasa*, *Pekerjaan*.
   - Section *Mamirooms* (koleksi kamar eksklusif dengan horizontal card slider).
   - Section kota terpopuler: *Yogyakarta*, *Jabodetabek*, *Bali*, *Surabaya*, *Bandung*.
2. **Katalog Kos (List / Grid Screen Responsif)**:
   - Pencarian realtime berdasarkan nama kos, alamat, atau kota.
   - Filter cepat berdasarkan gender (*Semua*, *Campur*, *Putri*, *Putra*).
   - Filter modal bottom sheet untuk memilih wilayah/kota dan tipe kos.
   - Layout responsif otomatis: 2 kolom pada smartphone (<600px) dan 3–4 kolom pada layar tablet/desktop (>=600px).
   - State handling lengkap: *Loading skeleton/spinner*, *Error state* dengan tombol *Coba Lagi*, serta *Empty state* jika data tidak ditemukan.
3. **Detail Kos Lengkap (Passing Data)**:
   - Header slider galeri foto kamar.
   - Badge status: *Bisa Booking*, tipe (*Campur/Putri/Putra*), dan rating bintang.
   - Informasi spesifikasi kamar: ukuran kamar (misal `3 x 4 m`), status listrik (termasuk/token), dan tipe kamar mandi.
   - Fasilitas populer: AC, WiFi Cepat, Kasur Springbed, Meja Belajar, Parkir Luas, dll.
   - Peraturan khusus kos dan informasi pemilik/pengelola terverifikasi.
   - Tombol *Floating Action* untuk menghubungi pemilik via dialog chat / telepon dan tombol simpan catatan ke database.
4. **Formulir Tambah Catatan Kos (Database CREATE)**:
   - Form input dengan validasi (`Form` & `GlobalKey<FormState>`).
   - Validasi catatan pribadi minimal 5 karakter.
   - 4 bentuk interaksi pengguna: *Text input*, *Interactive Star Rating (1–5)*, *Dropdown Status Rencana*, dan *Date Picker Dialog*.
   - Menyimpan personal review/rencana survei langsung ke database Supabase.
5. **Wishlist & Manajemen Catatan (Database READ & DELETE)**:
   - Menampilkan daftar kos favorit dan catatan pribadi yang tersimpan di database.
   - Filter status: *Semua*, *Rencana Survei*, *Sudah Disurvei*, *Booking Sukses*.
   - Operasi *Delete* dengan konfirmasi dialog pengamanan (*AlertDialog confirmation*).
   - Feedback responsif via `SnackBar`.
6. **Formulir Edit Catatan Kos (Database UPDATE)**:
   - Memperbarui catatan pribadi, perubahan rating prioritas, status survei/booking, dan tanggal masuk.
   - Validasi formulir sebelum data di-commit ke database.
7. **Profil Mahasiswa & Dokumen UTS**:
   - Menampilkan identitas lengkap mahasiswa (Jack Rich Loro, 2415051101).
   - Statistik data personal (katalog kos aktif, total disimpan, kota terjangkau).
   - Informasi mata kuliah, dosen pengampu, dan asisten dosen.
   - Fitur sinkronisasi data manual (trigger API & database reload).
8. **Live Chat Helpdesk & Pengelola**:
   - Simulasi percakapan realtime dengan customer care KosFinder dan pemilik kos.
9. **Formulir Tambah & Edit Kos Baru (Katalog & Listing CRUD)**:
   - Formulir lengkap untuk mempublikasikan kos baru ke katalog atau mengedit informasi listing kos (nama, tipe, harga sewa, alamat, kota, fasilitas, ukuran kamar, gambar, deskripsi, dan kontak pengelola).
   - Tombol akses cepat: Floating Action Button di Home dan Katalog, tombol di header AppBar, serta tombol "Edit Informasi Kos Ini" pada layar Detail Kos.

---

##  Struktur Arsitektur Aplikasi (Separation of Concerns)

Project mengimplementasikan arsitektur berjenjang yang memisahkan tampilan, state management, repository, dan sumber data:

```
lib/
├── models/
│   ├── kos_model.dart            # Model data katalog kos & serialisasi JSON
│   └── saved_kos_model.dart      # Model data database (saved_kos) & mapping CRUD
├── services/
│   ├── kos_api_service.dart      # HTTP GET client ke REST API dengan fallback aman
│   └── database_service.dart     # Service backend database Supabase (CRUD) & local sync
├── repositories/
│   └── kos_repository.dart       # Abstraksi repositori penghubung UI/Provider dan Data Source
├── providers/
│   └── kos_provider.dart         # State management (Provider + ChangeNotifier)
├── widgets/
│   ├── banner_slider.dart        # Reusable promo slider banner
│   ├── category_item.dart        # Reusable icon kategori
│   ├── city_card.dart            # Reusable card kota populer
│   ├── custom_search_bar.dart    # Reusable search bar bergaya modern
│   ├── empty_state_widget.dart   # Reusable empty state view
│   ├── error_state_widget.dart   # Reusable error state view dengan tombol coba lagi
│   ├── kos_card.dart             # Reusable card kos responsif dengan tombol love
│   └── status_badge.dart         # Reusable badge tag (booking, campur, putri, putra)
├── screens/
│   ├── main_navigation_screen.dart # Navigasi utama BottomNavigationBar (4 tab)
│   ├── home_screen.dart          # Layar Dashboard / Explore (Sesuai foto desain)
│   ├── kos_list_screen.dart      # Layar Katalog & Pencarian Kos (Sesuai foto desain)
│   ├── kos_detail_screen.dart    # Layar Detail Kos dengan passing data
│   ├── add_edit_kos_screen.dart  # Layar Tambah & Edit Kos ke Katalog
│   ├── add_saved_kos_screen.dart # Layar Form Tambah Catatan (Create)
│   ├── edit_saved_kos_screen.dart# Layar Form Edit Catatan (Update)
│   ├── saved_kos_screen.dart     # Layar Wishlist & Catatan Database (Read & Delete)
│   ├── profile_screen.dart       # Layar Profil Mahasiswa & Informasi UTS
│   └── chat_screen.dart          # Layar Chat Simulasi Pengelola
└── main.dart                     # Entry point inisialisasi Supabase, Provider & Theme
```

### Prinsip Aliran Data:
$$\text{UI (Screens \& Widgets)} \longrightarrow \text{State Management (KosProvider)} \longrightarrow \text{KosRepository} \longrightarrow \text{Services (API / DB)} \longrightarrow \text{REST API / Supabase}$$

Screen tidak pernah melakukan HTTP query atau database query secara langsung, menjaga kode tetap bersih, mudah diuji, dan memenuhi standar arsitektur UTS.

---

## Integrasi REST API

- **Metode HTTP**: `GET`
- **Fungsi**: Mengambil katalog listing kos, rekomendasi kamar, harga, fasilitas, dan detail lokasi wilayah.
- **Handling**:
  - Konversi otomatis dari response JSON ke `KosModel` via `KosModel.fromJson()`.
  - Fallback otomatis ke dataset lokal (`assets/data/kos_data.json`) jika perangkat dalam kondisi offline atau jaringan timeout, memastikan demo di depan dosen penguji tetap berjalan mulus tanpa kendala.
  - Penanganan state lengkap: *loading*, *error*, dan *empty*.

---

## Backend & Database (Supabase PostgreSQL)

- **Database**: Supabase / PostgreSQL.
- **Tabel Utama**: `saved_kos`
- **Skema Kolom Data**:
  | Kolom | Tipe Data | Deskripsi |
  | :--- | :--- | :--- |
  | `id` | `VARCHAR` (Primary Key) | ID unik catatan kos |
  | `student_id` | `VARCHAR` | NIM Mahasiswa (`2415051101`) |
  | `kos_id` | `VARCHAR` | Relasi ID kos yang disimpan |
  | `kos_name` | `VARCHAR` | Nama kos |
  | `kos_price` | `INTEGER` | Harga sewa per bulan |
  | `kos_type` | `VARCHAR` | Tipe kos (`Campur`, `Putri`, `Putra`) |
  | `kos_address` | `TEXT` | Alamat lengkap kos |
  | `kos_image` | `TEXT` | URL gambar kos |
  | `note` | `TEXT` | Catatan pribadi mahasiswa / hasil survei |
  | `rating` | `DOUBLE` | Rating prioritas pilihan (1.0 – 5.0) |
  | `status` | `VARCHAR` | Status (`Rencana Survei`, `Sudah Disurvei`, `Booking Sukses`) |
  | `visit_date` | `VARCHAR` | Target tanggal kunjungan / survei |
  | `created_at` | `TIMESTAMP` | Waktu pencatatan |

- **Operasi CRUD Lengkap**:
  - **Create**: Dilakukan melalui formulir di `add_saved_kos_screen.dart`.
  - **Read**: Ditampilkan dan difilter pada `saved_kos_screen.dart`.
  - **Update**: Diedit melalui formulir validasi di `edit_saved_kos_screen.dart`.
  - **Delete**: Dihapus dengan konfirmasi pengamanan dialog `AlertDialog` di `saved_kos_screen.dart`.
  - Dilengkapi mekanisme *local cache synchronizer* sehingga operasi CRUD tetap dapat dicoba secara instan meskipun belum terhubung internet.

---

## Minimum Requirement Checklist (Kesesuaian Spesifikasi UTS)

| Komponen | Spesifikasi Minimum | Implementasi pada KosFinder | Status |
| :--- | :--- | :--- | :---: |
| **Screen Fungsional** | Minimal 6 screen | 9 screen fungsional (Home, Catalog, Detail, Add/Edit Kos, Add Note, Edit Note, Wishlist, Profile, Chat) | ✅ Terpenuhi |
| **Dart Model** | Minimal 2 model | `KosModel` dan `SavedKosModel` dengan serialisasi JSON lengkap | ✅ Terpenuhi |
| **Reusable Widget** | Minimal 3 custom widget | 8 widget kustom (`KosCard`, `CustomSearchBar`, `CategoryItem`, `CityCard`, `StatusBadge`, `BannerSlider`, `EmptyStateWidget`, `ErrorStateWidget`) | ✅ Terpenuhi |
| **Responsive Layout** | Minimal 2 kondisi | Compact (<600px) 2 kolom grid, Wide (>=600px) 4 kolom grid & side-by-side detail | ✅ Terpenuhi |
| **REST API** | Minimal 1 REST API (GET) | Integrasi HTTP GET katalog kos dengan parsing JSON dan fallback | ✅ Terpenuhi |
| **Backend Database** | Minimal 1 database | Supabase / PostgreSQL table `saved_kos` dengan local synchronizer | ✅ Terpenuhi |
| **Field Tabel** | ID + minimal 4 field | 13 field data lengkap (`id`, `student_id`, `kos_id`, `kos_name`, `kos_price`, dll.) | ✅ Terpenuhi |
| **CRUD Database** | 4 operasi (C-R-U-D) | Create, Read, Update, Delete (dengan dialog konfirmasi) | ✅ Terpenuhi |
| **State Management** | Provider / ekuivalen | `Provider` + `ChangeNotifier` dengan shared state favorit & filter | ✅ Terpenuhi |
| **Navigasi Multi-Screen** | Wajib | BottomNavigationBar (4 tab) + Navigasi list ke detail + modal bottom sheet | ✅ Terpenuhi |
| **Passing Data** | Wajib | Passing objek `KosModel` dan `SavedKosModel` antar layar | ✅ Terpenuhi |
| **Form & Validasi** | Form + validasi | Validasi nama kos, catatan minimal 5 karakter, rating, status, & date | ✅ Terpenuhi |
| **User Feedback** | Dialog / SnackBar | SnackBar feedback berhasil/gagal, AlertDialog konfirmasi hapus, call dialog | ✅ Terpenuhi |
| **Handling State** | Loading, Error, Empty | Indikator loading, tampilan error dengan retry, dan tampilan data kosong | ✅ Terpenuhi |
| **Git Commits** | Minimal 16 meaningful commits | Riwayat commit bertahap mencakup seluruh milestone UTS | ✅ Terpenuhi |

---

## Cara Menjalankan Project

### Prasyarat:
- Flutter SDK versi 3.13 ke atas (direkomendasikan Flutter 3.24 / 3.47).
- Dart SDK versi 3.13 ke atas.
- Koneksi internet untuk unduhan dependencies pertama kali.

### Langkah-langkah:
1. **Clone repository ini**:
   ```bash
   git clone https://github.com/kepalarusa2022-sketch/uts_2415051101_jack_rich_loro.git
   cd uts_2415051101_jack_rich_loro
   ```

2. **Unduh dependencies paket**:
   ```bash
   flutter pub get
   ```

3. **Verifikasi analisis kode dan unit test**:
   ```bash
   flutter analyze
   flutter test
   ```

4. **Jalankan aplikasi pada emulator atau perangkat fisik**:
   ```bash
   flutter run
   ```

5. **Membangun APK rilis**:
   ```bash
   flutter build apk --release
   ```

---

*Project ini dibuat dan diselesaikan dengan penuh tanggung jawab dan integritas akademik oleh Jack Rich Loro (2415051101) untuk Ujian Tengah Semester Pemrograman Mobile.*
