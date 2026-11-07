# PROJECT UJIAN TENGAH SEMESTER
## PEMROGRAMAN MOBILE
### Mobile Application Mini Project
**Implementasi Git, Dart, Flutter UI, Responsive Layout, Navigation, State Management, Architecture, REST API, Backend, dan Database**

---

| Identitas | Keterangan |
| :--- | :--- |
| **Nama** | **Jack Rich Loro** |
| **NIM** | **2415051101** |
| **Kelas** | **3A** |
| **Tema Project** | **KosFinder (Pencarian & Manajemen Kos Modern - Mamikos Inspired)** |
| **URL GitHub** | **https://github.com/kepalarusa2022-sketch/uts_2415051101_jack_rich_loro** |

* **Sifat:** Individual  
* **Durasi:** 2 Minggu  
* **Tema:** Bebas (KosFinder)  
* **Dosen Pengampu:** Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom  
* **Teaching Assistant:** Made Yuda Sadewa, S.Pd.  

---

## A. Deskripsi Penugasan
Project UTS merupakan tugas individual untuk membangun satu aplikasi mobile Flutter yang mengintegrasikan kompetensi dari Worksheet 1–7. Mahasiswa bebas menentukan tema aplikasi, tetapi aplikasi harus memenuhi spesifikasi minimum teknis dan menunjukkan proses pengembangan yang nyata melalui Git/GitHub.

> **Fokus penilaian:** Project dinilai dari kualitas UI, kelengkapan widget, struktur kode, state management, arsitektur aplikasi (Separation of Concerns), integrasi REST API & cloud database Supabase, penanganan error (loading/error/empty state), serta konsistensi proses pengembangan bertahap pada Git.

---

## B. Cakupan Materi yang Wajib Terintegrasi

| Materi | Implementasi pada Project KosFinder |
| :--- | :--- |
| **Git & GitHub** | Repository publik aktif, branch `main`, 49 meaningful commits bertahap sesuai milestone Worksheet 1–7, file `.gitignore`, dan dokumentasi `README.md` komprehensif. |
| **Dart Fundamentals** | Model OOP bertipe ketat (`KosModel`, `SavedKosModel`), serialization/deserialization JSON (`fromJson`, `toJson`), null safety, `Future`, `async`/`await`, exception handling (`try-catch`). |
| **Flutter UI Fundamentals** | Widget tree terstruktur: `Scaffold`, `AppBar`, `Card`, `Container`, `Row`, `Column`, `ListView`, `GridView.builder`, custom badges, tema hijau modern Mamikos (`#1BAA56`). |
| **Responsive Layout** | Menggunakan `LayoutBuilder` dan `MediaQuery` dengan 2 breakpoint layout: **Compact** (Mobile < 600px: 2 kolom grid) dan **Wide** (Web/Tablet ≥ 600px: 4 kolom grid & split-screen detail). |
| **Navigation & User Interaction** | `BottomNavigationBar` (4 tab: Explore, Wishlist, Chat, Profil), navigasi antar-layar dengan `Navigator.push`, passing data model lengkap, validasi form, serta feedback SnackBar & Dialog. |
| **State Management & Architecture** | Provider (`provider: ^6.1.2`) dengan `ChangeNotifier` (`KosProvider`). Arsitektur modular 5 lapis: `UI (Screens/Widgets)` → `Provider` → `Repository` → `Service` → `API / Supabase`. |
| **REST API & Database Integration** | REST GET via `KosApiService` untuk katalog kos, serta cloud database **Supabase (PostgreSQL)** untuk CRUD data personal wishlist/saved kos (`saved_kos` table). |

---

## C. Spesifikasi Minimum Project

### 1. Screen dan Navigasi
* [x] **Minimal 6 screen fungsional (Project KosFinder memiliki 10 screen):**
  1. `HomeScreen`: Dashboard beranda utama dengan search bar Mamikos, promo banner slider carousel, kategori dinamis, rekomendasi Mamirooms, kartu kota, dan banner/FAB Tambah Kos.
  2. `KosListScreen`: Halaman katalog lengkap dengan pencarian realtime, filter chips kota/tipe, grid responsif 2/4 kolom, tombol Tambah Kos, dan tombol Edit di tiap kartu.
  3. `KosDetailScreen`: Detail lengkap kos (foto, harga, fasilitas populer, aturan kos, deskripsi, profil pemilik, sticky top bar "Edit & Tambah", card manajemen, dan bottom booking bar).
  4. `AddEditKosScreen`: Form create & update data katalog kos dengan validasi input.
  5. `AddSavedKosScreen`: Form simpan kos ke database Supabase (catatan survei, rating, status).
  6. `EditSavedKosScreen`: Form edit data survei/catatan kos yang tersimpan di Supabase.
  7. `SavedKosScreen` (Wishlist): Menampilkan data kos tersimpan dari Supabase dengan konfirmasi hapus dialog.
  8. `ProfileScreen`: Profil mahasiswa (Jack Rich Loro - 2415051101), statistik data, spesifikasi UTS, dan tautan repositori.
  9. `ChatScreen`: Simulasi perpesanan dengan pemilik kos dan customer care.
  10. `MainNavigationScreen`: Induk navigasi `BottomNavigationBar` (Explore, Wishlist, Chat, Profil).
