import 'package:flutter/material.dart';

class KosDetailPage extends StatelessWidget {
  const KosDetailPage({super.key, required this.kosId});
  final String kosId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Kos')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.home_work_rounded,
                size: 72,
                color: Color(0xFF1BAA56),
              ),
              const SizedBox(height: 16),
              Text(
                'Kos ID: $kosId',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Halaman ini terbuka otomatis setelah pengguna menekan notifikasi push FCM (Bonus Interaction).',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
