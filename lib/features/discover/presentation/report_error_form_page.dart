import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/text_utils.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/custom_input.dart';
import 'package:portasauna/core/widgets/loader_widget.dart';
import 'package:portasauna/features/discover/controller/place_details_modal_controller.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';

class ReportErrorFormPage extends StatefulWidget {
  const ReportErrorFormPage({super.key});

  @override
  State<ReportErrorFormPage> createState() => _ReportErrorFormPageState();
}

class _ReportErrorFormPageState extends State<ReportErrorFormPage> {
  final fnc = Get.find<FindNearSaunaController>();
  final pdc = Get.find<PlaceDetailsModalController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pdc.errorTitleController.text = "Error found";
      pdc.errorDescriptionController.text =
          "Write the problem here:\n\n\n\nDon't edit the details below:\nPlace id ${fnc.selectedSaunaPlace.id},\nUser id ${fnc.selectedSaunaPlace.userId},\nPlace details: ${fnc.selectedSaunaPlace.address},\nLatitude: ${fnc.selectedSaunaPlace.lattitude},\nLongitude: ${fnc.selectedSaunaPlace.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlaceDetailsModalController>(builder: (pdc) {
      return LoaderWidget(
        isLoading: pdc.isLoading,
        child: Scaffold(
          appBar: appbarCommon('Report error', context),
          body: SingleChildScrollView(
            child: Container(
                padding: screenPaddingH,
                child: Column(
                  children: [
                    Container(
                      color: Colors.grey.withOpacity(.2),
                      child: CustomInput(
                        hintText: 'Title',
                        maxLines: 1,
                        controller: pdc.errorTitleController,
                        onChanged: (text) {},
                        borderBottom: InputBorder.none,
                        hintStyle: TextUtils.inputHintStyle(context: context),
                      ),
                    ),
                    gapH(20),
                    Container(
                      color: Colors.grey.withOpacity(.2),
                      child: CustomInput(
                        hintText: 'Write feedback',
                        maxLines: 10,
                        controller: pdc.errorDescriptionController,
                        borderBottom: InputBorder.none,
                        hintStyle: TextUtils.inputHintStyle(context: context),
                      ),
                    ),
                    gapH(20),
                    ButtonPrimary(
                        text: 'Submit',
                        bgColor: Pallete.primarColor,
                        onPressed: () {
                          pdc.reportError(context);
                        })
                  ],
                )),
          ),
        ),
      );
    });
  }
}
