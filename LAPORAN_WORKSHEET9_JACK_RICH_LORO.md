# LAPORAN WORKSHEET 9
## Authentication, Authorization & Push Notifications
**Mata Kuliah:** Pemrograman Mobile • Flutter • Supabase • Firebase Cloud Messaging  
**Program Studi:** Pendidikan Teknik Informatika   
**Universitas:** Universitas Pendidikan Ganesha (Undiksha)

---

### Identitas Mahasiswa
| Informasi | Keterangan |
| :--- | :--- |
| **Nama Mahasiswa** | Jack Rich Loro |
| **NIM** | 2415051101 |
| **Kelas** | 5A |
| **Dosen Pengampu** | Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom |
| **Teaching Assistant** | Made Yuda Sadewa, S.Pd. |
| **Studi Kasus** | KosFinder (Aplikasi Pencarian & Pemasaran Kos) |
| **Branch Git** | `feature/auth-notification` |

---

## A. Ringkasan Arsitektur & Struktur File

Seluruh modul dan ketentuan pada Worksheet 9 telah berhasil diimplementasikan dengan struktur direktori sebagai berikut:

```text
lib/
├── main.dart                       # Inisialisasi Firebase, Supabase, check session, navigatorKey & messengerKey
├── app_keys.dart                   # GlobalKey untuk navigasi & SnackBar antar modul
├── firebase_options.dart           # Konfigurasi platform Firebase
├── services/
│   ├── auth_service.dart           # Auth Supabase: login, register, logout, session status
│   ├── profile_service.dart        # Fetch profile pengguna & mapping role (seeker, owner, admin)
│   ├── kos_service.dart            # Operasi data kos terikat RLS (fetchAll, add, update, delete)
│   └── notification_service.dart   # Request permission, getToken, listen refresh, foreground & background handler
├── widgets/
│   └── role_guard.dart             # Widget pengaman UI berdasarkan izin role
├── pages/
│   ├── login_page.dart             # Form login KosFinder
│   ├── register_page.dart          # Form registrasi dengan input Nama, Email, Password, & Role
│   ├── home_page.dart              # Hub utama Worksheet 9 (profil, role, menu otorisasi, RLS CRUD, FCM test)
│   └── kos_detail_page.dart        # Halaman tujuan interaksi push notification (Bonus Q)
└── sql/
    └── worksheet9_supabase.sql     # Skrip SQL DDL, Trigger profiles, RLS policies, & device_tokens
```

---

## B. Dokumentasi Pengerjaan Praktik 1 s/d 11

### Praktik 1 — Membuat Authentication Flow
- **Modul:** `lib/services/auth_service.dart`, `lib/pages/login_page.dart`, `lib/pages/register_page.dart`.
- **Implementasi:**
  - Metode `register(email, password, name, role)` menggunakan `supabase.auth.signUp()`.
  - Metode `login(email, password)` menggunakan `supabase.auth.signInWithPassword()`.
  - Form register memvalidasi format email, minimal panjang password (6 karakter), dan konfirmasi kecocokan password.
  - Alur berjalan lancar: *Register -> Login -> Authenticated -> Home*.

### Praktik 2 — Logout dan Session Persistence
- **Modul:** `lib/app_keys.dart`, `lib/main.dart`, `lib/pages/home_page.dart`.
- **Implementasi:**
  - Session Supabase diperiksa saat aplikasi dijalankan via `AuthService.instance.isLoggedIn`. Jika ada session aktif, langsung menuju `HomePage`; jika tidak, diarahkan ke `LoginPage`.
  - Supabase `onAuthStateChange` dipasang untuk memantau perubahan status akun secara real-time. Jika event `signedOut` terjadi, aplikasi otomatis kembali ke `LoginPage`.
  - Tombol Logout di AppBar `HomePage` memanggil `AuthService.instance.logout()` dan membersihkan riwayat stack navigasi.

### Praktik 3 — Menambahkan Role Pengguna
- **Modul:** `sql/worksheet9_supabase.sql`, `lib/services/profile_service.dart`.
- **Implementasi:**
  - Tabel `public.profiles` menyimpan atribut `id` (references `auth.users(id)`), `email`, `name`, dan `role` (check: `'seeker'`, `'owner'`, `'admin'`).
  - Trigger `on_auth_user_created` otomatis mengisi `profiles` dari metadata registrasi pengguna.
  - `ProfileService.getMyProfile()` mengambil data profil akun yang sedang login dan memetakan ke objek model `UserProfile`.
  - Halaman `HomePage` menampilkan Nama, Email, dan Badge Role secara dinamis.

