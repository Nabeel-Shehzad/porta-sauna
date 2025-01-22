import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/custom_input.dart';
import 'package:portasauna/core/widgets/loader_widget.dart';
import 'package:portasauna/features/request_place_edit/controller/request_edit_place_controller.dart';

class RequestEditDescriptionPage extends StatelessWidget {
  const RequestEditDescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestEditPlaceController>(builder: (rec) {
      return LoaderWidget(
        isLoading: rec.isLoading,
        child: Scaffold(
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
                      controller: rec.descController,
                      borderBottom: InputBorder.none,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                              fontSize: 16.h, color: Pallete.hintGreyColor),
                    ),
                  ),
                  gapH(45),
                  ButtonPrimary(
                      bgColor: Pallete.primarColor,
                      borderRadius: 8,
                      text: 'Next',
                      onPressed: () {
                        rec.requestEditPlace(context: context);
                      }),
                  gapH(45),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
