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
      return Positioned(
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
                    hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 16.h, color: Pallete.hintGreyColor),
                  ),

                  //================================
                  //Place suggestion
                  //================================
                  if (mc.suggestedPlaces.isNotEmpty)
                    Container(
                      color: Pallete.buttonBgColor,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: mc.suggestedPlaces.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (_, i) {
                            return ListTile(
                              onTap: () {
                                mc.moveCameraToPlace(context,
                                    placeName: mc.suggestedPlaces[i]);

                                Future.delayed(const Duration(seconds: 1), () {
                                  mc.makeSuggestedPlaceEmpty();
                                });
                              },
                              title: Text(
                                mc.suggestedPlaces[i],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontSize: 17.h),
                              ),
                            );
                          }),
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
                  color: Pallete.buttonBgColor, borderRadius: radius(1.5)),
              child: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      enableDrag: false,
                      isScrollControlled: true,
                      builder: (context) {
                        return const DiscoverPageFilterContent();
                      });
                },
                icon: Icon(
                  Icons.tune,
                  size: 29.h,
                ),
                color: Pallete.whiteColor,
              ),
            )
          ],
        ),
      );
    });
  }
}
