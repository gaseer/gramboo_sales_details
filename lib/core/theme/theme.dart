import 'package:flutter/material.dart';

class Palette {
  static const primaryColor = Color.fromRGBO(232, 240, 251, 1.0);
  static const appBarColor = Color.fromRGBO(232, 240, 251, 1.0);
  static const borderColor = Colors.black;
  static const cardColor = Colors.white;
  static const textColor = Colors.black;

  static const iconColor = Colors.black;

  static var lightModeAppTheme = ThemeData.light(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: primaryColor,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      color: appBarColor,
      iconTheme: IconThemeData(color: iconColor),
    ),
    iconTheme: const IconThemeData(
      color: iconColor,
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(iconColor),
      ),
    ),
    cardColor: cardColor,
  );
}
