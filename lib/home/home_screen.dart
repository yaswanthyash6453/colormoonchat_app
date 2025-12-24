import 'package:flutter/material.dart';
import '../home/widgets/chat_tile.dart';
import '../../utils/greeting_utils.dart';
import '../chat/chat_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final greeting = getGreeting();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          // 🔵 TOP HEADER (NO OVERFLOW)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF1C4ED8),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(26),
                bottomRight: Radius.circular(26),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔝 TOP ROW
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreen(),
                            ),
                          );
                        },
                        child: const CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage(
                            "assets/images/profile.png",
                          ),
                        ),
                      ),

                      const Spacer(),

                      // 🌡 TEMPERATURE
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
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

                      // ⚙ SETTINGS
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          Navigator.pushNamed(context, '/settings');
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // 👋 GREETING
                  Text(
                    "Hi, $greeting",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),

                  const SizedBox(height: 4),

                  // 👤 USER NAME
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 👥 USER COUNTS
                  Row(
                    children: const [
                      Expanded(
                        child: _UserCountCard(
                          title: "Registered Users",
                          count: "190",
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _UserCountCard(
                          title: "Online Users",
                          count: "86",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 🧾 CHAT LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 8),
              children: [
                ChatTile(
                  name: "Venkatesh",
                  message: "Meet me Tomorrow",
                  time: "05:26 PM",
                  unread: 2,
                  online: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => const ChatScreen(
                              userName: "Venkatesh",
                              profileImage:
                                  "assets/images/profile.png", // ✅ fixed
                            ),
                      ),
                    );
                  },
                ),

                ChatTile(
                  name: "Rajesh",
                  message: "Did you have your Lunch?",
                  time: "05:26 PM",
                  unread: 1,
                  online: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => const ChatScreen(
                              userName: "Rajesh",
                              profileImage: "assets/images/pk.png", // ✅ exists
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 🟢 USER COUNT CARD (SAFE SIZE)
class _UserCountCard extends StatelessWidget {
  final String title;
  final String count;

  const _UserCountCard({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
