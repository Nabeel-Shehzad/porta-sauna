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

class SaunaSpotsAroundYou extends StatefulWidget {
  const SaunaSpotsAroundYou({
    super.key,
  });

  @override
  State<SaunaSpotsAroundYou> createState() => _SaunaSpotsAroundYouState();
}

class _SaunaSpotsAroundYouState extends State<SaunaSpotsAroundYou> {
  @override
  void initState() {
    super.initState();
    // Load nearby saunas when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<FindNearSaunaController>();
      controller.getNearestSaunaLocation(context);
    });
  }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sauna spots near you',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 22.h,
                      ),
                ),
                if (!fnc.isLoading)
                  IconButton(
                    onPressed: () => fnc.getNearestSaunaLocation(context),
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh nearby saunas',
                  ),
              ],
            ),
            gapH(32),
            if (fnc.nearestSaunas.isEmpty && !fnc.isLoading)
              Container(
                margin: EdgeInsets.only(top: 15.h),
                child: Text(
                  'No sauna spots found nearby',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 17.h),
                ),
              ),
            if (fnc.nearestSaunas.isNotEmpty && !fnc.isLoading)
              SizedBox(
                height: 280.h,  // Match card height
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  clipBehavior: Clip.none,
                  itemCount: fnc.nearestSaunas.length,
                  itemBuilder: (_, i) {
                    final sauna = fnc.nearestSaunas[i];
                    return InkWell(
                      onTap: () {
                        fnc.setSelectedSaunaPlace(sauna);
                        Get.to(const SaunaPlaceDetailsPage());
                      },
                      child: HomeCards(
                        imgLink: getLocationImage(sauna.imgLinks),
                        title: sauna.address ?? 'Unknown address',
                        distance: '${sauna.distance?.toStringAsFixed(1)} km',
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
