import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationService {
  static void navigateToScreen(BuildContext context, screen) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => screen),
    );
  }

  static void navigateAndRemoveAll(BuildContext context, screen) {
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => screen,
        ),
        (route) => false);
  }
}
