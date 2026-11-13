import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../app_keys.dart';
import '../firebase_options.dart';
import '../pages/kos_detail_page.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {}
  debugPrint('[BACKGROUND] ${message.notification?.title}');
  debugPrint('[BACKGROUND] ${message.notification?.body}');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? currentToken;

  /// Meminta izin notifikasi dan mengembalikan statusnya:
  /// authorized | provisional | denied | notDetermined
  Future<AuthorizationStatus> requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('Notification permission: ${settings.authorizationStatus.name}');
      return settings.authorizationStatus;
    } catch (e) {
      debugPrint('Error requestPermission: $e');
      return AuthorizationStatus.notDetermined;
    }
  }

  /// Mendapatkan FCM token dari perangkat
  Future<String?> getToken() async {
    try {
      // ignore: deprecated_member_use
      final token = await _messaging.getToken();
      currentToken = token;
      debugPrint('FCM Token: $token');
      return token;
    } catch (e) {
      debugPrint('Error getToken: $e');
      return null;
    }
  }

  /// Token dapat berubah, sehingga perubahan perlu didengarkan.
  void listenTokenRefresh(void Function(String token) onRefresh) {
    try {
      // ignore: deprecated_member_use
      _messaging.onTokenRefresh.listen((newToken) {
        currentToken = newToken;
        debugPrint('FCM Token diperbarui: $newToken');
        onRefresh(newToken);
      });
    } catch (e) {
      debugPrint('Error listenTokenRefresh: $e');
    }
  }

  /// Menyimpan token FCM ke database Supabase
  Future<void> saveTokenToSupabase(String token) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;
      await Supabase.instance.client.from('device_tokens').upsert({
        'token': token,
        'user_id': user.id,
        'platform': defaultTargetPlatform.name,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
      debugPrint('Token FCM berhasil disimpan ke Supabase.');
    } catch (e) {
      debugPrint('Catatan simpan token ke Supabase: $e');
    }
  }

  Future<void> init() async {
    try {
      await requestPermission();
      final token = await getToken();
      if (token != null) {
        await saveTokenToSupabase(token);
      }
      listenTokenRefresh(saveTokenToSupabase);

      // iOS: tampilkan banner saat aplikasi di foreground
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // FOREGROUND: aplikasi sedang terbuka
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('[FOREGROUND] Notification received');
        debugPrint('title: ${message.notification?.title}');
        debugPrint('body : ${message.notification?.body}');
        debugPrint('data : ${message.data}');

        // Android tidak otomatis memunculkan pop-up saat aplikasi foreground,
        // sehingga ditampilkan SnackBar di dalam aplikasi.
        final title = message.notification?.title ?? 'Notifikasi KosFinder';
        final body = message.notification?.body ?? '';
        messengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('$title\n$body'),
            backgroundColor: const Color(0xFF1BAA56),
            duration: const Duration(seconds: 4),
          ),
        );
      });
    } catch (e) {
      debugPrint('Notification init notice: $e');
    }
  }

  /// Bonus: Navigasi otomatis saat notifikasi ditekan
  Future<void> setupInteractedMessage() async {
    try {
      // Aplikasi TERMINATED lalu dibuka dari notifikasi
      final initial = await _messaging.getInitialMessage();
      if (initial != null) _handleTap(initial);

      // Aplikasi BACKGROUND lalu dibuka dari notifikasi
      FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);
    } catch (e) {
      debugPrint('setupInteractedMessage notice: $e');
    }
  }

  void _handleTap(RemoteMessage message) {
    final kosId = message.data['kos_id'];
    if (kosId == null) return;
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => KosDetailPage(kosId: kosId.toString()),
      ),
    );
  }
}
