import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gramboo_sales_details/core/utilities/custom_snackBar.dart';
import 'package:gramboo_sales_details/features/auth/services/loginServices.dart';
import 'package:gramboo_sales_details/features/dashboard/screens/dashBoard_screen.dart';

import '../../../core/navigation_services.dart';

final authControllerProvider = NotifierProvider<AuthController, bool>(
  () => AuthController(),
);

class AuthController extends Notifier<bool> {
  AuthController();

  @override
  build() {
    return false;
  }

  login(
      {required String userName,
      required String password,
      required BuildContext context}) async {
    final res = await ref
        .read(authServiceProvider)
        .login(userName: userName, password: password);

    res.fold(
      (l) =>
          showSnackBar(content: l.errMSg, context: context, color: Colors.red),
      (r) {
        NavigationService.navigateToScreen(
          context,
          const DashBoardScreen(),
        );
        return showSnackBar(
            content: "Login success", context: context, color: Colors.green);
      },
    );
  }
}
