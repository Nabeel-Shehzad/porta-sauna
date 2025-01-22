// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/admin/features/modify_place/model/mod_req_place_model.dart';
import 'package:portasauna/core/bindings/init_dependencies.dart';
import 'package:portasauna/core/utils/email_helper.dart';
import 'package:portasauna/core/utils/send_email.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/add_sauna_place/model/sauna_place_model.dart';
import 'package:portasauna/features/auth/model/user_model.dart';
import 'package:portasauna/features/discover/controller/place_added_by_user_controller.dart';

class AdminModificationRequestedController extends GetxController {
  bool isLoading = false;

  setLoadingTrue() {
    isLoading = true;
    update();
  }

  setLoadingFalse() {
    isLoading = false;
    update();
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
  //Modification Request
  //==================>
  int selectedModReqPlaceIndex = 0;
  setSelectedModReqPlaceIndex(int index) {
    selectedModReqPlaceIndex = index;
    update();
  }

  List<ModReqPlaceModel> modReqPlaceData = [];

  Future getModReqPlaces(BuildContext context) async {
    try {
      setLoadingTrue();
      modReqPlaceData.clear();

      final response =
          await dbClient.from('edit_place_requests').select().limit(300);

      for (int i = 0; i < response.length; i++) {
        modReqPlaceData.add(ModReqPlaceModel.fromJson(response[i]));
      }
    } catch (e) {
      showSnackBar(
          context, 'Failed to load modification requested places', Colors.red);
      debugPrint('$e');
    } finally {
      update();
      setLoadingFalse();
    }
  }

  //==================>
  //Load place of an id
  //==================>

  late SaunaPlaceModel selectedSaunaPlace;

  Future getDetailsOfSelectedPlaces(BuildContext context,
      {required placeId}) async {
    try {
      setLoadingTrue();

      final response = await dbClient
          .from('sauna_locations')
          .select()
          .eq('is_approved', true)
          .eq('id', placeId);

      selectedSaunaPlace = SaunaPlaceModel.fromJson(response[0]);
      debugPrint('selected s place $selectedSaunaPlace');
    } catch (e) {
      showSnackBar(context, 'Failed to load pending sauna places', Colors.red);
      debugPrint('$e');
    } finally {
      update();
      setLoadingFalse();
    }
  }

  //===============================>
  //Delete modification requested place
  //===============================>
  Future deleteModReqPlace(
    BuildContext context,
  ) async {
    try {
      setLoadingTrue();

      await dbClient
          .from('edit_place_requests')
          .delete()
          .eq('id', modReqPlaceData[selectedModReqPlaceIndex].id);

      sendModReqRejectedMail();

      Get.back();
      Future.delayed(const Duration(milliseconds: 500), () {
        getModReqPlaces(context);
      });
    } catch (e) {
      showSnackBar(
          context, 'Failed to delete modification requested place', Colors.red);
      debugPrint('$e');
    } finally {
      update();
      setLoadingFalse();
    }
  }

  //===============================>
  //Approve modification requested place
  //===============================>
  Future approveModReqPlace(
    BuildContext context,
  ) async {
    try {
      setLoadingTrue();

      var placeId = modReqPlaceData[selectedModReqPlaceIndex].placeId;

      // image add
      //===============================

      List imageLinks = selectedSaunaPlace.imgLinks ?? [];
      if (modReqPlaceData[selectedModReqPlaceIndex].imgLinks != null) {
        imageLinks.addAll(modReqPlaceData[selectedModReqPlaceIndex].imgLinks!);

        await dbClient.from('sauna_locations').update({
          'img_links': imageLinks,
        }).eq('id', placeId);
      }

      // description add
      //===============================
      String? description =
          modReqPlaceData[selectedModReqPlaceIndex].description;
      if (description != null) {
        await dbClient.from('sauna_locations').update({
          'description': description,
        }).eq('id', placeId);
      }

      // nearby service add
      //===============================
      List nearbyServices =
          modReqPlaceData[selectedModReqPlaceIndex].selectedNearbyService ?? [];
      if (nearbyServices.isNotEmpty) {
        await dbClient.from('sauna_locations').update({
          'nearby_service': nearbyServices,
        }).eq('id', placeId);
      }

      // nearby activities add
      //===============================
      List nearbyActivities =
          modReqPlaceData[selectedModReqPlaceIndex].selectedNearbyActivities ??
              [];
      if (nearbyActivities.isNotEmpty) {
        await dbClient.from('sauna_locations').update({
          'nearby_activity': nearbyActivities,
        }).eq('id', placeId);
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        deleteModReqPlace(context);
      });

      sendModReqAcceptedMail();
    } catch (e) {
      showSnackBar(context, 'Failed to approve modification requested place',
          Colors.red);
      debugPrint('$e');
    } finally {
      update();
      setLoadingFalse();
    }
  }
}
