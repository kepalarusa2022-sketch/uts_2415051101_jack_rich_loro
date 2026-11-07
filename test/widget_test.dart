import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_fundamentals/models/kos_model.dart';
import 'package:flutter_ui_fundamentals/models/saved_kos_model.dart';

void main() {
  group('KosFinder Model Tests', () {
    test('KosModel fromJson and toJson serialization test', () {
      final json = {
        'id': 'kos_test_1',
        'name': 'Kost Wisma Test',
        'type': 'Campur',
        'price': 2500000,
        'price_unit': '/bln',
        'address': 'Jl. Kaliurang KM 5, Sleman',
        'city': 'Yogyakarta',
        'image_url': 'https://example.com/image.jpg',
        'images': ['https://example.com/image1.jpg'],
        'rating': 4.9,
        'review_count': 25,
        'is_can_booking': true,
        'room_size': '3 x 4 m',
        'is_electric_included': true,
        'facilities': ['AC', 'WiFi', 'KM Dalam'],
        'description': 'Kost nyaman dekat kampus',
        'rules': ['Akses 24 Jam'],
        'owner_name': 'Pak Budi',
        'owner_phone': '+6281234567890',
      };

      final kos = KosModel.fromJson(json);

      expect(kos.id, 'kos_test_1');
      expect(kos.name, 'Kost Wisma Test');
      expect(kos.type, 'Campur');
      expect(kos.price, 2500000);
      expect(kos.city, 'Yogyakarta');
      expect(kos.facilities.length, 3);
      expect(kos.isCanBooking, true);

      final outJson = kos.toJson();
      expect(outJson['name'], 'Kost Wisma Test');
      expect(outJson['price'], 2500000);
    });

    test('SavedKosModel CRUD properties test', () {
      final saved = SavedKosModel(
        id: 'saved_001',
        studentId: '2415051101',
        kosId: 'kos_001',
        kosName: 'Kost Wisma Divina',
        kosPrice: 2540000,
        kosType: 'Campur',
        kosAddress: 'Sleman',
        kosImage: 'https://example.com/kos.jpg',
        note: 'Dekat kampus UGM',
        rating: 5.0,
        status: 'Rencana Survei',
        visitDate: '2026-11-15',
        createdAt: '2026-11-07T00:00:00Z',
      );

      expect(saved.id, 'saved_001');
      expect(saved.studentId, '2415051101');
      expect(saved.status, 'Rencana Survei');

      final updated = saved.copyWith(status: 'Sudah Disurvei', rating: 4.8);
      expect(updated.status, 'Sudah Disurvei');
      expect(updated.rating, 4.8);
      expect(updated.id, 'saved_001');
    });
  });
}
