import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/custom_checkbox.dart';
import 'package:portasauna/features/add_sauna_place/controller/add_sauna_place_controller.dart';
import 'package:portasauna/features/add_sauna_place/presentation/add_sauna_description_page.dart';

class AddSaunaNearbyActivityPage extends StatelessWidget {
  const AddSaunaNearbyActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddSaunaPlaceController>(builder: (ac) {
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
                  itemCount: ac.nearbyActivitiesList.length,
                  itemBuilder: (context, i) {
                    return CustomCheckbox(
                        onChanged: (v) {
                          ac.setSelectedNearbyActivities(i);
                        },
                        isChecked: ac.nearbyActivitiesList[i].selected,
                        text: ac.nearbyActivitiesList[i].name);
                  },
                ),
                gapH(20),
                ButtonPrimary(
                    bgColor: Pallete.primarColor,
                    borderRadius: 8,
                    text: 'Next',
                    onPressed: () {
                      Get.to(const AddSaunaDescriptionPage());
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
