import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/login_page.dart';
import 'utils/app_colors.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ChivoApp());
}

class ChivoApp extends StatelessWidget {
  const ChivoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CHIVO - Sistem Klasifikasi Perilaku Anak Ayam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: const Color(0xFFF9FBF9),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
    
      home: const LoginPage(),
    );
  }
}