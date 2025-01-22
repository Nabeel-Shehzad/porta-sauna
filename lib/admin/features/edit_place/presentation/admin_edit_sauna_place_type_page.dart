import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/text_utils.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/custom_checkbox.dart';
import 'package:portasauna/core/widgets/custom_input.dart';
import 'package:portasauna/admin/features/edit_place/controller/admin_edit_place_controller.dart';
import 'package:portasauna/admin/features/edit_place/presentation/admin_edit_sauna_nearby_service_page.dart';

class AdminEditSaunaPlaceTypePage extends StatelessWidget {
  const AdminEditSaunaPlaceTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminEditPlaceController>(builder: (epc) {
      return Scaffold(
        appBar: appbarCommon('Type of location', context),
        body: SingleChildScrollView(
          child: Container(
            padding: screenPaddingH,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //=====================>
                //Address field
                //=====================>

                Text(
                  "Address",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontSize: 22.h),
                ),

                gapH(15),
                Container(
                  color: Colors.grey.withOpacity(.2),
                  child: CustomInput(
                    hintText: 'Edit location',
                    maxLines: 1,
                    controller: epc.markedPlaceAddressController,
                    onChanged: (text) {},
                    borderBottom: InputBorder.none,
                    hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 16.h, color: Pallete.hintGreyColor),
                  ),
                ),

                //=====================>
                //Zip code
                //=====================>
                gapH(25),
                Text("Post code / Zip code",
                    style: TextUtils.inputLabel(context: context)),

                gapH(15),
                Container(
                  color: Colors.grey.withOpacity(.2),
                  child: CustomInput(
                    hintText: 'Example: 23507',
                    maxLines: 1,
                    controller: epc.markedPlaceZipController,
                    onChanged: (text) {},
                    borderBottom: InputBorder.none,
                    hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 16.h, color: Pallete.hintGreyColor),
                  ),
                ),

                //=====================>
                //Wild locations
                //=====================>
                gapH(30),
                Text(
                  "Wild Sauna Spots",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontSize: 22.h),
                ),
                gapH(15),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: epc.placeWildTypeList.length,
                  itemBuilder: (context, i) {
                    return CustomCheckbox(
                        onChanged: (v) {
                          epc.setSelectedWildType(i);
                        },
                        isChecked: epc.placeWildTypeList[i].selected,
                        text: epc.placeWildTypeList[i].name);
                  },
                ),

                //=====================>
                //Commercial
                //=====================>
                Text(
                  "Commercial Sauna Locations",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontSize: 22.h),
                ),
                gapH(15),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: epc.placeCommercialTypeList.length,
                  itemBuilder: (context, i) {
                    return CustomCheckbox(
                        onChanged: (v) {
                          epc.setSelectedCommercialType(i);
                        },
                        isChecked: epc.placeCommercialTypeList[i].selected,
                        text: epc.placeCommercialTypeList[i].name);
                  },
                ),

                //=====================>
                //Commercial phone number
                //=====================>
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Commercial phone number",
                        style: TextUtils.inputLabel(context: context)),
                    gapH(15),
                    Container(
                      color: Colors.grey.withOpacity(.2),
                      child: CustomInput(
                        hintText: 'Enter phone number',
                        controller: epc.commercialPhoneController,
                        borderBottom: InputBorder.none,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                                fontSize: 16.h, color: Pallete.hintGreyColor),
                      ),
                    ),
                    gapH(25),
                  ],
                ),

                gapH(20),

                ButtonPrimary(
                    bgColor: Pallete.primarColor,
                    borderRadius: 8,
                    text: 'Next',
                    onPressed: () {
                      Get.to(const AdminEditSaunaNearbyServicePage());
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
