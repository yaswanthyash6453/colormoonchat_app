import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String profileImage;

  const ChatScreen({
    super.key,
    required this.userName,
    required this.profileImage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<String> messages = [
    "Hello",
    "Where are you",
    "Vizag, Where are you from",
    "Did you had lunch",
    "Yes, Yourself",
    "Did you know me?",
  ];

  // 🧹 CLEAR CHAT CONFIRMATION
  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Clear Chat"),
            content: const Text("Are you sure to Clear Chat?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  setState(() => messages.clear());
                  Navigator.pop(context);
                },
                child: const Text("Yes", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  // 🚫 BLOCK CONTACT CONFIRMATION
  void _showBlockDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Block the Contact"),
            content: const Text(
              "Are you sure you want to Block the Contact?\n\n"
              "If you block this contact you can't able to "
              "get or send the messages",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Contact Blocked")),
                  );
                },
                child: const Text("Yes", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  // ⋮ MENU CLICK
  void _onMenuSelected(String value) {
    if (value == "block") {
      _showBlockDialog();
    } else if (value == "clear") {
      _showClearChatDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1ECE6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B47D6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(backgroundImage: AssetImage(widget.profileImage)),
            const SizedBox(width: 10),
            Text(widget.userName, style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: _showClearChatDialog,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: _onMenuSelected,
            itemBuilder:
                (_) => const [
                  PopupMenuItem(
                    value: "block",
                    child: Text("Block the Contact"),
                  ),
                  PopupMenuItem(value: "clear", child: Text("Clear Chat")),
                ],
          ),
        ],
      ),

      // 💬 CHAT BODY
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: messages.length,
        itemBuilder: (_, index) {
          final isMe = index.isOdd;
          return Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                messages[index],
                style: TextStyle(color: isMe ? Colors.white : Colors.black),
              ),
            ),
          );
        },
      ),

      // ⌨ INPUT BAR
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Type your message here",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
