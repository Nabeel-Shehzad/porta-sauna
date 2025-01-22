import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/constants/assets_const.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/show_image.dart';
import 'package:portasauna/features/auth/controller/profile_controller.dart';
import 'package:portasauna/features/home/controller/landing_controller.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final lc = Get.find<LandingController>();

    return GetBuilder<ProfileController>(builder: (pc) {
      return Container(
        padding: screenPaddingH,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Logo
            ShowImage(
              imgLocation: AssetsConst.logoWhiteHorizontal,
              isAssetImg: true,
              height: 40.h,
              width: Get.width / 2,
              fit: BoxFit.fitHeight,
              imageAlignment: Alignment.centerLeft,
            ),

            //profile image
            if (pc.isLoggedIn)
              if (!pc.isLoading && pc.userDetails != null)
                InkWell(
                  onTap: () {
                    lc.setSelectedIndex(3);
                  },
                  child: ShowImage(
                    imgLocation: pc.userDetails?.profileImg ?? defaultUserImage,
                    isAssetImg: false,
                    radius: 100.sp,
                  ),
                )
          ],
        ),
      );
    });
  }
}
