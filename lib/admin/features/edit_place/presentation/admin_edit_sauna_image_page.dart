import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/pick_image.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/image_pick_choice_modal_content.dart';
import 'package:portasauna/core/widgets/loader_widget.dart';
import 'package:portasauna/core/widgets/show_image.dart';
import 'package:portasauna/admin/features/edit_place/controller/admin_edit_place_controller.dart';
import 'package:portasauna/features/add_sauna_place/presentation/add_image_page.dart';

class AdminEditSaunaImagePage extends StatefulWidget {
  const AdminEditSaunaImagePage({super.key});

  @override
  State<AdminEditSaunaImagePage> createState() =>
      _AdminEditSaunaImagePageState();
}

class _AdminEditSaunaImagePageState extends State<AdminEditSaunaImagePage> {
  File? image;

  void selectImage({bool pickFromCamera = false}) async {
    final pickedImage = await pickImage(pickFromCamera: pickFromCamera);
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminEditPlaceController>(builder: (epc) {
      return LoaderWidget(
        isLoading: epc.isLoading,
        child: Scaffold(
          appBar: appbarCommon('Edit image', context),
          body: SingleChildScrollView(
            child: Container(
              padding: screenPaddingH,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //=================>
                  //Image pick
                  //=================>

                  image != null
                      ? addSaunaPageShowFileImage(fileImage: image)
                      : addSaunaPageShowEmptyImage(),

                  //=================>
                  //=================>
                  gapH(25),
                  ButtonPrimary(
                      text: 'Pick image',
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return ImagePickChoiceModalContent(
                                onCameraTap: () {
                                  Get.back();
                                  selectImage(pickFromCamera: true);
                                },
                                onGalleryTap: () {
                                  Get.back();
                                  selectImage();
                                },
                              );
                            });
                      }),

                  //=================>
                  //=================>
                  gapH(45),
                  ButtonPrimary(
                      bgColor: Pallete.primarColor,
                      borderRadius: 8,
                      text: 'Update & Approve',
                      onPressed: () {
                        epc.updateSauna(context: context, imageFile: image);
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

  adminEditSaunaPageShowDbImage({required imageLink}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: 200.h,
          width: Get.width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ShowImage(imgLocation: imageLink, isAssetImg: false),
          ),
        ),
      ],
    );
  }
}
