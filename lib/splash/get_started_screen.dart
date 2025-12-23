import 'dart:async';
import 'package:flutter/material.dart';
import '../auth/register_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  bool moved = false;
  int questionIndex = 0;

  final List<String> questions = [
    "Who do you want to chat with today?",
    "Ready to start a conversation?",
    "Private chats, made simple 💬",
  ];

  @override
  void initState() {
    super.initState();

    // 🔄 Avatar movement
    Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() => moved = !moved);
    });

    // 🔄 Question change
    Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {
        questionIndex = (questionIndex + 1) % questions.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FFF6),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 20),

            // 🔵 MOVING AVATARS + EMOJIS
            SizedBox(
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _animatedAvatar(
                    top: 10,
                    left: moved ? 120 : 150,
                    size: 80,
                    image: 'assets/images/image1.png',
                  ),
                  _animatedAvatar(
                    top: 90,
                    left: moved ? 20 : 40,
                    size: 70,
                    image: 'assets/images/image2.png',
                  ),
                  _animatedAvatar(
                    top: 90,
                    right: moved ? 20 : 40,
                    size: 70,
                    image: 'assets/images/image3.png',
                  ),
                  _animatedAvatar(
                    bottom: 20,
                    left: moved ? 120 : 150,
                    size: 80,
                    image: 'assets/images/image4.png',
                  ),

                  const Positioned(
                    top: 60,
                    right: 120,
                    child: Text("😡", style: TextStyle(fontSize: 28)),
                  ),
                  const Positioned(
                    bottom: 60,
                    left: 80,
                    child: Text("🥰", style: TextStyle(fontSize: 28)),
                  ),
                  const Positioned(
                    bottom: 40,
                    right: 90,
                    child: Text("🤔", style: TextStyle(fontSize: 28)),
                  ),
                ],
              ),
            ),

            // 📝 TEXT CONTENT + QUESTIONS
            Column(
              children: [
                const Text(
                  "Enjoy the Joy of",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Chatting with Friends",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 85, 69, 232),
                  ),
                ),
                const SizedBox(height: 14),

                // 🔥 AUTO CHANGING QUESTION
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  transitionBuilder: (child, animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(animation),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Padding(
                    key: ValueKey(questionIndex),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      questions[questionIndex],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),

            // 🟢 GET STARTED BUTTON
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 59, 62, 242),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Animated Avatar Widget (FIXED)
  Widget _animatedAvatar({
    double? top,
    double? left,
    double? right,
    double? bottom,
    required double size,
    required String image,
  }) {
    return AnimatedPositioned(
      duration: const Duration(seconds: 2),
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: CircleAvatar(
        radius: size / 2,
        backgroundImage: AssetImage(image), // ✅ FIX
      ),
    );
  }
}
