import 'package:flutter/material.dart';
import '../models/kos_model.dart';
import '../models/saved_kos_model.dart';
import '../repositories/kos_repository.dart';

class KosProvider extends ChangeNotifier {
  final KosRepository _repository;

  KosProvider({KosRepository? repository})
      : _repository = repository ?? KosRepository() {
    init();
  }

  // ===================== STATE VARIABEL =====================

  // Bottom Navigation Index
  int _currentNavIndex = 0;
  int get currentNavIndex => _currentNavIndex;

  // Catalog State (REST API)
  List<KosModel> _allKos = [];
  List<KosModel> _filteredKos = [];
  bool _isLoadingCatalog = false;
  String? _catalogError;

  List<KosModel> get kosList => _filteredKos;
  List<KosModel> get allKos => _allKos;
  bool get isLoadingCatalog => _isLoadingCatalog;
  String? get catalogError => _catalogError;

  // Filters
  String _searchQuery = '';
  String _selectedTypeFilter = 'Semua';
  String _selectedCityFilter = 'Semua';

  String get searchQuery => _searchQuery;
  String get selectedTypeFilter => _selectedTypeFilter;
  String get selectedCityFilter => _selectedCityFilter;

  // Database State (Supabase / CRUD)
  List<SavedKosModel> _savedKosList = [];
  bool _isLoadingSaved = false;
  String? _savedError;
  String _savedStatusFilter = 'Semua';

  List<SavedKosModel> get savedKosList {
    if (_savedStatusFilter == 'Semua') {
      return _savedKosList;
    }
    return _savedKosList
        .where((item) => item.status == _savedStatusFilter)
        .toList();
  }

  bool get isLoadingSaved => _isLoadingSaved;
  String? get savedError => _savedError;
  String get savedStatusFilter => _savedStatusFilter;

  // ===================== INISIALISASI =====================

  Future<void> init() async {
    await Future.wait([
      fetchCatalog(),
      fetchSavedKos(),
    ]);
  }

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  // ===================== CATALOG METHODS (REST API) =====================

  Future<void> fetchCatalog() async {
    _isLoadingCatalog = true;
    _catalogError = null;
    notifyListeners();

    try {
      _allKos = await _repository.getKosCatalog();
      _applyFilters();
    } catch (e) {
      _catalogError = 'Gagal memuat katalog kos. Silakan coba lagi.';
    } finally {
      _isLoadingCatalog = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setTypeFilter(String type) {
    _selectedTypeFilter = type;
    _applyFilters();
  }

  void setCityFilter(String city) {
    _selectedCityFilter = city;
    _applyFilters();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedTypeFilter = 'Semua';
    _selectedCityFilter = 'Semua';
    _applyFilters();
  }

  void _applyFilters() {
    _filteredKos = _allKos.where((kos) {
      // Filter Nama / Alamat
      final matchQuery = _searchQuery.isEmpty ||
          kos.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          kos.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          kos.city.toLowerCase().contains(_searchQuery.toLowerCase());

      // Filter Tipe (Putri/Putra/Campur)
      final matchType = _selectedTypeFilter == 'Semua' ||
          kos.type.toLowerCase() == _selectedTypeFilter.toLowerCase();

      // Filter Kota
      final matchCity = _selectedCityFilter == 'Semua' ||
          kos.city.toLowerCase() == _selectedCityFilter.toLowerCase();

      return matchQuery && matchType && matchCity;
    }).toList();

    notifyListeners();
  }

  // ===================== KOS CATALOG CRUD METHODS =====================

  /// [CREATE] Tambah Kos baru ke katalog
  void addKos(KosModel kos) {
    _allKos.insert(0, kos);
    _applyFilters();
  }

  /// [UPDATE] Edit data Kos di katalog
  void updateKos(KosModel kos) {
    final index = _allKos.indexWhere((k) => k.id == kos.id);
    if (index != -1) {
      _allKos[index] = kos;
      _applyFilters();
    }
  }

  /// [DELETE] Hapus Kos dari katalog
  void deleteKos(String id) {
    _allKos.removeWhere((k) => k.id == id);
    _applyFilters();
  }

  // ===================== DATABASE CRUD METHODS =====================

  /// [READ] Ambil data catatan/favorit dari database
  Future<void> fetchSavedKos() async {
    _isLoadingSaved = true;
    _savedError = null;
    notifyListeners();

    try {
      _savedKosList = await _repository.getSavedKosList();
    } catch (e) {
      _savedError = 'Gagal memuat data tersimpan dari database.';
    } finally {
      _isLoadingSaved = false;
      notifyListeners();
    }
  }

  /// [CREATE] Tambah data ke database
  Future<bool> createSavedKos(SavedKosModel item) async {
    try {
      await _repository.saveKos(item);
      // Refresh local list
      _savedKosList.removeWhere((k) => k.id == item.id);
      _savedKosList.insert(0, item);
      notifyListeners();
      return true;
    } catch (e) {
      _savedError = 'Gagal menyimpan catatan kos: $e';
      notifyListeners();
      return false;
    }
  }

  /// [UPDATE] Ubah data di database
  Future<bool> updateSavedKos(SavedKosModel item) async {
    try {
      await _repository.updateSavedKos(item);
      final index = _savedKosList.indexWhere((k) => k.id == item.id);
      if (index != -1) {
        _savedKosList[index] = item;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _savedError = 'Gagal memperbarui catatan kos: $e';
      notifyListeners();
      return false;
    }
  }

  /// [DELETE] Hapus data dari database
  Future<bool> deleteSavedKos(String id) async {
    try {
      await _repository.deleteSavedKos(id);
      _savedKosList.removeWhere((k) => k.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _savedError = 'Gagal menghapus catatan kos: $e';
      notifyListeners();
      return false;
    }
  }

  void setSavedStatusFilter(String status) {
    _savedStatusFilter = status;
    notifyListeners();
  }

  // ===================== SHARED STATE HELPERS =====================

  bool isKosSaved(String kosId) {
    return _savedKosList.any((item) => item.kosId == kosId);
  }

  SavedKosModel? getSavedKosByKosId(String kosId) {
    try {
      return _savedKosList.firstWhere((item) => item.kosId == kosId);
    } catch (_) {
      return null;
    }
  }

  /// Quick toggle favorit dari tombol love
  Future<void> toggleWishlist(KosModel kos) async {
    final existing = getSavedKosByKosId(kos.id);
    if (existing != null) {
      await deleteSavedKos(existing.id);
    } else {
      final newItem = SavedKosModel(
        id: 'saved_${DateTime.now().millisecondsSinceEpoch}',
        studentId: '2415051101',
        kosId: kos.id,
        kosName: kos.name,
        kosPrice: kos.price,
        kosType: kos.type,
        kosAddress: kos.address,
        kosImage: kos.imageUrl,
        note: 'Disimpan dari pencarian KosFinder.',
        rating: kos.rating,
        status: 'Rencana Survei',
        visitDate: '',
        createdAt: DateTime.now().toIso8601String(),
      );
      await createSavedKos(newItem);
    }
  }
}