* [x] Terdapat navigasi List → Detail dengan passing object `KosModel`.
* [x] Terdapat passing data antar-screen (List ke Detail, Detail ke Form Tambah/Edit).
* [x] Menggunakan `BottomNavigationBar` dengan 4 menu utama berikon Material Design.

### 2. Flutter UI dan Reusable Components
* [x] Menggunakan widget dasar Flutter secara tepat dan modular: `Scaffold`, `AppBar`, `Text`, `Image.network` (dengan fallback aset), `Card`, `Container`, `Row`, `Column`, `Padding`, `SizedBox`, `Expanded`, `Flexible`.
* [x] Menggunakan `GridView.builder` dan `ListView.separated` untuk rendering data dinamis.
* [x] **Minimal 3 reusable/custom widgets (Project KosFinder mengimplementasikan 8 custom widgets di folder `lib/widgets/`):**
  1. `KosCard` (`lib/widgets/kos_card.dart`): Kartu kos modular dengan foto rasio 4:3, badge tipe/booking, judul, rating bintang, harga bulanan, dan tombol Edit.
  2. `CustomSearchBar` (`lib/widgets/custom_search_bar.dart`): Bar pencarian kustom dengan prefix icon, border rounded, dan shadow lembut.
  3. `BannerSlider` (`lib/widgets/banner_slider.dart`): Carousel promo banner dengan indikator dot aktif/inaktif.
  4. `CategoryItemWidget` (`lib/widgets/category_item.dart`): Item kategori interaktif dengan ikon SVG/Material dan label.
  5. `CityCard` (`lib/widgets/city_card.dart`): Kartu rekomendasi kota dengan background ilustrasi dan nama kota.
  6. `StatusBadge` (`lib/widgets/status_badge.dart`): Chip penanda status survei kos berwarna adaptif.
  7. `EmptyStateWidget` (`lib/widgets/empty_state_widget.dart`): Tampilan visual informatif ketika data kosong.
  8. `ErrorStateWidget` (`lib/widgets/error_state_widget.dart`): Tampilan visual ketika terjadi kegagalan jaringan beserta tombol "Coba Lagi".
* [x] UI dipisahkan secara bersih dalam file-file modular berukuran kecil (< 250 baris per file).

### 3. Responsive Layout
* [x] **Minimal memiliki 2 kondisi layout:**
  - **Compact (< 600px, Smartphone):** Katalog berjejer 2 kolom (`crossAxisCount: 2`), tampilan detail vertikal memanjang, navigasi bawah compact.
  - **Wide / Expanded (≥ 600px, Tablet / Desktop / Web):** Katalog berjejer 4 kolom (`crossAxisCount: 4`), tampilan detail split-screen (foto di sebelah kiri dan informasi booking di sebelah kanan).
* [x] Menggunakan `LayoutBuilder` dan `MediaQuery` secara konsisten.
* [x] Bebas dari error `RenderFlex overflow` pada seluruh resolusi layar.

### 4. REST API
* [x] Menggunakan 1 REST API service layer: `KosApiService` (`lib/services/kos_api_service.dart`).
* [x] Operasi `GET` diimplementasikan dengan `http.get` dan deserialisasi JSON ke `KosModel`.
* [x] Data API ditampilkan langsung secara visual pada layar Beranda dan Katalog (bukan sekadar `print` di console).
* [x] Response JSON dikonversi otomatis menjadi objek Dart Model (`KosModel.fromJson`).
* [x] Memiliki penanganan status lengkap:
  - **Loading State:** `CircularProgressIndicator` warna hijau dengan pesan "Memuat data kos...".
  - **Empty State:** `EmptyStateWidget` dengan ilustrasi pencarian kosong dan tombol reset.
  - **Error State:** `ErrorStateWidget` dengan pesan error jelas dan tombol reload.

