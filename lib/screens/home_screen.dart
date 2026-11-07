import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/kos_model.dart';
import '../providers/kos_provider.dart';
import '../widgets/banner_slider.dart';
import '../widgets/category_item.dart';
import '../widgets/city_card.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/status_badge.dart';
import 'add_edit_kos_screen.dart';
import 'kos_detail_screen.dart';
import 'kos_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {'title': 'Kamar Kos', 'icon': Icons.single_bed_rounded},
    {'title': 'Apartemen', 'icon': Icons.apartment_rounded},
    {'title': 'Barang & Jasa', 'icon': Icons.card_giftcard_rounded},
    {'title': 'Pekerjaan', 'icon': Icons.work_outline_rounded},
  ];

  final List<Map<String, dynamic>> _cities = [
    {'name': 'Yogyakarta', 'icon': Icons.account_balance_rounded},
    {'name': 'Jabodetabek', 'icon': Icons.location_city_rounded},
    {'name': 'Bali', 'icon': Icons.beach_access_rounded},
    {'name': 'Surabaya', 'icon': Icons.domain_rounded},
    {'name': 'Bandung', 'icon': Icons.park_rounded},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToCatalog({String? filterType, String? filterCity}) {
    final provider = context.read<KosProvider>();
    if (filterType != null) provider.setTypeFilter(filterType);
    if (filterCity != null) provider.setCityFilter(filterCity);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const KosListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kosProvider = context.watch<KosProvider>();
    final mamirooms = kosProvider.allKos;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditKosScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF1BAA56),
        icon: const Icon(Icons.add_home_work_rounded, color: Colors.white),
        label: const Text(
          'Tambah Kos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF1BAA56),
          onRefresh: () async {
            await kosProvider.fetchCatalog();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================== HEADER HIJAU MAMIKOS ====================
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1BAA56),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Avatar + mamikos.com + Notifikasi (99)
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/profile.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'mamikos.com',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const Spacer(),
                          // Tombol Tambah Kos Baru
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddEditKosScreen(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.22),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white70, width: 1),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.add_circle_outline, color: Colors.white, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    'Tambah Kos',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          // Notifikasi Bell dengan badge 99
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.notifications_none_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Anda memiliki 99+ promo dan rekomendasi kos baru!'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.5,
                                    vertical: 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF5252),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Text(
                                    '99',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Headline: "Kamu mau ngekos dimana ?"
                      const Text(
                        'Kamu mau ngekos dimana ?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Search Bar
                      CustomSearchBar(
                        controller: _searchController,
                        hintText: 'Masukkan alamat atau nama tempat',
                        readOnly: true,
                        onTap: () {
                          _navigateToCatalog();
                        },
                        onFilterTap: () {
                          _navigateToCatalog();
                        },
                      ),
                      const SizedBox(height: 16),

                      // Promo Carousel Banner Card (Mamikos Promo Slider)
                      BannerSlider(
                        onVoucherTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Voucher BISABOOKING berhasil disalin! Diskon Rp 50.000'),
                              backgroundColor: Color(0xFF0D6832),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Quick Action Bar: Tambah Kos Baru
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE8F8EE), Color(0xFFD4F3DE)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFB8E6C8)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1BAA56),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add_home_work_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Punya Kamar Kos Kosong?',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Tambah data kos baru ke katalog KosFinder',
                                style: TextStyle(fontSize: 11, color: Color(0xFF008744)),
                              ),
                            ],
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
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Tambah Kos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1BAA56),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ==================== SECTION: KATEGORI LAIN ====================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Kategori lain',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      InkWell(
                        onTap: () => _navigateToCatalog(),
                        child: const Text(
                          'Lihat semua',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1BAA56),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 4 Category Icons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_categories.length, (index) {
                      final item = _categories[index];
                      return CategoryItem(
                        icon: item['icon'] as IconData,
                        title: item['title'] as String,
                        isSelected: _selectedCategoryIndex == index,
                        onTap: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                          if (index == 0) {
                            _navigateToCatalog();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Kategori ${item['title']} segera hadir! Menampilkan kos rekomendasi.'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                            _navigateToCatalog();
                          }
                        },
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 24),

                // ==================== SECTION: MAMIROOMS / KOSFINDER ROOMS ====================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Mamirooms',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          InkWell(
                            onTap: () => _navigateToCatalog(),
                            child: const Text(
                              'Lihat semua',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1BAA56),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Kos yang dikelola langsung oleh pengelola professional mamikos',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Horizontal scroll room cards
                SizedBox(
                  height: 195,
                  child: mamirooms.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF1BAA56),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: mamirooms.length,
                          itemBuilder: (context, index) {
                            final kos = mamirooms[index];
                            return _buildMamiroomCard(kos);
                          },
                        ),
                ),

                const SizedBox(height: 24),

                // ==================== SECTION: TEMUKAN MAMIKOS DI KOTAMU ====================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.place,
                        color: Color(0xFF1BAA56),
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Temukan Mamikos di kotamu !',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // City horizontal cards
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _cities.length,
                    itemBuilder: (context, index) {
                      final city = _cities[index];
                      return CityCard(
                        cityName: city['name'] as String,
                        landmarkIcon: city['icon'] as IconData,
                        isSelected:
                            kosProvider.selectedCityFilter == city['name'],
                        onTap: () {
                          _navigateToCatalog(filterCity: city['name'] as String);
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMamiroomCard(KosModel kos) {
    return Container(
      width: 175,
      margin: const EdgeInsets.only(right: 12, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KosDetailScreen(kos: kos),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFE8F8EE),
                        child: const Icon(
                          Icons.bed_rounded,
                          color: Color(0xFF1BAA56),
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: const CircleBorder(),
                    elevation: 1,
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
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.edit_rounded,
                          size: 14,
                          color: Color(0xFF1BAA56),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StatusBadge.gender(kos.type),
                      const SizedBox(width: 4),
                      if (kos.isCanBooking) StatusBadge.booking(),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    kos.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Rp ${kos.price ~/ 1000}rb/bln',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF008744),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
