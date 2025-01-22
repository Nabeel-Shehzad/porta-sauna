// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/bindings/init_dependencies.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/auth/model/user_model.dart';
import 'package:portasauna/features/discover/model/ratings_model.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';

class RatingController extends GetxController {
  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    update();
  }

  setLoadingFalse() {
    isloading = false;
    update();
  }

  //===========================================
  // Fetch Ratings
  //===========================================
  List<RatingsModel> ratingsList = [];
  List<UserModel> ratedUsersList = [];
  int averageRating = 0;

  fillRatingsRatedUsersAndAverage(
      {required List<RatingsModel> newRateList,
      required List<UserModel> newRatedUsersList,
      required int newAverageRating}) {
    ratingsList = newRateList;
    ratedUsersList = newRatedUsersList;
    averageRating = newAverageRating;
    update();
  }

  fetchRatings(BuildContext context, {required locationId}) async {
    try {
      ratingsList = [];
      ratedUsersList = [];
      averageRating = 0;
      update();
      setLoadingTrue();

      final response =
          await dbClient.from('ratings').select().eq('location_id', locationId);

      final userIds =
          response.map((rating) => rating['user_id']).toSet().toList();

      final usersResponse =
          await dbClient.from('users').select().inFilter('user_id', userIds);

      for (int i = 0; i < response.length; i++) {
        ratingsList.add(RatingsModel.fromJson(response[i]));
        ratedUsersList.add(UserModel.fromJson(usersResponse[i]));
      }

      //Calculate average rating
      final ratings = [];

      for (int i = 0; i < ratingsList.length; i++) {
        ratings.add(ratingsList[i].rating);
      }

      final sumOfRatings = ratings.reduce((a, b) => a + b);
      final numberOfRatings = ratings.length;

      final avgRate = sumOfRatings / numberOfRatings;
      averageRating = avgRate.round();
    } catch (e) {
      // showSnackBar(context, "Failed to load ratings", Pallete.redColor);
      print(e);
    } finally {
      update();
      setLoadingFalse();
    }
  }

  //===========================================
  // Leave Rating
  //===========================================
  int rating = 5;

  setRating(int value) {
    rating = value;
    update();
  }

  final feedbackController = TextEditingController();

  leaveRating(BuildContext context) async {
    try {
      setLoadingTrue();

      final fnc = Get.find<FindNearSaunaController>();
      final user = await dbClient.auth.getUser();

      //check if user already left rating
      final response = await dbClient
          .from('ratings')
          .select()
          .eq('user_id', user.user?.id ?? 0)
          .eq('location_id', fnc.selectedSaunaPlace.id);

      if (response.isNotEmpty) {
        showSnackBar(
            context, "You have already left a rating", Pallete.redColor);

        return;
      }

      await dbClient.from('ratings').insert({
        'user_id': user.user?.id,
        'location_id': fnc.selectedSaunaPlace.id,
        'rating': rating,
        'feedback':
            feedbackController.text.isEmpty ? null : feedbackController.text,
      });

      showSnackBar(context, "Rating added successfully", Pallete.greenColor);
      fetchRatings(context, locationId: fnc.selectedSaunaPlace.id);
    } catch (e) {
      showSnackBar(context, "Failed to add rating", Pallete.redColor);
      print(e);
    } finally {
      update();
      setLoadingFalse();
      Get.back();
      Get.back();
    }
  }
}
