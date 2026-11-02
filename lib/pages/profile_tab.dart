import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Informasi Pengguna", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.green),
            title: const Text("Nama"),
            subtitle: const Text("Resky Muh. Saleh"),
          ),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.green),
            title: const Text("Email"),
            subtitle: const Text("reskymuh.saleh@gmail.com"),
          ),
        ],
      ),
    );
  }
}