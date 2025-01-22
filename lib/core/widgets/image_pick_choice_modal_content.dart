import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portasauna/core/theme/pallete.dart';
import '../utils/ui_const.dart';

class ImagePickChoiceModalContent extends StatelessWidget {
  const ImagePickChoiceModalContent({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.h,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon(
                icon: Icons.camera_alt_outlined,
                txt: 'Camera',
                ontap: onCameraTap,
                context: context),
            gapW(25),
            icon(
                icon: Icons.image_outlined,
                txt: 'Gallery',
                ontap: onGalleryTap,
                context: context),
          ]),
    );
  }

  icon(
      {required icon,
      required String txt,
      required VoidCallback ontap,
      required BuildContext context}) {
    return InkWell(
      onTap: ontap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            decoration: BoxDecoration(
                borderRadius: radius(1.5),
                border: Border.all(color: Colors.grey.withOpacity(.25))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Pallete.whiteColor,
                  size: 30.sp,
                ),
                gapH(10),
                Text(
                  txt,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 17.h),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
