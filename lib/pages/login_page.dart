import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'main_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    String inputEmail = _emailController.text.trim();
    String inputPassword = _passwordController.text.trim();

    if (inputEmail.isEmpty || inputPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password tidak boleh kosong!"), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Koneksi ke Firebase Realtime Database region asia-southeast1
      DatabaseReference peternakRef = FirebaseDatabase.instanceFor(
        app: FirebaseDatabase.instance.app,
        databaseURL: 'https://chivo-996da-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref('peternak');

      Query query = peternakRef.orderByChild('email').equalTo(inputEmail);
      DataSnapshot snapshot = await query.get().timeout(const Duration(seconds: 5));

      bool isLoginSuccess = false;
      String fetchedEmail = inputEmail;
      String fetchedNama = "Peternak CHIVO";

      if (snapshot.exists && snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value is Map) {
            String dbPassword = value['password']?.toString() ?? '';
            if (dbPassword == inputPassword) {
              isLoginSuccess = true;
              fetchedEmail = value['email']?.toString() ?? inputEmail;
              fetchedNama = value['nama']?.toString() ?? 'Peternak CHIVO';
            }
          }
        });
      }

      if (!mounted) return;

      if (isLoginSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(
              userEmail: fetchedEmail,
              userName: fetchedNama,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email atau Password salah!"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal masuk (Periksa Koneksi): $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/chivoo.jpg',
                  height: 130,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.pets, size: 90, color: Color(0xFF2E7D32));
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "Sistem Klasifikasi Perilaku Aktif-Pasif Anak Ayam",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black26)),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.mail_outline, color: Color(0xFF2E7D32)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black26)),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2E7D32)),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.black45),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("MASUK", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum punya akun? ", style: TextStyle(color: Colors.black54, fontSize: 13)),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
                      child: const Text("Daftar Sekarang", style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}