### 5. Backend & Database
* [x] Menggunakan backend cloud database **Supabase (PostgreSQL)**:
  - **Project URL:** `https://pugfdvhldusonayslhui.supabase.co`
  - **Project ID:** `pugfdvhldusonayslhui`
* [x] **Tabel Utama:** `public.saved_kos` dengan primary key `id` (TEXT) dan 12 field data:
  1. `id` (TEXT, PRIMARY KEY)
  2. `student_id` (TEXT)
  3. `kos_id` (TEXT)
  4. `kos_name` (TEXT)
  5. `kos_price` (BIGINT)
  6. `kos_type` (TEXT)
  7. `kos_address` (TEXT)
  8. `kos_image` (TEXT)
  9. `note` (TEXT)
  10. `rating` (DOUBLE PRECISION)
  11. `status` (TEXT)
  12. `visit_date` (TEXT)
  13. `created_at` (TIMESTAMPTZ)
* [x] **CRUD Database Lengkap Terintegrasi:**
  - **Create:** Menambahkan catatan survei kos baru via `AddSavedKosScreen` (`DatabaseService.insertSavedKos()`).
  - **Read:** Membaca daftar kos tersimpan realtime via `SavedKosScreen` (`DatabaseService.getSavedKos()`).
  - **Update:** Memperbarui catatan/rating/status survei via `EditSavedKosScreen` (`DatabaseService.updateSavedKos()`).
  - **Delete:** Menghapus kos dari daftar simpan via `DatabaseService.deleteSavedKos()`.
* [x] Operasi Delete wajib menggunakan **Confirmation Dialog (`AlertDialog`)** sebelum eksekusi.
* [x] Aplikasi aman: hanya menggunakan `anon` / `publishable key`, **tidak pernah** menyimpan `service_role key` atau password sensitif pada source code. Dilengkapi fitur *graceful local fallback* sehingga aplikasi tetap berjalan mulus tanpa crash saat offline.

### 6. State Management
* [x] Menggunakan paket resmi `Provider` (`provider: ^6.1.2`) dengan `ChangeNotifier`.
* [x] Seluruh state global dikelola dalam `KosProvider` (`lib/providers/kos_provider.dart`), bukan `setState()` lokal yang tersebar.
* [x] **State yang dikelola:**
  - `isLoading` (status proses asinkron),
  - `errorMessage` (pesan kesalahan koneksi/API),
  - `allKos` (seluruh katalog kos),
  - `filteredKos` (hasil pencarian dan filter kota/tipe),
  - `savedKosList` (daftar kos tersimpan dari Supabase),
  - `searchQuery`, `selectedCityFilter`, `selectedTypeFilter`.
* [x] **Shared State Lintas Layar:** Perubahan pada favorit / wishlist atau CRUD katalog langsung tersinkronisasi otomatis di seluruh layar (`HomeScreen`, `KosListScreen`, `KosDetailScreen`, `SavedKosScreen`, dan `ProfileScreen`).

### 7. Mobile Application Architecture
Struktur folder mematuhi prinsip *Separation of Concerns*:
```text
lib/
├── models/
│   ├── kos_model.dart            # Model katalog kos (12 field + JSON serialization)
│   └── saved_kos_model.dart      # Model database Supabase (12 field + CRUD mapping)
├── services/
│   ├── kos_api_service.dart      # REST API client & asset fallback loader
│   └── database_service.dart     # Supabase CRUD service + offline resilient cache
├── repositories/
│   └── kos_repository.dart       # Abstraksi data layer antara Provider dan Services
├── providers/
│   └── kos_provider.dart         # ChangeNotifier pusat pengatur state aplikasi
├── screens/
│   ├── main_navigation_screen.dart # Shell navigasi BottomNavigationBar
│   ├── home_screen.dart          # Explore dashboard beranda
│   ├── kos_list_screen.dart      # Katalog grid responsif
│   ├── kos_detail_screen.dart    # Detail kos & quick action
│   ├── add_edit_kos_screen.dart  # Form create/update kos katalog
│   ├── add_saved_kos_screen.dart # Form create wishlist Supabase
│   ├── edit_saved_kos_screen.dart# Form update wishlist Supabase
│   ├── saved_kos_screen.dart     # Tampilan Wishlist & konfirmasi hapus
│   ├── profile_screen.dart       # Profil mahasiswa & rekap UTS
│   └── chat_screen.dart          # Layar simulasi pesan
├── widgets/
│   ├── banner_slider.dart        # Reusable promo carousel
│   ├── category_item.dart        # Reusable category icon button
│   ├── city_card.dart            # Reusable city card
│   ├── custom_search_bar.dart    # Reusable search bar input
│   ├── empty_state_widget.dart   # Reusable empty state view
│   ├── error_state_widget.dart   # Reusable error retry view
│   ├── kos_card.dart             # Reusable kos card
│   └── status_badge.dart         # Reusable status chip
└── main.dart                     # Entry point & inisialisasi Supabase
```
> **Prinsip Alur Data:**  
> `UI (Screens/Widgets)` ➔ `State (KosProvider)` ➔ `Repository (KosRepository)` ➔ `Service (KosApiService / DatabaseService)` ➔ `REST API / Supabase Database`.  
> Tidak ada screen yang melakukan query HTTP atau SQL langsung.

