import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/custom_checkbox.dart';
import 'package:portasauna/features/add_sauna_place/controller/add_sauna_place_controller.dart';
import 'package:portasauna/features/add_sauna_place/presentation/add_sauna_nearby_activity_page.dart';

class AddSaunaNearbyServicePage extends StatelessWidget {
  const AddSaunaNearbyServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddSaunaPlaceController>(builder: (ac) {
      return Scaffold(
        appBar: appbarCommon('Nearby Services', context),
        body: SingleChildScrollView(
          child: Container(
            padding: screenPaddingH,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //=====================>
                //Nearby Services
                //=====================>

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: ac.nearbyServicesList.length,
                  itemBuilder: (context, i) {
                    return CustomCheckbox(
                        onChanged: (v) {
                          ac.setSelectedNearbyService(i);
                        },
                        isChecked: ac.nearbyServicesList[i].selected,
                        text: ac.nearbyServicesList[i].name);
                  },
                ),
                gapH(20),
                ButtonPrimary(
                    bgColor: Pallete.primarColor,
                    borderRadius: 8,
                    text: 'Next',
                    onPressed: () {
                      Get.to(const AddSaunaNearbyActivityPage());
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
