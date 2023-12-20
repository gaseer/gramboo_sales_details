import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gramboo_sales_details/core/utilities/custom_snackBar.dart';
import 'package:gramboo_sales_details/features/auth/services/loginServices.dart';
import 'package:gramboo_sales_details/features/dashboard/screens/dashBoard_screen.dart';
import 'package:gramboo_sales_details/models/branch_model.dart';

import '../../../core/navigation_services.dart';

final authControllerProvider = NotifierProvider<AuthController, bool>(
  () => AuthController(),
);

final branchListProvider = StateProvider<List<BranchModel>>((ref) {
  return [];
});

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
    state = true;
    final res = await ref
        .read(authServiceProvider)
        .login(userName: userName, password: password);
    state = false;

    res.fold(
      (l) =>
          showSnackBar(content: l.errMSg, color: Colors.red, context: context),
      (uName) async {
        final res = await ref
            .read(authServiceProvider)
            .getUserBranches(userName: uName);

        res.fold(
          (l) => showSnackBar(
              content: l.errMSg, color: Colors.red, context: context),
          (bList) {
            ref.read(branchListProvider.notifier).update((state) => bList);
            showSnackBar(
                content: "Login success",
                color: Colors.green,
                context: context);
            NavigationService.navigateAndRemoveAll(
              context,
              const DashBoardScreen(),
            );
          },
        );
      },
    );
  }
}
