import 'package:flutter/material.dart';

class AppTheme {
  // Define the colors for each user role
  static const Color beneficiaryColor = Color(0xFF7A6FCB);
  static const Color caregiverColor = Color(0xFF54B96F);
  static const Color volunteerColor = Color(0xFFD9A351);
  static const Color medicalSupervisorColor = Color(0xFF6A92D4);
  static const Color administratorColor = Color(0xFFA05A2B);
  static const Color defaultUserColor = Colors.blueAccent;

  // Button color for submission
  static const Color submitButtonColor = Colors.green;

  // Method to get the color based on user type
  static Color getUserTypeColor(String userType) {
    switch (userType) {
      case 'Beneficiary':
        return beneficiaryColor;
      case 'Caregiver':
        return caregiverColor;
      case 'Volunteer':
        return volunteerColor;
      case 'MedicalSupervisor':
        return medicalSupervisorColor;
      case 'Administrator':
        return administratorColor;
      default:
        return defaultUserColor;
    }
  }

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Tajawal',
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontFamily: 'Tajawal',
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Tajawal',
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(submitButtonColor), // Green for submission button
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        foregroundColor: WidgetStateProperty.all(Colors.white),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: beneficiaryColor,
      secondary: caregiverColor,
      surface: Colors.white,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Tajawal',
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontFamily: 'Tajawal',
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Tajawal',
        fontWeight: FontWeight.w500,
        color: Colors.white70,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(submitButtonColor), // Green for submission button
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        foregroundColor: WidgetStateProperty.all(Colors.white),
      ),
    ),
    // Custom colors for dark mode
    colorScheme: const ColorScheme.dark(
      primary: beneficiaryColor,
      secondary: caregiverColor,
      surface: Color(0xFF121212), // Dark background
    ),
  );
}
