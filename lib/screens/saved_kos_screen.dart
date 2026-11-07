import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/saved_kos_model.dart';
import '../providers/kos_provider.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/status_badge.dart';
import 'add_saved_kos_screen.dart';
import 'edit_saved_kos_screen.dart';

class SavedKosScreen extends StatelessWidget {
  const SavedKosScreen({super.key});

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
    return 'Rp $formatted/bln';
  }

  void _showDeleteConfirmation(BuildContext context, SavedKosModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('Hapus Catatan Kos?'),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus catatan untuk "${item.kosName}" dari database? Data yang dihapus tidak dapat dipulihkan.',
          style: const TextStyle(fontSize: 13.5, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final provider = context.read<KosProvider>();
              final success = await provider.deleteSavedKos(item.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Catatan "${item.kosName}" berhasil dihapus dari Database'
                          : 'Gagal menghapus catatan',
                    ),
                    backgroundColor: success ? Colors.red.shade700 : Colors.black87,
                  ),
                );
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kosProvider = context.watch<KosProvider>();
    final savedList = kosProvider.savedKosList;

    final filterTabs = [
      'Semua',
      'Rencana Survei',
      'Sudah Disurvei',
      'Booking Sukses',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        title: const Text(
          'Wishlist & Catatan Kos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF1BAA56),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_rounded, color: Colors.white, size: 24),
            tooltip: 'Tambah Catatan Baru',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddSavedKosScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 38,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: filterTabs.length,
                itemBuilder: (context, index) {
                  final tab = filterTabs[index];
                  final isSelected = kosProvider.savedStatusFilter == tab;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(tab),
                      selected: isSelected,
                      selectedColor: const Color(0xFF1BAA56),
                      backgroundColor: Colors.grey.shade100,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF1BAA56)
                              : Colors.grey.shade300,
                        ),
                      ),
                      onSelected: (_) {
                        kosProvider.setSavedStatusFilter(tab);
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          // Content List
          Expanded(
            child: RefreshIndicator(
              color: const Color(0xFF1BAA56),
              onRefresh: () async {
                await kosProvider.fetchSavedKos();
              },
              child: kosProvider.isLoadingSaved
                  ? const Center(
                      child: CircularProgressIndicator(color: Color(0xFF1BAA56)),
                    )
                  : savedList.isEmpty
                      ? EmptyStateWidget(
                          title: 'Belum Ada Kos Disimpan',
                          message:
                              'Temukan kos impianmu dan simpan catatan survei atau wishlist di sini.',
                          icon: Icons.favorite_border_rounded,
                          actionText: 'Jelajahi Kos Sekarang',
                          onAction: () {
                            kosProvider.setNavIndex(0); // Pindah ke tab Explore
                          },
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: savedList.length,
                          itemBuilder: (context, index) {
                            final item = savedList[index];
                            return _buildSavedKosCard(context, item);
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedKosCard(BuildContext context, SavedKosModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card: Gambar + Info Kos
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    item.kosImage,
                    width: 85,
                    height: 85,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      width: 85,
                      height: 85,
                      color: const Color(0xFFE8F8EE),
                      child: const Icon(Icons.apartment, color: Color(0xFF1BAA56), size: 36),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatusBadge.savedStatus(item.status),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 2),
                              Text(
                                item.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.kosName,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.kosAddress,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatPrice(item.kosPrice),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF008744),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // User Note Box
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FBF9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.note_alt_outlined, size: 14, color: Color(0xFF1BAA56)),
                    const SizedBox(width: 4),
                    const Text(
                      'Catatan Pribadi Mahasiswa:',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF008744),
                      ),
                    ),
                    const Spacer(),
                    if (item.visitDate.isNotEmpty)
                      Text(
                        'Target: ${item.visitDate}',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.note,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Action Buttons: Edit & Delete (with confirmation dialog)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditSavedKosScreen(item: item),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined, size: 15),
                  label: const Text('Edit Catatan', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1BAA56),
                    side: const BorderSide(color: Color(0xFF1BAA56)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
                  tooltip: 'Hapus Catatan',
                  onPressed: () => _showDeleteConfirmation(context, item),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
