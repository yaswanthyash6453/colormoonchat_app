import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final int unread;

  const ChatTile({
    super.key,
    required this.name,
    required this.message,
    required this.unread,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(message),
      trailing:
          unread > 0
              ? CircleAvatar(
                radius: 12,
                backgroundColor: const Color.fromARGB(255, 39, 42, 194),
                child: Text(
                  unread.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
              : null,
    );
  }
}
