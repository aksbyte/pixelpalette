import 'package:flutter/material.dart';

class ThemeManager {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    hintColor: Colors.blueAccent,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.6),
    ),
    iconTheme: const IconThemeData(color: Colors.black54),
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      onPrimary: Colors.white,
      secondary: Colors.green,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: Colors.white.withOpacity(0.8),
      onBackground: Colors.black,
      surface: Colors.grey,
      onSurface: Colors.black,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(
          fontSize: 22.0,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    primaryColor: Colors.indigo,
    hintColor: Colors.indigoAccent,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black.withOpacity(0.7),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    colorScheme: ColorScheme.dark(
      primary: Colors.indigo,
      onPrimary: Colors.white,
      secondary: Colors.green,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: Colors.black.withOpacity(0.8),
      onBackground: Colors.white,
      surface: Colors.grey,
      onSurface: Colors.white,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 22.0, fontStyle: FontStyle.italic),
      bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  );

  static const ThemeMode themeMode = ThemeMode.system;
}
