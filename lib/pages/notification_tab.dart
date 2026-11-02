import 'package:flutter/material.dart';

class NotificationTab extends StatelessWidget {
  const NotificationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text("HARI INI", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Card(
          color: Colors.red[50],
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.red.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Critical Alert", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 8),
                Text("Peringatan Kandang A", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 4),
                Text("Tingkat kepasifan ayam meningkat. Segera periksa kandang!"),
                SizedBox(height: 8),
                Text("10 menit yang lalu", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}