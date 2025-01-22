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
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/add_sauna_place/controller/add_sauna_place_controller.dart';
import 'package:portasauna/features/add_sauna_place/presentation/add_sauna_nearby_service_page.dart';

class AddSaunaPlaceTypePage extends StatelessWidget {
  const AddSaunaPlaceTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddSaunaPlaceController>(builder: (ac) {
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
                  style: TextUtils.inputLabel(context: context),
                ),

                gapH(15),
                Container(
                  color: Colors.grey.withOpacity(.2),
                  child: CustomInput(
                    hintText: 'Enter Sauna Name / Location',
                    maxLines: 1,
                    controller: ac.markedPlaceAddressController,
                    onChanged: (text) {},
                    borderBottom: InputBorder.none,
                    hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 16.h, color: Pallete.hintGreyColor),
                  ),
                ),

                //=====================>
                //Zip code
                //=====================>
                gapH(20),
                Text("Post code / Zip code",
                    style: TextUtils.inputLabel(context: context)),

                gapH(15),
                Container(
                  color: Colors.grey.withOpacity(.2),
                  child: CustomInput(
                    hintText: 'Example: 23507',
                    maxLines: 1,
                    controller: ac.markedPlaceZipController,
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
                  itemCount: ac.placeWildTypeList.length,
                  itemBuilder: (context, i) {
                    return CustomCheckbox(
                        onChanged: (v) {
                          ac.setSelectedWildType(i);
                        },
                        isChecked: ac.placeWildTypeList[i].selected,
                        text: ac.placeWildTypeList[i].name);
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
                  itemCount: ac.placeCommercialTypeList.length,
                  itemBuilder: (context, i) {
                    return CustomCheckbox(
                        onChanged: (v) {
                          ac.setSelectedCommercialType(i);
                        },
                        isChecked: ac.placeCommercialTypeList[i].selected,
                        text: ac.placeCommercialTypeList[i].name);
                  },
                ),

                //=====================>
                //Commercial phone number
                //=====================>
                if (ac.commercialSelected)
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
                          controller: ac.commercialPhoneController,
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

                ButtonPrimary(
                    bgColor: Pallete.primarColor,
                    borderRadius: 8,
                    text: 'Next',
                    onPressed: () {
                      if (ac.markedPlaceAddressController.text.isEmpty) {
                        showSnackBar(context, 'Address field cannot be empty',
                            Pallete.redColor);
                        return;
                      }
                      Get.to(const AddSaunaNearbyServicePage());
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
