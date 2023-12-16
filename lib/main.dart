import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gramboo_sales_details/core/theme/theme.dart';
import 'package:gramboo_sales_details/features/auth/screens/login_screen.dart';
import 'package:gramboo_sales_details/features/dashboard/screens/dashBoard_screen.dart';
import 'package:gramboo_sales_details/features/sales_report/screens/salesReport_screen.dart';

import 'core/global_variables.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Palette.lightModeAppTheme,
      home: const LoginScreen(),
    );
  }
}
