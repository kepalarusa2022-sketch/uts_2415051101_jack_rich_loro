import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KosService {
  final SupabaseClient _client = Supabase.instance.client;

  String? get _uid => _client.auth.currentUser?.id;

  Future<List<Map<String, dynamic>>> fetchAll() async {
    try {
      final data = await _client
          .from('kos')
          .select()
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      debugPrint('fetchAll error: $e');
      return [];
    }
  }

  Future<void> add({
    required String name,
    required String address,
    required int price,
  }) async {
    if (_uid == null) {
      throw Exception('Pengguna belum login.');
    }
    await _client.from('kos').insert({
      'owner_id': _uid,
      'name': name,
      'address': address,
      'price': price,
    });
  }

  /// true = berhasil, false = ditolak RLS / data tidak ditemukan
  Future<bool> update(String id, Map<String, dynamic> values) async {
    try {
      final rows =
          await _client.from('kos').update(values).eq('id', id).select();
      return rows.isNotEmpty;
    } catch (e) {
      debugPrint('update error / ditolak: $e');
      return false;
    }
  }

  /// true = berhasil, false = ditolak RLS / data tidak ditemukan
  Future<bool> delete(String id) async {
    try {
      final rows = await _client.from('kos').delete().eq('id', id).select();
      return rows.isNotEmpty;
    } catch (e) {
      debugPrint('delete error / ditolak: $e');
      return false;
    }
  }
}
