class CourseModel {
  final String id;
  final String title;
  final String day;
  final String time;
  final String room;
  final String lecturer;
  final int credits;

  CourseModel({
    required this.id,
    required this.title,
    required this.day,
    required this.time,
    required this.room,
    required this.lecturer,
    required this.credits,
  });

  // Konversi dari JSON (Database Supabase) ke Objek Dart
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      day: json['day'] ?? '',
      time: json['time'] ?? '',
      room: json['room'] ?? '',
      lecturer: json['lecturer'] ?? '',
      credits: json['credits'] is int 
          ? json['credits'] 
          : int.tryParse(json['credits'].toString()) ?? 0,
    );
  }

  // Konversi dari Objek Dart ke JSON (untuk simpan/update ke database)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'day': day,
      'time': time,
      'room': room,
      'lecturer': lecturer,
      'credits': credits,
    };
  }
}