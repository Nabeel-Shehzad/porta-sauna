// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/bindings/init_dependencies.dart';
import 'package:portasauna/core/constants/admin_const.dart';
import 'package:portasauna/core/constants/place_category_const.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/send_email.dart';
import 'package:portasauna/core/utils/upload_image_to_db.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/add_sauna_place/model/add_place_around_things_model.dart';
import 'package:portasauna/features/add_sauna_place/model/address_from_lat_long_model.dart';
import 'package:portasauna/features/add_sauna_place/model/sauna_place_model.dart';
import 'package:portasauna/features/add_sauna_place/presentation/place_added_success_page.dart';
import 'package:portasauna/features/discover/controller/map_controller.dart';
import 'package:portasauna/features/discover/controller/map_place_controller.dart';

class AddSaunaPlaceController extends GetxController {
  @override
  void onInit() {
    fillCategories();
    super.onInit();
  }

  fillCategories() {
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
  }

  final descController = TextEditingController();
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

    commercialSelected = false;
    update();
  }

  //=====================>
  //Commercial locations
  //=====================>
  TextEditingController commercialPhoneController = TextEditingController();
  List<AddPlaceAroundThingsModel> placeCommercialTypeList = [];
  bool commercialSelected = false;

  setSelectedCommercialType(int i) {
    //Unselect everything from wild
    for (int j = 0; j < placeWildTypeList.length; j++) {
      placeWildTypeList[j].selected = false;
    }

    for (int j = 0; j < placeCommercialTypeList.length; j++) {
      if (i == j) {
        placeCommercialTypeList[i].selected =
            !placeCommercialTypeList[i].selected;

        if (placeCommercialTypeList[i].selected) {
          commercialSelected = true;
        } else {
          commercialSelected = false;
        }
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

  setFiltersToDefault() {
    print('set to default ran');
    for (int i = 0; i < placeWildTypeList.length; i++) {
      placeWildTypeList[i].selected = false;
    }
    for (int i = 0; i < placeCommercialTypeList.length; i++) {
      placeCommercialTypeList[i].selected = false;
    }
    for (int i = 0; i < nearbyServicesList.length; i++) {
      nearbyServicesList[i].selected = false;
    }
    for (int i = 0; i < nearbyActivitiesList.length; i++) {
      nearbyActivitiesList[i].selected = false;
    }
    update();
  }

  //=====================>
  //Picked Location info
  //=====================>

  double lattitude = 0.0;
  double longitude = 0.0;
  TextEditingController markedPlaceAddressController = TextEditingController();
  TextEditingController markedPlaceZipController = TextEditingController();

  setLatLongAndAddress({lat, long}) async {
    lattitude = lat;
    longitude = long;
    setLoadingTrue();

    final data = await Get.find<MapPlaceController>()
        .getAddressFromLatLong(lat: lat, long: long);

    final placeData = AddressFromLatLongModel.fromJson(data);
    markedPlaceAddressController.text =
        placeData.results[0].formattedAddress ?? '';

    setLoadingFalse();
    update();
  }

  //================>
  //Save place to Db
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

  addSaunaToDb({
    required BuildContext context,
    File? imageFile,
  }) async {
    setLoadingTrue();

    try {
      // Validate user is logged in
      final user = await dbClient.auth.getUser();
      if (user.user == null) {
        showSnackBar(context, 'Please log in to add a sauna location', Colors.orange);
        return;
      }

      // Validate coordinates
      if (lattitude == 0.0 || longitude == 0.0) {
        showSnackBar(context, 'Please select a valid location on the map', Colors.orange);
        return;
      }

      // Validate address
      if (markedPlaceAddressController.text.trim().isEmpty) {
        showSnackBar(context, 'Please enter a valid address', Colors.orange);
        return;
      }

      // Collect selected types
      List selecteWildTypes = [];
      List selecteCommercialTypes = [];
      List selecteNearbyServices = [];
      List selecteNearbyActivities = [];

      // Get wild types
      for (var i = 0; i < placeWildTypeList.length; i++) {
        if (placeWildTypeList[i].selected) {
          selecteWildTypes.add(placeWildTypeList[i].name);
        }
      }

      // Get commercial types
      for (var i = 0; i < placeCommercialTypeList.length; i++) {
        if (placeCommercialTypeList[i].selected) {
          selecteCommercialTypes.add(placeCommercialTypeList[i].name);
        }
      }

      // Validate at least one type is selected
      if (selecteWildTypes.isEmpty && selecteCommercialTypes.isEmpty) {
        showSnackBar(context, 'Please select at least one sauna type (Wild or Commercial)', Colors.orange);
        return;
      }

      // Get nearby services
      for (var i = 0; i < nearbyServicesList.length; i++) {
        if (nearbyServicesList[i].selected) {
          selecteNearbyServices.add(nearbyServicesList[i].name);
        }
      }

      // Get nearby activities
      for (var i = 0; i < nearbyActivitiesList.length; i++) {
        if (nearbyActivitiesList[i].selected) {
          selecteNearbyActivities.add(nearbyActivitiesList[i].name);
        }
      }

      // Validate commercial phone if commercial type selected
      if (selecteCommercialTypes.isNotEmpty && 
          commercialPhoneController.text.trim().isEmpty) {
        showSnackBar(context, 'Please enter a phone number for commercial sauna', Colors.orange);
        return;
      }

      // Insert sauna location
      final response = await dbClient.from('sauna_locations').insert({
        'user_id': user.user?.id ?? 0,
        'latitude': lattitude,
        'longitude': longitude,
        'wild_location': selecteWildTypes,
        'commercial_location': selecteCommercialTypes,
        'nearby_service': selecteNearbyServices,
        'nearby_activity': selecteNearbyActivities,
        'description': descController.text.isEmpty ? null : descController.text,
        'address': markedPlaceAddressController.text,
        'zip_code': markedPlaceZipController.text.isEmpty
            ? null
            : markedPlaceZipController.text,
        'commercial_phone': selecteCommercialTypes.isEmpty
            ? null
            : commercialPhoneController.text.isEmpty
                ? null
                : commercialPhoneController.text,
      }).select();

      // Handle image upload if provided
      if (imageFile != null) {
        try {
          final data = SaunaPlaceModel.fromJson(response.first);
          final imgLink = await uploadImgToDb(
              imageFile: imageFile, imageName: "${data.id}-${DateTime.now()}");

          await dbClient.from('sauna_locations').update({
            'img_links': [imgLink],
          }).eq('id', data.id);
        } catch (e) {
          print('Error uploading image: $e');
          showSnackBar(context, 'Sauna added but image upload failed', Colors.orange);
        }
      }

      // Success handling
      Get.find<MapController>().setShowBottomNav(false);
      setFiltersToDefault();
      Get.find<MapController>().getSaunaPlacesOnMap(context);
      Get.offAll(const PlaceAddedSuccessPage());
      
      // Notify admin
      try {
        await sendEmail(
            toEmail: AdminConst.adminEmail,
            subject: "New place added",
            emailText:
                'Someone added a new place on map and its pending. Go to the admin panel to review');
      } catch (e) {
        print('Error sending admin notification: $e');
      }

    } catch (e) {
      print('Error adding sauna: $e');
      if (e.toString().contains('auth')) {
        showSnackBar(context, 'Authentication error. Please log in again', Colors.red);
      } else if (e.toString().contains('network')) {
        showSnackBar(context, 'Network error. Please check your connection', Colors.red);
      } else {
        showSnackBar(context, 'Error adding sauna. Please try again', Colors.red);
      }
    } finally {
      setLoadingFalse();
    }
  }
}
