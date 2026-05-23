import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary colour gradient (used in AppBar for a subtle “تدرج لوني”).
  static const LinearGradient appBarGradient = LinearGradient(
    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Simple, clean theme with Poppins font.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.deepPurple,
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      textTheme: GoogleFonts.poppinsTextTheme(),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.deepPurple,
        ),
        iconTheme: const IconThemeData(color: Colors.deepPurple),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Color(0xFF6A11CB),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }

   static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: Colors.deepPurple,
      scaffoldBackgroundColor: const Color(0xFF121212),
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.white54,
        showUnselectedLabels: true,
        backgroundColor: Color(0xFF1E1E1E),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF2C2C2C),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF6A11CB),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Colors.white54),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      primaryIconTheme: const IconThemeData(color: Colors.white),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF2C2C2C),
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: Color(0xFF2C2C2C),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        contentTextStyle: TextStyle(color: Colors.white70),
      ),
    );
  }
}