import 'package:flutter/material.dart';
import 'widgets/chat_tile.dart';
import '../../utils/greeting_utils.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final greeting = getGreeting();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // 🔵 CUSTOM TOP BAR
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF3F3DFF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 👤 USER + GREETING
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hi, $greeting",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userName, // 🔥 dynamic username
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🌡️ TEMPERATURE
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.wb_sunny, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text("48°C", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // ⚙️ SETTINGS ICON
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // 🧾 CHAT LIST
            Expanded(
              child: ListView(
                children: const [
                  ChatTile(name: "Rajesh", message: "Hello", unread: 2),
                  ChatTile(name: "Suresh", message: "Good Morning", unread: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
