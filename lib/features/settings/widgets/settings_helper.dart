import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/features/auth/controller/profile_controller.dart';

logoutPopup({required context}) {
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
            text: 'Logout',
            textStyle: Theme.of(context).textTheme.bodySmall,
            bgColor: Colors.red,
            onPressed: () {
              Get.find<ProfileController>().logout(context);
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
