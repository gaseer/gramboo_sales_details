import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gramboo_sales_details/core/navigation_services.dart';
import 'package:gramboo_sales_details/core/utilities/custom_dropDown.dart';
import 'package:gramboo_sales_details/features/dashboard/screens/dashBoard_screen.dart';

import '../../../core/global_variables.dart';
import '../../../core/theme/theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  final obscureTextProvider = StateProvider((ref) => true);

  final branchValueProvider = StateProvider<String?>((ref) => "branch 1");

  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _userNameController,
                decoration: const InputDecoration(
                  hintText: "Enter username",
                  prefixIcon: Icon(
                    Icons.account_circle_sharp,
                    color: Palette.iconColor,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.redAccent),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Palette.primaryColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Palette.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: ref.watch(obscureTextProvider),
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Palette.iconColor,
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.redAccent),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Palette.borderColor,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Palette.borderColor,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (ref.read(obscureTextProvider)) {
                        ref
                            .read(obscureTextProvider.notifier)
                            .update((state) => false);
                      } else {
                        ref
                            .read(obscureTextProvider.notifier)
                            .update((state) => true);
                      }
                    },
                    icon: const Icon(
                      Icons.remove_red_eye_outlined,
                      color: Palette.iconColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: h * .05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomDropDown(dropList: [
                    "branch 1",
                    "branch 2",
                    "branch 3",
                  ], selectedValueProvider: branchValueProvider),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.cardColor,
                      fixedSize: const Size(150, 60),
                    ),
                    onPressed: () {
                      NavigationService.navigateToScreen(
                        context,
                        DashBoardScreen(),
                      );
                    },
                    child: const Text(
                      "Log in",
                      style: TextStyle(fontSize: 20, color: Palette.textColor),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
