import '../models/course.dart';

class CourseRepository {
  // Sementara kita pakai list kosong dulu untuk testing UI nanti,
  // sebelum disambungkan penuh ke Supabase.
  final List<CourseModel> _dummyCourses = [];

  // Mengambil daftar jadwal
  Future<List<CourseModel>> getCourses() async {
    // Simulasi delay jaringan (loading)
    await Future.delayed(const Duration(seconds: 1));
    return _dummyCourses;
  }

  // Menambah jadwal baru
  Future<void> addCourse(CourseModel course) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _dummyCourses.add(course);
  }

  // Menghapus jadwal
  Future<void> deleteCourse(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _dummyCourses.removeWhere((course) => course.id == id);
  }
}