class SavedKosModel {
  final String id;
  final String studentId;
  final String kosId;
  final String kosName;
  final int kosPrice;
  final String kosType;
  final String kosAddress;
  final String kosImage;
  final String note;
  final double rating;
  final String status; // 'Rencana Survei', 'Sudah Disurvei', 'Booking Sukses'
  final String visitDate;
  final String createdAt;

  SavedKosModel({
    required this.id,
    this.studentId = '2415051101',
    required this.kosId,
    required this.kosName,
    required this.kosPrice,
    this.kosType = 'Campur',
    this.kosAddress = '',
    this.kosImage = '',
    required this.note,
    this.rating = 5.0,
    this.status = 'Rencana Survei',
    this.visitDate = '',
    required this.createdAt,
  });

  factory SavedKosModel.fromJson(Map<String, dynamic> json) {
    return SavedKosModel(
      id: json['id']?.toString() ?? '',
      studentId: json['student_id']?.toString() ?? '2415051101',
      kosId: json['kos_id']?.toString() ?? '',
      kosName: json['kos_name']?.toString() ?? '',
      kosPrice: json['kos_price'] is int
          ? json['kos_price']
          : int.tryParse(json['kos_price']?.toString() ?? '0') ?? 0,
      kosType: json['kos_type']?.toString() ?? 'Campur',
      kosAddress: json['kos_address']?.toString() ?? '',
      kosImage: json['kos_image']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      rating: (json['rating'] is num)
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating']?.toString() ?? '5.0') ?? 5.0,
      status: json['status']?.toString() ?? 'Rencana Survei',
      visitDate: json['visit_date']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'kos_id': kosId,
      'kos_name': kosName,
      'kos_price': kosPrice,
      'kos_type': kosType,
      'kos_address': kosAddress,
      'kos_image': kosImage,
      'note': note,
      'rating': rating,
      'status': status,
      'visit_date': visitDate,
      'created_at': createdAt,
    };
  }

  SavedKosModel copyWith({
    String? id,
    String? studentId,
    String? kosId,
    String? kosName,
    int? kosPrice,
    String? kosType,
    String? kosAddress,
    String? kosImage,
    String? note,
    double? rating,
    String? status,
    String? visitDate,
    String? createdAt,
  }) {
    return SavedKosModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      kosId: kosId ?? this.kosId,
      kosName: kosName ?? this.kosName,
      kosPrice: kosPrice ?? this.kosPrice,
      kosType: kosType ?? this.kosType,
      kosAddress: kosAddress ?? this.kosAddress,
      kosImage: kosImage ?? this.kosImage,
      note: note ?? this.note,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      visitDate: visitDate ?? this.visitDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
