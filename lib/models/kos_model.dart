class KosModel {
  final String id;
  final String name;
  final String type; // 'Campur', 'Putri', 'Putra'
  final int price;
  final String priceUnit;
  final String address;
  final String city;
  final String imageUrl;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final bool isCanBooking;
  final String roomSize;
  final bool isElectricIncluded;
  final List<String> facilities;
  final String description;
  final List<String> rules;
  final String ownerName;
  final String ownerPhone;

  KosModel({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    this.priceUnit = '/bln',
    required this.address,
    required this.city,
    required this.imageUrl,
    this.images = const [],
    this.rating = 4.8,
    this.reviewCount = 10,
    this.isCanBooking = true,
    this.roomSize = '3 x 4 m',
    this.isElectricIncluded = true,
    this.facilities = const [],
    this.description = '',
    this.rules = const [],
    this.ownerName = 'Pengelola Kos',
    this.ownerPhone = '+628123456789',
  });

  factory KosModel.fromJson(Map<String, dynamic> json) {
    return KosModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Kos Nyaman',
      type: json['type']?.toString() ?? 'Campur',
      price: json['price'] is int
          ? json['price']
          : int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      priceUnit: json['price_unit']?.toString() ?? '/bln',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      rating: (json['rating'] is num)
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating']?.toString() ?? '4.8') ?? 4.8,
      reviewCount: json['review_count'] is int
          ? json['review_count']
          : int.tryParse(json['review_count']?.toString() ?? '10') ?? 10,
      isCanBooking: json['is_can_booking'] == true,
      roomSize: json['room_size']?.toString() ?? '3 x 4 m',
      isElectricIncluded: json['is_electric_included'] ?? true,
      facilities: (json['facilities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      description: json['description']?.toString() ?? '',
      rules: (json['rules'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      ownerName: json['owner_name']?.toString() ?? 'Pengelola Kos',
      ownerPhone: json['owner_phone']?.toString() ?? '+628123456789',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'price': price,
      'price_unit': priceUnit,
      'address': address,
      'city': city,
      'image_url': imageUrl,
      'images': images,
      'rating': rating,
      'review_count': reviewCount,
      'is_can_booking': isCanBooking,
      'room_size': roomSize,
      'is_electric_included': isElectricIncluded,
      'facilities': facilities,
      'description': description,
      'rules': rules,
      'owner_name': ownerName,
      'owner_phone': ownerPhone,
    };
  }
}