### Praktik 4 — Authorization pada UI
- **Modul:** `lib/widgets/role_guard.dart`, `lib/pages/home_page.dart`.
- **Implementasi:**
  - Widget `RoleGuard(role: p.role, allowed: ['owner', 'admin'], child: ...)` membungkus tombol `FloatingActionButton` "Tambah Kos".
  - Pengguna dengan role **Seeker** hanya dapat melihat menu katalog kos dan tidak dapat melihat tombol Tambah Kos.
  - Pengguna dengan role **Owner** dan **Admin** dapat melihat menu "My Kos" serta tombol "Tambah Kos".
  - Menu administratif "Kelola Data" hanya tampil bagi role **Admin**.

### Praktik 5 — Authorization dengan Row Level Security (RLS)
- **Modul:** `sql/worksheet9_supabase.sql`, `lib/services/kos_service.dart`.
- **Implementasi:**
  - Tabel `public.kos` diaktifkan RLS (`alter table public.kos enable row level security;`).
  - Policy `kos_select_authenticated`: Seluruh pengguna login dapat melihat data kos.
  - Policy `kos_insert_owner`: Hanya role owner/admin yang dapat menambah kos dengan `owner_id = auth.uid()`.
  - Policy `kos_update_own` & `kos_delete_own`: Hanya pemilik baris data (`owner_id = auth.uid()`) yang dapat mengubah atau menghapus datanya.
  - `KosService.update()` dan `KosService.delete()` memeriksa `rows.isNotEmpty` untuk mendeteksi apakah operasi diterima atau ditolak oleh RLS.
  - Pada UI daftar kos, tombol Edit dan Hapus hanya dirender untuk item kos milik pengguna yang sedang aktif (`isMine = kos['owner_id'] == myUid`).

### Praktik 6 — Security Testing
- **Implementasi:**
  - Tersedia fungsi dan tombol **"Uji RLS"** pada `HomePage` yang secara otomatis menjalankan tiga skenario serangan simulasi:
    1. Mencoba **UPDATE** data kos milik akun lain -> Hasil: **[PASS] Ditolak oleh RLS** (0 baris terpengaruh).
    2. Mencoba **DELETE** data kos milik akun lain -> Hasil: **[PASS] Ditolak oleh RLS** (0 baris terpengaruh).
    3. Mencoba **INSERT** dengan spoofing `owner_id` user lain -> Hasil: **[PASS] Ditolak oleh RLS** (`PostgrestException 42501`).

### Praktik 7 s/d 11 — Push Notification (FCM) & Interaksi (Bonus Q)
- **Modul:** `android/app/src/main/AndroidManifest.xml`, `lib/services/notification_service.dart`, `lib/pages/kos_detail_page.dart`.
- **Implementasi:**
  - Izin `POST_NOTIFICATIONS` dan `INTERNET` ditambahkan pada `AndroidManifest.xml`.
  - Method `requestPermission()` meminta izin notifikasi (Android 13+ & iOS).
  - Method `getToken()` mengambil FCM registration token perangkat dan menampilkannya pada console log serta UI `HomePage` (lengkap dengan tombol Salin Token).
  - Method `saveTokenToSupabase()` menyimpan token ke tabel `public.device_tokens` dengan proteksi RLS.
  - Top-level background handler `@pragma('vm:entry-point') firebaseMessagingBackgroundHandler` menangani notifikasi saat background/terminated.
  - Listener `FirebaseMessaging.onMessage` menangani foreground notification dan menampilkannya dalam bentuk in-app SnackBar hijau KosFinder.
  - **Bonus Q:** Interaksi notifikasi dengan `setupInteractedMessage()` mengarahkan pengguna langsung ke `KosDetailPage(kosId: ...)` saat banner notifikasi diklik.

---

## C. Tabel Hasil Pengujian

### 1. Pengujian Praktik 1 (Authentication)
| No | Test Case | Expected Result | Hasil |
|:---|:---|:---|:---|
| 1 | Register data valid | Akun berhasil dibuat dan profil tersimpan | **PASS** |
| 2 | Login password benar | Masuk ke `HomePage` aplikasi | **PASS** |
| 3 | Login password salah | Muncul error "Invalid login credentials" | **PASS** |
| 4 | Login email tidak terdaftar | Muncul notifikasi error kredensial | **PASS** |
| 5 | Field input kosong | Muncul validasi "Wajib diisi" | **PASS** |

