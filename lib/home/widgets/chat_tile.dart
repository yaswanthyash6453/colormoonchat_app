import 'dart:io';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final int unread;
  final bool online;
  final VoidCallback? onTap;

  // 🔥 IMAGE SOURCES
  final String? photoUrlPath; // local file path
  final String? photoUrl; // firestore / network url

  const ChatTile({
    super.key,
    required this.name,
    required this.message,
    this.time = "",
    this.unread = 0,
    required this.online,
    this.onTap,
    this.photoUrlPath,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider avatar;

    // ✅ PRIORITY 1: LOCAL IMAGE
    if (photoUrlPath != null &&
        photoUrlPath!.isNotEmpty &&
        File(photoUrlPath!).existsSync()) {
      avatar = FileImage(File(photoUrlPath!));

      // ✅ PRIORITY 2: FIRESTORE / NETWORK IMAGE
    } else if (photoUrl != null && photoUrl!.isNotEmpty) {
      avatar = NetworkImage(photoUrl!);

      // ✅ PRIORITY 3: DEFAULT ASSET
    } else {
      avatar = const AssetImage("assets/images/profile.png");
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // 🔵 PROFILE IMAGE + ONLINE DOT
            Stack(
              children: [
                CircleAvatar(radius: 26, backgroundImage: avatar),
                if (online)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 14),

            // 🔤 NAME + LAST MESSAGE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ⏰ TIME + UNREAD COUNT
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (time.isNotEmpty)
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
