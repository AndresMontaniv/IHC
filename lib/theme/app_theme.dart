import 'package:flutter/material.dart';

class AppTheme {
  static Color primary = Colors.blue.shade900;
  static Color secondary = Colors.blue.shade800;
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    // Primary Color
    primaryColor: primary,

    //AppBar Theme
    appBarTheme: AppBarTheme(
      color: primary,
      elevation: 0,
      centerTitle: true,
    ),

    //TextButton Theme

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: primary),
    ),

    //Floation action button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
    ),

    //Elevated button

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: primary,
        shape: const StadiumBorder(),
        elevation: 0,
      ),
    ),

    scaffoldBackgroundColor: Colors.grey[300],
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
      // Primary Color
      primaryColor: Colors.indigo,

      //AppBar Theme
      appBarTheme: AppBarTheme(
        color: primary,
        elevation: 0,
        centerTitle: true,
      ),
      scaffoldBackgroundColor: Colors.black);
}
