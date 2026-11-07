import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/kos_provider.dart';
import 'screens/main_navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase (dengan graceful handling agar tetap jalan offline/lokal jika key kosong)
  try {
    const String supabaseUrl = 'https://pugfdvhldusonayslhui.supabase.co';
    const String supabaseAnonKey = 'sb_publishable_lklcxyhn_oRyj4P2B2ejOA_2Y8qRKZi';

    if (supabaseUrl.isNotEmpty && !supabaseUrl.contains('MASUKKAN')) {
      await Supabase.initialize(
        url: supabaseUrl,
        publishableKey: supabaseAnonKey,
      );
    }
  } catch (e) {
    debugPrint('Supabase initialisation fallback: $e');
  }

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
        title: 'KosFinder - Mamikos UTS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1BAA56),
            primary: const Color(0xFF1BAA56),
            secondary: const Color(0xFF008744),
          ),
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
        home: const MainNavigationScreen(),
      ),
    );
  }
}
