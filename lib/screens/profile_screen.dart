import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../providers/kos_provider.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final kosProvider = context.watch<KosProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        title: const Text(
          'Profil Mahasiswa & Aplikasi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF1BAA56),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profil Card Hijau
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
              decoration: const BoxDecoration(
                color: Color(0xFF1BAA56),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage('assets/images/profile.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Jack Rich Loro',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'NIM: 2415051101',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Pendidikan Teknik Informatika / Ilmu Komputer\nUniversitas Pendidikan Ganesha (Undiksha)',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Statistics Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildStatCard(
                    'Katalog Kos',
                    '${kosProvider.allKos.length}',
                    Icons.apartment,
                    const Color(0xFF1BAA56),
                  ),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    'Disimpan',
                    '${kosProvider.savedKosList.length}',
                    Icons.favorite,
                    Colors.redAccent,
                  ),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    'Kota Terjangkau',
                    '5 Kota',
                    Icons.location_on,
                    Colors.amber.shade800,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Academic Project Information Box
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.school, color: Color(0xFF1BAA56), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Informasi Ujian Tengah Semester',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  _buildInfoRow('Mata Kuliah', 'Pemrograman Mobile (UTS)'),
                  _buildInfoRow('Dosen Pengampu', 'Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom'),
                  _buildInfoRow('Teaching Assistant', 'Made Yuda Sadewa, S.Pd.'),
                  _buildInfoRow('Tema Project', 'KosFinder (Mamikos-Style Finder)'),
                  _buildInfoRow('State Management', 'Provider + ChangeNotifier'),
                  _buildInfoRow('Arsitektur', 'Clean Architecture (UI-Provider-Repo-Service)'),
                  _buildInfoRow('Database CRUD', 'Supabase / PostgreSQL + Local Cache'),
                  _buildInfoRow('REST API', 'HTTP GET JSON Mapping Model'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // App Settings & Actions
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.sync_rounded, color: Color(0xFF1BAA56)),
                      title: const Text('Sinkronkan Data Katalog & DB', style: TextStyle(fontSize: 14)),
                      subtitle: const Text('Muat ulang katalog REST API dan Database', style: TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        await kosProvider.init();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Data berhasil disinkronkan!'),
                              backgroundColor: Color(0xFF1BAA56),
                            ),
                          );
                        }
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.info_outline, color: Color(0xFF1BAA56)),
                      title: const Text('Tentang KosFinder v1.0.0', style: TextStyle(fontSize: 14)),
                      subtitle: const Text('Aplikasi pencarian & manajemen catatan kos UTS', style: TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'KosFinder UTS',
                          applicationVersion: '1.0.0+1',
                          applicationIcon: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1BAA56),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.apartment, color: Colors.white, size: 28),
                          ),
                          children: const [
                            Text('Dikembangkan oleh Jack Rich Loro (NIM: 2415051101) untuk Project Ujian Tengah Semester Pemrograman Mobile.'),
                          ],
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.security, color: Color(0xFF1BAA56)),
                      title: const Text('Worksheet 9 Hub (Auth & FCM)', style: TextStyle(fontSize: 14)),
                      subtitle: const Text('Status role, security test, dan token FCM', style: TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const HomePage()),
                          (route) => false,
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text('Keluar (Logout)', style: TextStyle(fontSize: 14, color: Colors.red)),
                      subtitle: const Text('Hapus session dan kembali ke login', style: TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.chevron_right, color: Colors.red),
                      onTap: () async {
                        await AuthService.instance.logout();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 12.5, color: Colors.grey)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
