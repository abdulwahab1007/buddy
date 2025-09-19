import 'package:buddy/res/contants/colors_contants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  scaffoldBackgroundColor: Colors.white,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorsContants.primaryColor,
      minimumSize: const Size(200, 40),
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600, // Optional: Add weight or style
        //color: Colors.white, // Optional: Set text color
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.white, width: 1),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xffff2dafe), // Light background color

    // Invisible border with rounded corners
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),

    labelStyle: const TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
    hintStyle: const TextStyle(
      color: Color(0xFF7D8B91),
      fontSize: 14,
    ),
  ),
);
