import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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

  final isLoginSuccessProvider = StateProvider((ref) => false);

  final branchValueProvider = StateProvider<String?>((ref) => "branch 1");

  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoginSuccessProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          height: isLoggedIn ? h * .6 : h * .5,
          padding: const EdgeInsets.all(20),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Login",
                        style: GoogleFonts.alice(fontSize: w * .1),
                      ),
                      SizedBox(
                        height: h * .02,
                      ),
                      TextFormField(
                        controller: _userNameController,
                        decoration: InputDecoration(
                          hintText: "Enter username",
                          prefixIcon: const Icon(
                            Icons.account_circle_sharp,
                            color: Palette.iconColor,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                width: 3, color: Colors.redAccent),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Palette.primaryColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Palette.primaryColor,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "This field can't be empty";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: h * .01,
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
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                width: 3, color: Colors.redAccent),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Palette.borderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter password";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: h * .02,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (!isLoggedIn) {
                            login();
                          }
                        },
                        child: Container(
                          height: h * .06,
                          width: w * .4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Palette.primaryColor),
                          child: Center(
                            child: Text(
                              isLoggedIn ? "Logged in" : "Log in",
                              style: TextStyle(
                                fontSize: w * .06,
                                color: Palette.textColor,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // if login success branch select drop down
                      if (isLoggedIn)
                        Column(
                          children: [
                            SizedBox(
                              height: h * .02,
                            ),
                            Text(
                              "Select branch",
                              style: GoogleFonts.alice(fontSize: w * .05),
                            ),
                            SizedBox(
                              height: h * .02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomDropDown(
                                  dropList: const [
                                    "branch 1",
                                    "branch 2",
                                    "branch 3",
                                  ],
                                  selectedValueProvider: branchValueProvider,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: h * .06,
                                    width: w * .4,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Palette.primaryColor),
                                    child: Center(
                                      child: Text(
                                        "Continue",
                                        style: TextStyle(
                                          fontSize: w * .06,
                                          color: Palette.textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  login() {
    // if login successful
    if (_formKey.currentState!.validate()) {
      ref.read(isLoginSuccessProvider.notifier).state = true;
    }
  }
}
