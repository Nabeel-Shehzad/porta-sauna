// ignore_for_file: avoid_print, use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:portasauna/core/bindings/init_dependencies.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/add_sauna_place/model/sauna_place_model.dart';
import 'package:portasauna/features/auth/model/user_model.dart';
import 'package:portasauna/features/discover/controller/rating_controller.dart';
import 'package:portasauna/features/discover/model/ratings_model.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';

import '../presentation/sauna_place_details_page.dart';

class PlaceAddedByUserController extends GetxController {
  double? defaultLat = 52.3555;
  double? defaultLong = 1.1743;
  late GoogleMapController mapController;

  bool isLoading = false;

  setLoadingTrue() {
    isLoading = true;
    update();
  }

  setLoadingFalse() {
    isLoading = false;
    update();
  }

  final Set<Marker> markers = {};

  CameraPosition cameraPosition({double? zoom, lat, long}) {
    return CameraPosition(
      target: LatLng(lat ?? defaultLat, long ?? defaultLong),
      zoom: zoom ?? 4,
    );
  }

  animateCameraToNewPosition({double? zoom, lat, long}) {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        cameraPosition(zoom: zoom, lat: lat, long: long)));
  }

  //==========================>
  // Get user details of selected user
  //==========================>

  UserModel? selectedUserDetails;

  Future<UserModel?> getUserDetailsOfSelectedUser(BuildContext context,
      {required userId}) async {
    print('getUserDetailsOfSelectedUser() fun ran');
    try {
      selectedUserDetails = null;
      update();

      final response =
          await dbClient.from('users').select().eq('user_id', userId);

      selectedUserDetails = UserModel.fromJson(response.first);
      return selectedUserDetails;
    } catch (e) {
      showSnackBar(context, 'Failed to load user details', Colors.red);
      print('$e');
    } finally {
      update();
    }
    return null;
  }

  //==========================>
  // Save values to temp
  //==========================>
  //keeping the sauna place,ratings,user details in temp variables so that
  //when user comes back to this screen again, we can show them
  //Because, user will visit many other sauna places details page from map page
  late SaunaPlaceModel saunaPlaceFromWhereUserCameToMap;
  List<RatingsModel> tempRatingList = [];
  List<UserModel> tempRatedUsersList = [];
  int tempAverageRating = 0;
  UserModel? tempSelectedUserDetails;
  int mapPageInStack = 0;

  setPlaceRatingUserDetailsToTemp() {
    final fnc = Get.find<FindNearSaunaController>();
    final rc = Get.find<RatingController>();

    saunaPlaceFromWhereUserCameToMap = fnc.selectedSaunaPlace;
    tempSelectedUserDetails = selectedUserDetails;
    tempRatingList = rc.ratingsList;
    tempRatedUsersList = rc.ratedUsersList;
    tempAverageRating = rc.averageRating;
    mapPageInStack++;
    update();
  }

  fillDatasFromTempPlaceRatingUserDetails() {
    final fnc = Get.find<FindNearSaunaController>();
    final rc = Get.find<RatingController>();

    fnc.setSelectedSaunaPlace(saunaPlaceFromWhereUserCameToMap);
    selectedUserDetails = tempSelectedUserDetails;
    rc.fillRatingsRatedUsersAndAverage(
        newRateList: tempRatingList,
        newRatedUsersList: tempRatedUsersList,
        newAverageRating: tempAverageRating);

    mapPageInStack--;
    update();
  }

  //==========================>
  // Get places map markers of selected user
  //==========================>

  addMultipleMarkers() {
    markers.clear();

    for (int i = 0; i < placesList.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('${placesList[i].lattitude}'),
          position: LatLng(
              placesList[i].lattitude ?? 0, placesList[i].longitude ?? 0),
          infoWindow: InfoWindow(
            title: placesList[i].address ?? '',
            snippet: 'Click to see details',
          ),
          icon: BitmapDescriptor.defaultMarker,
          onTap: () {
            Get.find<FindNearSaunaController>()
                .setSelectedSaunaPlace(placesList[i]);
            Get.to(const SaunaPlaceDetailsPage());
          },
        ),
      );
    }
    update();
  }

  List<SaunaPlaceModel> placesList = [];

  Future getPlacesOfSelectedUser(
    BuildContext context,
  ) async {
    try {
      setLoadingTrue();
      placesList.clear();

      final fnc = Get.find<FindNearSaunaController>();

      final response = await dbClient
          .from('sauna_locations')
          .select()
          .eq('is_approved', true)
          .eq('user_id', fnc.selectedSaunaPlace.userId ?? 0);

      for (int i = 0; i < response.length; i++) {
        var responseData = response[i];
        placesList.add(SaunaPlaceModel.fromJson(responseData));
      }

      print('Total places found ${placesList.length}');

      if (placesList.isNotEmpty) {
        animateCameraToNewPosition(
            lat: placesList[0].lattitude, long: placesList[0].longitude);
      }
    } catch (e) {
      showSnackBar(context, 'Failed to load places', Colors.red);
      print('$e');
    } finally {
      update();
      setLoadingFalse();
      addMultipleMarkers();
    }
  }
}