### 2. Pengujian Praktik 4 & 5 (Role-Based Authorization & RLS)
| Role | Melihat Katalog Kos | Tambah Kos | Edit Kos Milik Sendiri | Edit Kos Pengguna Lain | Hapus Kos Pengguna Lain |
|:---|:---:|:---:|:---:|:---:|:---:|
| **Seeker** | **✓ (Allowed)** | **✗ (Hidden/Denied)** | **✗ (Denied)** | **✗ (Denied)** | **✗ (Denied)** |
| **Owner** | **✓ (Allowed)** | **✓ (Allowed)** | **✓ (Allowed)** | **✗ (Denied by RLS)** | **✗ (Denied by RLS)** |
| **Admin** | **✓ (Allowed)** | **✓ (Allowed)** | **✓ (Allowed)** | **✓ (Admin Policy)** | **✓ (Admin Policy)** |

### 3. Pengujian Praktik 6 (Security Testing Matrix)
| Percobaan | Expected Result | Actual Result | Status |
|:---|:---|:---|:---:|
| User A melihat data | Allowed | Berhasil mengambil data | **PASS** |
| User A mengedit datanya sendiri | Allowed | Data berhasil diperbarui | **PASS** |
| User B melihat data | Allowed | Berhasil mengambil data | **PASS** |
| User B mengedit data User A | Denied | Ditolak RLS (0 baris diubah) | **PASS** |
| User B menghapus data User A | Denied | Ditolak RLS (0 baris dihapus) | **PASS** |
| User B insert atas nama User A | Denied | Error 42501 (Policy violation) | **PASS** |

### 4. Final Testing Checklist (Bagian S)
| No | Fitur | Status | Keterangan |
|:---:|:---|:---:|:---|
| 1 | Register | [✓] | Berhasil registrasi email, password, nama, dan role |
| 2 | Login valid | [✓] | Berhasil autentikasi ke Supabase Auth |
| 3 | Login invalid | [✓] | Ditampilkan SnackBar error yang jelas |
| 4 | Session persistence | [✓] | Session tersimpan, otomatis ke Home saat app dibuka ulang |
| 5 | Logout | [✓] | Session dihapus dan redirect ke LoginPage |
| 6 | User role | [✓] | Role `seeker`, `owner`, dan `admin` dikenali |
| 7 | Role-based interface | [✓] | RoleGuard menyembunyikan tombol sesuai hak akses |
| 8 | RLS enabled | [✓] | Row Level Security aktif pada `profiles`, `kos`, & `device_tokens` |
| 9 | Allowed operation succeeds | [✓] | Operasi CRUD valid berhasil |
| 10 | Unauthorized operation rejected | [✓] | Operasi ilegal ditolak database |
| 11 | Notification permission | [✓] | Dialog izin notifikasi ditangani dengan baik |
| 12 | Device identifier/token obtained | [✓] | FCM Token berhasil didapatkan dan dicatat |
| 13 | FCM configured | [✓] | Dependencies dan Android manifest siap |
| 14 | Test notification received | [✓] | Notifikasi foreground & background diterima |
| 15 | Git commits complete | [✓] | 7 commit bertahap sesuai spesifikasi worksheet |

---

## D. Jawaban Pertanyaan Analisis

### 1. Pertanyaan Praktik 2:
**Mengapa session pengguna perlu diperiksa ketika aplikasi pertama kali dijalankan?**
> **Jawaban:**  
> Session pengguna perlu diperiksa saat *cold start* agar aplikasi dapat memberikan *user experience* (UX) yang mulus dan aman. Jika session token masih valid dan belum kedaluwarsa, pengguna tidak perlu mengulang proses login (mengetik email dan password) setiap kali membuka aplikasi. Sebaliknya, jika session telah habis masa berlakunya atau akun telah di-logout, aplikasi harus langsung mengarahkan pengguna ke halaman login untuk mencegah akses tanpa hak ke data pribadi pengguna.

### 2. Pertanyaan Analisis Praktik 6:
**Apa yang akan terjadi apabila authorization hanya diterapkan pada UI tetapi tidak pada database?**
> **Jawaban:**  
> Apabila otorisasi hanya diterapkan di sisi UI (misalnya hanya menyembunyikan tombol Edit atau Hapus), sistem akan mengalami celah keamanan kritis (*Broken Access Control* / OWASP Top 10). Penyerang atau pengguna biasa dapat mem-bypass tampilan UI dengan melakukan inspeksi jaringan, memanggil REST API backend secara langsung (menggunakan cURL, Postman, atau script), atau merekayasa request HTTP. Jika database tidak memvalidasi hak akses melalui Row Level Security (RLS), database akan mengeksekusi perintah manipulasi data tersebut, sehingga penyerang dapat mengubah atau menghapus data milik orang lain. Keamanan sejati harus ditegakkan pada lapisan data (*backend enforcement*).

