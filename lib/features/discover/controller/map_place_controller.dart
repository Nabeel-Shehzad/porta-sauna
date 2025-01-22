import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:portasauna/core/constants/app_secrets.dart';

class MapPlaceController extends GetxController {
  Future getPlaceSuggestion({required String placeName}) async {
    String baseUrl =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=${AppSecrets.googleMapPlaceApiKey}&sessionToken=123453453";
    var response = await http.get(Uri.parse(baseUrl));
    return jsonDecode(response.body);
  }

  Future getLatLongFromPlaceName({required String placeName}) async {
    String baseUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?address=$placeName&key=${AppSecrets.googleMapPlaceApiKey}";
    var response = await http.get(Uri.parse(baseUrl));
    return jsonDecode(response.body);
  }

  Future getAddressFromLatLong({required lat, required long}) async {
    String baseUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=${AppSecrets.googleMapPlaceApiKey}";
    var response = await http.get(Uri.parse(baseUrl));
    return jsonDecode(response.body);
  }
}
