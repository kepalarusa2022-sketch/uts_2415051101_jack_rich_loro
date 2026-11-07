import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/kos_model.dart';

class KosApiService {
  // REST API endpoint (dapat disesuaikan dengan API publik / mock API)
  // Default URL ke endpoint JSON publik atau simulasi API KosFinder
  static const String _apiEndpoint =
      'https://raw.githubusercontent.com/kepalarusa2022-sketch/uts_2415051101_jack_rich_loro/main/assets/data/kos_data.json';

  /// Melakukan HTTP GET request ke REST API untuk mengambil katalog kos.
  /// Memiliki fallback otomatis ke local asset jika jaringan offline / timeout.
  Future<List<KosModel>> getKosCatalog() async {
    try {
      // 1. Coba request via HTTP GET
      final response = await http
          .get(Uri.parse(_apiEndpoint))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        final List<dynamic> list = body['data'] ?? [];
        return list.map((item) => KosModel.fromJson(item)).toList();
      } else {
        // Fallback jika status code bukan 200
        return await _loadFromLocalAsset();
      }
    } catch (_) {
      // Fallback aman ke local assets jika offline / tidak ada koneksi
      return await _loadFromLocalAsset();
    }
  }

  /// Membaca data katalog kos dari asset lokal (assets/data/kos_data.json)
  Future<List<KosModel>> _loadFromLocalAsset() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/kos_data.json');
      final Map<String, dynamic> body = json.decode(jsonString);
      final List<dynamic> list = body['data'] ?? [];
      return list.map((item) => KosModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Gagal memuat katalog kos: $e');
    }
  }

  /// Mengambil detail satu kos berdasarkan ID
  Future<KosModel?> getKosById(String id) async {
    final list = await getKosCatalog();
    try {
      return list.firstWhere((k) => k.id == id);
    } catch (_) {
      return null;
    }
  }
}