### 8. Form, Validation, dan User Feedback
* [x] **Minimal 1 Form dengan Validation:**
  - `AddEditKosScreen`: Validasi Nama Kos (wajib, min. 3 karakter), Harga (wajib angka > 0), Alamat, URL Foto, dan Fasilitas.
  - `AddSavedKosScreen` & `EditSavedKosScreen`: Validasi Catatan Survei (tidak boleh kosong), Rating (rentang 1.0 - 5.0), dan Tanggal Rencana Kunjungan.
* [x] **Bentuk User Interaction:**
  1. Input teks & pencarian instan pada `CustomSearchBar`.
  2. Pemilihan filter chip interaktif kategori kos (Semua, Campur, Putra, Putri).
  3. Form input teks, dropdown status survei, dan slider rating.
  4. Tombol konfirmasi hapus dialog (`AlertDialog`).
* [x] **User Feedback:**
  - `ScaffoldMessenger.of(context).showSnackBar()` berwarna hijau saat sukses dan merah saat terjadi kesalahan.
  - `AlertDialog` konfirmasi sebelum menghapus kos dari Supabase.
* [x] Menangani validation error, network error, dan database timeout secara elegan.

---

## D. Ketentuan Git & GitHub (Tercatat 49 Meaningful Commits)

### Tabel Milestone Pengerjaan (Contoh 16 Commit Representatif):

| Tahap | Milestone | Hash Commit | Pesan Commit Riil di Repository |
| :---: | :--- | :---: | :--- |
| **1** | Project Initialization | `4ccc675` | `Tahap 0: Fix bersih tanpa file build dan app` |
| **2** | Architecture Setup | `13a1cf7` | `Siapkan project untuk state management dan architecture` |
| **3** | Models Implementation | `b4fbcf5` | `feat(models): Setup KosFinder architecture and data models (KosModel, SavedKosModel)` |
| **4** | Basic UI & Widgets | `a6c12ac` | `feat(widgets): Build reusable Mamikos UI widgets (KosCard, CustomSearchBar, BannerSlider, Badges)` |
| **5** | Responsive Layout | `4238462` | `feat(screens): Implement full 8 functional screens with responsive layout, forms, validation, and dialogs` |
| **6** | Navigation System | `5b496cb` | `Integrasikan Course Explorer v2 dengan Provider dan architecture` |
| **7** | State Management | `c8de065` | `feat(state): Implement KosProvider state management with shared favorites and filters` |
| **8** | REST API Service | `0bc3f35` | `feat(services): Implement KosApiService REST client and DatabaseService Supabase CRUD` |
| **9** | Backend Database | `3b0bfaa` | `Konfigurasikan Supabase client untuk backend database` |
| **10** | Create Data Feature | `c17fd6c` | `feat(kos): Add Tambah Kos and Edit Kos feature with AddEditKosScreen and actions` |
| **11** | Read Data Feature | `f89be06` | `Baca data courses dari Supabase database` |
| **12** | Update Data Feature | `cc00934` | `Tambahkan update course di Supabase` |
| **13** | Delete Data Feature | `cae42ff` | `Tambahkan delete course di Supabase` |
| **14** | Error Handling & State | `d478a75` | `Tambahkan error handling dan security hardening dasar` |
| **15** | UI Refinement & Action | `80d64d9` | `feat(ui): Make Edit Kos and Tambah Kos prominently visible in wide and mobile layouts` |
| **16** | Final Documentation | `f4b77e7` | `docs: Update README with 9 functional screens including AddEditKosScreen` |

---

## I. Minimum Requirement Checklist

