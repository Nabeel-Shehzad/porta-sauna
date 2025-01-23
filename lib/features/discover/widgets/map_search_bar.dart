import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/custom_input.dart';
import 'package:portasauna/features/discover/controller/map_controller.dart';
import 'package:portasauna/features/discover/widgets/discover_page_filter_content.dart';

class MapSearchBar extends StatelessWidget {
  const MapSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapController>(builder: (mc) {
      return Stack(
        children: [
          Positioned(
            top: 70.h,
            left: 20.w,
            right: 20.w,
            child: Row(
              children: [
                //=================================
                // search bar
                //=================================
                Expanded(
                  child: Column(
                    children: [
                      CustomInput(
                        onChanged: (v) {
                          mc.searchPlace(placeName: v);
                        },
                        hintText: 'Search sauna by location',
                        controller: mc.searchController,
                        suffixIcon: Icons.clear,
                        onSuffixTap: () {
                          mc.searchController.clear();
                          mc.makeSuggestedPlaceEmpty();
                        },
                        filled: true,
                        borderBottom: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: 16.h, color: Pallete.hintGreyColor),
                      ),

                      //================================
                      //Place suggestion
                      //================================
                      if (mc.suggestedPlaces.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: Pallete.buttonBgColor,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(7),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Pallete.buttonBgColor,
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: mc.suggestedPlaces.length > 5 ? 5 : mc.suggestedPlaces.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, i) {
                                return InkWell(
                                  onTap: () {
                                    mc.moveCameraToPlace(
                                      context,
                                      placeName: mc.suggestedPlaces[i],
                                      animateCamera: true,
                                      clearMarkers: true,
                                    );
                                    mc.searchController.text = mc.suggestedPlaces[i];
                                    mc.makeSuggestedPlaceEmpty();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 12.h,
                                    ),
                                    child: Text(
                                      mc.suggestedPlaces[i],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontSize: 16.h,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                //=================================
                // Filter button
                //=================================
                gapW(5),
                Container(
                  padding: EdgeInsets.all(4.h),
                  decoration: BoxDecoration(
                    color: Pallete.buttonBgColor,
                    borderRadius: radius(1.5),
                  ),
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        enableDrag: false,
                        isScrollControlled: true,
                        builder: (context) {
                          return const DiscoverPageFilterContent();
                        },
                      );
                    },
                    icon: Icon(
                      Icons.tune,
                      size: 29.h,
                    ),
                    color: Pallete.whiteColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
