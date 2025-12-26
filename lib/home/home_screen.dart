import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'widgets/chat_tile.dart';
import '../../utils/greeting_utils.dart';
import '../chat/chat_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late final String myUid;

  @override
  void initState() {
    super.initState();
    myUid = widget.userId;
    WidgetsBinding.instance.addObserver(this);
    _setOnline(true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _setOnline(false);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _setOnline(state == AppLifecycleState.resumed);
  }

  Future<void> _setOnline(bool value) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(myUid).update({
        'online': value,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  String _chatId(String a, String b) {
    final ids = [a, b]..sort();
    return ids.join("_");
  }

  String _formatTime(Timestamp? time) {
    if (time == null) return "";
    final d = time.toDate();
    return "${d.hour}:${d.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final greeting = getGreeting();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          // 🔵 HEADER
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
                children: [
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

                  // 🔥 REAL-TIME USER NAME (FIXED)
                  StreamBuilder<DocumentSnapshot>(
                    stream:
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(myUid)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text(
                          "Loading...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }

                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final name = data['name'] ?? "User";

                      return Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 🔥 USERS LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, userSnap) {
                if (!userSnap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users =
                    userSnap.data!.docs.where((u) => u.id != myUid).toList();

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final userData = user.data() as Map<String, dynamic>;
                    final chatId = _chatId(myUid, user.id);

                    return StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('chats')
                              .doc(chatId)
                              .collection('messages')
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                      builder: (context, msgSnap) {
                        String lastMsg = "Tap to chat";
                        String time = "";
                        int unread = 0;

                        if (msgSnap.hasData && msgSnap.data!.docs.isNotEmpty) {
                          final docs = msgSnap.data!.docs;
                          final last = docs.first;
                          final data = last.data() as Map<String, dynamic>;

                          lastMsg = data['text'] ?? "";
                          if (data['timestamp'] != null) {
                            time = _formatTime(data['timestamp']);
                          }

                          unread =
                              docs.where((m) {
                                final d = m.data() as Map<String, dynamic>;
                                return d['receiverId'] == myUid &&
                                    d['isSeen'] == false;
                              }).length;
                        }

                        return ChatTile(
                          name: userData['name'] ?? "User",
                          message: lastMsg,
                          time: time,
                          unread: unread,
                          online: userData['online'] ?? false,
                          photoUrl: userData['photoUrl'] ?? "",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ChatScreen(
                                      userName: userData['name'] ?? "User",
                                      photoUrl: userData['photoUrl'] ?? "",
                                      otherUserId: user.id,
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
