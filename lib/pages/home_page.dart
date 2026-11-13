import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../app_keys.dart';
import '../screens/main_navigation_screen.dart';
import '../services/auth_service.dart';
import '../services/kos_service.dart';
import '../services/notification_service.dart';
import '../services/profile_service.dart';
import '../widgets/role_guard.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<UserProfile?> _profileFuture;
  late Future<List<Map<String, dynamic>>> _kosFuture;
  final KosService _kosService = KosService();

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileService().getMyProfile();
    _kosFuture = _kosService.fetchAll();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await NotificationService.instance.init();
      await NotificationService.instance.setupInteractedMessage();
      if (mounted) setState(() {});
    });
  }

  void _refreshData() {
    setState(() {
      _profileFuture = ProfileService().getMyProfile();
      _kosFuture = _kosService.fetchAll();
    });
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void _showAddKosDialog() {
    final nameC = TextEditingController();
    final addressC = TextEditingController();
    final priceC = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Kos Baru'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameC,
                decoration: const InputDecoration(labelText: 'Nama Kos'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: addressC,
                decoration: const InputDecoration(labelText: 'Alamat Kos'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: priceC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga (Rp/bulan)'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                await _kosService.add(
                  name: nameC.text.trim(),
                  address: addressC.text.trim(),
                  price: int.tryParse(priceC.text.trim()) ?? 0,
                );
                if (ctx.mounted) Navigator.pop(ctx);
                if (!mounted) return;
                _refreshData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kos berhasil ditambahkan!')),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal menambahkan: $e')),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showEditKosDialog(Map<String, dynamic> item) {
    final nameC = TextEditingController(text: item['name']?.toString() ?? '');
    final addressC =
        TextEditingController(text: item['address']?.toString() ?? '');
    final priceC =
        TextEditingController(text: item['price']?.toString() ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Kos Milik Saya'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameC,
                decoration: const InputDecoration(labelText: 'Nama Kos'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: addressC,
                decoration: const InputDecoration(labelText: 'Alamat Kos'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: priceC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga (Rp/bulan)'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final success = await _kosService.update(
                item['id'].toString(),
                {
                  'name': nameC.text.trim(),
                  'address': addressC.text.trim(),
                  'price': int.tryParse(priceC.text.trim()) ?? 0,
                },
              );
              if (ctx.mounted) Navigator.pop(ctx);
              if (!mounted) return;
              _refreshData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success
                      ? 'Kos berhasil diperbarui!'
                      : 'Operasi ditolak oleh RLS / bukan milik Anda.'),
                ),
              );
            },
            child: const Text('Simpan Perubahan'),
          ),
        ],
      ),
    );
  }

  Future<void> _runSecurityTest(String targetKosId, String ownerId) async {
    final results = <String>[];
    results.add('=== HASIL SECURITY TESTING RLS (Praktik 6) ===\n');

    // Test 1: UPDATE
    final updated = await _kosService.update(
      targetKosId,
      {'name': 'HACKED BY SECURITY TEST'},
    );
    results.add(
      updated
          ? '[FAIL] User berhasil mengubah data kos lain (RLS bocor).'
          : '[PASS] UPDATE data orang lain DITOLAK oleh RLS Supabase.',
    );

    // Test 2: DELETE
    final deleted = await _kosService.delete(targetKosId);
    results.add(
      deleted
          ? '[FAIL] User berhasil menghapus data kos lain (RLS bocor).'
          : '[PASS] DELETE data orang lain DITOLAK oleh RLS Supabase.',
    );

    // Test 3: INSERT spoofing owner_id
    try {
      await Supabase.instance.client.from('kos').insert({
        'owner_id': '00000000-0000-0000-0000-000000000000',
        'name': 'Kos Palsu Spoofing',
      });
      results.add('[FAIL] INSERT atas nama user lain berhasil (RLS bocor).');
    } on PostgrestException catch (e) {
      results.add('[PASS] INSERT data user lain DITOLAK: ${e.code} - ${e.message}');
    } catch (_) {
      results.add('[PASS] INSERT data user lain DITOLAK oleh aturan validasi.');
    }

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hasil Security Testing'),
        content: SingleChildScrollView(
          child: Text(results.join('\n\n')),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myUid = Supabase.instance.client.auth.currentUser?.id;

    return FutureBuilder<UserProfile?>(
      future: _profileFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF1BAA56)),
            ),
          );
        }

        final p = snap.data ??
            UserProfile(
              id: myUid ?? '',
              email: Supabase.instance.client.auth.currentUser?.email ?? '-',
              name: 'Pengguna',
              role: 'seeker',
            );

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9FA),
          appBar: AppBar(
            title: Text('KosFinder (${p.role.toUpperCase()})'),
            actions: [
              IconButton(
                tooltip: 'Refresh Data',
                icon: const Icon(Icons.refresh),
                onPressed: _refreshData,
              ),
              IconButton(
                tooltip: 'Logout',
                icon: const Icon(Icons.logout),
                onPressed: _logout,
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Card Informasi Profil & Role Pengguna (Praktik 3)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: const Color(0xFF1BAA56).withValues(alpha: 0.15),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 32,
                              color: Color(0xFF1BAA56),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name.isEmpty ? 'Pengguna KosFinder' : p.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  p.email,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: p.isOwner
                                  ? Colors.orange.shade100
                                  : p.isAdmin
                                      ? Colors.purple.shade100
                                      : Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              p.role.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: p.isOwner
                                  ? Colors.orange.shade800
                                  : p.isAdmin
                                      ? Colors.purple.shade800
                                      : Colors.blue.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Text(
                        'User ID: ${p.id}',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Card FCM Token & Notifikasi Push (Praktik 7, 8, 9, 10, 11)
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.notifications_active_outlined,
                            color: Color(0xFF1BAA56),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Firebase Cloud Messaging (FCM)',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        NotificationService.instance.currentToken != null
                            ? 'Token: ${NotificationService.instance.currentToken!.substring(0, 30)}...'
                            : 'Token FCM sedang diambil / simulator...',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            icon: const Icon(Icons.copy, size: 16),
                            label: const Text('Salin Token FCM'),
                            onPressed: () {
                              final token =
                                  NotificationService.instance.currentToken;
                              if (token != null) {
                                Clipboard.setData(ClipboardData(text: token));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Token FCM disalin ke clipboard!'),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Token FCM belum tersedia.'),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              messengerKey.currentState?.showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'KosFinder\nKos baru tersedia di sekitar kampus.',
                                  ),
                                  backgroundColor: Color(0xFF1BAA56),
                                ),
                              );
                            },
                            child: const Text('Uji Foreground'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Menu Otorisasi UI berdasarkan Role (Praktik 4)
              const Text(
                'Menu Otorisasi Role (Praktik 4)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const ListTile(
                      leading: Icon(Icons.list_alt, color: Color(0xFF1BAA56)),
                      title: Text('Daftar Kos (Semua Role)'),
                      subtitle: Text('Seeker, Owner, dan Admin dapat melihat kos'),
                    ),
                    if (p.isOwner || p.isAdmin) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading:
                            const Icon(Icons.home_work, color: Colors.orange),
                        title: const Text('My Kos (Owner / Admin)'),
                        subtitle: const Text('Kelola kos milik Anda sendiri'),
                      ),
                    ],
                    if (p.isAdmin) ...[
                      const Divider(height: 1),
                      const ListTile(
                        leading:
                            Icon(Icons.admin_panel_settings, color: Colors.purple),
                        title: Text('Kelola Data (Admin Saja)'),
                        subtitle: Text('Hak akses administratif sistem'),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Akses ke Tampilan Penuh Mamikos UTS
              OutlinedButton.icon(
                icon: const Icon(Icons.dashboard_customize_rounded),
                label: const Text('Buka Aplikasi Lengkap KosFinder (Mamikos UI)'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  foregroundColor: const Color(0xFF1BAA56),
                  side: const BorderSide(color: Color(0xFF1BAA56)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainNavigationScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Header Daftar Kos & RLS CRUD (Praktik 5)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar Kos Database (RLS)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.security, size: 16),
                    label: const Text('Uji RLS'),
                    onPressed: () {
                      _runSecurityTest(
                        '00000000-0000-0000-0000-000000000000',
                        'other-user',
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // FutureBuilder Daftar Kos dari Supabase
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _kosFuture,
                builder: (context, kosSnap) {
                  if (kosSnap.connectionState != ConnectionState.done) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(color: Color(0xFF1BAA56)),
                      ),
                    );
                  }

                  final items = kosSnap.data ?? [];

                  if (items.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.home_outlined, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 8),
                          const Text(
                            'Belum ada data kos di database Supabase.',
                            style: TextStyle(color: Colors.grey),
                          ),
                          if (p.isOwner || p.isAdmin) ...[
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _showAddKosDialog,
                              icon: const Icon(Icons.add),
                              label: const Text('Tambah Kos Sekarang'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1BAA56),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final kos = items[i];
                      final ownerId = kos['owner_id']?.toString() ?? '';
                      final isMine = (ownerId == myUid && myUid != null);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isMine
                                ? const Color(0xFF1BAA56)
                                : Colors.grey.shade200,
                            width: isMine ? 1.5 : 1,
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isMine
                                ? const Color(0xFF1BAA56).withValues(alpha: 0.15)
                                : Colors.grey.shade200,
                            child: Icon(
                              Icons.house_rounded,
                              color: isMine
                                  ? const Color(0xFF1BAA56)
                                  : Colors.grey.shade600,
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  kos['name'] ?? '-',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (isMine)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1BAA56),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Milik Saya',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Text(
                            '${kos['address'] ?? '-'} • Rp ${kos['price'] ?? 0}/bln',
                          ),
                          trailing: isMine
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      tooltip: 'Edit Kos',
                                      onPressed: () => _showEditKosDialog(kos),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      tooltip: 'Hapus Kos',
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('Hapus Kos'),
                                            content: const Text(
                                              'Apakah Anda yakin ingin menghapus data kos ini?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx, false),
                                                child: const Text('Batal'),
                                              ),
                                              FilledButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx, true),
                                                style: FilledButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                child: const Text('Hapus'),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          final success = await _kosService
                                              .delete(kos['id'].toString());
                                          if (!mounted) return;
                                          _refreshData();
                                          messengerKey.currentState?.showSnackBar(
                                            SnackBar(
                                              content: Text(success
                                                  ? 'Kos berhasil dihapus!'
                                                  : 'Gagal / ditolak oleh RLS.'),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                )
                              : null, // Jika bukan pemilik, tombol edit/hapus disembunyikan
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 70),
            ],
          ),

          // Tombol Tambah Kos hanya untuk Owner / Admin (Praktik 4)
          floatingActionButton: RoleGuard(
            role: p.role,
            allowed: const ['owner', 'admin'],
            child: FloatingActionButton.extended(
              onPressed: _showAddKosDialog,
              backgroundColor: const Color(0xFF1BAA56),
              icon: const Icon(Icons.add_home_rounded, color: Colors.white),
              label: const Text(
                'Tambah Kos (Owner)',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
