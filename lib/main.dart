// lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Screens
import 'package:recipe_book_app/screens/home_page.dart';
import 'package:recipe_book_app/screens/add_recipe_page.dart';
import 'package:recipe_book_app/screens/recipe_detail_page.dart';
import 'package:recipe_book_app/screens/auth/login_page.dart';
import 'package:recipe_book_app/screens/auth/signup_page.dart';
import 'package:recipe_book_app/screens/profile_page.dart';
import 'package:recipe_book_app/screens/saved_recipes_page.dart';
import 'package:recipe_book_app/screens/chat_page.dart';

// Firebase generated config
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Load .env BEFORE Firebase
  await dotenv.load();

  // ✅ Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const RecipeBookApp());
}

class RecipeBookApp extends StatelessWidget {
  const RecipeBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();

    final theme = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.teal,
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: baseTextTheme,
      cardTheme: CardThemeData(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Book',
      theme: theme,
      home: const AuthGate(),
      routes: {
        '/home': (_) => const HomePage(),
        
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignUpPage(),
        '/profile': (_) => const ProfilePage(),
        '/saved_recipes': (_) => const SavedRecipesPage(),
        '/chat': (_) => const ChatPage(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        // Loading splash
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ✅ User logged in → Home
        if (snap.hasData) return const HomePage();

        // ✅ User logged out → Login
        return const LoginPage();
      },
    );
  }
}
