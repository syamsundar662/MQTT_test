import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black)),
    ),
    brightness: Brightness.light,
    primaryColor: Colors.black,
    colorScheme: const ColorScheme.light().copyWith(
        surface: Colors.white,
        primary: const Color.fromARGB(75, 179, 179, 179),
        secondary: Colors.grey,
        onPrimary: Colors.black,
        onTertiary: Colors.white),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Color.fromARGB(255, 3, 80, 115),
        unselectedItemColor: Color.fromARGB(255, 125, 125, 125)));
