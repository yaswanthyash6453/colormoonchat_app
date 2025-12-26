import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'get_started_screen.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // ❌ Not logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const GetStartedScreen()),
        );
      } else {
        // ✅ Logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => HomeScreen(
                  userId: user.uid, // ✅ ONLY userId
                ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(flex: 2),

            Column(
              children: [
                Lottie.asset('assets/lottie/chat_animation.json', height: 200),
                const SizedBox(height: 30),
                const Text(
                  "Chat Us",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: Color(0xFF5538E6),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Flutter Developer Task",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const Spacer(flex: 3),

            Column(
              children: [
                const Text(
                  "POWERED BY",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Image.asset('assets/images/colour_moon_logo.png', height: 120),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
