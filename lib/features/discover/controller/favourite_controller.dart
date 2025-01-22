// ignore_for_file: avoid_print, use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/bindings/init_dependencies.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';

class FavouriteController extends GetxController {
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
  //Favourite / UnFaourite place
  //==================>
  List favouritePlaceList = [];

  setFavouritePlaceList(v) {
    favouritePlaceList = v ?? [];
    update();
  }

  favouriteOrUnfavouriteAPlace(BuildContext context, {required placeId}) async {
    try {
      final loggedUser = await dbClient.auth.getUser();
      bool addedFavourite = false;

      if (favouritePlaceList.contains(placeId)) {
        favouritePlaceList.remove(placeId);
      } else {
        favouritePlaceList.add(placeId);
        addedFavourite = true;
      }

      await dbClient
          .from('users')
          .update({'favourites': favouritePlaceList})
          .eq('user_id', loggedUser.user?.id.toString() ?? 0)
          .select();

      return addedFavourite;
    } catch (e) {
      showSnackBar(context, 'Something went wrong', Colors.red);
      print('$e');
    } finally {
      update();
      setLoadingFalse();
    }
  }
}
