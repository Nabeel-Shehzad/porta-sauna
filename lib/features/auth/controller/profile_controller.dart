// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/bindings/init_dependencies.dart';
import 'package:portasauna/core/constants/app_secrets.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/upload_image_to_db.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/auth/model/user_model.dart';
import 'package:portasauna/features/auth/presentation/login_page.dart';
import 'package:portasauna/features/discover/controller/favourite_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  @override
  onInit() {
    print('on init ');
    super.onInit();
    checkIfLoggedIn();
  }

  bool isLoading = false;
  bool isLoggedIn = false;

  checkIfLoggedIn() {
    final currentUser = dbClient.auth.currentUser;

    print(currentUser);
    if (currentUser != null) {
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }
    update();
  }

  setLoadingTrue() {
    isLoading = true;
    update();
  }

  setLoadingFalse() {
    isLoading = false;
    update();
  }

  //==================>
  //fetch profile
  //==================>
  UserModel? userDetails;

  Future<bool> getLoggedInUserDetails(BuildContext context) async {
    try {
      setLoadingTrue();

      final loggedUser = await dbClient.auth.getUser();

      final response = await dbClient
          .from('users')
          .select()
          .eq('user_id', loggedUser.user?.id.toString() ?? '0');

      if (response.isNotEmpty) {
        print('logged in user details ${response.first}');
        userDetails = UserModel.fromJson(response.first);
        final fvC = Get.find<FavouriteController>();
        fvC.setFavouritePlaceList(userDetails?.favourites);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      showSnackBar(context, 'Failed to load user details', Colors.red);
      print('$e');
      return false;
    } finally {
      update();
      setLoadingFalse();
    }
  }

  //==================>
  //edit profile
  //==================>

  Future updateProfile(BuildContext context,
      {File? imageFile, String? userName}) async {
    try {
      setLoadingTrue();

      final loggedUser = await dbClient.auth.getUser();

      PostgrestFilterBuilder query;
      var imgLink;

      if (imageFile != null) {
        imgLink = await uploadImgToDb(
            imageFile: imageFile, imageName: 'profile_image-${DateTime.now()}');

        query = dbClient
            .from('users')
            .update({'profile_img': imgLink, 'user_name': userName ?? ''}).eq(
                'user_id', loggedUser.user?.id.toString() ?? 0);
      } else {
        query = dbClient
            .from('users')
            .update({'profile_img': imgLink, 'user_name': userName}).eq(
                'user_id', loggedUser.user?.id.toString() ?? 0);
      }

      await query;
      Get.back();

      showSnackBar(context, 'Profile updated', Pallete.primarColor);
      getLoggedInUserDetails(context);
    } catch (e) {
      showSnackBar(context, 'Failed to update profile', Colors.red);
      print('$e');
    } finally {
      update();
      setLoadingFalse();
    }
  }

  //==================>
  //logout
  //==================>
  logout(BuildContext context) async {
    dbClient.auth.signOut();
    checkIfLoggedIn();
    Get.offAll(const LoginPage());
  }

  //==================>
  //delete account
  //==================>
  Future deleteAccount(BuildContext context) async {
    try {
      setLoadingTrue();

      final userId = dbClient.auth.currentUser?.id ?? 0;

      //Delete sessions
      await dbClient.from('sauna_sessions').delete().eq('user_id', userId);

      //Delete added places
      await dbClient.from('sauna_locations').delete().eq('user_id', userId);

      //logout
      dbClient.auth.signOut();
      checkIfLoggedIn();

      //Delete user data
      final supbaseAdminInstance = SupabaseClient(
          AppSecrets.supabaseUrl, AppSecrets.supabaseServiceRoleKey);

      print('user id is $userId');
      await dbClient.from('users').delete().eq('user_id', userId);
      await supbaseAdminInstance.auth.admin.deleteUser('$userId');

      showSnackBar(context, 'Account deleted', Pallete.redColor);
      Get.offAll(const LoginPage());
    } catch (e) {
      showSnackBar(context, 'Failed to delete account', Colors.red);
      print('$e');
    } finally {
      update();
      setLoadingFalse();
    }
  }
}