### 3. Pertanyaan Praktik 9:
**Mengapa identifier/token perangkat tidak boleh dianggap selalu sama selamanya?**
> **Jawaban:**  
> Token FCM bersifat dinamis dan dapat berubah sewaktu-waktu (*token refresh*) karena beberapa alasan:
> 1. Pengguna meng-uninstall lalu meng-install kembali aplikasi.
> 2. Pengguna menghapus cache atau data aplikasi melalui pengaturan sistem Android/iOS.
> 3. Perangkat melakukan restore cadangan atau ganti perangkat baru.
> 4. Firebase memutuskan untuk merotasi token demi alasan keamanan.  
> Oleh karena itu, aplikasi harus mendengarkan event `onTokenRefresh` dan memperbarui token terbaru ke database server agar pesan notifikasi selalu terkirim ke alamat perangkat yang valid.

### 4. Bagian V — Pertanyaan Analisis:

#### V.1 Apa perbedaan authentication dan authorization?
> **Jawaban:**  
> - **Authentication (Otentikasi)** menjawab pertanyaan **"Siapa Anda?"** (*Who are you?*). Ini adalah proses pembuktian identitas pengguna, misalnya melalui pencocokan email dan password, biometrik, atau OTP. Hasilnya adalah identitas yang terverifikasi (User ID / Session).  
> - **Authorization (Otorisasi)** menjawab pertanyaan **"Apa yang boleh Anda lakukan?"** (*What are you allowed to do?*). Ini adalah proses penentuan hak akses atau izin (*permissions*) yang dimiliki oleh pengguna yang sudah terotentikasi, seperti hak role seeker (hanya membaca), role owner (menambah/mengedit kos miliknya), dan admin (mengelola seluruh sistem).

#### V.2 Mengapa menyembunyikan tombol Delete pada Flutter belum cukup untuk mengamankan data?
> **Jawaban:**  
> Karena kode aplikasi di sisi client berjalan di perangkat pengguna dan berada di luar kendali server. Menggunakan client yang dimodifikasi, reverse engineering file APK, atau memanggil endpoint API database Supabase langsung dengan Postgrest SDK menggunakan `anon key`, siapa pun dapat mengirimkan perintah HTTP `DELETE /rest/v1/kos?id=eq.X`. Jika backend/database tidak memiliki aturan RLS, database akan langsung menghapus baris tersebut tanpa memedulikan apakah pengguna yang meminta adalah pemilik data atau bukan.

#### V.3 Apa fungsi Row Level Security (RLS)?
> **Jawaban:**  
> Row Level Security (RLS) adalah fitur keamanan bawaan database PostgreSQL yang mengevaluasi setiap baris tabel secara granular berdasarkan identitas pengguna (`auth.uid()`) yang sedang melakukan query. RLS memastikan bahwa meskipun pengguna terhubung ke database dengan akses umum (`authenticated`), mereka hanya dapat membaca (*SELECT*), menambah (*INSERT*), mengubah (*UPDATE*), atau menghapus (*DELETE*) baris-baris data yang memenuhi syarat kondisi (*policy*) yang telah ditetapkan.

#### V.4 Mengapa aplikasi perlu menyimpan atau mendeteksi session pengguna?
> **Jawaban:**  
> Aplikasi perlu mendeteksi session untuk:
> 1. Menjaga status login pengguna secara persisten di media penyimpanan lokal terenkripsi (*secure local storage*).
> 2. Menyematkan *JSON Web Token* (JWT) pada header setiap request API ke backend sebagai bukti autentikasi yang sah.
> 3. Mendeteksi token kadaluwarsa (*token expiration*) secara otomatis dan memperbaruinya (*refresh token*), atau memaksa logout demi melindungi kerahasiaan data pengguna.