| Komponen | Minimum | Hasil Implementasi | Cek |
| :--- | :---: | :--- | :---: |
| Screen fungsional | ≥ 6 | **10 screen** (Home, List, Detail, AddEdit, AddSaved, EditSaved, Saved, Profile, Chat, MainNav) | [x] |
| Dart Model | ≥ 2 | **2 model** (`KosModel` & `SavedKosModel` dengan `fromJson`/`toJson`) | [x] |
| Reusable Widget | ≥ 3 | **8 widget** (`KosCard`, `CustomSearchBar`, `BannerSlider`, `CityCard`, `CategoryItem`, `StatusBadge`, `EmptyState`, `ErrorState`) | [x] |
| Responsive condition | ≥ 2 | **2 kondisi** (Compact < 600px 2-kolom & Wide ≥ 600px 4-kolom + split detail) | [x] |
| REST API | ≥ 1 | **1 service** (`KosApiService` dengan model deserialization) | [x] |
| REST GET | Wajib | Diimplementasikan untuk pengambilan data katalog kos | [x] |
| Backend database | ≥ 1 | **Supabase Cloud (PostgreSQL)** | [x] |
| Tabel database | ≥ 1 | **1 tabel** (`public.saved_kos`) | [x] |
| Field tabel | ≥ 4 + ID | **12 field data + ID** (`id`, `student_id`, `kos_id`, `kos_name`, `kos_price`, `kos_type`, `kos_address`, `kos_image`, `note`, `rating`, `status`, `visit_date`, `created_at`) | [x] |
| CRUD database | 4 operasi | **Create, Read, Update, Delete** aktif di Supabase | [x] |
| State management | Provider | `KosProvider` (`ChangeNotifier`) terpusat tanpa `setState` global | [x] |
| Multi-screen navigation | Wajib | `BottomNavigationBar` + navigasi Stack antar-screen | [x] |
| Passing data | Wajib | Passing object `KosModel` & `SavedKosModel` antar layar | [x] |
| Form + validation | Wajib | `Form` dengan `GlobalKey<FormState>` dan validator di 3 form | [x] |
| SnackBar/Dialog | Wajib | `SnackBar` feedback aksi & `AlertDialog` konfirmasi hapus | [x] |
| Loading state | Wajib | `CircularProgressIndicator` pada transisi data async | [x] |
| Error state | Wajib | `ErrorStateWidget` dengan pesan error & tombol Retry | [x] |
| Empty state | Wajib | `EmptyStateWidget` jika pencarian atau wishlist kosong | [x] |
| Meaningful Git commits | ≥ 16 | **49 commits** tercatat di Git log | [x] |
| Push per milestone | Wajib | Seluruh tahapan dipush bertahap ke branch `main` | [x] |
| README | Wajib | Dokumentasi lengkap dengan panduan instalasi dan arsitektur | [x] |
| GitHub URL | Wajib | `https://github.com/kepalarusa2022-sketch/uts_2415051101_jack_rich_loro` | [x] |

---

## J. Identitas dan Bukti Pengumpulan

* **Nama Project:** KosFinder - Mobile Kos Finder & Management
* **Tema:** Pencarian & Manajemen Kos Modern (Mamikos Inspired)
* **URL GitHub Repository:** `https://github.com/kepalarusa2022-sketch/uts_2415051101_jack_rich_loro`
* **Nama Branch Utama:** `main`
* **REST API yang digunakan:** REST API Endpoint Katalog Kos (`KosApiService` dengan fallback data offline `assets/data/kos_data.json`)
* **Backend/Database yang digunakan:** Supabase Cloud PostgreSQL (Tabel `public.saved_kos` pada project ID `pugfdvhldusonayslhui`)
* **Jumlah Screen:** 10 Screen Fungsional
* **Jumlah Meaningful Commit:** 49 Commits
* **Hash Commit Final:** `80d64d9`
* **Link APK / File APK:** `UTS_2415051101_Jack_Rich_Loro.apk` (tersedia di root folder project)
* **Catatan Kendala Utama & Solusi:**
  1. *Propagasi DNS Supabase:* Saat project Supabase free-tier di-unpause, dibutuhkan waktu propagasi DNS global. Solusi: Diimplementasikan arsitektur dual-storage graceful fallback (in-memory persistent cache) sehingga aplikasi tetap berjalan lancar tanpa freeze atau crash.
  2. *Responsive Layout & Overflow:* Tampilan mobile dan layar lebar memerlukan penataan layout yang berbeda. Solusi: Menggunakan `LayoutBuilder` untuk secara otomatis beralih antara 2 kolom (mobile) dan 4 kolom (wide/web), serta menempatkan tombol aksi "Tambah Kos" dan "Edit Kos" di area strategis agar mudah diakses pada seluruh ukuran layar.
