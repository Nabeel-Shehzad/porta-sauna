// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/admin/features/all_place/controller/admin_all_place_controller.dart';
import 'package:portasauna/core/bindings/init_dependencies.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/email_helper.dart';
import 'package:portasauna/core/utils/helper.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/add_sauna_place/model/sauna_place_model.dart';
import 'package:portasauna/features/auth/model/user_model.dart';
import 'package:portasauna/features/discover/controller/place_added_by_user_controller.dart';

class AdminPendingPlaceController extends GetxController {
  bool isLoading = false;

  setLoadingTrue() {
    isLoading = true;
    update();
  }

  setLoadingFalse() {
    isLoading = false;
    update();
  }

  late SaunaPlaceModel selectedSaunaPlace;
  setSelectedSaunaPlace(SaunaPlaceModel v) {
    selectedSaunaPlace = v;
    update();
  }

  //==================>
  //Get pending location
  //==================>
  List<SaunaPlaceModel> pendingLocations = [];

  Future getPendingPlaces(BuildContext context) async {
    try {
      setLoadingTrue();
      pendingLocations.clear();

      final response = await dbClient
          .from('sauna_locations')
          .select()
          .eq('is_approved', false);

      for (int i = 0; i < response.length; i++) {
        pendingLocations.add(SaunaPlaceModel.fromJson(response[i]));
      }
    } catch (e) {
      showSnackBar(context, 'Failed to load pending sauna places', Colors.red);
      print('$e');
    } finally {
      update();
      setLoadingFalse();
    }
  }

  //==================>
  //User details of user who added the place
  //==================>

  UserModel? selectedUserDetails;

  Future getUserDetailsOfSelectedUser(BuildContext context,
      {required userId}) async {
    selectedUserDetails = null;
    update();

    final pac = Get.find<PlaceAddedByUserController>();
    selectedUserDetails =
        await pac.getUserDetailsOfSelectedUser(context, userId: userId);

    update();
  }

  //==================>
  //Accept a place
  //==================>
  Future acceptPlace(BuildContext context, {required id}) async {
    try {
      setLoadingTrue();

      await dbClient
          .from('sauna_locations')
          .update({'is_approved': true}).eq('id', id);

      showSnackBar(context, 'Sauna place approved', Pallete.primarColor);
      getPendingPlaces(context);
      Get.back();

      sendPlaceAcceptedMail();
    } catch (e) {
      showSnackBar(context, 'Failed to approved the sauna place', Colors.red);
      print('$e');
    } finally {
      update();
      setLoadingFalse();
    }
  }

  //==================>
  //Delete a place
  //==================>
  Future deletePlace(BuildContext context,
      {required id, required bool editingAcceptedPlace}) async {
    try {
      setLoadingTrue();

      await dbClient.from('sauna_locations').delete().eq('id', id);

      showSnackBar(context, 'Sauna place deleted', Pallete.primarColor);

      if (editingAcceptedPlace) {
        Get.back();
        Get.find<AdminAllPlaceController>().getAllPlaces(context);
      } else {
        getPendingPlaces(context);
        Get.back();
        Get.back();
        sendPlaceRejectedMail();
      }
    } catch (e) {
      showSnackBar(context, 'Failed to delete the sauna place', Colors.red);
      print('$e');
    } finally {
      update();
      setLoadingFalse();
    }
  }

  //==================>
  //Contact user
  //==================>

  Future<void> launchEmailApp({email}) async {
    String subject = "PortaSauna app";
    String body = "Hello";

    goToUrl('mailto:$email?subject=$subject&body=$body');
  }
}
