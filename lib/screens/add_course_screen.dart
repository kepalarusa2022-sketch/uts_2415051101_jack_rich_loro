import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({Key? key}) : super(key: key);

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controller untuk menangkap input teks
  final _titleController = TextEditingController();
  final _dayController = TextEditingController();
  final _timeController = TextEditingController();
  final _roomController = TextEditingController();
  final _lecturerController = TextEditingController();
  final _creditsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _dayController.dispose();
    _timeController.dispose();
    _roomController.dispose();
    _lecturerController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  void _saveForm() {
    // Validasi form (Syarat UTS: Form dengan validasi)
    if (_formKey.currentState!.validate()) {
      final newCourse = CourseModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        day: _dayController.text,
        time: _timeController.text,
        room: _roomController.text,
        lecturer: _lecturerController.text,
        credits: int.parse(_creditsController.text),
      );

      // Simpan data melalui Provider
      Provider.of<CourseProvider>(context, listen: false).addNewCourse(newCourse);

      // Kembali ke screen sebelumnya & tampilkan SnackBar
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jadwal kuliah berhasil ditambahkan!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Jadwal Kuliah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Nama Mata Kuliah'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama mata kuliah tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dayController,
                decoration: const InputDecoration(labelText: 'Hari (Contoh: Senin)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Hari harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Jam (Contoh: 08:00 - 10:30)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jam harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(labelText: 'Ruangan (Contoh: Lab Komputer 1)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ruangan harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lecturerController,
                decoration: const InputDecoration(labelText: 'Nama Dosen Pengampu'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama dosen harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _creditsController,
                decoration: const InputDecoration(labelText: 'Jumlah SKS (Angka)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah SKS harus diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'SKS harus berupa angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Simpan Jadwal', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}