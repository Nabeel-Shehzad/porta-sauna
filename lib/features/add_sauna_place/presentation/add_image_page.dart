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
import 'package:portasauna/features/add_sauna_place/controller/add_sauna_place_controller.dart';
import 'package:portasauna/features/request_place_edit/controller/request_edit_place_controller.dart';

class AddImagePage extends StatefulWidget {
  const AddImagePage(
      {super.key,
      this.fromAddSaunaPage = false,
      this.fromAddImageByOtherUserPage = false});

  @override
  State<AddImagePage> createState() => _AddImagePageState();

  final bool fromAddSaunaPage;
  final bool fromAddImageByOtherUserPage;
}

class _AddImagePageState extends State<AddImagePage> {
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
    return GetBuilder<AddSaunaPlaceController>(builder: (ac) {
      return GetBuilder<RequestEditPlaceController>(builder: (rec) {
        return LoaderWidget(
          isLoading: ac.isLoading || rec.isLoading,
          child: Scaffold(
            appBar: appbarCommon('Add picture', context),
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
                    //Rules
                    //=================>
                    gapH(35),
                    rulesText(context,
                        text: "Photos must be taken in landscape mode."),
                    rulesText(context,
                        text:
                            "Images should not include others that have not given express permission to be in the photographs."),
                    rulesText(context,
                        text:
                            "Showcase the services or features offered by Sauna, such as the sauna setup, cold plunge pool, and relaxation spaces."),
                    rulesText(context,
                        text:
                            "Ensure the images provide a clear view of the location and sauna  in use, highlighting its key features."),
                    rulesText(context,
                        text:
                            "Avoid overly personal images, such as selfies or posed photos with people, pets, or unrelated items like food."),
                    rulesText(context,
                        text:
                            "Advertising material or images with added text or inappropriate images  will not be accepted."),

                    //=================>
                    //=================>

                    gapH(45),
                    ButtonPrimary(
                        bgColor: Pallete.primarColor,
                        borderRadius: 8,
                        text: 'Save',
                        onPressed: () {
                          if (widget.fromAddSaunaPage) {
                            ac.addSaunaToDb(context: context, imageFile: image);
                          } else if (widget.fromAddImageByOtherUserPage) {
                            rec.addImageToExistingPlace(
                                context: context, imageFile: image);
                          }
                        }),
                    gapH(45),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    });
  }
}

Container addSaunaPageShowEmptyImage() {
  return Container(
    height: 200.h,
    width: Get.width,
    decoration: BoxDecoration(
        borderRadius: radius(2), border: Border.all(color: Colors.grey[600]!)),
    child: Icon(
      Icons.camera_alt_outlined,
      size: 40.h,
    ),
  );
}

rulesText(BuildContext context, {required text}) {
  return Container(
    margin: EdgeInsets.only(bottom: 20.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 7.h, right: 12.w),
          child: Icon(
            Icons.circle,
            size: 8.h,
            color: Pallete.greyColor,
          ),
        ),
        Flexible(
          child: Text(
            text,
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 16.h),
          ),
        ),
      ],
    ),
  );
}

addSaunaPageShowFileImage({required fileImage}) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      SizedBox(
        height: 200.h,
        width: Get.width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            fileImage!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ],
  );
}
