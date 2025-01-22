import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/custom_input.dart';
import 'package:portasauna/features/add_sauna_place/controller/add_sauna_place_controller.dart';
import 'package:portasauna/features/add_sauna_place/presentation/add_image_page.dart';

class AddSaunaDescriptionPage extends StatelessWidget {
  const AddSaunaDescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddSaunaPlaceController>(builder: (asc) {
      return Scaffold(
        appBar: appbarCommon('Place description', context),
        body: SingleChildScrollView(
          child: Container(
            padding: screenPaddingH,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tell us some details about the location. eg. Opening Hours, Location Help",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                gapH(35),
                Container(
                  color: Colors.grey.withOpacity(.2),
                  child: CustomInput(
                    hintText: 'Write some description of the place',
                    maxLines: 6,
                    controller: asc.descController,
                    borderBottom: InputBorder.none,
                    hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 16.h, color: Pallete.hintGreyColor),
                  ),
                ),
                gapH(45),
                ButtonPrimary(
                    bgColor: Pallete.primarColor,
                    borderRadius: 8,
                    text: 'Next',
                    onPressed: () {
                      Get.to(const AddImagePage(
                        fromAddSaunaPage: true,
                      ));
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
