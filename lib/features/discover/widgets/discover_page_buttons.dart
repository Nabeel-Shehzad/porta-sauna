// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/auth/controller/profile_controller.dart';
import 'package:portasauna/features/discover/controller/map_controller.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';

class DiscoverPageButtons extends StatelessWidget {
  const DiscoverPageButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 15.w,
      bottom: 25.h,
      child: GetBuilder<MapController>(builder: (mc) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //=================================
            // Show cards button
            //=================================
            if (mc.placesList.isNotEmpty)
              IconButton(
                  onPressed: () async {
                    mc.setShowHorizontalCard(true);
                  },
                  icon: Container(
                    padding: EdgeInsets.all(19.sp),
                    decoration: BoxDecoration(
                        boxShadow: [bigShadow],
                        color: Pallete.whiteColor,
                        borderRadius: BorderRadius.circular(100)),
                    child: Icon(
                      Icons.photo_camera_back_outlined,
                      color: Colors.grey[800],
                      size: 25.h,
                    ),
                  )),

            //=================================
            // my location button
            //=================================
            IconButton(
                onPressed: () async {
                  await Get.find<FindNearSaunaController>()
                      .getUserCurrentPosition(context);

                  mc.animateCameraToNewPosition(
                      lat: mc.selectedPlaceLatLong?.lat,
                      long: mc.selectedPlaceLatLong?.lng);
                  mc.getSaunaPlacesOnMap(context);
                },
                icon: Container(
                  padding: EdgeInsets.all(19.sp),
                  decoration: BoxDecoration(
                      boxShadow: [bigShadow],
                      color: Pallete.whiteColor,
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(
                    Icons.gps_fixed,
                    color: Colors.grey[800],
                    size: 25.h,
                  ),
                )),
            gapH(12),

            //=================================
            // add place button
            //=================================
            InkWell(
              onTap: () {
                final pc = Get.find<ProfileController>();
                if (!pc.isLoggedIn) {
                  showSnackBar(
                      context, 'Please login to add place', Colors.red);
                  return;
                }

                mc.keepMarkersToTemp();
                mc.setShowBottomNav(true);
              },
              child: Container(
                  height: 55.h,
                  width: 200.w,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                      color: Pallete.whiteColor,
                      borderRadius: BorderRadius.circular(100)),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add_circle_outline,
                        color: Pallete.backgroundColor,
                      ),
                      gapW(10),
                      Text(
                        'Add Location',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Pallete.backgroundColor),
                      )
                    ],
                  )),
            ),
          ],
        );
      }),
    );
  }
}
