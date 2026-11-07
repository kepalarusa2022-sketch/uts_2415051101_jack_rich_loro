import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/saved_kos_model.dart';

class DatabaseService {
  static const String studentId = '2415051101';
  static const String tableName = 'saved_kos';

  // In-memory fallback storage jika Supabase belum dikonfigurasi atau offline
  final List<SavedKosModel> _localDatabase = [
    SavedKosModel(
      id: 'saved_01',
      studentId: studentId,
      kosId: 'kos_001',
      kosName: 'Kost Wisma Divina Sejahtera',
      kosPrice: 2540000,
      kosType: 'Campur',
      kosAddress: 'Jl. Kaliurang KM 5.2, Sleman, Yogyakarta',
      kosImage:
          'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=800&auto=format&fit=crop&q=80',
      note: 'Sangat dekat dengan kampus UGM, lingkungan tenang, fasilitas lengkap.',
      rating: 5.0,
      status: 'Rencana Survei',
      visitDate: '2026-11-15',
      createdAt: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
    ),
    SavedKosModel(
      id: 'saved_02',
      studentId: studentId,
      kosId: 'kos_002',
      kosName: 'Kost Ibu Lilis, Sleman',
      kosPrice: 2540000,
      kosType: 'Campur',
      kosAddress: 'Jl. Ring Road Utara, Condongcatur, Sleman',
      kosImage:
          'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=800&auto=format&fit=crop&q=80',
      note: 'Ibu kost sangat ramah, ada parkir mobil, kamar luas.',
      rating: 4.8,
      status: 'Sudah Disurvei',
      visitDate: '2026-11-05',
      createdAt: DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
    ),
  ];

  SupabaseClient? get _supabaseClient {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  /// READ (GET ALL): Mengambil data saved_kos
  Future<List<SavedKosModel>> getSavedKosList() async {
    final client = _supabaseClient;
    if (client != null) {
      try {
        final response = await client
            .from(tableName)
            .select()
            .eq('student_id', studentId)
            .order('created_at', ascending: false);

        final list = (response as List<dynamic>)
            .map((item) => SavedKosModel.fromJson(item))
            .toList();

        if (list.isNotEmpty) return list;
      } catch (_) {
        // Fallback ke local database
      }
    }
    // Return local database copy
    return List<SavedKosModel>.from(_localDatabase);
  }

  /// CREATE (INSERT): Menambahkan catatan kos baru ke database
  Future<void> insertSavedKos(SavedKosModel item) async {
    final client = _supabaseClient;
    if (client != null) {
      try {
        await client.from(tableName).insert(item.toJson());
      } catch (_) {
        // Fallback
      }
    }
    // Simpan juga ke local fallback
    _localDatabase.removeWhere((x) => x.id == item.id);
    _localDatabase.insert(0, item);
  }

  /// UPDATE: Memperbarui catatan kos di database
  Future<void> updateSavedKos(SavedKosModel item) async {
    final client = _supabaseClient;
    if (client != null) {
      try {
        await client.from(tableName).update(item.toJson()).eq('id', item.id);
      } catch (_) {
        // Fallback
      }
    }
    // Update di local fallback
    final index = _localDatabase.indexWhere((x) => x.id == item.id);
    if (index != -1) {
      _localDatabase[index] = item;
    } else {
      _localDatabase.insert(0, item);
    }
  }

  /// DELETE: Menghapus catatan kos dari database
  Future<void> deleteSavedKos(String id) async {
    final client = _supabaseClient;
    if (client != null) {
      try {
        await client.from(tableName).delete().eq('id', id);
      } catch (_) {
        // Fallback
      }
    }
    // Hapus dari local fallback
    _localDatabase.removeWhere((x) => x.id == id);
  }
}
