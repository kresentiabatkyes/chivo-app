import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi standar yang otomatis membaca konfigurasi google-services.json
  await Firebase.initializeApp();

  runApp(const ChivoApp());
}

class ChivoApp extends StatelessWidget {
  const ChivoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CHIVO App',
      home: LoginPage(),
    );
  }
}