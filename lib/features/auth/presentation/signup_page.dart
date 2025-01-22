import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/custom_input.dart';
import 'package:portasauna/core/widgets/loader_widget.dart';
import 'package:portasauna/features/auth/controller/auth_controller.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool keepLoggedIn = true;
  bool passwordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (ac) {
      return LoaderWidget(
        isLoading: ac.isLoading,
        child: Scaffold(
          appBar: appbarCommon('', context),
          body: SingleChildScrollView(
            child: Container(
              padding: screenPaddingH,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapH(20),

                    Text(
                      'Sign Up',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    gapH(5),
                    Text(
                      'Let\'s create an account',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    gapH(45),

                    //=============>
                    //Email
                    //=============>
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

                    //=============>
                    //Username
                    //=============>
                    CustomInput(
                        hintText: 'Username',
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a display name';
                          }
                          if (value.length < 3) {
                            return 'Display name must be at least 3 characters long';
                          }
                          return null;
                        },
                        controller: usernameController),

                    gapH(35),
                    CustomInput(
                      hintText: 'Password',
                      controller: passwordController,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                      isPasswordField: !passwordVisible,
                      suffixIcon: passwordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      onSuffixTap: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),

                    gapH(40),
                    ButtonPrimary(
                        text: 'Sign Up',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            ac.signup(
                              context: context,
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              username: usernameController.text.trim(),
                            );
                          }
                        }),
                    gapH(45),
                    ButtonPrimary(
                        text: 'Already have an account? Login',
                        bgColor: Colors.transparent,
                        onPressed: () {}),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
