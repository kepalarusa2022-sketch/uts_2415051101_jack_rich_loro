import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_keys.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'providers/kos_provider.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Firebase (FCM)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint('Firebase fallback notice: $e');
  }

  // 2. Inisialisasi Supabase
  const String supabaseUrl = 'https://pugfdvhldusonayslhui.supabase.co';
  const String supabaseAnonKey =
      'sb_publishable_lklcxyhn_oRyj4P2B2ejOA_2Y8qRKZi';

  try {
    if (supabaseUrl.isNotEmpty) {
      await Supabase.initialize(
        url: supabaseUrl,
        // ignore: deprecated_member_use
        anonKey: supabaseAnonKey,
      );
    }
  } catch (e) {
    debugPrint('Supabase initialization notice: $e');
  }

  // 3. Listener perubahan sesi otentikasi (Auto Redirect saat signedOut)
  try {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      debugPrint('Auth event: ${data.event}');
      if (data.event == AuthChangeEvent.signedOut) {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    });
  } catch (_) {}

  runApp(const KosFinderApp());
}

class KosFinderApp extends StatelessWidget {
  const KosFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KosProvider()),
      ],
      child: MaterialApp(
        title: 'KosFinder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF1BAA56),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: false,
            backgroundColor: Color(0xFF1BAA56),
            foregroundColor: Colors.white,
          ),
          cardTheme: CardThemeData(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: messengerKey,
        // Check Session -> Login / Home (Praktik 2 & Final Integration)
        home: AuthService.instance.isLoggedIn
            ? const HomePage()
            : const LoginPage(),
      ),
    );
  }
}
