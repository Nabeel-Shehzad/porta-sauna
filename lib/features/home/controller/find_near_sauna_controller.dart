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
      print('🔍 Starting to find nearest saunas...');
      setLoadingTrue();
      nearestSaunas.clear();
      final position = await getUserCurrentPosition(context);
      print('📍 Got user position: ${position.latitude}, ${position.longitude}');

      //get place name from user's current location lat long
      final data = await Get.find<MapPlaceController>().getAddressFromLatLong(
          lat: position.latitude, long: position.longitude);
      print('📌 Got address data: $data');
      final placeData = AddressFromLatLongModel.fromJson(data);

      //load all location of user's country
      String? countryName;
      for (int i = 0; i < placeData.results[0].addressComponents.length; i++) {
        if (placeData.results[0].addressComponents[i].types
            .contains('country')) {
          countryName = placeData.results[0].addressComponents[i].longName;
          print('🌍 Found country: $countryName');
        }
      }

      //move camera to user's current country
      final mapc = Get.find<MapController>();
      await mapc.moveCameraToPlace(
        context,
        placeName: countryName ?? '',
        animateCamera: false
      );

      final countryData = await Get.find<MapPlaceController>()
          .getLatLongFromPlaceName(placeName: countryName ?? '');
      final userCountryLatLong = LatLongFromPlaceModel.fromJson(countryData);
      print('🗺️ Got country bounds data: $countryData');

      final minLongitude =
          userCountryLatLong.results[0].geometry?.viewport?.southwest?.lng;
      final minLatitude =
          userCountryLatLong.results[0].geometry?.viewport?.southwest?.lat;
      final maxLongitude =
          userCountryLatLong.results[0].geometry?.viewport?.northeast?.lng;
      final maxLatitude =
          userCountryLatLong.results[0].geometry?.viewport?.northeast?.lat;
      
      print('📊 Search bounds: Lat($minLatitude to $maxLatitude), Long($minLongitude to $maxLongitude)');
      
      List response;
      try {
        response = await dbClient
            .from('sauna_locations')
            .select('''
              id,
              created_at,
              latitude,
              longitude,
              wild_location,
              commercial_location,
              nearby_service,
              nearby_activity,
              description,
              img_links,
              user_id,
              address,
              is_approved,
              zip_code,
              commercial_phone,
              checked_in_users
            ''')
            .gte('latitude', minLatitude?.floor() ?? 0)
            .lte('latitude', maxLatitude?.ceil() ?? 0)
            .gte('longitude', minLongitude?.floor() ?? 0)
            .lte('longitude', maxLongitude?.ceil() ?? 0)
            .eq('is_approved', true);

        print('🔍 Database query successful. Found ${response.length} saunas');
        print('📍 First sauna data (if any): ${response.isNotEmpty ? response.first : 'No saunas found'}');
      } catch (e) {
        print('❌ Database query error: $e');
        rethrow;
      }

      // Sort by distance
      var lonAndLatDistance = LonAndLatDistance();
      List<Map<String, dynamic>> placeMap = [];

      for (int i = 0; i < response.length; i++) {
        try {
          print('Processing sauna ${i + 1}/${response.length}');
          print('Raw sauna data: ${response[i]}');
          
          // Check if latitude and longitude exist and are valid
          final double? saunaLat = response[i]['latitude']?.toDouble();
          final double? saunaLong = response[i]['longitude']?.toDouble();
          
          if (saunaLat == null || saunaLong == null) {
            print('⚠️ Invalid coordinates for sauna ${response[i]['id']}');
            continue;
          }

          final pData = SaunaPlaceModel.fromJson(response[i]);
          
          final double distanceKm = lonAndLatDistance.lonAndLatDistance(
              lat1: saunaLat,
              lon1: saunaLong,
              lat2: position.latitude,
              lon2: position.longitude,
              km: true);
              
          pData.distance = distanceKm;
          placeMap.add({'distance': distanceKm, 'place': pData});
          print('✅ Successfully processed sauna at distance: ${distanceKm.toStringAsFixed(2)}km');
        } catch (e) {
          print('❌ Error processing sauna ${i + 1}: $e');
          continue;
        }
      }

      // Sort by distance
      placeMap.sort((a, b) => a['distance'].compareTo(b['distance']));
      
      // Take only the closest 10 saunas
      final maxSaunas = placeMap.length > 10 ? 10 : placeMap.length;
      nearestSaunas.clear(); // Clear existing list before adding new items
      for (int i = 0; i < maxSaunas; i++) {
        nearestSaunas.add(placeMap[i]['place']);
      }
      
      print('🎯 Final nearest saunas count: ${nearestSaunas.length}');
    } catch (e) {
      print('Error finding nearby saunas: $e');
    } finally {
      update();
      setLoadingFalse();
    }
  }

  //==================>
  //Find saunas in a specific area
  //==================>
  Future<void> findNearSaunas({
    required double lat,
    required double long,
    required double radius,
  }) async {
    try {
      print('🔍 Finding saunas near: $lat, $long with radius: $radius km');
      setLoadingTrue();
      nearestSaunas.clear();

      // Convert radius from km to degrees (approximate)
      final degreeRadius = radius / 111.0;
      
      final response = await dbClient
          .from('sauna_locations')
          .select()
          .gte('latitude', lat - degreeRadius)
          .lte('latitude', lat + degreeRadius)
          .gte('longitude', long - degreeRadius)
          .lte('longitude', long + degreeRadius)
          .eq('is_approved', true);

      if (response != null) {
        for (var place in response) {
          try {
            final saunaPlace = SaunaPlaceModel.fromJson(place);
            nearestSaunas.add(saunaPlace);
          } catch (e) {
            print('Error processing sauna place: $e');
          }
        }
      }

      // Update the map controller's places list
      final mc = Get.find<MapController>();
      mc.placesList.clear();
      mc.placesList.addAll(nearestSaunas);
      
      setLoadingFalse();
      update();
    } catch (e) {
      setLoadingFalse();
      print('Error finding nearby saunas: $e');
      rethrow;
    }
  }
}
