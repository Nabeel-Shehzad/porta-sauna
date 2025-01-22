// ignore_for_file: use_build_context_synchronously, avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:longitude_and_latitude_calculator/longitude_and_latitude_calculator.dart';
import 'package:portasauna/core/bindings/init_dependencies.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/add_sauna_place/model/address_from_lat_long_model.dart';
import 'package:portasauna/features/add_sauna_place/model/sauna_place_model.dart';
import 'package:portasauna/features/discover/controller/map_controller.dart';
import 'package:portasauna/features/discover/controller/map_place_controller.dart';
import 'package:portasauna/features/discover/model/lat_long_from_place_model.dart';

class FindNearSaunaController extends GetxController {
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
  //Get user's current location
  //==================>

  Future<Position> getUserCurrentPosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showSnackBar(
            context,
            'Location service is disabled. From your settings, you can enable it again',
            Pallete.redColor);
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showSnackBar(
              context,
              'Location service is necessary to find saunas around you',
              Pallete.redColor);
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showSnackBar(
            context,
            'You have denied permission to access your device location. To enable location service again please go to your device settings',
            Pallete.redColor);
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      final response = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);

      Get.find<MapController>().setSelectedPlaceLatLong(LatLngCustomModel(
        lat: response.latitude,
        lng: response.longitude,
      ));
      return response;
    } catch (e) {
      showSnackBar(
          context,
          'To enable location service again please go to your device settings',
          Pallete.redColor);
      rethrow;
    }
  }

  //==================>
  //Get nearest Location from db
  //==================>
  List<SaunaPlaceModel> nearestSaunas = [];

  Future getNearestSaunaLocation(BuildContext context) async {
    try {
      setLoadingTrue();
      nearestSaunas.clear();
      final position = await getUserCurrentPosition(context);

      //we need viewport to load place within the viewport
      //but user's current location is not giving us viewport,only lat long
      //so need to get place name from lat long and then,
      //from that place name we will call an api which will give us viewport

      //get place name from user's current location lat long
      //also get country name, because we want to load all location
      //of user's country
      final data = await Get.find<MapPlaceController>().getAddressFromLatLong(
          lat: position.latitude, long: position.longitude);
      final placeData = AddressFromLatLongModel.fromJson(data);
      // final formattedAddress = placeData.results[0].formattedAddress ?? '';

      //load all location of user's country
      String? countryName;
      for (int i = 0; i < placeData.results[0].addressComponents.length; i++) {
        if (placeData.results[0].addressComponents[i].types
            .contains('country')) {
          countryName = placeData.results[0].addressComponents[i].longName;
        }
      }

      //move camera to user's current country
      final mapc = Get.find<MapController>();
      await mapc.moveCameraToPlace(context,
          placeName: countryName, animateCamera: false);

      final countryData = await Get.find<MapPlaceController>()
          .getLatLongFromPlaceName(placeName: countryName ?? '');
      final userCountryLatLong = LatLongFromPlaceModel.fromJson(countryData);

      final minLongitude =
          userCountryLatLong.results[0].geometry?.viewport?.southwest?.lng;
      final minLatitude =
          userCountryLatLong.results[0].geometry?.viewport?.southwest?.lat;
      final maxLongitude =
          userCountryLatLong.results[0].geometry?.viewport?.northeast?.lng;
      final maxLatitude =
          userCountryLatLong.results[0].geometry?.viewport?.northeast?.lat;
      List response;

      response = await dbClient
          .from('sauna_locations')
          .select()
          .gte('latitude', minLatitude?.floor() ?? 0)
          .lte('latitude', maxLatitude?.ceil() ?? 0)
          .gte('longitude', minLongitude?.floor() ?? 0)
          .lte('longitude', maxLongitude?.ceil() ?? 0)
          .eq('is_approved', true);

      // nearestSaunas.sort((a, b) => a.lattitude.compareTo(b.lattitude));

      // Sort by meter
      var lonAndLatDistance = LonAndLatDistance();
      List<Map<String, dynamic>> placeMap = [];

      for (int i = 0; i < response.length; i++) {
        final pData = SaunaPlaceModel.fromJson(response[i]);

        final double mile = lonAndLatDistance.lonAndLatDistance(
            lat1: pData.lattitude,
            lon1: pData.longitude,
            lat2: position.latitude,
            lon2: position.longitude,
            km: true);
        //based on miles which is smaller, sort it and add pdata to nearestSaunas
        placeMap.add({'mile': mile, 'place': pData});
      }

      placeMap.sort((a, b) => a['mile'].compareTo(b['mile']));
      for (int i = 0; i < placeMap.length; i++) {
        print(placeMap[i]['mile']);
        print(placeMap[i]['place'].address);

        nearestSaunas.add(placeMap[i]['place']);
      }
    } catch (e) {
      print('$e');
    } finally {
      update();
      setLoadingFalse();
    }
  }
}
