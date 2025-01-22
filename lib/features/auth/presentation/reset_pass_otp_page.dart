import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/loader_widget.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/auth/controller/change_password_controller.dart';
import 'package:portasauna/features/auth/presentation/reset_pass_set_new_pass_page.dart';

class ResetPassOtpPage extends StatefulWidget {
  const ResetPassOtpPage({super.key});

  @override
  State<ResetPassOtpPage> createState() => _ResetPassOtpPageState();
}

class _ResetPassOtpPageState extends State<ResetPassOtpPage> {
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
                      'Check your email',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    gapH(5),
                    Text(
                      'Make sure to check your spam box.',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Colors.yellow, fontSize: 20.sp),
                    ),
                    gapH(5),
                    Text(
                      'We have sent an OTP to your email. Enter the OTP below to reset your password.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    gapH(45),

                    //=============>
                    //Otp
                    //=============>
                    Pinput(
                      length: 4,
                      defaultPinTheme: PinTheme(
                        width: 60.w,
                        height: 60.h,
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.45),
                          borderRadius: radius(1),
                        ),
                      ),
                      onCompleted: (pin) {
                        if (pin == cpc.sentOtpCode) {
                          Get.to(const ResetPassSetNewPassPage());
                        } else {
                          showSnackBar(
                              context,
                              'Make sure you entered the correct OTP',
                              Pallete.redColor);
                        }
                      },
                    ),
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
