import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../utils/app_colors.dart';
import 'login_page.dart';

class ProfileTab extends StatefulWidget {
  final String loggedInUsername;

  const ProfileTab({super.key, required this.loggedInUsername});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Map<String, dynamic> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final database = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://chivo-996da-default-rtdb.asia-southeast1.firebasedatabase.app',
      );

      DatabaseReference ref = database.ref().child('peternak');
      DataSnapshot snapshot = await ref.get();

      if (snapshot.exists && snapshot.value != null) {
        Object? rawData = snapshot.value;

        if (rawData is Map) {
          rawData.forEach((key, value) {
            if (value is Map) {
              String dbUser = (value['username'] ?? '').toString().trim();
              String dbEmail = (value['email'] ?? '').toString().trim();

              // Cocokkan dengan username atau email yang sedang login
              if (dbUser.toLowerCase() == widget.loggedInUsername.toLowerCase() ||
                  dbEmail.toLowerCase() == widget.loggedInUsername.toLowerCase()) {
                setState(() {
                  userData = Map<String, dynamic>.from(value);
                });
              }
            }
          });
        }
      }
    } catch (e) {
      print("Error ambil profil: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi Pop-up Konfirmasi Logout
  void konfirmasiLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Konfirmasi Keluar',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: const Text(
            'Apakah kamu yakin ingin keluar dari aplikasi CHIVO?',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
              },
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                // Pindah ke LoginPage dan hapus riwayat navigasi sebelumnya
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
              child: const Text(
                'Keluar',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String nama = userData['nama'] ?? widget.loggedInUsername;
    String email = userData['email'] ?? '-';
    String noHp = userData['no_hp'] ?? '-';
    String alamat = userData['alamat'] ?? '-';
    String tanggalDaftar = userData['tanggal_daftar'] ?? '-';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profil Peternak', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Avatar / Foto Profil Inisial
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                    child: Text(
                      nama.isNotEmpty ? nama[0].toUpperCase() : 'C',
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    nama,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${userData['username'] ?? widget.loggedInUsername}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 30),

                  // Kartu Detail Informasi (Berdasarkan ERD)
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Column(
                        children: [
                          _buildProfileItem(Icons.email_outlined, 'Email', email),
                          const Divider(),
                          _buildProfileItem(Icons.phone_outlined, 'Nomor Telepon', noHp),
                          const Divider(),
                          _buildProfileItem(Icons.location_on_outlined, 'Alamat Kandang', alamat),
                          const Divider(),
                          _buildProfileItem(Icons.calendar_today_outlined, 'Tanggal Terdaftar', tanggalDaftar),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Tombol Keluar / Logout dengan Pop-up
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        'Keluar dari Aplikasi',
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => konfirmasiLogout(context),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}