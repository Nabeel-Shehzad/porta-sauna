// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    return GetBuilder<MapController>(builder: (mc) {
      return Positioned(
        right: 16.w,
        bottom: mc.selectedSauna != null ? 345.h : (mc.showBottomNav ? 80.h : 180.h), // Adjusted bottom padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Show cards button
            if (mc.placesList.isNotEmpty)
              _buildFloatingButton(
                onPressed: () async {
                  mc.setShowHorizontalCard(true);
                },
                icon: Icons.photo_camera_back_outlined,
                tooltip: 'View Sauna Cards',
              ),

            SizedBox(height: 12.h),

            // My location button
            _buildFloatingButton(
              onPressed: () async {
                final mc = Get.find<MapController>();
                final position = await mc.getCurrentLocation();
                if (position != null) {
                  await mc.moveCamera(
                    LatLng(position.latitude, position.longitude),
                    zoom: 15,
                  );
                  mc.addCurrentPlaceMarker(
                    lat: position.latitude,
                    long: position.longitude,
                    title: 'Your Location',
                  );
                } else {
                  showSnackBar(context, 'Could not get current location', Colors.red);
                }
              },
              icon: Icons.gps_fixed,
              tooltip: 'My Location',
            ),

            SizedBox(height: 12.h),

            // Add place button
            _buildFloatingButton(
              onPressed: () {
                final pc = Get.find<ProfileController>();
                if (!pc.isLoggedIn) {
                  showSnackBar(context, 'Please login to add place', Colors.red);
                  return;
                }
                mc.keepMarkersToTemp();
                mc.setShowBottomNav(true);
              },
              icon: Icons.add_location_alt_outlined,
              tooltip: 'Add New Location',
              isLarge: true,
              backgroundColor: Pallete.primarColor,
              iconColor: Colors.white,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFloatingButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String tooltip,
    bool isLarge = false,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      child: FloatingActionButton(
        onPressed: onPressed,
        tooltip: tooltip,
        elevation: 4,
        backgroundColor: backgroundColor ?? Colors.white,
        mini: !isLarge,
        child: Icon(
          icon,
          color: iconColor ?? Colors.grey[800],
          size: isLarge ? 28.sp : 24.sp,
        ),
      ),
    );
  }
}
