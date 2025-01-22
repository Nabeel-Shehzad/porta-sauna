import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/constants/admin_const.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/custom_input.dart';
import 'package:portasauna/admin/features/edit_place/controller/admin_pending_place_controller.dart';
import 'package:portasauna/admin/features/homepage/admin_homepage.dart';

deletePlacePopup({required context, required VoidCallback onTap}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 13.h),
    width: Get.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Are you sure?',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontSize: 22.h),
          textAlign: TextAlign.center,
        ),
        gapH(50),
        ButtonPrimary(
            text: 'Delete',
            textStyle: Theme.of(context).textTheme.bodySmall,
            bgColor: Colors.red,
            onPressed: onTap),
        gapH(15),
        ButtonPrimary(
            text: 'Cancel',
            textStyle: Theme.of(context).textTheme.bodySmall,
            onPressed: () {
              Get.back();
            }),
      ],
    ),
  );
}

//=================================================>
//Admin area popup
//=================================================>
adminAreaPopup({required context}) {
  final passController = TextEditingController();

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 13.h),
    width: Get.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomInput(
          hintText: 'Enter admin password',
          controller: passController,
          isPasswordField: true,
        ),
        gapH(50),
        ButtonPrimary(
            text: 'Continue',
            textStyle: Theme.of(context).textTheme.bodySmall,
            bgColor: Pallete.primarColor,
            onPressed: () {
              if (passController.text == AdminConst.adminPass) {
                Get.offAll(const AdminHomepage());
              }
            }),
        gapH(15),
        ButtonPrimary(
            text: 'Cancel',
            textStyle: Theme.of(context).textTheme.bodySmall,
            onPressed: () {
              Get.back();
            }),
      ],
    ),
  );
}
