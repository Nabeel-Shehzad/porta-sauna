// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/bindings/init_dependencies.dart';
import 'package:portasauna/core/constants/place_category_const.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/upload_image_to_db.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/add_sauna_place/model/add_place_around_things_model.dart';
import 'package:portasauna/features/add_sauna_place/model/sauna_place_model.dart';
import 'package:portasauna/admin/features/homepage/admin_homepage.dart';

class AdminEditPlaceController extends GetxController {
  TextEditingController markedPlaceAddressController = TextEditingController();
  TextEditingController markedPlaceZipController = TextEditingController();
  TextEditingController commercialPhoneController = TextEditingController();
  TextEditingController descController = TextEditingController();

  fillCategoriesAndSetEverythingDefault() {
    placeWildTypeList = [];
    placeCommercialTypeList = [];
    nearbyServicesList = [];
    nearbyActivitiesList = [];
    descController.clear();
    markedPlaceAddressController.clear();

    //fill wild places
    for (int i = 0; i < wildPlaces.length; i++) {
      placeWildTypeList.add(AddPlaceAroundThingsModel(
        name: wildPlaces[i],
        selected: false,
      ));
    }

    //fill commercial places
    for (int i = 0; i < commercialPlaces.length; i++) {
      placeCommercialTypeList.add(AddPlaceAroundThingsModel(
        name: commercialPlaces[i],
        selected: false,
      ));
    }

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

  //=====================>
  //Wild locations
  //=====================>
  List<AddPlaceAroundThingsModel> placeWildTypeList = [];

  setSelectedWildType(int i) {
    //Unselect everything from commercial
    for (int j = 0; j < placeCommercialTypeList.length; j++) {
      placeCommercialTypeList[j].selected = false;
    }

    for (int j = 0; j < placeWildTypeList.length; j++) {
      if (i == j) {
        placeWildTypeList[i].selected = !placeWildTypeList[i].selected;
      } else {
        placeWildTypeList[j].selected = false;
      }
    }
    update();
  }

  //=====================>
  //Commercial locations
  //=====================>
  List<AddPlaceAroundThingsModel> placeCommercialTypeList = [];

  setSelectedCommercialType(int i) {
    //Unselect everything from wild
    for (int j = 0; j < placeWildTypeList.length; j++) {
      placeWildTypeList[j].selected = false;
    }

    for (int j = 0; j < placeCommercialTypeList.length; j++) {
      if (i == j) {
        placeCommercialTypeList[i].selected =
            !placeCommercialTypeList[i].selected;
      } else {
        placeCommercialTypeList[j].selected = false;
      }
    }
    update();
  }

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

  //================================>
  //fill data initially from database
  //================================>
  late SaunaPlaceModel selectedSauna;
  setSelectedSauna(SaunaPlaceModel v) {
    selectedSauna = v;
    update();
  }

  fillDataFromDb() {
    markedPlaceAddressController.text = selectedSauna.address ?? '';
    markedPlaceZipController.text = selectedSauna.zipCode ?? '';
    commercialPhoneController.text = selectedSauna.commercialPhone ?? '';
    descController.text = selectedSauna.description ?? '';

    //fill wild places
    for (int i = 0; i < placeWildTypeList.length; i++) {
      for (int j = 0; j < selectedSauna.selectedWildType!.length; j++) {
        if (placeWildTypeList[i].name == selectedSauna.selectedWildType![j]) {
          placeWildTypeList[i].selected = true;
        }
      }
    }

    //fill commercial places
    for (int i = 0; i < placeCommercialTypeList.length; i++) {
      for (int j = 0; j < selectedSauna.selectedCommercialType!.length; j++) {
        if (placeCommercialTypeList[i].name ==
            selectedSauna.selectedCommercialType![j]) {
          placeCommercialTypeList[i].selected = true;
        }
      }
    }

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
  }

  //================>
  //Update place to Db
  //================>

  bool isLoading = false;

  setLoadingTrue() {
    isLoading = true;
    update();
  }

  setLoadingFalse() {
    isLoading = false;
    update();
  }

  void updateSauna({required BuildContext context, File? imageFile}) async {
    setLoadingTrue();

    try {
      List selecteWildTypes = [];
      List selecteCommercialTypes = [];
      List selecteNearbyServices = [];
      List selecteNearbyActivities = [];

      //select wild type
      for (var i = 0; i < placeWildTypeList.length; i++) {
        if (placeWildTypeList[i].selected) {
          selecteWildTypes.add(placeWildTypeList[i].name);
        }
      }

      //select commercial type
      for (var i = 0; i < placeCommercialTypeList.length; i++) {
        if (placeCommercialTypeList[i].selected) {
          selecteCommercialTypes.add(placeCommercialTypeList[i].name);
        }
      }

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

      final response = await dbClient
          .from('sauna_locations')
          .update({
            'wild_location': selecteWildTypes,
            'commercial_location': selecteCommercialTypes,
            'nearby_service': selecteNearbyServices,
            'nearby_activity': selecteNearbyActivities,
            'description':
                descController.text.isEmpty ? null : descController.text,
            'address': markedPlaceAddressController.text,
            'is_approved': true
          })
          .eq('id', selectedSauna.id)
          .select();

      if (imageFile != null) {
        final data = SaunaPlaceModel.fromJson(response.first);
        final imgLink = await uploadImgToDb(
            imageFile: imageFile, imageName: "${data.id}-${DateTime.now()}");

        await dbClient.from('sauna_locations').update({
          'img_links': [imgLink],
        }).eq('id', data.id);
      }

      fillCategoriesAndSetEverythingDefault(); // clear everything and fill as new
      Get.offAll(const AdminHomepage());

      showSnackBar(context, 'Sauna place updated', Pallete.primarColor);
    } catch (e) {
      showSnackBar(context, 'Something went wrong', Pallete.redColor);
      print(e);
    } finally {
      setLoadingFalse();
    }
  }
}
