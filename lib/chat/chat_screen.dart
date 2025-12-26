import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String photoUrl; // 🔥 Firestore image URL (may be empty)
  final String otherUserId;

  const ChatScreen({
    super.key,
    required this.userName,
    required this.photoUrl,
    required this.otherUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  late final String chatId;

  bool isBlocked = false;

  @override
  void initState() {
    super.initState();

    final ids = [currentUserId, widget.otherUserId]..sort();
    chatId = ids.join("_");

    _markMessagesAsSeen();
    _checkBlockedStatus();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // ---------------- BLOCK ----------------

  Future<void> _checkBlockedStatus() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('blocked')
            .doc(currentUserId)
            .get();

    if (doc.exists && doc.data()!.containsKey(widget.otherUserId)) {
      setState(() => isBlocked = true);
    }
  }

  Future<void> _blockUser() async {
    await FirebaseFirestore.instance
        .collection('blocked')
        .doc(currentUserId)
        .set({widget.otherUserId: true}, SetOptions(merge: true));

    setState(() => isBlocked = true);
  }

  Future<void> _unblockUser() async {
    await FirebaseFirestore.instance
        .collection('blocked')
        .doc(currentUserId)
        .update({widget.otherUserId: FieldValue.delete()});

    setState(() => isBlocked = false);
  }

  // ---------------- SEEN ----------------

  Future<void> _markMessagesAsSeen() async {
    final snap =
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .where('receiverId', isEqualTo: currentUserId)
            .where('isSeen', isEqualTo: false)
            .get();

    for (var doc in snap.docs) {
      doc.reference.update({
        'isSeen': true,
        'seenBy': FieldValue.arrayUnion([currentUserId]),
      });
    }
  }

  // ---------------- SEND ----------------

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || isBlocked) return;

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
          'text': text,
          'senderId': currentUserId,
          'receiverId': widget.otherUserId,
          'timestamp': FieldValue.serverTimestamp(),
          'isSeen': false,
          'seenBy': [],
          'deletedFor': [],
        });

    _messageController.clear();
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1ECE6),

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B47D6),

        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade300,
              child: ClipOval(
                child:
                    widget.photoUrl.isNotEmpty
                        ? Image.network(
                          widget.photoUrl,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Image.asset(
                              "assets/images/profile.png",
                              fit: BoxFit.cover,
                            );
                          },
                        )
                        : Image.asset(
                          "assets/images/profile.png",
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                        ),
              ),
            ),
            const SizedBox(width: 10),
            Text(widget.userName),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            iconColor: Colors.white,
            onSelected: (v) {
              if (v == 'block') {
                isBlocked ? _unblockUser() : _blockUser();
              }
            },
            itemBuilder:
                (_) => [
                  PopupMenuItem(
                    value: 'block',
                    child: Text(
                      isBlocked ? "Unblock Contact" : "Block Contact",
                    ),
                  ),
                ],
          ),
        ],
      ),

      // ================= CHAT BODY =================
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('chats')
                .doc(chatId)
                .collection('messages')
                .orderBy('timestamp')
                .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final raw = docs[i].data() as Map<String, dynamic>;
              final deletedFor = (raw['deletedFor'] ?? []) as List;

              if (deletedFor.contains(currentUserId)) {
                return const SizedBox.shrink();
              }

              final isMe = raw['senderId'] == currentUserId;

              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        raw['text'] ?? "",
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                        ),
                      ),
                      if (isMe)
                        Icon(
                          raw['isSeen'] == true ? Icons.done_all : Icons.done,
                          size: 14,
                          color:
                              raw['isSeen'] == true
                                  ? Colors.lightBlue
                                  : Colors.white70,
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      // ================= INPUT =================
      bottomNavigationBar:
          isBlocked
              ? Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey.shade200,
                child: const Text(
                  "You blocked this contact",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Type message",
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
                    GestureDetector(
                      onTap: _sendMessage,
                      child: const CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
