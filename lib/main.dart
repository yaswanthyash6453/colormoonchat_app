import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'splash/splash_screen.dart';
import 'splash/get_started_screen.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'settings/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Firebase Init (Auth + Firestore + Storage)
  await Firebase.initializeApp();

  // 📦 Hive Init (Local Storage for Profile Image)
  await Hive.initFlutter();
  await Hive.openBox<String>('profileBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🔥 APP ALWAYS STARTS FROM SPLASH
      home: const SplashScreen(),

      // 🧭 ONLY STATIC ROUTES
      routes: {
        '/getStarted': (_) => const GetStartedScreen(),
        '/register': (_) => const RegisterScreen(),
        '/login': (_) => const LoginScreen(),
        '/settings': (_) => const SettingsScreen(),
      },

      // ❌ IMPORTANT:
      // ❌ HomeScreen, UploadProfilePhotoScreen
      // ❌ NEVER add here (they need dynamic data like userId)
    );
  }
}
