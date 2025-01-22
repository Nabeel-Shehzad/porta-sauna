// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/bindings/init_dependencies.dart';
import 'package:portasauna/core/constants/place_category_const.dart';
import 'package:portasauna/core/utils/upload_image_to_db.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/core/widgets/success_page.dart';
import 'package:portasauna/features/add_sauna_place/model/add_place_around_things_model.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';

class RequestEditPlaceController extends GetxController {
  final descController = TextEditingController();

  bool isLoading = false;

  setLoadingTrue() {
    isLoading = true;
    update();
  }

  setLoadingFalse() {
    isLoading = false;
    update();
  }

  //================>
  //add new image to existing place
  //================>
  addImageToExistingPlace(
      {required BuildContext context, File? imageFile}) async {
    final fnc = Get.find<FindNearSaunaController>();
    setLoadingTrue();

    try {
      final imgLink = await uploadImgToDb(
          imageFile: imageFile,
          imageName: "${fnc.selectedSaunaPlace.id}-${DateTime.now()}");

      final userId = dbClient.auth.currentUser?.id ?? 0;

      await dbClient.from('edit_place_requests').insert({
        'img_links': [imgLink],
        'place_id': fnc.selectedSaunaPlace.id,
        'user_id': userId
      });

      Get.to(SuccessPage(
        onBackPressed: () {
          Get.back();
          Get.back();
        },
        title: 'Thank you!',
        desc:
            'Thank you for your contribution. We will verify it soon. Once it is verified, it will be available on the place.',
      ));
    } catch (e) {
      showErrorSnackBar(context, 'Something went wrong');
      debugPrint('$e');
    } finally {
      setLoadingFalse();
    }
  }

  //==============================================>
  //Services and Activities
  //==============================================>

  //=====================>
  //Nearby Services
  //=====================>
  List<AddPlaceAroundThingsModel> nearbyServicesList = [];

  setSelectedNearbyService(int i) {
    nearbyServicesList[i].selected = !nearbyServicesList[i].selected;
    update();
  }

  //=====================>
  //Nearby Activities
  //=====================>
  List<AddPlaceAroundThingsModel> nearbyActivitiesList = [];

  setSelectedNearbyActivities(int i) {
    nearbyActivitiesList[i].selected = !nearbyActivitiesList[i].selected;
    update();
  }

  //==============================================>
  //Fill services and activities to default
  //==============================================>

  fillCategoriesAndSetEverythingDefault() {
    descController.clear();
    nearbyServicesList = [];
    nearbyActivitiesList = [];

    //fill nearby service
    for (int i = 0; i < nearbyServicePlaces.length; i++) {
      nearbyServicesList.add(AddPlaceAroundThingsModel(
        name: nearbyServicePlaces[i],
        selected: false,
      ));
    }

    //fill nearby activities
    for (int i = 0; i < nearbyActivityPlaces.length; i++) {
      nearbyActivitiesList.add(AddPlaceAroundThingsModel(
        name: nearbyActivityPlaces[i],
        selected: false,
      ));
    }

    update();
  }

  //====================================================>
  //Fill services and activities from selected place data
  //====================================================>

  fillServicesAndActivitiesFromSelectedPlace() {
    final selectedSauna =
        Get.find<FindNearSaunaController>().selectedSaunaPlace;

    descController.text = selectedSauna.description ?? '';
    //fill nearby service
    for (int i = 0; i < nearbyServicesList.length; i++) {
      for (int j = 0; j < selectedSauna.selectedNearbyService!.length; j++) {
        if (nearbyServicesList[i].name ==
            selectedSauna.selectedNearbyService![j]) {
          nearbyServicesList[i].selected = true;
        }
      }
    }

    //fill nearby activities
    for (int i = 0; i < nearbyActivitiesList.length; i++) {
      for (int j = 0; j < selectedSauna.selectedNearbyActivities!.length; j++) {
        if (nearbyActivitiesList[i].name ==
            selectedSauna.selectedNearbyActivities![j]) {
          nearbyActivitiesList[i].selected = true;
        }
      }
    }

    update();
  }

  //================================================>
  //request edit place service activity desc
  //================================================>
  requestEditPlace({required BuildContext context, File? imageFile}) async {
    final fnc = Get.find<FindNearSaunaController>();
    setLoadingTrue();

    try {
      List selecteNearbyServices = [];
      List selecteNearbyActivities = [];
      //select nearby service
      for (var i = 0; i < nearbyServicesList.length; i++) {
        if (nearbyServicesList[i].selected) {
          selecteNearbyServices.add(nearbyServicesList[i].name);
        }
      }

      //select nearby activities
      for (var i = 0; i < nearbyActivitiesList.length; i++) {
        if (nearbyActivitiesList[i].selected) {
          selecteNearbyActivities.add(nearbyActivitiesList[i].name);
        }
      }

      final userId = dbClient.auth.currentUser?.id ?? 0;

      await dbClient.from('edit_place_requests').insert({
        'place_id': fnc.selectedSaunaPlace.id,
        'user_id': userId,
        'description': descController.text,
        'nearby_service': selecteNearbyServices,
        'nearby_activity': selecteNearbyActivities
      });

      Get.to(SuccessPage(
        onBackPressed: () {
          Get.back();
          Get.back();
          Get.back();
          Get.back();
        },
        title: 'Thank you!',
        desc:
            'Thank you for your contribution. We will verify it soon. Once it is verified, it will be available on the place.',
      ));
    } catch (e) {
      showErrorSnackBar(context, 'Something went wrong');
      debugPrint('$e');
    } finally {
      setLoadingFalse();
    }
  }
}
