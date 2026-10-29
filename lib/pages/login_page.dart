import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../utils/app_colors.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> submitLogin() async {
    if (!_formKey.currentState!.validate()) return;

    String inputUser = usernameController.text.trim();
    String inputPass = passwordController.text.trim();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    bool loginBerhasil = false;
    String pesanError = '';

    try {
      final database = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://chivo-996da-default-rtdb.asia-southeast1.firebasedatabase.app',
      );

      DatabaseReference ref = database.ref().child('peternak');

      DataSnapshot snapshot = await ref.get().timeout(
        const Duration(seconds: 8),
        onTimeout: () => throw Exception("Koneksi ke Firebase timeout. Periksa koneksi internet."),
      );

      if (snapshot.exists && snapshot.value != null) {
        Object? rawData = snapshot.value;

        if (rawData is Map) {
          rawData.forEach((key, value) {
            if (value is Map) {
              String dbUser = (value['username'] ?? '').toString().trim();
              String dbEmail = (value['email'] ?? '').toString().trim();
              String dbPass = (value['password'] ?? '').toString().trim();

              if ((dbUser.toLowerCase() == inputUser.toLowerCase() || 
                   dbEmail.toLowerCase() == inputUser.toLowerCase()) &&
                  dbPass == inputPass) {
                loginBerhasil = true;
              }
            }
          });
        }
      } else {
        pesanError = "Node 'peternak' tidak ditemukan di database.";
      }
    } catch (e) {
      pesanError = e.toString();
    } finally {
      if (mounted) Navigator.pop(context);
    }

    if (!mounted) return;

    if (loginBerhasil) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(loggedInUsername: inputUser),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(pesanError.isNotEmpty ? pesanError : 'Login Gagal: Username/Email atau Password salah!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text(
                      'CHIVO',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Selamat Datang di CHIVO',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pantau kenyamanan kandang anak ayam\nsecara real-time.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Masukkan email atau username',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Field tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Masukkan kata sandi',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => obscurePassword = !obscurePassword),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Password tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: submitLogin,
                    child: const Text('Masuk →', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}