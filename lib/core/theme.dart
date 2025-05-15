import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFF5E4F34),
  primaryColor: const Color(0xFF5E4F34),
  textTheme: GoogleFonts.poppinsTextTheme().copyWith(
    titleLarge: GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 16,
      color: Colors.white,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: 14,
      color: Colors.white70,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: 1.2,
      shadows: [
        Shadow(
          blurRadius: 4,
          color: Colors.black45,
          offset: Offset(2, 2),
        ),
      ],
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  cardTheme: CardTheme(
    color: Colors.white.withOpacity(0.95),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 4,
    margin: const EdgeInsets.symmetric(vertical: 8),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.green[600],
    behavior: SnackBarBehavior.floating,
    contentTextStyle: GoogleFonts.poppins(
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: GoogleFonts.poppins(color: Colors.black45),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    menuStyle: MenuStyle(
      backgroundColor: MaterialStateProperty.all(Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple[400],
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      textStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    ),
  ),
);