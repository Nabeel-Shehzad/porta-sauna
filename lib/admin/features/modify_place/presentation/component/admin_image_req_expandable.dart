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
import 'package:portasauna/core/widgets/show_image.dart';
import 'package:portasauna/features/discover/widgets/place_details_image_slider.dart';

class AdminImageReqExpandable extends StatelessWidget {
  const AdminImageReqExpandable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminModificationRequestedController>(builder: (mrc) {
      final selectedModReqPlace =
          mrc.modReqPlaceData[mrc.selectedModReqPlaceIndex];

      bool changeRequested = true;
      if (selectedModReqPlace.imgLinks == null ||
          selectedModReqPlace.imgLinks is List &&
              selectedModReqPlace.imgLinks!.isEmpty) {
        changeRequested = false;
      }

      return !changeRequested
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //===========================>
                //Image req
                //===========================>
                Theme(
                  data: ThemeData().copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    childrenPadding: screenPaddingH,
                    title: Text(
                      'Image requested to add',
                      style: TextUtils.small1(context: context),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_down),
                    children: [
                      gapH(20),

                      //===========================>
                      PlaceDetailsImageSlider(
                          imageList: selectedModReqPlace.imgLinks ?? []),
                    ],
                    onExpansionChanged: (bool expanded) {},
                  ),
                ),
              ],
            );
    });
  }
}
