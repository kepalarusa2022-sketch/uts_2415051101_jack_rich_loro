import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class EditCourseScreen extends StatefulWidget {
  final CourseModel course;

  const EditCourseScreen({Key? key, required this.course}) : super(key: key);

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _dayController;
  late TextEditingController _timeController;
  late TextEditingController _roomController;
  late TextEditingController _lecturerController;
  late TextEditingController _creditsController;

  @override
  void initState() {
    super.initState();
    // Mengisi data awal form dengan data mata kuliah yang mau diedit
    _titleController = TextEditingController(text: widget.course.title);
    _dayController = TextEditingController(text: widget.course.day);
    _timeController = TextEditingController(text: widget.course.time);
    _roomController = TextEditingController(text: widget.course.room);
    _lecturerController = TextEditingController(text: widget.course.lecturer);
    _creditsController = TextEditingController(text: widget.course.credits.toString());
  }

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

  void _updateForm() {
    if (_formKey.currentState!.validate()) {
      final updatedCourse = CourseModel(
        id: widget.course.id,
        title: _titleController.text,
        day: _dayController.text,
        time: _timeController.text,
        room: _roomController.text,
        lecturer: _lecturerController.text,
        credits: int.parse(_creditsController.text),
      );

      // Karena di provider kita bisa tambahkan logika update atau replace, 
      // kita perbarui data sesuai ID-nya
      Provider.of<CourseProvider>(context, listen: false).removeCourse(widget.course.id);
      Provider.of<CourseProvider>(context, listen: false).addNewCourse(updatedCourse);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jadwal kuliah berhasil diperbarui!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Jadwal Kuliah'),
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
                validator: (value) => value == null || value.isEmpty ? 'Nama mata kuliah harus diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dayController,
                decoration: const InputDecoration(labelText: 'Hari'),
                validator: (value) => value == null || value.isEmpty ? 'Hari harus diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Jam'),
                validator: (value) => value == null || value.isEmpty ? 'Jam harus diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(labelText: 'Ruangan'),
                validator: (value) => value == null || value.isEmpty ? 'Ruangan harus diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lecturerController,
                decoration: const InputDecoration(labelText: 'Nama Dosen Pengampu'),
                validator: (value) => value == null || value.isEmpty ? 'Nama dosen harus diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _creditsController,
                decoration: const InputDecoration(labelText: 'Jumlah SKS'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'SKS harus diisi';
                  if (int.tryParse(value) == null) return 'SKS harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateForm,
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Simpan Perubahan', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}