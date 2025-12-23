import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'get_started_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // ⏱️ EXACT 2 SECONDS HOLD
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GetStartedScreen()),
      );
    });
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

            // 🔥 MAIN CENTER CONTENT
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lottie/chat_animation.json',
                  height: 200,
                  repeat: true,
                ),
                const SizedBox(height: 30),

                Text(
                  "Chat Us",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: const Color(0xFF5538E6),
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

            // 🔻 POWERED BY SECTION (CENTER + BIGGER LOGO)
            // 🔻 POWERED BY SECTION (BIG + CENTER)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
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

                Image.asset(
                  'assets/images/colour_moon_logo.png',
                  height: 120, // 🔥 BIG SIZE
                  fit: BoxFit.contain,
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
