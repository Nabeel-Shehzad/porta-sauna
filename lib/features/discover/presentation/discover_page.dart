// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:portasauna/core/utils/helper.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/features/add_sauna_place/controller/add_sauna_place_controller.dart';
import 'package:portasauna/features/discover/controller/map_controller.dart';
import 'package:portasauna/features/discover/widgets/discover_page_buttons.dart';
import 'package:portasauna/features/discover/presentation/sauna_place_details_page.dart';
import 'package:portasauna/features/discover/widgets/discover_page_bottom_nav.dart';
import 'package:portasauna/features/discover/widgets/discover_top_bar.dart';
import 'package:portasauna/features/discover/widgets/map_place_card.dart';
import 'package:portasauna/features/discover/widgets/map_search_bar.dart';
import 'package:portasauna/features/discover/widgets/map_zoom_buttons.dart';
import 'package:portasauna/features/discover/widgets/nearby_sauna_cards.dart';
import 'package:portasauna/features/discover/widgets/search_area_button.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> with AutomaticKeepAliveClientMixin {
  final MapController mc = Get.find<MapController>();
  final FindNearSaunaController _nearSaunaController = Get.find<FindNearSaunaController>();
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMap();
    });
  }

  Future<void> _initializeMap() async {
    try {
      // Get current location and move map there
      final position = await _nearSaunaController.getUserCurrentPosition(context);
      
      // Move camera to current location
      await mc.moveCamera(
        LatLng(position.latitude, position.longitude),
        zoom: 15,
      );

      // Search for saunas in the area
      await _nearSaunaController.findNearSaunas(
        lat: position.latitude,
        long: position.longitude,
        radius: 10, // 10km radius for initial search
      );

      // Update markers and show cards
      await mc.addMultipleMarkers();
      mc.setShowHorizontalCard(true);
    } catch (e) {
      print('Error initializing map: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<MapController>(
      builder: (mc) => WillPopScope(
        onWillPop: () async {
          if (mc.showBottomNav) {
            return true;
          } else {
            mc.makeSuggestedPlaceEmpty();
            return false;
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: mc.cameraPosition(zoom: 6),
                markers: mc.markers,
                mapType: mc.currentMapType,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                compassEnabled: true,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
                onCameraMove: mc.onCameraMove,
                onCameraIdle: () => mc.onCameraIdle(context),
                onMapCreated: mc.onMapCreated,
                buildingsEnabled: false,
                mapToolbarEnabled: false, // Disable default map toolbar
                onTap: (latLng) {
                  if (!mc.showBottomNav) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    mc.makeSuggestedPlaceEmpty();
                    return;
                  }
                  
                  // Add marker when in add mode
                  mc.addOneMarker(
                    lat: latLng.latitude,
                    long: latLng.longitude,
                  );
                  
                  // Update coordinates in add sauna controller
                  Get.find<AddSaunaPlaceController>().setLatLongAndAddress(
                    lat: latLng.latitude,
                    long: latLng.longitude,
                  );
                },
              ),

              // Map Type Selector
              const DiscoverTopBar(),

              // Search bar (only shown when search is active)
              if (mc.showSearchBar) const MapSearchBar(),

              // Map Zoom Buttons
              const MapZoomButtons(),

              // Search Area Button
              const SearchAreaButton(),

              //=================================
              // Buttons
              //=================================
              const DiscoverPageButtons(),

              //=================================
              // Nearby Sauna Cards
              //=================================
              if (!mc.showBottomNav && mc.showHorizontalCard)
                const NearbySaunaCards(),

              //=================================
              // Bottom card for selected sauna
              //=================================
              if (mc.selectedSauna != null && !mc.showHorizontalCard)
                Positioned(
                  left: 16.w,
                  right: 16.w,
                  bottom: 25.h,
                  child: Container(
                    height: 180.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.find<FindNearSaunaController>()
                            .setSelectedSaunaPlace(mc.selectedSauna!);
                        Get.to(() => const SaunaPlaceDetailsPage());
                      },
                      child: Column(
                        children: [
                          // Image Container
                          Container(
                            height: 100.h,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(getLocationImage(mc.selectedSauna!.imgLinks)),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Dark overlay
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.3),
                                      ],
                                    ),
                                  ),
                                ),
                                // Favorite button
                                Positioned(
                                  top: 8.h,
                                  right: 8.w,
                                  child: Container(
                                    padding: EdgeInsets.all(6.w),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.star_border,
                                      color: Colors.white,
                                      size: 18.sp,
                                    ),
                                  ),
                                ),
                                // Close button
                                Positioned(
                                  top: 8.h,
                                  left: 8.w,
                                  child: Container(
                                    padding: EdgeInsets.all(6.w),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: InkWell(
                                      onTap: () => mc.hideBottomCard(),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 18.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Text Content
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 8.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mc.selectedSauna!.address ?? '',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.lightBlue[300],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Expanded(
                                    child: Text(
                                      mc.selectedSauna!.description ?? '',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.grey[400],
                                        height: 1.2,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: mc.showBottomNav
              ? const DiscoverPageBottomNav()
              : Container(
                  height: 0,
                ),
        ),
      ),
    );
  }
}
