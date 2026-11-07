import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/kos_model.dart';
import '../providers/kos_provider.dart';
import '../screens/add_edit_kos_screen.dart';
import 'status_badge.dart';

class KosCard extends StatelessWidget {
  final KosModel kos;
  final VoidCallback? onTap;

  const KosCard({
    super.key,
    required this.kos,
    this.onTap,
  });

  String _formatPrice(int price) {
    // Format angka ke format mata uang Rupiah
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
    return 'Rp. $formatted/bln';
  }

  @override
  Widget build(BuildContext context) {
    final kosProvider = context.watch<KosProvider>();
    final isSaved = kosProvider.isKosSaved(kos.id);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 1),
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
            // Gambar Kos + Tombol Wishlist
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Image.network(
                      kos.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFE8F5E9),
                          child: Center(
                            child: Icon(
                              Icons.apartment,
                              color: Colors.green.shade600,
                              size: 40,
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF1BAA56),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Tombol Edit Kos Cepat
                Positioned(
                  top: 8,
                  left: 8,
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditKosScreen(kosToEdit: kos),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.edit_rounded,
                          color: Color(0xFF1BAA56),
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.85),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () async {
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
                              backgroundColor:
                                  isSaved ? Colors.grey.shade800 : const Color(0xFF1BAA56),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          isSaved ? Icons.favorite : Icons.favorite_border,
                          color: isSaved ? Colors.red : Colors.grey.shade700,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Konten Teks
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row Badges
                        Row(
                          children: [
                            if (kos.isCanBooking) ...[
                              StatusBadge.booking(),
                              const SizedBox(width: 4),
                            ],
                            StatusBadge.gender(kos.type),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Nama Kos
                        Text(
                          kos.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Lokasi / Alamat
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 13,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                kos.city,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Harga & Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            _formatPrice(kos.price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              kos.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
