import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:portasauna/core/constants/assets_const.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/features/home/controller/landing_controller.dart';
import 'package:portasauna/features/home/presentation/landing_page.dart';

class PlaceAddedSuccessPage extends StatelessWidget {
  const PlaceAddedSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: screenPaddingH,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LottieBuilder.asset(
                  AssetsConst.checkAnimation,
                  repeat: false,
                ),
                gapH(9),
                Text('Location added',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall),
                gapH(9),
                Text(
                    'Thank you for your contribution. We will verify it soon. Once it is verified, it will be available on the map.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall
                    // ?.copyWith(
                    //     fontSize: 22.h,),
                    ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: LottieBuilder.asset(
                AssetsConst.celebrateAnimation,
                repeat: true,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60.h,
        padding: screenPaddingH,
        margin: EdgeInsets.only(bottom: 40.h),
        child: ButtonPrimary(
            bgColor: Pallete.primarColor,
            borderRadius: 8,
            text: 'Back to map',
            onPressed: () {
              Get.find<LandingController>().setSelectedIndex(2);
              Get.offAll(const LandingPage(
                loadLandingInit: false,
              ));
            }),
      ),
    );
  }
}
