
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/custom_input.dart';
import 'package:portasauna/core/widgets/loader_widget.dart';
import 'package:portasauna/features/auth/controller/change_password_controller.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangePasswordController>(builder: (cpc) {
      return LoaderWidget(
        isLoading: cpc.isLoading,
        child: Scaffold(
          appBar: appbarCommon('', context),
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Container(
                padding: screenPaddingH,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapH(20),

                    Text(
                      'Forgot password?',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    gapH(5),
                    Text(
                      'Enter your email, phone, or username and we\'ll send you a link to set a new password',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    gapH(45),

                    //=============>
                    //Email
                    //=============>
                    CustomInput(
                      hintText: 'Email',
                      controller: cpc.emailController,
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
                    ),
                    gapH(35),

                    gapH(40),
                    ButtonPrimary(
                        text: 'Reset password',
                        bgColor: Pallete.primarColor,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            cpc.sendEmailToChangePassword(context: context);
                          }
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
}
