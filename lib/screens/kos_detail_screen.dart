import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/kos_model.dart';
import '../providers/kos_provider.dart';
import '../widgets/status_badge.dart';
import 'add_edit_kos_screen.dart';
import 'add_saved_kos_screen.dart';

class KosDetailScreen extends StatefulWidget {
  final KosModel kos;

  const KosDetailScreen({super.key, required this.kos});

  @override
  State<KosDetailScreen> createState() => _KosDetailScreenState();
}

class _KosDetailScreenState extends State<KosDetailScreen> {
  int _selectedImageIndex = 0;

  String _formatPrice(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    final formatted = buffer.toString().split('').reversed.join('');
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    final kos = widget.kos;
    final kosProvider = context.watch<KosProvider>();
    final isSaved = kosProvider.isKosSaved(kos.id);
    final gallery = kos.images.isNotEmpty ? kos.images : [kos.imageUrl];

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 700;

          if (isWide) {
            // Tablet / Desktop Wide Layout (Side-by-side)
            return Column(
              children: [
                // Top Header Bar Desktop / Wide Screen
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black87),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          kos.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      // Tombol Edit Kos
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditKosScreen(kosToEdit: kos),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit_note_rounded, size: 18),
                        label: const Text('Edit Data Kos', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Tombol Tambah Kos Baru
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddEditKosScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_home_work_rounded, size: 18),
                        label: const Text('+ Tambah Kos Baru', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1BAA56),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: Icon(
                          isSaved ? Icons.favorite : Icons.favorite_border,
                          color: isSaved ? Colors.red : Colors.grey.shade700,
                        ),
                        onPressed: () async {
                          await kosProvider.toggleWishlist(kos);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isSaved
                                      ? 'Dihapus dari Wishlist'
                                      : 'Disimpan ke Wishlist & Catatan',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          color: Colors.black12,
                          child: Center(
                            child: Image.network(
                              gallery[_selectedImageIndex],
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                              errorBuilder: (ctx, err, stack) => const Center(
                                child: Icon(Icons.apartment, size: 80, color: Color(0xFF1BAA56)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(24),
                                child: _buildDetailContent(context, kos, isSaved, kosProvider),
                              ),
                            ),
                            // Persistent bottom action bar in wide mode!
                            _buildBottomActionBar(context, kos, isSaved),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // Mobile Layout (Vertical Scroll)
          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // Sliver App Bar with Image Carousel
                  SliverAppBar(
                    expandedHeight: 280,
                    pinned: true,
                    backgroundColor: const Color(0xFF1BAA56),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    actions: [
                      CircleAvatar(
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                        child: IconButton(
                          icon: const Icon(Icons.edit_note_rounded, color: Color(0xFF1BAA56), size: 22),
                          tooltip: 'Edit Data Kos',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEditKosScreen(kosToEdit: kos),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                        child: IconButton(
                          icon: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            color: isSaved ? Colors.red : Colors.black87,
                            size: 22,
                          ),
                          onPressed: () async {
                            await kosProvider.toggleWishlist(kos);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isSaved
                                        ? 'Dihapus dari Wishlist'
                                        : 'Disimpan ke Wishlist & Catatan',
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                        child: IconButton(
                          icon: const Icon(Icons.share, color: Colors.black87, size: 20),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Tautan ${kos.name} siap dibagikan!'),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          PageView.builder(
                            itemCount: gallery.length,
                            onPageChanged: (i) {
                              setState(() => _selectedImageIndex = i);
                            },
                            itemBuilder: (context, i) {
                              return Image.network(
                                gallery[i],
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) => Container(
                                  color: const Color(0xFFE8F8EE),
                                  child: const Center(
                                    child: Icon(Icons.apartment, size: 60, color: Color(0xFF1BAA56)),
                                  ),
                                ),
                              );
                            },
                          ),
                          // Gallery Dots Indicator
                          if (gallery.length > 1)
                            Positioned(
                              bottom: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${_selectedImageIndex + 1}/${gallery.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Detail Body Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      child: _buildDetailContent(context, kos, isSaved, kosProvider),
                    ),
                  ),
                ],
              ),

              // Bottom Persistent Action Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomActionBar(context, kos, isSaved),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailContent(
    BuildContext context,
    KosModel kos,
    bool isSaved,
    KosProvider kosProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ==================== PANEL KELOLA KOS (EDIT & TAMBAH) ====================
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F8F3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFB9E5C5), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.dashboard_customize_rounded, color: Color(0xFF008744), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Kelola & Manajemen Kos:',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF008744),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditKosScreen(kosToEdit: kos),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit_note_rounded, size: 20),
                    label: const Text('Edit Data Kos Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade800,
                      foregroundColor: Colors.white,
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddEditKosScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_home_work_rounded, size: 20),
                    label: const Text('+ Tambah Kos Baru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1BAA56),
                      foregroundColor: Colors.white,
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Badges Row
        Row(
          children: [
            if (kos.isCanBooking) ...[
              StatusBadge.booking(),
              const SizedBox(width: 6),
            ],
            StatusBadge.gender(kos.type),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, size: 13, color: Colors.amber),
                  const SizedBox(width: 3),
                  Text(
                    '${kos.rating} (${kos.reviewCount} ulasan)',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Title
        Text(
          kos.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),

        // Address
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_on, size: 18, color: Color(0xFF1BAA56)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                kos.address,
                style: TextStyle(
                  fontSize: 13.5,
                  color: Colors.grey.shade700,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Tombol Edit Data Kos
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditKosScreen(kosToEdit: kos),
              ),
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8EE),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFC8E6C9)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.edit_note_rounded, size: 18, color: Color(0xFF008744)),
                SizedBox(width: 6),
                Text(
                  'Edit Data Kos Ini',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF008744),
                  ),
                ),
              ],
            ),
          ),
        ),

