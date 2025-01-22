import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/constants/assets_const.dart';
import 'package:portasauna/core/utils/pick_image.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/custom_input.dart';
import 'package:portasauna/core/widgets/loader_widget.dart';
import 'package:portasauna/core/widgets/show_image.dart';
import 'package:portasauna/features/auth/controller/profile_controller.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, this.userName});

  final userName;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final usernameController = TextEditingController();

  @override
  void initState() {
    usernameController.text = widget.userName ?? '';
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (pc) {
      return LoaderWidget(
        isLoading: pc.isLoading,
        child: Scaffold(
          appBar: appbarCommon('Edit profile', context),
          body: SingleChildScrollView(
            child: Container(
              padding: screenPaddingH,
              child: Column(
                children: [
                  image != null
                      ? GestureDetector(
                          onTap: selectImage,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SizedBox(
                                height: 100.h,
                                width: 100.h,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: -15,
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 30.h,
                                  ))
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            selectImage();
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ShowImage(
                                height: 100.h,
                                width: 100.h,
                                imgLocation: defaultUserImage,
                                isAssetImg: false,
                                radius: 100.sp,
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: -15,
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 30.h,
                                  ))
                            ],
                          ),
                        ),
                  gapH(20),
                  CustomInput(
                      hintText: 'Username', controller: usernameController),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 60.h,
            margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 40.h),
            child: ButtonPrimary(
                text: 'Update',
                onPressed: () {
                  pc.updateProfile(context,
                      imageFile: image, userName: usernameController.text);
                }),
          ),
        ),
      );
    });
  }
}
