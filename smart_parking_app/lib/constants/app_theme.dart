import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  static ThemeData darkTheme = ThemeData(

    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF0F172A),

    primaryColor: const Color(0xFF38BDF8),

    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    ),

    colorScheme: const ColorScheme.dark(

      primary: Color(0xFF38BDF8),

      secondary: Color(0xFF22C55E),

      error: Color(0xFFEF4444),
    ),

    appBarTheme: const AppBarTheme(

      backgroundColor: Colors.transparent,

      elevation: 0,
    ),
  );
}