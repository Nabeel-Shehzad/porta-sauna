import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/custom_checkbox.dart';
import 'package:portasauna/features/request_place_edit/controller/request_edit_place_controller.dart';
import 'package:portasauna/features/request_place_edit/presentation/request_edit_description_page.dart';

class RequestEditNearbyActivityPage extends StatelessWidget {
  const RequestEditNearbyActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestEditPlaceController>(builder: (rec) {
      return Scaffold(
        appBar: appbarCommon('Nearby Activities', context),
        body: SingleChildScrollView(
          child: Container(
            padding: screenPaddingH,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //=====================>
                //Nearby Activities
                //=====================>

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: rec.nearbyActivitiesList.length,
                  itemBuilder: (context, i) {
                    return CustomCheckbox(
                        onChanged: (v) {
                          rec.setSelectedNearbyActivities(i);
                        },
                        isChecked: rec.nearbyActivitiesList[i].selected,
                        text: rec.nearbyActivitiesList[i].name);
                  },
                ),
                ButtonPrimary(
                    bgColor: Pallete.primarColor,
                    borderRadius: 8,
                    text: 'Next',
                    onPressed: () {
                      Get.to(const RequestEditDescriptionPage());
                    }),
                gapH(45),
              ],
            ),
          ),
        ),
      );
    });
  }
}
