// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/bindings/init_dependencies.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/encrypt_decrypt_password.dart';
import 'package:portasauna/core/utils/send_email.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/auth/controller/profile_controller.dart';
import 'package:portasauna/features/auth/presentation/reset_pass_otp_page.dart';
import 'package:portasauna/features/home/presentation/landing_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangePasswordController extends GetxController {
  final emailController = TextEditingController();
  final newPassController = TextEditingController();

  bool isLoading = false;

  setLoadingTrue() {
    isLoading = true;
    update();
  }

  setLoadingFalse() {
    isLoading = false;
    update();
  }

  String sentOtpCode = "1234";

  sendEmailToChangePassword({
    required BuildContext context,
    bool keepLoggedIn = true,
  }) async {
    setLoadingTrue();

    try {
      Random random = Random();
      sentOtpCode = List.generate(4, (_) => random.nextInt(10)).join();

      await sendEmail(
          toEmail: emailController.text.trim(),
          emailText: "Here is your OTP code: $sentOtpCode",
          subject: "PortaSauna reset password");

      Get.to(const ResetPassOtpPage());
      showSnackBar(
          context, 'An OTP has been sent to your email', Pallete.primarColor);
    } catch (e) {
      showSnackBar(context, 'Failed to send OTP', Pallete.redColor);
      print('$e');
    } finally {
      update();
      setLoadingFalse();
    }
  }

  resetAndSetNewPasswordWhenNotLoggedIn(BuildContext context) async {
    try {
      setLoadingTrue();

      final userInfo = await dbClient
          .from('users')
          .select()
          .eq('email', emailController.text);

      print('user info $userInfo');

      var userPass = userInfo.first['password'];
      var userPassAfterDecrypt = decryptPassword(userPass);

      await dbClient.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: userPassAfterDecrypt,
      );

      //Updaing new password
      await dbClient.auth
          .updateUser(UserAttributes(password: newPassController.text.trim()));

      //updating new password to user table
      await dbClient.from('users').update({
        "password": encryptPassword(newPassController.text.trim())
      }).eq('email', emailController.text.trim());

      showSnackBar(context, 'Password updated', Pallete.primarColor);

      Get.find<ProfileController>().checkIfLoggedIn();
      Get.offAll(const LandingPage());
    } catch (e) {
      showSnackBar(context, 'Failed to reset password', Pallete.redColor);
      print('$e');
    } finally {
      setLoadingFalse();
    }
  }
}
