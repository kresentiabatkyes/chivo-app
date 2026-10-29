import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../utils/app_colors.dart';

class DashboardTab extends StatelessWidget {
  final String loggedInUsername;

  const DashboardTab({super.key, required this.loggedInUsername});

  @override
  Widget build(BuildContext context) {
    final DatabaseReference sensorRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://chivo-996da-default-rtdb.asia-southeast1.firebasedatabase.app',
    ).ref().child('sensor_data');

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        title: const Text('CHIVO Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: sensorRef.onValue,
        builder: (context, snapshot) {
          int aktif = 7;
          int pasif = 3;
          int total = 10;
          String status = "NYAMAN";

          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            aktif = data['jumlah_ayam_aktif'] ?? 7;
            pasif = data['jumlah_ayam_pasif'] ?? 3;
            total = data['total_ayam'] ?? 10;
            status = data['status_kandang'] ?? 'NYAMAN';
          }

          bool isNyaman = status.toUpperCase() == 'NYAMAN';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Area Pemutar Video Live Stream (SRS hlm. 27)
                Container(
                  height: 220,
                  color: Colors.black87,
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.videocam, color: Colors.white54, size: 48),
                            SizedBox(height: 8),
                            Text('Live Stream Kandang A', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                          child: const Text('● LIVE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Kartu Status Kenyamanan
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Suhu & Kelembaban Kandang', style: TextStyle(color: Colors.grey, fontSize: 13)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(color: isNyaman ? Colors.green : Colors.red, shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    status,
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isNyaman ? Colors.green.shade800 : Colors.red.shade800),
                                  ),
                                  const Spacer(),
                                  Icon(isNyaman ? Icons.verified_user : Icons.warning_rounded, color: isNyaman ? Colors.green : Colors.red, size: 28),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 3 Kotak Statistik (Total, Aktif, Pasif)
                      Row(
                        children: [
                          Expanded(child: _buildMetricCard('Total Ayam', '$total', Icons.pets, Colors.blueGrey)),
                          const SizedBox(width: 10),
                          Expanded(child: _buildMetricCard('Ayam Aktif', '$aktif', Icons.directions_run, Colors.green)),
                          const SizedBox(width: 10),
                          Expanded(child: _buildMetricCard('Ayam Pasif', '$pasif', Icons.airline_seat_flat, Colors.orange)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}