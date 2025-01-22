// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/bindings/init_dependencies.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/add_sauna_place/model/sauna_place_model.dart';

class AdminAllPlaceController extends GetxController {
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
  //Get all location
  //==================>
  List<SaunaPlaceModel> allPlaces = [];

  Future getAllPlaces(BuildContext context) async {
    try {
      setLoadingTrue();
      allPlaces.clear();

      final response =
          await dbClient.from('sauna_locations').select().limit(300);

      for (int i = 0; i < response.length; i++) {
        allPlaces.add(SaunaPlaceModel.fromJson(response[i]));
      }
    } catch (e) {
      showSnackBar(context, 'Failed to load pending sauna places', Colors.red);
      debugPrint('$e');
    } finally {
      update();
      setLoadingFalse();
    }
  }

  //==================>
  //Search location
  //==================>
  final searchController = TextEditingController();

  Future searchLocation(BuildContext context) async {
    try {
      setLoadingTrue();
      allPlaces.clear();
      final response = await dbClient
          .from('sauna_locations')
          .select()
          .ilike('address', "%${searchController.text}%");
      for (int i = 0; i < response.length; i++) {
        allPlaces.add(SaunaPlaceModel.fromJson(response[i]));
      }

      //remove duplicate based on address and description
      for (int i = 0; i < allPlaces.length; i++) {
        for (int j = i + 1; j < allPlaces.length; j++) {
          if (allPlaces[i].address == allPlaces[j].address &&
              allPlaces[i].description == allPlaces[j].description) {
            allPlaces.removeAt(j);
          }
        }
      }
    } catch (e) {
      showSnackBar(context, 'Failed to load places', Colors.red);
      debugPrint('$e');
    } finally {
      update();
      setLoadingFalse();
    }
  }
}
