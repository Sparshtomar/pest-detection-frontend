import 'package:flutter/material.dart';

class AppTheme {
  static final Color primaryColor = Color(0xFF2E7D32);
  static final Color secondaryColor = Color(0xFF4CAF50);
  static final Color backgroundColor = Color(0xFFF5F9F6);
  static final Color cardColor = Colors.white;
  static final Color accentColor = Color(0xFFFFC107);

  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Poppins',
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: primaryColor),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}