// ignore_for_file: use_build_context_synchronously

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/bindings/init_dependencies.dart';
import 'package:portasauna/core/constants/assets_const.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/send_email.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';
import 'package:share_plus/share_plus.dart';

class PlaceDetailsModalController extends GetxController {
  bool isLoading = false;

  setLoadingTrue() {
    isLoading = true;
    update();
  }

  setLoadingFalse() {
    isLoading = false;
    update();
  }

  saveIamHere(BuildContext context) async {
    setLoadingTrue();

    try {
      final fnc = Get.find<FindNearSaunaController>();
      final user = await dbClient.auth.getUser();

      List? checkedInUsers = fnc.selectedSaunaPlace.checkedInUsers ?? [];

      if (checkedInUsers.contains(user.user?.id)) {
        showSnackBar(context, 'You have already checked in', Pallete.redColor);
        Get.back();
        return;
      }

      checkedInUsers.add(user.user?.id);
      //remove duplicate
      checkedInUsers = checkedInUsers.toSet().toList();

      await dbClient
          .from('sauna_locations')
          .update({'checked_in_users': checkedInUsers}).eq(
              'id', fnc.selectedSaunaPlace.id);

      showSnackBar(context, 'Thank you for checking in', Pallete.greenColor);
      Get.back();
    } catch (e) {
      debugPrint('$e');
      showSnackBar(context, 'Something went wrong', Pallete.redColor);
    } finally {
      setLoadingFalse();
    }
  }

  //==============================================================================
  //Share place
  //=============================================================================
  sharePlace(BuildContext context) async {
    final fnc = Get.find<FindNearSaunaController>();
    Share.share(
        'Download the PortaSauna app from appstore and on map search for address ${fnc.selectedSaunaPlace.address}. App download link: $portaSaunaAppstoreLink',
        subject: 'Check out this sauna place');
  }

  //==============================================================================
  //Report errors
  //=============================================================================
  final errorTitleController = TextEditingController();
  final errorDescriptionController = TextEditingController();

  reportError(BuildContext context) async {
    final userDetails = await dbClient.auth.getUser();
    final toEmail = userDetails.user?.email;
    setLoadingTrue();

    try {
      await sendEmail(
          toEmail: toEmail,
          emailText: errorDescriptionController.text,
          subject: errorTitleController.text);
      showSnackBar(context, 'Email sent', Pallete.greenColor);
      Get.back();
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setLoadingFalse();
    }
  }
}
