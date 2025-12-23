import 'package:flutter/material.dart';
import 'splash/splash_screen.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'profile/upload_profile_photo_screen.dart';
import 'home/home_screen.dart';
import 'settings/settings_screen.dart';
import 'splash/get_started_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🔥 APP STARTS FROM SPLASH
      home: const SplashScreen(),

      routes: {
        '/getStarted': (_) => const GetStartedScreen(),
        '/register': (_) => const RegisterScreen(),
        '/uploadPhoto': (_) => const UploadProfilePhotoScreen(),
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(userName: "Yeswanth"),
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}
