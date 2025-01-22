import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/custom_input.dart';
import 'package:portasauna/core/widgets/loader_widget.dart';
import 'package:portasauna/features/auth/controller/change_password_controller.dart';

class ResetPassSetNewPassPage extends StatefulWidget {
  const ResetPassSetNewPassPage({super.key});

  @override
  State<ResetPassSetNewPassPage> createState() =>
      _ResetPassSetNewPassPageState();
}

class _ResetPassSetNewPassPageState extends State<ResetPassSetNewPassPage> {
  final formKey = GlobalKey<FormState>();
  bool passwordVisible = false;

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
                      'Set new password',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    gapH(45),

                    //=============>
                    //Email
                    //=============>
                    CustomInput(
                      hintText: 'Enter new password',
                      controller: cpc.newPassController,
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
                        text: 'Save',
                        bgColor: Pallete.primarColor,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            cpc.resetAndSetNewPasswordWhenNotLoggedIn(context);
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
