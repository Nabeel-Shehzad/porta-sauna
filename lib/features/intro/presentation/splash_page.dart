// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/constants/assets_const.dart';
import 'package:portasauna/core/controllers/prefs_controller.dart';
import 'package:portasauna/admin/features/homepage/admin_homepage.dart';
import 'package:portasauna/features/auth/controller/profile_controller.dart';
import 'package:portasauna/features/auth/presentation/login_page.dart';
import 'package:portasauna/features/home/presentation/landing_page.dart';
import 'package:portasauna/features/intro/presentation/intro_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(
        seconds: 1,
      ),
      () async {
        final pc = Get.find<ProfileController>();
        bool keepLoggedIn = PrefsController.getKeepLoggedIn;

        if (!keepLoggedIn) {
          Get.offAll(const LoginPage());
          pc.logout(context);
          return;
        }
        //check if user logged in as admin last time
        bool loginAsAdmin = PrefsController.getLoginAsAdmin;
        if (loginAsAdmin) {
          Get.offAll(const AdminHomepage());
          return;
        }

        //Normal user login

        int userEntered = PrefsController.getUserEnteredAppCount;
        if (userEntered == 1) {
          Get.offAll(const IntroPage());
          return;
        }
        if (pc.isLoggedIn) {
          Get.offAll(const LandingPage());
        } else {
          Get.offAll(const LoginPage());
        }
      },
    );

    return Scaffold(
      body: Column(
        children: [
          Image.asset(AssetsConst.splashBgImg),
          Image.asset(AssetsConst.logoWhiteImg,
              width: 140.w, fit: BoxFit.fitWidth),
        ],
      ),
    );
  }
}
