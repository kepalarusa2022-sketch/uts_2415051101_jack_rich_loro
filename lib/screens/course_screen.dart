import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import 'course_detail_screen.dart';
import 'add_course_screen.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  @override
  void initState() {
    super.initState();
    // Memuat data saat screen pertama kali dibuka
    Future.microtask(() =>
        Provider.of<CourseProvider>(context, listen: false).loadCourses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Jadwal Kuliah'),
      ),
      body: Consumer<CourseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                'Terjadi Kesalahan:\n${provider.errorMessage}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (provider.courses.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada jadwal kuliah.\nSilakan tambah jadwal baru!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Responsive Layout menggunakan LayoutBuilder
          return LayoutBuilder(
            builder: (context, constraints) {
              // Jika lebar layar lebar (Wide/Expanded)
              if (constraints.maxWidth > 600) {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: provider.courses.length,
                  itemBuilder: (context, index) {
                    final course = provider.courses[index];
                    return Card(
                      elevation: 3,
                      child: ListTile(
                        title: Text(course.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${course.day} - ${course.time}'),
                        trailing: Text('${course.credits} SKS'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CourseDetailScreen(course: course),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }

              // Jika layar biasa/compact (ListView)
              return ListView.builder(
                itemCount: provider.courses.length,
                itemBuilder: (context, index) {
                  final course = provider.courses[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(course.credits.toString()),
                      ),
                      title: Text(course.title,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Hari: ${course.day} | Jam: ${course.time}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Navigasi List -> Detail (Passing data)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CourseDetailScreen(course: course),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCourseScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}