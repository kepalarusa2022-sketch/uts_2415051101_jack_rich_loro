import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseDetailScreen extends StatelessWidget {
  final CourseModel course;

  const CourseDetailScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        actions: [
          // Tombol Delete dengan konfirmasi Dialog (Syarat UTS)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Hapus Jadwal'),
                  content: Text(
                      'Apakah Anda yakin ingin menghapus mata kuliah ${course.title}?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Panggil fungsi hapus dari provider
                        Provider.of<CourseProvider>(context, listen: false)
                            .removeCourse(course.id);
                        Navigator.pop(ctx); // Tutup dialog
                        Navigator.pop(context); // Kembali ke list screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Jadwal berhasil dihapus!'),
                          ),
                        );
                      },
                      child: const Text('Hapus',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 24),
                _buildInfoRow(Icons.calendar_today, 'Hari', course.day),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.access_time, 'Jam', course.time),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.room, 'Ruangan', course.room),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.person, 'Dosen Pengampu', course.lecturer),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.school, 'Jumlah SKS', '${course.credits} SKS'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}