// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/bindings/init_dependencies.dart';
import 'package:portasauna/core/constants/admin_const.dart';
import 'package:portasauna/core/controllers/prefs_controller.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/encrypt_decrypt_password.dart';
import 'package:portasauna/core/utils/send_email.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/admin/features/homepage/admin_homepage.dart';
import 'package:portasauna/features/auth/controller/profile_controller.dart';
import 'package:portasauna/features/auth/model/user_model.dart';
import 'package:portasauna/features/home/presentation/landing_page.dart';

class AuthController extends GetxController {
//=====================>
//Login
//<=====================

  UserModel? loggedInUserInfo;
  bool isLoading = false;

  login({
    required BuildContext context,
    required String email,
    required String password,
    bool keepLoggedIn = true,
  }) async {
    if (email == AdminConst.adminEmail && password == AdminConst.adminPass) {
      loginAdmin();
      return;
    }

    isLoading = true;
    update();

    try {
      final response = await dbClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        loggedInUserInfo = UserModel.fromJson(response.user!.toJson());
      }
      Get.find<ProfileController>().checkIfLoggedIn();
      Get.offAll(const LandingPage());
    } catch (e) {
      showSnackBar(context, 'Invalid credentials', Colors.red);
      print(e);
    } finally {
      isLoading = false;
      update();
    }
  }

//=====================>
//Signup
//<=====================

  signup({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
  }) async {
    isLoading = true;
    update();

    try {
      final response = await dbClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'display_name': username,
        },
      );

      if (response.user != null) {
        loggedInUserInfo = UserModel.fromJson(response.user!.toJson());
      }
      await saveUserInfoToDb(userName: username, password: password);
      showSnackBar(context, 'Signup successful', Pallete.primarColor);
      Get.find<ProfileController>().checkIfLoggedIn();
      Get.offAll(const LandingPage());
      sendEmail(
          toEmail: AdminConst.adminEmail,
          emailText: ' Name: $username Email: $email',
          subject: "New user signed up");
    } catch (e) {
      showSnackBar(context, 'Something went wrong', Colors.red);
      print(e);
    } finally {
      isLoading = false;
      update();
    }
  }

//=====================>
//Save user info
//<=====================

  Future<bool> saveUserInfoToDb(
      {required userName, required String password}) async {
    final user = await dbClient.auth.getUser();
    final email = user.user?.email;
    final userId = user.user?.id;

    final response = await dbClient.from('users').insert({
      'email': email,
      'user_name': userName,
      "user_id": userId,
      "password": encryptPassword(password)
    }).select();

    if (response.first.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //=====================>
  //Login for admin
  //<=====================

  loginAdmin() async {
    PrefsController.setLoginAsAdmin = true;
    Get.offAll(const AdminHomepage());
  }
}
