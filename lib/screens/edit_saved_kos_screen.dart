import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/saved_kos_model.dart';
import '../providers/kos_provider.dart';

class EditSavedKosScreen extends StatefulWidget {
  final SavedKosModel item;

  const EditSavedKosScreen({super.key, required this.item});

  @override
  State<EditSavedKosScreen> createState() => _EditSavedKosScreenState();
}

class _EditSavedKosScreenState extends State<EditSavedKosScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _noteController;
  late double _rating;
  late String _status;
  DateTime? _visitDate;
  bool _isSubmitting = false;

  final List<String> _statusOptions = [
    'Rencana Survei',
    'Sudah Disurvei',
    'Booking Sukses',
  ];

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.item.note);
    _rating = widget.item.rating;
    _status = widget.item.status;
    if (widget.item.visitDate.isNotEmpty) {
      _visitDate = DateTime.tryParse(widget.item.visitDate);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _visitDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 60)),
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
        _visitDate = picked;
      });
    }
  }

  Future<void> _updateForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    final provider = context.read<KosProvider>();
    final updated = widget.item.copyWith(
      note: _noteController.text.trim(),
      rating: _rating,
      status: _status,
      visitDate: _visitDate != null
          ? '${_visitDate!.year}-${_visitDate!.month.toString().padLeft(2, '0')}-${_visitDate!.day.toString().padLeft(2, '0')}'
          : '',
    );

    final success = await provider.updateSavedKos(updated);

    setState(() => _isSubmitting = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Catatan kos berhasil diperbarui di Database!'),
            backgroundColor: Color(0xFF1BAA56),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.savedError ?? 'Gagal memperbarui catatan kos.'),
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
          'Edit Catatan Kos',
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
              // Header Card Kos Info
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
                        widget.item.kosImage,
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
                            widget.item.kosName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.item.kosAddress,
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

              // Form Field 1: Catatan Pribadi
              const Text(
                'Catatan Pribadi *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Tuliskan catatan perubahan survei atau booking...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Catatan tidak boleh kosong';
                  }
                  if (val.trim().length < 5) {
                    return 'Catatan minimal 5 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Form Field 2: Status
              const Text(
                'Status Rencana / Booking *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _status,
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
                  if (val != null) setState(() => _status = val);
                },
              ),
              const SizedBox(height: 16),

              // User Interaction: Rating
              const Text(
                'Rating Kepuasan / Prioritas',
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

              // Date Picker
              const Text(
                'Tanggal Survei / Mulai Masuk',
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
                        _visitDate != null
                            ? '${_visitDate!.day}/${_visitDate!.month}/${_visitDate!.year}'
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
                  onPressed: _isSubmitting ? null : _updateForm,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.update_rounded),
                  label: Text(
                    _isSubmitting ? 'Memperbarui...' : 'Simpan Perubahan',
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
