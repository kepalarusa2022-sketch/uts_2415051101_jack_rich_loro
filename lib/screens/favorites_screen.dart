import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mata Kuliah Prioritas / Favorit'),
      ),
      body: Consumer<CourseProvider>(
        builder: (context, provider, child) {
          // Kita ambil beberapa mata kuliah sebagai contoh favorit (misal SKS >= 3)
          final favoriteCourses = provider.courses.where((c) => c.credits >= 3).toList();

          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (favoriteCourses.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada mata kuliah prioritas (>= 3 SKS).',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: favoriteCourses.length,
            itemBuilder: (context, index) {
              final course = favoriteCourses[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.star, color: Colors.amber),
                  title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Hari: ${course.day} | Ruangan: ${course.room}'),
                  trailing: Text('${course.credits} SKS'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}