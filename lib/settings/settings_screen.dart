import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../splash/splash_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String appVersion = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = "v${info.version}";
    });
  }

  // 🔥 LOGOUT FUNCTION (NO ERROR VERSION)
  Future<void> _logout(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      if (user != null) {
        // ✅ Set offline + last seen
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
              'online': false,
              'lastSeen': FieldValue.serverTimestamp(),
            });

        // ✅ Firebase sign out
        await FirebaseAuth.instance.signOut();
      }
    } catch (e) {
      debugPrint("Logout error: $e");
    }

    // ✅ Go to Splash Screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (route) => false,
    );
  }

  // 🔥 LOGOUT CONFIRMATION
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Logout"),
            content: const Text("Are you sure you want to logout?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _logout(context);
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

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

          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "About App",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("App Version"),
            trailing: Text(
              appVersion,
              style: const TextStyle(color: Colors.grey),
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("Help"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text("Data Privacy"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),

          const SizedBox(height: 30),

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
              onPressed: () => _showLogoutDialog(context),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
