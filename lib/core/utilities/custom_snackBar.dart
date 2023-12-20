import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

showSnackBar(
    {required String content, required BuildContext context, Color? color}) {
  final snackBar = SnackBar(
    content: Text(
      content,
      textAlign: TextAlign.center,
      style: GoogleFonts.abel(
          letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 20),
    ),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
