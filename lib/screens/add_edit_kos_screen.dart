import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/kos_model.dart';
import '../providers/kos_provider.dart';

class AddEditKosScreen extends StatefulWidget {
  final KosModel? kosToEdit;

  const AddEditKosScreen({super.key, this.kosToEdit});

  @override
  State<AddEditKosScreen> createState() => _AddEditKosScreenState();
}

class _AddEditKosScreenState extends State<AddEditKosScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _addressController;
  late TextEditingController _roomSizeController;
  late TextEditingController _descriptionController;
  late TextEditingController _ownerNameController;
  late TextEditingController _ownerPhoneController;
  late TextEditingController _imageUrlController;

  String _selectedType = 'Campur';
  String _selectedCity = 'Yogyakarta';
  bool _isCanBooking = true;
  bool _isElectricIncluded = true;

  final List<String> _availableTypes = ['Campur', 'Putri', 'Putra'];
  final List<String> _availableCities = [
    'Yogyakarta',
    'Jabodetabek',
    'Bali',
    'Surabaya',
    'Bandung',
  ];

  final List<String> _allFacilities = [
    'Kamar Mandi Dalam',
    'AC Dingin',
    'WiFi Cepat 50 Mbps',
    'Kasur Springbed',
    'Lemari Pakaian',
    'Meja Belajar',
    'Water Heater',
    'Parkir Luas',
    'Dapur Bersama',
    'CCTV 24 Jam',
  ];

  late List<String> _selectedFacilities;

  @override
  void initState() {
    super.initState();
    final kos = widget.kosToEdit;

    _nameController = TextEditingController(text: kos?.name ?? '');
    _priceController = TextEditingController(
      text: kos != null ? kos.price.toString() : '1850000',
    );
    _addressController = TextEditingController(text: kos?.address ?? '');
    _roomSizeController = TextEditingController(text: kos?.roomSize ?? '3 x 4 m');
    _descriptionController = TextEditingController(
      text: kos?.description ??
          'Kost nyaman, bersih, dan strategis dekat kampus dan pusat perbelanjaan.',
    );
    _ownerNameController = TextEditingController(text: kos?.ownerName ?? 'Ibu Kos');
    _ownerPhoneController =
        TextEditingController(text: kos?.ownerPhone ?? '+6281234567890');
    _imageUrlController = TextEditingController(
      text: kos?.imageUrl ??
          'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=800&auto=format&fit=crop&q=80',
    );

    if (kos != null) {
      _selectedType = kos.type;
      _selectedCity = kos.city.isNotEmpty ? kos.city : 'Yogyakarta';
      _isCanBooking = kos.isCanBooking;
      _isElectricIncluded = kos.isElectricIncluded;
      _selectedFacilities = List<String>.from(kos.facilities);
    } else {
      _selectedFacilities = [
        'Kamar Mandi Dalam',
        'AC Dingin',
        'WiFi Cepat 50 Mbps',
        'Kasur Springbed',
      ];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _roomSizeController.dispose();
    _descriptionController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveKos() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final kosProvider = context.read<KosProvider>();
    final isEditing = widget.kosToEdit != null;

    final id = isEditing
        ? widget.kosToEdit!.id
        : 'kos_${DateTime.now().millisecondsSinceEpoch}';

    final kosData = KosModel(
      id: id,
      name: _nameController.text.trim(),
      type: _selectedType,
      price: int.tryParse(_priceController.text.trim()) ?? 0,
      priceUnit: '/bln',
      address: _addressController.text.trim(),
      city: _selectedCity,
      imageUrl: _imageUrlController.text.trim(),
      images: [
        _imageUrlController.text.trim(),
        'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=800&auto=format&fit=crop&q=80',
      ],
      rating: widget.kosToEdit?.rating ?? 4.9,
      reviewCount: widget.kosToEdit?.reviewCount ?? 12,
      isCanBooking: _isCanBooking,
      roomSize: _roomSizeController.text.trim(),
      isElectricIncluded: _isElectricIncluded,
      facilities: _selectedFacilities,
      description: _descriptionController.text.trim(),
      rules: widget.kosToEdit?.rules.isNotEmpty == true
          ? widget.kosToEdit!.rules
          : [
              'Akses gerbang 24 jam dengan kartu akses',
              'Tamu lawan jenis dilarang masuk kamar',
              'Menjaga kebersihan bersama',
            ],
      ownerName: _ownerNameController.text.trim(),
      ownerPhone: _ownerPhoneController.text.trim(),
    );

    if (isEditing) {
      kosProvider.updateKos(kosData);
    } else {
      kosProvider.addKos(kosData);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditing
              ? 'Data "${kosData.name}" berhasil diperbarui!'
              : 'Kos baru "${kosData.name}" berhasil ditambahkan ke Katalog!',
        ),
        backgroundColor: const Color(0xFF1BAA56),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.kosToEdit != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Data Kos' : 'Tambah Kos Baru',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF1BAA56),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8EE),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFC8E6C9)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF1BAA56), size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isEditing
                            ? 'Ubah data dan detail kos sesuai kebutuhan Anda.'
                            : 'Lengkapi formulir di bawah ini untuk menambahkan kos baru ke katalog pencarian KosFinder.',
                        style: const TextStyle(fontSize: 12.5, color: Color(0xFF008744)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 1. Nama Kos
              const Text('Nama Kos *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Contoh: Kost Wisma Bahagia Seturan',
                  prefixIcon: const Icon(Icons.home_work_outlined, color: Color(0xFF1BAA56)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Nama kos wajib diisi';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 2. Tipe Penghuni
              const Text('Tipe Penghuni *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: _availableTypes.map((type) {
                  final isSelected = _selectedType == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(type),
                      selected: isSelected,
                      selectedColor: const Color(0xFF1BAA56),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) => setState(() => _selectedType = type),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // 3. Harga Sewa per Bulan
              const Text('Harga Sewa per Bulan (Rp) *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Contoh: 1850000',
                  prefixIcon: const Icon(Icons.payments_outlined, color: Color(0xFF1BAA56)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Harga sewa wajib diisi';
                  if (int.tryParse(val.trim()) == null) return 'Harga harus berupa angka';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 4. Kota / Wilayah
              const Text('Kota / Wilayah *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedCity,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_city, color: Color(0xFF1BAA56)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                items: _availableCities.map((city) {
                  return DropdownMenuItem(value: city, child: Text(city));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCity = val);
                },
              ),

              const SizedBox(height: 16),

              // 5. Alamat Lengkap
              const Text('Alamat Lengkap *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Contoh: Jl. Kaliurang KM 5.2, Sleman, Yogyakarta',
                  prefixIcon: const Icon(Icons.place_outlined, color: Color(0xFF1BAA56)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Alamat kos wajib diisi';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 6. Ukuran Kamar
              const Text('Ukuran Kamar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _roomSizeController,
                decoration: InputDecoration(
                  hintText: 'Contoh: 3 x 4 m',
                  prefixIcon: const Icon(Icons.aspect_ratio, color: Color(0xFF1BAA56)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),

              const SizedBox(height: 16),

              // 7. URL Foto Kamar
              const Text('URL Foto Kamar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  hintText: 'Masukkan URL gambar ruangan...',
                  prefixIcon: const Icon(Icons.image_outlined, color: Color(0xFF1BAA56)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),

              const SizedBox(height: 16),

              // 8. Fasilitas Kamar
              const Text('Fasilitas Kos & Kamar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _allFacilities.map((facility) {
                  final isSelected = _selectedFacilities.contains(facility);
                  return FilterChip(
                    label: Text(facility),
                    selected: isSelected,
                    selectedColor: const Color(0xFF1BAA56),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedFacilities.add(facility);
                        } else {
                          _selectedFacilities.remove(facility);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // 9. Deskripsi Kos
              const Text('Deskripsi Kos *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Jelaskan keunggulan, suasana, dan fasilitas sekitarnya...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Deskripsi wajib diisi';
                  if (val.trim().length < 5) return 'Deskripsi minimal 5 karakter';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // 10. Kontak Pengelola
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Nama Pengelola', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _ownerNameController,
                          decoration: InputDecoration(
                            hintText: 'Ibu/Bapak Kos',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Nomor WhatsApp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _ownerPhoneController,
                          decoration: InputDecoration(
                            hintText: '+628123456...',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Opsi Tambahan (Bisa Booking & Termasuk Listrik)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: const Color(0xFF1BAA56),
                title: const Text('Bisa Booking Langsung', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Menampilkan lencana "Bisa Booking" di kartu kos', style: TextStyle(fontSize: 12)),
                value: _isCanBooking,
                onChanged: (val) => setState(() => _isCanBooking = val),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: const Color(0xFF1BAA56),
                title: const Text('Biaya Listrik Termasuk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Harga sewa sudah termasuk penggunaan listrik', style: TextStyle(fontSize: 12)),
                value: _isElectricIncluded,
                onChanged: (val) => setState(() => _isElectricIncluded = val),
              ),

              const SizedBox(height: 30),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveKos,
                  icon: Icon(isEditing ? Icons.save_as_rounded : Icons.add_home_work_rounded),
                  label: Text(
                    isEditing ? 'Simpan Perubahan Kos' : 'Tambah ke Katalog Kos',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1BAA56),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
