import 'package:flutter/foundation.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider with ChangeNotifier {
  final CourseRepository repository = CourseRepository();

  List<CourseModel> _courses = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<CourseModel> get courses => _courses;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fungsi untuk mengambil data
  Future<void> loadCourses() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _courses = await repository.getCourses();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi untuk menambah data baru
  Future<void> addNewCourse(CourseModel newCourse) async {
    try {
      await repository.addCourse(newCourse);
      await loadCourses();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Fungsi untuk menghapus data
  Future<void> removeCourse(String id) async {
    try {
      await repository.deleteCourse(id);
      await loadCourses();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}