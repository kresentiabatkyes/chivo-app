import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Hubungkan ke koleksi dan dokumen database Firebase
    final Stream<DocumentSnapshot> kandangStream = FirebaseFirestore.instance
        .collection('kandang')
        .doc('kandang_a')
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: kandangStream,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.green));
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("Gagal memuat data dari Firebase"));
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;
        
        // Menggunakan .toString() agar aman dari error tipe data int ke String
        String statusKandang = data['status'] ?? 'NYAMAN';
        String totalAyam = (data['total_ayam'] ?? 0).toString();
        String ayamAktif = (data['ayam_aktif'] ?? 0).toString();
        String ayamPasif = (data['ayam_pasif'] ?? 0).toString();
        String persentaseAktif = (data['persentase_aktif'] ?? '0').toString();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Kotak Video Live Stream
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.videocam, color: Colors.white54, size: 50),
                          SizedBox(height: 8),
                          Text("Live Stream Kandang A", style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text("• LIVE", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Real-time Status Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Real-time Status", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(statusKandang, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              const Icon(Icons.circle, color: Colors.green, size: 12),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text("Status Kenyamanan Kandang", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      Column(
                        children: [
                          Text("$persentaseAktif%", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          const Text("Aktif", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Kotak Statistik Ayam
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [
                        const Text("Total Ayam", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 6),
                        Text(totalAyam, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ]),
                      Container(height: 30, width: 1, color: Colors.grey),
                      Column(children: [
                        const Text("Ayam Aktif", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 6),
                        Text(ayamAktif, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ]),
                      Container(height: 30, width: 1, color: Colors.grey),
                      Column(children: [
                        const Text("Ayam Pasif", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 6),
                        Text(ayamPasif, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}