        const Divider(height: 32),

        // Spesifikasi Kamar Box
        const Text(
          'Spesifikasi Kamar',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FBF9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSpecItem(Icons.aspect_ratio_rounded, 'Ukuran Kamar', kos.roomSize),
              _buildSpecItem(
                Icons.bolt_rounded,
                'Biaya Listrik',
                kos.isElectricIncluded ? 'Termasuk' : 'Token Listrik',
              ),
              _buildSpecItem(Icons.bathtub_outlined, 'Kamar Mandi', 'Dalam'),
            ],
          ),
        ),

        const Divider(height: 32),

        // Fasilitas Kos
        const Text(
          'Fasilitas Populer',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: kos.facilities.map((fac) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, size: 14, color: Color(0xFF1BAA56)),
                  const SizedBox(width: 6),
                  Text(
                    fac,
                    style: const TextStyle(fontSize: 12.5, color: Colors.black87),
                  ),
                ],
              ),
            );
          }).toList(),
        ),

        const Divider(height: 32),

        // Deskripsi Kos
        const Text(
          'Deskripsi Kos',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          kos.description,
          style: TextStyle(
            fontSize: 13.5,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),

        const Divider(height: 32),

        // Peraturan Kos
        const Text(
          'Peraturan Khusus Kos',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: kos.rules.map((rule) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      rule,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),

        const Divider(height: 32),

        // Profil Pemilik / Pengelola
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F8EE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFF1BAA56),
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kos.ownerName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Pengelola Terverifikasi KosFinder',
                      style: TextStyle(fontSize: 11.5, color: Color(0xFF008744)),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  _showChatDialog(context, kos);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1BAA56),
                  side: const BorderSide(color: Color(0xFF1BAA56)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Chat', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1BAA56), size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(BuildContext context, KosModel kos, bool isSaved) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Harga
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatPrice(kos.price),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF008744),
                  ),
                ),
                Text(
                  '/ bulan',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(width: 10),

            // Tombol Edit Kos Cepat
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditKosScreen(kosToEdit: kos),
                  ),
                );
              },
              icon: const Icon(Icons.edit_note_rounded, size: 18),
              label: const Text('Edit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.amber.shade900,
                side: BorderSide(color: Colors.amber.shade700, width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(width: 8),

            // Tombol Simpan Catatan / Ke Database
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddSavedKosScreen(kos: kos),
                    ),
                  );
                },
                icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                label: const Text(
                  'Simpan / Catat',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1BAA56),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Tombol Ajukan Sewa / Booking
            IconButton(
              icon: const Icon(Icons.phone_in_talk, color: Color(0xFF1BAA56)),
              onPressed: () => _showContactDialog(context, kos),
            ),
          ],
        ),
      ),
    );
  }

  void _showChatDialog(BuildContext context, KosModel kos) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Hubungi ${kos.ownerName}'),
        content: Text(
          'Mulai percakapan langsung dengan pengelola ${kos.name} via WhatsApp di nomor ${kos.ownerPhone}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1BAA56)),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Menghubungkan ke ${kos.ownerPhone}...'),
                ),
              );
            },
            child: const Text('Buka Chat', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context, KosModel kos) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kontak Pemilik Kos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${kos.ownerName}'),
            const SizedBox(height: 6),
            Text('Telepon: ${kos.ownerPhone}'),
            const SizedBox(height: 6),
            Text('Alamat: ${kos.address}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1BAA56)),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Panggilan dialirkan...')),
              );
            },
            child: const Text('Panggil', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
