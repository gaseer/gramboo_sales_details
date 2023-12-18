import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global_variables.dart';

class Palette {
  static const primaryColor = Color.fromRGBO(141, 186, 234, 1.0);
  static const appBarColor = Color.fromRGBO(141, 186, 234, 1.0);
  static const borderColor = Colors.black;
  static const cardColor = Colors.white;
  static const textColor = Colors.black;
  static const iconColor = Colors.black;

  static var lightModeAppTheme = ThemeData.light(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: primaryColor,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: appBarColor,
      iconTheme: const IconThemeData(color: iconColor),
      titleTextStyle: GoogleFonts.alice(
        color: textColor,
        fontSize: w * .07,
      ),
    ),
    iconTheme: const IconThemeData(
      color: iconColor,
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(iconColor),
      ),
    ),
    cardTheme: const CardTheme(
      color: cardColor,
      elevation: 0,
    ),
  );
}
