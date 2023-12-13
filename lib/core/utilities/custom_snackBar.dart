import 'package:flutter/material.dart';

showSnackBar({required String content, required BuildContext context}) {
  final snackBar = SnackBar(content: Text(content));
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
