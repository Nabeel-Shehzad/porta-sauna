import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/custom_checkbox.dart';
import 'package:portasauna/admin/features/edit_place/controller/admin_edit_place_controller.dart';
import 'package:portasauna/admin/features/edit_place/presentation/admin_edit_sauna_description_page.dart';

class AdminEditSaunaNearbyActivityPage extends StatelessWidget {
  const AdminEditSaunaNearbyActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminEditPlaceController>(builder: (epc) {
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
                  itemCount: epc.nearbyActivitiesList.length,
                  itemBuilder: (context, i) {
                    return CustomCheckbox(
                        onChanged: (v) {
                          epc.setSelectedNearbyActivities(i);
                        },
                        isChecked: epc.nearbyActivitiesList[i].selected,
                        text: epc.nearbyActivitiesList[i].name);
                  },
                ),
                gapH(20),
                ButtonPrimary(
                    bgColor: Pallete.primarColor,
                    borderRadius: 8,
                    text: 'Next',
                    onPressed: () {
                      Get.to(const AdminEditSaunaDescriptionPage());
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
