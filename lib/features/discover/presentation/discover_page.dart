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
import 'package:portasauna/features/discover/widgets/map_place_card.dart';
import 'package:portasauna/features/discover/widgets/map_search_bar.dart';
import 'package:portasauna/features/discover/widgets/map_type_selector.dart';
import 'package:portasauna/features/discover/widgets/map_zoom_buttons.dart';
import 'package:portasauna/features/discover/widgets/search_area_button.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> with AutomaticKeepAliveClientMixin {
  final MapController mc = Get.find<MapController>();
  
  @override
  bool get wantKeepAlive => true;

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
                onTap: (argument) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  mc.makeSuggestedPlaceEmpty();
                },
              ),

              // Map Type Selector
              const MapTypeSelector(),

              // Map Zoom Buttons
              const MapZoomButtons(),

              if (!mc.showBottomNav) const MapSearchBar(),

              // Search Area Button
              const SearchAreaButton(),

              //=================================
              // Buttons
              //=================================
              const DiscoverPageButtons(),

              //=================================
              // Bottom card for selected sauna
              //=================================
              if (mc.selectedSauna != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 25.h,
                  child: SizedBox(
                    height: 310.h,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        //=================================
                        // Sauna card
                        //=================================
                        InkWell(
                          onTap: () {
                            Get.find<FindNearSaunaController>()
                                .setSelectedSaunaPlace(mc.selectedSauna!);
                            Get.to(const SaunaPlaceDetailsPage());
                          },
                          child: MapPlaceCard(
                            imgLink: getLocationImage(mc.selectedSauna!.imgLinks),
                            title: mc.selectedSauna!.selectedWildType != null && 
                                   mc.selectedSauna!.selectedWildType!.isNotEmpty ?
                              "Free Sauna Spot | ${mc.selectedSauna!.selectedWildType!.first}" :
                              "Commercial | ${mc.selectedSauna!.selectedCommercialType?.first ?? ''}",
                            subTitle: mc.selectedSauna!.description ?? '',
                            distance: mc.selectedSauna!.distance,
                            cardWidth: Get.width - 50.w,
                          ),
                        ),

                        //=================================
                        // Close button
                        //=================================
                        Positioned(
                          right: 10.w,
                          top: 0.h,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: radius(100),
                              boxShadow: [bigShadowTwo]
                            ),
                            child: IconButton(
                              onPressed: () => mc.hideBottomCard(),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black,
                              )
                            ),
                          ),
                        ),
                      ],
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
