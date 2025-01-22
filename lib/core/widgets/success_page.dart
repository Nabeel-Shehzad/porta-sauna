import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:portasauna/core/constants/assets_const.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/button_primary.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage(
      {super.key,
      required this.title,
      required this.desc,
      required this.onBackPressed});

  final String title;
  final String desc;
  final VoidCallback onBackPressed;

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
                Text(title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall),
                gapH(9),
                Text(desc,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall),
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
            text: 'Go back',
            onPressed: onBackPressed),
      ),
    );
  }
}
