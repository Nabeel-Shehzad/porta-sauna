import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/controllers/prefs_controller.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/custom_input.dart';
import 'package:portasauna/core/widgets/loader_widget.dart';
import 'package:portasauna/features/auth/controller/auth_controller.dart';
import 'package:portasauna/features/auth/presentation/forgot_pass_page.dart';
import 'package:portasauna/features/auth/presentation/signup_page.dart';
import 'package:portasauna/features/home/presentation/landing_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool keepLoggedIn = true;
  bool passwordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (ac) {
      return LoaderWidget(
        isLoading: ac.isLoading,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Container(
                padding: screenPaddingH,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapH(60),
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    gapH(5),
                    Text(
                      'Please enter your detail',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    gapH(45),
                    CustomInput(
                        hintText: 'Email',
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!RegExp(
                                  r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        controller: emailController),
                    gapH(35),
                    CustomInput(
                      hintText: 'Password',
                      controller: passwordController,
                      validation: (v) {
                        if (v == null || v.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      isPasswordField: !passwordVisible,
                      suffixIcon: passwordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      onSuffixTap: () {
                        setState(
                          () {
                            passwordVisible = !passwordVisible;
                          },
                        );
                      },
                    ),

                    gapH(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(const ForgotPassPage());
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            child: Text(
                              'Forgot password?',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        )
                      ],
                    ),

                    //keep logged in checkbox
                    rememberMe(context),
                    gapH(20),
                    ButtonPrimary(
                        text: 'Login',
                        bgColor: Pallete.primarColor,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            ac.login(
                                context: context,
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                keepLoggedIn: keepLoggedIn);
                          }
                        }),
                    gapH(15),
                    ButtonPrimary(
                        text: 'Explore without account',
                        onPressed: () {
                          Get.offAll(const LandingPage());
                        }),
                    gapH(45),
                    ButtonPrimary(
                        text: 'Don\'t have an account?',
                        bgColor: Colors.transparent,
                        onPressed: () {
                          Get.to(const SignupPage());
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  CheckboxListTile rememberMe(BuildContext context) {
    return CheckboxListTile(
      checkColor: Colors.white,
      activeColor: Pallete.primarColor,
      contentPadding: const EdgeInsets.all(0),
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child:
            Text("Remember Me", style: Theme.of(context).textTheme.bodySmall),
      ),
      value: keepLoggedIn,
      onChanged: (newValue) {
        setState(() {
          keepLoggedIn = !keepLoggedIn;
        });
        PrefsController.setKeepLoggedIn = keepLoggedIn;
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
