import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final int unread;
  final bool online;
  final VoidCallback? onTap; // ✅ ADD THIS

  const ChatTile({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.unread,
    required this.online,
    this.onTap, // ✅ ADD THIS
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // ✅ TAP HANDLER
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // 👤 PROFILE + ONLINE DOT
            Stack(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage("assets/images/ram.png"),
                ),
                if (online)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 30, 38, 182),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 14),

            // 💬 NAME + MESSAGE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ⏰ TIME + UNREAD
            Column(
              children: [
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                if (unread > 0)
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.blue,
                    child: Text(
                      unread.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
