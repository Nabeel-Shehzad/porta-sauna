import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/custom_checkbox.dart';
import 'package:portasauna/features/discover/controller/filter_sauna_place_controller.dart';
import 'package:portasauna/features/discover/controller/map_controller.dart';

class DiscoverPageFilterContent extends StatelessWidget {
  const DiscoverPageFilterContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mc = Get.find<MapController>();

    return GetBuilder<FilterSaunaPlaceController>(builder: (fsc) {
      return Container(
          height: 650.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          color: Pallete.backgroundColor,
          child: Column(
            children: [
              //========================================
              //Button
              //========================================

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      mc.getSaunaPlacesOnMap(context);
                      Get.back();
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 12.h),
                      decoration: BoxDecoration(
                          border: Border.all(color: Pallete.primarColor)),
                      child: Text(
                        'Save',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Pallete.primarColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.sp),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //========================================
                        //Wild
                        //========================================

                        Text(
                          'Wild Sauna Spots',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontSize: 18.h),
                        ),
                        gapH(18),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: fsc.wildTypeList.length,
                          itemBuilder: (context, i) {
                            print(
                                'selected wild ${fsc.wildTypeList[i].selected}');
                            print(
                                'selected wild name ${fsc.wildTypeList[i].name}');
                            return CustomCheckbox(
                                onChanged: (v) {
                                  fsc.setSelectedWildType(i);
                                },
                                isChecked: fsc.wildTypeList[i].selected,
                                text: fsc.wildTypeList[i].name);
                          },
                        ),

                        //========================================
                        //Commercial
                        //========================================
                        gapH(29),
                        Text(
                          'Commercial Sauna Locations',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontSize: 18.h),
                        ),
                        gapH(18),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: fsc.commercialList.length,
                          itemBuilder: (context, i) {
                            return CustomCheckbox(
                                onChanged: (v) {
                                  fsc.setSelectedCommercialType(i);
                                },
                                isChecked: fsc.commercialList[i].selected,
                                text: fsc.commercialList[i].name);
                          },
                        ),

                        //========================================
                        //Nearby services
                        //========================================
                        gapH(29),
                        Text(
                          'Nearby services',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontSize: 18.h),
                        ),
                        gapH(18),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: fsc.nearbyServiceList.length,
                          itemBuilder: (context, i) {
                            return CustomCheckbox(
                                onChanged: (v) {
                                  fsc.setSelectedNearbyService(i);
                                },
                                isChecked: fsc.nearbyServiceList[i].selected,
                                text: fsc.nearbyServiceList[i].name);
                          },
                        ),

                        //========================================
                        //Nearby activities
                        //========================================
                        gapH(29),
                        Text(
                          'Nearby activities',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontSize: 18.h),
                        ),
                        gapH(18),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: fsc.nearbyActivityList.length,
                          itemBuilder: (context, i) {
                            return CustomCheckbox(
                                onChanged: (v) {
                                  fsc.setSelectedNearbyActivities(i);
                                },
                                isChecked: fsc.nearbyActivityList[i].selected,
                                text: fsc.nearbyActivityList[i].name);
                          },
                        ),

                        gapH(45),
                      ]),
                ),
              ),
            ],
          ));
    });
  }
}
