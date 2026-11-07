import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/kos_model.dart';
import '../models/saved_kos_model.dart';
import '../providers/kos_provider.dart';

class AddSavedKosScreen extends StatefulWidget {
  final KosModel? kos;

  const AddSavedKosScreen({super.key, this.kos});

  @override
  State<AddSavedKosScreen> createState() => _AddSavedKosScreenState();
}

class _AddSavedKosScreenState extends State<AddSavedKosScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _noteController;
  late TextEditingController _priceController;

  double _rating = 5.0;
  String _selectedStatus = 'Rencana Survei';
  DateTime? _selectedDate;
  bool _isSubmitting = false;

  final List<String> _statusOptions = [
    'Rencana Survei',
    'Sudah Disurvei',
    'Booking Sukses',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.kos?.name ?? '');
    _priceController = TextEditingController(
      text: widget.kos != null ? widget.kos!.price.toString() : '2000000',
    );
    _noteController = TextEditingController();
    _selectedDate = DateTime.now().add(const Duration(days: 3));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1BAA56),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    final provider = context.read<KosProvider>();
    final newId = 'saved_${DateTime.now().millisecondsSinceEpoch}';

    final newItem = SavedKosModel(
      id: newId,
      studentId: '2415051101',
      kosId: widget.kos?.id ?? 'kos_custom_${DateTime.now().millisecondsSinceEpoch}',
      kosName: _nameController.text.trim(),
      kosPrice: int.tryParse(_priceController.text.trim()) ?? 0,
      kosType: widget.kos?.type ?? 'Campur',
      kosAddress: widget.kos?.address ?? 'Sleman, Yogyakarta',
      kosImage: widget.kos?.imageUrl ??
          'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=800&auto=format&fit=crop&q=80',
      note: _noteController.text.trim(),
      rating: _rating,
      status: _selectedStatus,
      visitDate: _selectedDate != null
          ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
          : '',
      createdAt: DateTime.now().toIso8601String(),
    );

    final success = await provider.createSavedKos(newItem);

    setState(() => _isSubmitting = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Catatan kos berhasil disimpan ke Database!'),
            backgroundColor: Color(0xFF1BAA56),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.savedError ?? 'Gagal menyimpan ke database.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tambah Catatan Kos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
              // Header Card jika memilih dari detail
              if (widget.kos != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8EE),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFC8E6C9)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.kos!.imageUrl,
                          width: 65,
                          height: 65,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(
                            width: 65,
                            height: 65,
                            color: Colors.green.shade100,
                            child: const Icon(Icons.apartment, color: Color(0xFF1BAA56)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.kos!.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.kos!.address,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Form Field 1: Nama Kos
              const Text(
                'Nama Kos *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                readOnly: widget.kos != null,
                decoration: InputDecoration(
                  hintText: 'Contoh: Kost Wisma Divina Sejahtera',
                  prefixIcon: const Icon(Icons.apartment, color: Color(0xFF1BAA56)),
                  filled: widget.kos != null,
                  fillColor: widget.kos != null ? Colors.grey.shade100 : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Nama kos wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Form Field 2: Catatan Pribadi (min 5 chars)
              const Text(
                'Catatan Pribadi / Review Rencana *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Tuliskan catatan khusus, kelebihan kos, atau hal yang perlu dicek saat survei...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Catatan pribadi wajib diisi';
                  }
                  if (val.trim().length < 5) {
                    return 'Catatan minimal 5 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Form Field 3: Status Survei / Booking
              const Text(
                'Status Rencana *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.bookmark_outline, color: Color(0xFF1BAA56)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _statusOptions.map((st) {
                  return DropdownMenuItem(value: st, child: Text(st));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedStatus = val);
                },
              ),
              const SizedBox(height: 16),

              // User Interaction 4: Rating Bintang Interaktif (1-5 Bintang)
              const Text(
                'Rating Prioritas Pilihan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  ...List.generate(5, (index) {
                    final starVal = index + 1;
                    return IconButton(
                      icon: Icon(
                        _rating >= starVal ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() => _rating = starVal.toDouble());
                      },
                    );
                  }),
                  const SizedBox(width: 8),
                  Text(
                    '${_rating.toStringAsFixed(1)} / 5.0',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // User Interaction 5: Tanggal Kunjungan / Survei
              const Text(
                'Rencana Tanggal Survei / Masuk',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Color(0xFF1BAA56)),
                      const SizedBox(width: 10),
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : 'Pilih Tanggal',
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submitForm,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.save_rounded),
                  label: Text(
                    _isSubmitting ? 'Menyimpan ke Database...' : 'Simpan Catatan Kos',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1BAA56),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
