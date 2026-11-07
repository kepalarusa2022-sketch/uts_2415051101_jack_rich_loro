import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/kos_provider.dart';
import '../widgets/city_card.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/kos_card.dart';
import 'kos_detail_screen.dart';

class KosListScreen extends StatefulWidget {
  const KosListScreen({super.key});

  @override
  State<KosListScreen> createState() => _KosListScreenState();
}

class _KosListScreenState extends State<KosListScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _typeFilters = ['Semua', 'Campur', 'Putri', 'Putra'];
  final List<Map<String, dynamic>> _cities = [
    {'name': 'Semua', 'icon': Icons.public_rounded},
    {'name': 'Yogyakarta', 'icon': Icons.account_balance_rounded},
    {'name': 'Jabodetabek', 'icon': Icons.location_city_rounded},
    {'name': 'Bali', 'icon': Icons.beach_access_rounded},
    {'name': 'Surabaya', 'icon': Icons.domain_rounded},
    {'name': 'Bandung', 'icon': Icons.park_rounded},
  ];

  @override
  void initState() {
    super.initState();
    final provider = context.read<KosProvider>();
    _searchController.text = provider.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kosProvider = context.watch<KosProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1BAA56),
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
                image: const DecorationImage(
                  image: AssetImage('assets/images/profile.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'mamikos.com',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
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
                      content: Text('99+ penawaran kos terbaru tersedia!'),
                    ),
                  );
                },
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5252),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: const Text(
                    '99',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive condition: Compact vs Wide
          final isWide = constraints.maxWidth >= 600;
          final crossAxisCount = isWide ? 4 : 2;
          final childAspectRatio = isWide ? 0.82 : 0.65;

          return RefreshIndicator(
            color: const Color(0xFF1BAA56),
            onRefresh: () async {
              await kosProvider.fetchCatalog();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Search Bar Section
                  Container(
                    color: const Color(0xFF1BAA56),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: CustomSearchBar(
                      controller: _searchController,
                      hintText: 'Cari nama kos, lokasi, kota...',
                      onChanged: (val) {
                        kosProvider.setSearchQuery(val);
                      },
                      onFilterTap: () {
                        _showFilterBottomSheet(context);
                      },
                    ),
                  ),

                  // Filter Chips (Gender: Semua, Campur, Putri, Putra)
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      height: 38,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: _typeFilters.length,
                        itemBuilder: (context, index) {
                          final type = _typeFilters[index];
                          final isSelected =
                              kosProvider.selectedTypeFilter == type;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(type),
                              selected: isSelected,
                              selectedColor: const Color(0xFF1BAA56),
                              backgroundColor: Colors.grey.shade100,
                              labelStyle: TextStyle(
                                fontSize: 12.5,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected
                                      ? const Color(0xFF1BAA56)
                                      : Colors.grey.shade300,
                                ),
                              ),
                              onSelected: (_) {
                                kosProvider.setTypeFilter(type);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Status Info / Hasil Pencarian
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daftar Kos (${kosProvider.kosList.length})',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        if (kosProvider.searchQuery.isNotEmpty ||
                            kosProvider.selectedTypeFilter != 'Semua' ||
                            kosProvider.selectedCityFilter != 'Semua')
                          TextButton(
                            onPressed: () {
                              _searchController.clear();
                              kosProvider.resetFilters();
                            },
                            child: const Text(
                              'Reset Filter',
                              style: TextStyle(
                                color: Color(0xFF1BAA56),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Content: Loading, Error, Empty, or Grid
                  if (kosProvider.isLoadingCatalog)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF1BAA56),
                        ),
                      ),
                    )
                  else if (kosProvider.catalogError != null)
                    ErrorStateWidget(
                      message: kosProvider.catalogError!,
                      onRetry: () => kosProvider.fetchCatalog(),
                    )
                  else if (kosProvider.kosList.isEmpty)
                    EmptyStateWidget(
                      title: 'Kos Tidak Ditemukan',
                      message:
                          'Tidak ada kos yang cocok dengan kriteria pencarian Anda. Coba kata kunci atau filter lain.',
                      onAction: () {
                        _searchController.clear();
                        kosProvider.resetFilters();
                      },
                      actionText: 'Tampilkan Semua Kos',
                    )
                  else
                    // Responsive Grid View
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: kosProvider.kosList.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemBuilder: (context, index) {
                          final kos = kosProvider.kosList[index];
                          return KosCard(
                            kos: kos,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      KosDetailScreen(kos: kos),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 24),

                  // ==================== SECTION: TEMUKAN MAMIKOS DI KOTAMU ====================
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.place,
                                color: Color(0xFF1BAA56),
                                size: 22,
                              ),
                              SizedBox(width: 6),
                              Text(
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
                        const SizedBox(height: 14),
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
                                isSelected: kosProvider.selectedCityFilter ==
                                    city['name'],
                                onTap: () {
                                  kosProvider.setCityFilter(
                                      city['name'] as String);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final kosProvider = context.read<KosProvider>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Pencarian Kos',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    'Tipe Penghuni',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _typeFilters.map((type) {
                      final selected =
                          kosProvider.selectedTypeFilter == type;
                      return ChoiceChip(
                        label: Text(type),
                        selected: selected,
                        selectedColor: const Color(0xFF1BAA56),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : Colors.black87,
                        ),
                        onSelected: (_) {
                          kosProvider.setTypeFilter(type);
                          setModalState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pilih Wilayah / Kota',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _cities.map((city) {
                      final cityName = city['name'] as String;
                      final selected =
                          kosProvider.selectedCityFilter == cityName;
                      return ChoiceChip(
                        label: Text(cityName),
                        selected: selected,
                        selectedColor: const Color(0xFF1BAA56),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : Colors.black87,
                        ),
                        onSelected: (_) {
                          kosProvider.setCityFilter(cityName);
                          setModalState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1BAA56),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Terapkan Filter',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
