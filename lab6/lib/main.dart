import 'package:flutter/material.dart';
import 'Views/GenreScreen.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cinematic - Find a Movie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
        primaryColor: const Color(0xFF6366F1), // Indigo 500
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF8B5CF6), // Violet 500
          surface: Color(0xFF1E293B), // Slate 800
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Color(0xFFF8FAFC), // Slate 50
        ),
        textTheme: const TextTheme(
          displayMedium: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Color(0xFFF8FAFC), letterSpacing: -0.5),
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Color(0xFFF8FAFC)),
          bodyLarge: TextStyle(fontSize: 16.0, color: Color(0xFF94A3B8)), // Slate 400
          bodyMedium: TextStyle(fontSize: 14.0, color: Color(0xFF94A3B8)),
        ),
        useMaterial3: true,
      ),
      home: const GenreScreen(),
    );
  }
}
