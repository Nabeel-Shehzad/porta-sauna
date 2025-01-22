// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/admin/features/all_place/components/admin_place_details_helper.dart';
import 'package:portasauna/admin/features/modify_place/controller/admin_modification_requested_controller.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/text_utils.dart';
import 'package:portasauna/core/utils/ui_const.dart';

class AdminDescriptionExpandableSection extends StatelessWidget {
  const AdminDescriptionExpandableSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminModificationRequestedController>(builder: (mrc) {
      final selectedModReqPlace =
          mrc.modReqPlaceData[mrc.selectedModReqPlaceIndex];

      bool changeRequested = true;
      //No change
      if (selectedModReqPlace.description == null ||
          selectedModReqPlace.description == "") {
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
                      'Description (Old)',
                      style: TextUtils.small1(context: context),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_down),
                    children: [
                      detailsRow(context,
                          title: '',
                          showTitle: false,
                          details: mrc.selectedSaunaPlace.description ?? ''),
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
                      'Description (New)',
                      style: TextUtils.small1(context: context),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_down),
                    children: [
                      gapH(10),
                      detailsRow(context,
                          title: '',
                          showTitle: false,
                          details: selectedModReqPlace.description ?? ''),
                    ],
                    onExpansionChanged: (bool expanded) {},
                  ),
                ),
              ],
            );
    });
  }
}

Container noChangeReqInAdminModReq(BuildContext context) {
  return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 5.h),
      child: Text('No changes requested here',
          style:
              TextUtils.small1(context: context, color: Pallete.greenColor)));
}
