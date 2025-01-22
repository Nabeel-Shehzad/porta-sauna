// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/admin/features/all_place/components/admin_place_details_helper.dart';
import 'package:portasauna/admin/features/modify_place/controller/admin_modification_requested_controller.dart';
import 'package:portasauna/admin/features/modify_place/presentation/component/admin_description_expandable_section.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/text_utils.dart';
import 'package:portasauna/core/utils/ui_const.dart';

class AdminServicesAndActivitiesExpandable extends StatelessWidget {
  const AdminServicesAndActivitiesExpandable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminModificationRequestedController>(builder: (mrc) {
      final selectedModReqPlace =
          mrc.modReqPlaceData[mrc.selectedModReqPlaceIndex];

      bool changeRequested = true;
      //No change
      if (selectedModReqPlace.selectedNearbyService == null &&
              selectedModReqPlace.selectedNearbyActivities == null ||
          selectedModReqPlace.selectedNearbyService!.isEmpty &&
              selectedModReqPlace.selectedNearbyActivities!.isEmpty) {
        changeRequested = false;
      }

      return !changeRequested
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //===========================>
                //Old Service type
                //===========================>
                Theme(
                  data: ThemeData().copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    childrenPadding: screenPaddingH,
                    title: Text(
                      'Services and activities (Old)',
                      style: TextUtils.small1(context: context),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_down),
                    children: [
                      gapH(20),
                      detailsRowWithPoints(context,
                          details:
                              mrc.selectedSaunaPlace.selectedNearbyService ??
                                  []),
                      detailsRowWithPoints(context,
                          details:
                              mrc.selectedSaunaPlace.selectedNearbyActivities ??
                                  []),
                    ],
                    onExpansionChanged: (bool expanded) {},
                  ),
                ),

                //===========================>
                //New Service type
                //===========================>

                Theme(
                  data: ThemeData().copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    childrenPadding: screenPaddingH,
                    title: Text(
                      'Services and activities (New)',
                      style: TextUtils.small1(context: context),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_down),
                    children: [
                      gapH(10),
                      detailsRowWithPoints(context,
                          details:
                              selectedModReqPlace.selectedNearbyService ?? []),
                      detailsRowWithPoints(context,
                          details:
                              selectedModReqPlace.selectedNearbyActivities ??
                                  []),
                    ],
                    onExpansionChanged: (bool expanded) {},
                  ),
                ),
              ],
            );
    });
  }
}
