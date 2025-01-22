import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:portasauna/core/constants/assets_const.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/features/add_sauna_place/controller/add_sauna_place_controller.dart';
import 'package:portasauna/features/add_sauna_place/presentation/important_notice_before_adding_place_page.dart';
import 'package:portasauna/features/discover/controller/map_controller.dart';

class DiscoverPageBottomNav extends StatelessWidget {
  const DiscoverPageBottomNav({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapController>(builder: (mc) {
      return GetBuilder<AddSaunaPlaceController>(builder: (aspc) {
        return Container(
          height: 300.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          color: Pallete.backgroundColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (aspc.isLoading)
                  Container(
                      margin: EdgeInsets.only(top: 25.h),
                      child: const CircularProgressIndicator()),

                if (!aspc.isLoading)
                  if (mc.markerPlacedOnMap)
                    Column(
                      children: [
                        gapH(15),
                        Text(
                          aspc.markedPlaceAddressController.text,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontSize: 19.h),
                        ),
                        gapH(9),
                        Text(
                          "(You will be able to edit the address to the next screen)",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  fontSize: 15.h, color: Pallete.yellowColor),
                        ),
                        gapH(25),
                        continueButton(context),
                        gapH(12),
                        cancelButton(context, mc),
                      ],
                    ),

                //Locatin not picked yet
                if (!aspc.isLoading)
                  if (!mc.markerPlacedOnMap)
                    Column(
                      children: [
                        Text(
                          'Touch anywhere on the map to place a marker',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 17.h),
                        ),
                        LottieBuilder.asset(
                            height: 80.h, AssetsConst.markerAnimation),
                        gapH(15),
                        cancelButton(context, mc)
                      ],
                    ),
              ],
            ),
          ),
        );
      });
    });
  }

  cancelButton(
    BuildContext context,
    MapController mc,
  ) {
    return ButtonPrimary(
        width: 120.w,
        paddingVertical: 13.h,
        textStyle:
            Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 16.h),
        text: 'Cancel',
        borderRadius: 100,
        onPressed: () {
          mc.setShowBottomNav(false);
          mc.fillMarkersWithTemp();
        });
  }

  continueButton(
    BuildContext context,
  ) {
    return ButtonPrimary(
        width: 120.w,
        paddingVertical: 13.h,
        bgColor: Pallete.primarColor,
        borderRadius: 100,
        textStyle:
            Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 16.h),
        text: 'Continue',
        onPressed: () {
          Get.to(const ImportantNoticeBeforeAddingPlacePage());
        });
  }
}
