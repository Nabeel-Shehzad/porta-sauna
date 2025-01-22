import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/utils/helper.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/show_image.dart';
import 'package:portasauna/features/discover/presentation/sauna_place_details_page.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';
import 'package:portasauna/features/home/controller/landing_controller.dart';
import 'package:portasauna/features/home/presentation/skeleton/sauna_card_horizontal_skeleton.dart';
import 'package:portasauna/features/home/presentation/widgets/home_cards.dart';

class SaunaSpotsAroundYou extends StatelessWidget {
  const SaunaSpotsAroundYou({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FindNearSaunaController>(builder: (fnc) {
      if (fnc.isLoading) {
        return const SaunaCardHorizontalSkeleton();
      }

      return Container(
        padding: screenPaddingH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                final lc = Get.find<LandingController>();
                lc.setSelectedIndex(2);
              },
              child: ShowImage(
                imgLocation: 'assets/images/map_bg.png',
                isAssetImg: true,
                width: Get.width,
                height: 120.w,
                fit: BoxFit.fitWidth,
              ),
            ),

            //
            gapH(30),
            Text(
              'Sauna spots near you',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 22.h,
                  ),
            ),
            gapH(32),
            if (fnc.nearestSaunas.isEmpty && !fnc.isLoading)
              Container(
                margin: EdgeInsets.only(top: 15.h),
                child: Text(
                  'No sauna spots found',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 17.h),
                ),
              ),
            if (fnc.nearestSaunas.isNotEmpty && !fnc.isLoading)
              SizedBox(
                height: 290.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  clipBehavior: Clip.none,
                  itemCount: fnc.nearestSaunas.length,
                  itemBuilder: (_, i) {
                    return InkWell(
                      onTap: () {
                        fnc.setSelectedSaunaPlace(fnc.nearestSaunas[i]);
                        Get.to(const SaunaPlaceDetailsPage());
                      },
                      child: HomeCards(
                        imgLink:
                            getLocationImage(fnc.nearestSaunas[i].imgLinks),
                        title:
                            fnc.nearestSaunas[i].address ?? 'Unknown address',
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      );
    });
  }
}
