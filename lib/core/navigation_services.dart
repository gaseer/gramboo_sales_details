import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationService {
  static void navigateToScreen(BuildContext context, screen) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => screen),
    );
  }
}
