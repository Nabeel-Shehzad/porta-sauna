import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/custom_checkbox.dart';
import 'package:portasauna/admin/features/edit_place/controller/admin_edit_place_controller.dart';
import 'package:portasauna/admin/features/edit_place/presentation/admin_edit_sauna_nearby_activity_page.dart';

class AdminEditSaunaNearbyServicePage extends StatelessWidget {
  const AdminEditSaunaNearbyServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminEditPlaceController>(builder: (epc) {
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
                  itemCount: epc.nearbyServicesList.length,
                  itemBuilder: (context, i) {
                    return CustomCheckbox(
                        onChanged: (v) {
                          epc.setSelectedNearbyService(i);
                        },
                        isChecked: epc.nearbyServicesList[i].selected,
                        text: epc.nearbyServicesList[i].name);
                  },
                ),
                gapH(20),
                ButtonPrimary(
                    bgColor: Pallete.primarColor,
                    borderRadius: 8,
                    text: 'Next',
                    onPressed: () {
                      Get.to(const AdminEditSaunaNearbyActivityPage());
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
