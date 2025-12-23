import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFF3F3DFF),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          // ℹ️ ABOUT APP
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "About App",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("App Version"),
            trailing: Text("v1.0.0", style: TextStyle(color: Colors.grey)),
          ),

          const Divider(),

          // ❓ HELP
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("Help"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Help screen later
            },
          ),

          // 🔒 DATA PRIVACY
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text("Data Privacy"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Privacy screen later
            },
          ),

          const SizedBox(height: 30),

          // 🚪 LOGOUT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
