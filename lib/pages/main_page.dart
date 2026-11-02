import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MainPage extends StatefulWidget {
  final String userEmail;
  final String userName;

  const MainPage({
    super.key, 
    required this.userEmail, 
    required this.userName,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // Inisialisasi Database dengan URL Region asia-southeast1
  final DatabaseReference _sensorRef = FirebaseDatabase.instanceFor(
    app: FirebaseDatabase.instance.app,
    databaseURL: 'https://chivo-996da-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref('sensor_data');

  // Fungsi untuk menampilkan pop-up konfirmasi keluar
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Konfirmasi Keluar",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: const Text(
            "Apakah kamu yakin ingin keluar dari aplikasi?",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup pop-up (Batal)
              },
              child: const Text(
                "Tidak",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pop(context); // Tutup pop-up
                // Keluar dan kembali ke halaman awal/login
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              child: const Text(
                "Ya, Keluar",
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
    String displayName = widget.userName.isNotEmpty ? widget.userName : 'Peternak CHIVO';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),
      appBar: AppBar(
        title: const Text("CHIVO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: const Color(0xFF2E7D32),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                displayName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
              ),
              accountEmail: Text(
                widget.userEmail,
                style: const TextStyle(fontSize: 13, color: Colors.white70),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.pets, size: 40, color: Color(0xFF2E7D32)),
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF2E7D32),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFF2E7D32)),
              title: const Text('Home', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87)),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Keluar', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.pop(context); // Tutup drawer terlebih dahulu
                _showLogoutDialog(context); // Tampilkan pop-up konfirmasi
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _sensorRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          String statusKandang = "NYAMAN";
          int totalAyam = 0;
          int ayamAktif = 0;
          int ayamPasif = 0;
          String persentaseAktif = "0%";

          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            final dataValue = snapshot.data!.snapshot.value;

            if (dataValue is Map) {
              var totalVal = dataValue['total_ayam'];
              var aktifVal = dataValue['jumlah_ayam_aktif'];
              var pasifVal = dataValue['jumlah_ayam_pasif'];
              
              if (dataValue['status_kandang'] != null) {
                statusKandang = dataValue['status_kandang'].toString();
              }

              totalAyam = int.tryParse(totalVal?.toString() ?? '0') ?? 0;
              ayamAktif = int.tryParse(aktifVal?.toString() ?? '0') ?? 0;
              ayamPasif = int.tryParse(pasifVal?.toString() ?? '0') ?? 0;

              if (totalAyam == 0 && (ayamAktif > 0 || ayamPasif > 0)) {
                totalAyam = ayamAktif + ayamPasif;
              }

              if (totalAyam > 0) {
                double p = (ayamAktif / totalAyam) * 100;
                persentaseAktif = "${p.toStringAsFixed(0)}%";
              }
            }
          }

          // Menentukan warna teks dan titik indikator berdasarkan status kandang
          bool isNyaman = statusKandang.trim().toUpperCase() == "NYAMAN";
          Color statusColor = isNyaman ? const Color(0xFF2E7D32) : Colors.red;
          Color dotColor = isNyaman ? Colors.green : Colors.red;

          return IndexedStack(
            index: _currentIndex,
            children: [
              // Tab 0: Dashboard / Utama
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Kotak Live Stream Video dengan Badge LIVE di Pojok Kiri Atas
                    Container(
                      width: double.infinity,
                      height: 220,
                      color: const Color(0xFF262626),
                      child: Stack(
                        children: [
                          const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.videocam, size: 50, color: Colors.white70),
                                SizedBox(height: 8),
                                Text(
                                  "Live Stream Kandang A",
                                  style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.circle, size: 8, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text("LIVE", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Card Status Kenyamanan
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Real-time Status", style: TextStyle(color: Colors.black54, fontSize: 12)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      statusKandang, 
                                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 10, 
                                      height: 10, 
                                      decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                const Text("Status Kenyamanan Kandang", style: TextStyle(color: Colors.black45, fontSize: 11)),
                              ],
                            ),
                            Column(
                              children: [
                                Text(persentaseAktif, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                                const Text("Aktif", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Card Statistik Ayam (Total, Aktif, Pasif dari Database)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text("Total Ayam", style: TextStyle(color: Colors.black54, fontSize: 12)),
                                const SizedBox(height: 6),
                                Text("$totalAyam", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                              ],
                            ),
                            Container(height: 30, width: 1, color: Colors.black12),
                            Column(
                              children: [
                                const Text("Ayam Aktif", style: TextStyle(color: Colors.black54, fontSize: 12)),
                                const SizedBox(height: 6),
                                Text("$ayamAktif", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                              ],
                            ),
                            Container(height: 30, width: 1, color: Colors.black12),
                            Column(
                              children: [
                                const Text("Ayam Pasif", style: TextStyle(color: Colors.black54, fontSize: 12)),
                                const SizedBox(height: 6),
                                Text("$ayamPasif", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // Tab 1: Notifikasi
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text("HARI INI", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                            SizedBox(width: 8),
                            Text("Critical Alert", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text("Peringatan Kandang A", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                        SizedBox(height: 4),
                        Text("Tingkat kepasifan ayam meningkat. Segera periksa kandang!", style: TextStyle(fontSize: 13, color: Colors.black54)),
                        SizedBox(height: 8),
                        Text("10 menit yang lalu", style: TextStyle(fontSize: 11, color: Colors.black38)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Color(0xFF2E7D32), size: 20),
                            SizedBox(width: 8),
                            Text("System Information", style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text("Kamera Terhubung", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                        SizedBox(height: 4),
                        Text("Live stream Kandang A berjalan normal dan stabil.", style: TextStyle(fontSize: 13, color: Colors.black54)),
                        SizedBox(height: 8),
                        Text("10 menit yang lalu", style: TextStyle(fontSize: 11, color: Colors.black38)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Utama',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
        ],
      ),
    );
  }
}