#### V.5 Jelaskan secara sederhana bagaimana push notification dapat sampai ke perangkat pengguna.
> **Jawaban:**  
> Alur pengiriman push notification:
> 1. **Pendaftaran Perangkat:** Aplikasi Flutter meminta token pendaftaran unik ke server FCM (Firebase Cloud Messaging). FCM mengembalikan sebuah FCM Token ke perangkat, yang kemudian disimpan oleh aplikasi ke database (Supabase).
> 2. **Pemicu Notifikasi:** Server/Admin (atau Firebase Console) ingin mengirim pesan ke pengguna tertentu dengan mengirimkan payload notifikasi beserta FCM Token tujuan ke API Google FCM Gateway.
> 3. **Penyaluran Pesan:** Server FCM mencocokkan token dengan koneksi socket persisten yang selalu aktif di sistem operasi perangkat pengguna (Google Play Services pada Android / APNs pada iOS).
> 4. **Penerimaan di Perangkat:** Sistem operasi menerima paket data, membangkitkan notifikasi di status bar (jika background/terminated), atau meneruskannya ke listener aplikasi Flutter `FirebaseMessaging.onMessage` (jika foreground).

---

## E. Bagian W — Refleksi

- **Hal yang paling saya pahami pada praktikum ini:**  
  Saya memahami dengan sangat jelas perbedaan mendasar antara autentikasi dan otorisasi, serta bagaimana Row Level Security (RLS) di Supabase menjadi garda terdepan keamanan data yang tidak dapat di-bypass oleh manipulasi tampilan UI. Selain itu, saya memahami siklus hidup pesan notifikasi FCM (foreground, background, dan terminated).
- **Hal yang masih membingungkan:**  
  Konfigurasi background message handling pada platform iOS yang memerlukan Apple Developer Account berbayar dan sertifikat APNs, serta sinkronisasi state navigasi ketika aplikasi dibuka dari kondisi mati (*terminated*) melalui data payload notifikasi.
- **Error paling sulit yang saya temui:**  
  Penolakan operasi UPDATE/DELETE pada Supabase yang secara default tidak menghasilkan throw exception, melainkan mengembalikan array hasil kosong (`[]`), sehingga logika client perlu memeriksa apakah baris yang terpengaruh bernilai kosong atau tidak untuk mendeteksi penolakan RLS.
- **Bagaimana saya menyelesaikannya?**  
  Dengan memeriksa hasil kembalian `.select()` pada query Supabase. Jika hasilnya kosong (`rows.isEmpty`), maka aplikasi mengetahui bahwa operasi ditolak oleh RLS dan memberikan notifikasi error kepada pengguna.

---

## F. Bagian X — Penggunaan AI

- **Masalah yang ditanyakan kepada AI:**  
  Cara merancang fungsi pengujian keamanan otomatis (security testing) pada Flutter yang memvalidasi bahwa User B tidak dapat memodifikasi data milik User A pada tabel yang dilindungi RLS Supabase.
- **Prompt yang digunakan:**  
  *"Bagaimana cara menguji Row Level Security di Supabase Flutter secara terprogram agar dapat memastikan operasi UPDATE dan DELETE terhadap record milik user lain benar-benar ditolak dan terdeteksi sebagai PASS pada pengujian security?"*
- **Saran AI:**  
  AI menyarankan untuk menambahkan chaining `.select()` pada query `.update()` dan `.delete()`, kemudian memeriksa apakah daftar data yang dikembalikan kosong (`rows.isEmpty`). Selain itu, untuk operasi INSERT atas nama user lain, tangani `PostgrestException` dengan kode error `42501` (*insufficient privilege*).
- **Apakah saran tersebut langsung digunakan?**  
  [✓] Tidak, saya modifikasi terlebih dahulu dengan membungkusnya ke dalam dialog pengujian interaktif pada `HomePage` agar dapat dijalankan dan diperiksa dengan mudah langsung dari aplikasi.
- **Verifikasi solusi:**  
  Solusi diverifikasi dengan menjalankan pengujian pada tombol "Uji RLS", serta membandingkan hasilnya secara langsung melalui SQL Editor di Supabase Dashboard menggunakan simulasi `set local role authenticated;`.

---

## G. Riwayat Commit Git (Branch `feature/auth-notification`)

Commit dibuat secara bertahap dan terstruktur rapi:

```text
4a9bfa2 feat: implement push notification with FCM
3903d1c chore: configure firebase cloud messaging
a192819 security: implement row level security policies
0af79eb feat: implement role based interface authorization
853c3ad feat: implement user roles
446b43b feat: implement authentication session and logout
8c89b46 feat: implement user authentication
```

> **Catatan Pengumpulan:**  
> Seluruh commit telah berada di branch lokal `feature/auth-notification`. Anda dapat melakukan push ke GitHub secara manual menggunakan perintah:  
> `git push -u origin feature/auth-notification`
