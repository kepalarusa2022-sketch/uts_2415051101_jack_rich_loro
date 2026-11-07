import '../models/kos_model.dart';
import '../models/saved_kos_model.dart';
import '../services/kos_api_service.dart';
import '../services/database_service.dart';

class KosRepository {
  final KosApiService _apiService;
  final DatabaseService _databaseService;

  KosRepository({
    KosApiService? apiService,
    DatabaseService? databaseService,
  })  : _apiService = apiService ?? KosApiService(),
        _databaseService = databaseService ?? DatabaseService();

  // ===================== REST API OPERATIONS =====================

  /// Mengambil semua data katalog kos dari REST API
  Future<List<KosModel>> getKosCatalog() async {
    return await _apiService.getKosCatalog();
  }

  /// Mengambil detail satu kos berdasarkan ID
  Future<KosModel?> getKosDetail(String id) async {
    return await _apiService.getKosById(id);
  }

  // ===================== DATABASE CRUD OPERATIONS =====================

  /// [READ] Mengambil daftar kos yang disimpan dari database
  Future<List<SavedKosModel>> getSavedKosList() async {
    return await _databaseService.getSavedKosList();
  }

  /// [CREATE] Menyimpan catatan kos baru ke database
  Future<void> saveKos(SavedKosModel item) async {
    await _databaseService.insertSavedKos(item);
  }

  /// [UPDATE] Mengubah data catatan kos di database
  Future<void> updateSavedKos(SavedKosModel item) async {
    await _databaseService.updateSavedKos(item);
  }

  /// [DELETE] Menghapus catatan kos dari database
  Future<void> deleteSavedKos(String id) async {
    await _databaseService.deleteSavedKos(id);
  }
}
