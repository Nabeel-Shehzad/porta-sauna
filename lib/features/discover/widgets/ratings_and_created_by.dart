import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/helper.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/features/discover/controller/place_added_by_user_controller.dart';
import 'package:portasauna/features/discover/controller/rating_controller.dart';
import 'package:portasauna/features/discover/presentation/place_added_by_an_user_on_map_page.dart';
import 'package:portasauna/features/discover/widgets/rating_modal_content.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';

class RatingsAndCreatedBy extends StatefulWidget {
  const RatingsAndCreatedBy({
    super.key,
  });

  @override
  State<RatingsAndCreatedBy> createState() => _RatingsAndCreatedByState();
}

class _RatingsAndCreatedByState extends State<RatingsAndCreatedBy> {
  final fnc = Get.find<FindNearSaunaController>();
  final pac = Get.find<PlaceAddedByUserController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<RatingController>()
          .fetchRatings(context, locationId: fnc.selectedSaunaPlace.id);

      pac.getUserDetailsOfSelectedUser(context,
          userId: fnc.selectedSaunaPlace.userId);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RatingController>(builder: (rc) {
      return Column(
        children: [
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //===================>
              //Ratings
              //===================>
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      enableDrag: false,
                      isScrollControlled: true,
                      builder: (context) {
                        return const RatingModalContent();
                      });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 22.h),
                  child: Row(
                    children: [
                      for (int i = 0; i < 5; i++)
                        Icon(
                          i >= rc.averageRating
                              ? Icons.star_border
                              : Icons.star,
                          color: i >= rc.averageRating
                              ? Colors.grey
                              : Pallete.yellowColor,
                          size: 23.sp,
                        ),
                      gapW(9),
                      rc.isloading
                          ? SizedBox(
                              height: 15.h,
                              width: 15.h,
                              child: const CircularProgressIndicator(),
                            )
                          : Text(
                              '${rc.averageRating}/5',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontSize: 17.h),
                            ),
                    ],
                  ),
                ),
              ),
              //===================>
              //Created by
              //===================>
              InkWell(
                onTap: () {
                  if (pac.mapPageInStack > 0) {
                    Get.back();
                    return;
                  }
                  Get.to(const PlaceAddedByAnUserOnMapPage());
                  pac.setPlaceRatingUserDetailsToTemp();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Created on ${formatDate(fnc.selectedSaunaPlace.createdAt)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 13.5.h, fontWeight: FontWeight.w400),
                    ),
                    gapH(4),
                    Text(
                      'by ${pac.selectedUserDetails?.name ?? '-'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 13.5.h,
                          fontWeight: FontWeight.w600,
                          color: Pallete.primarColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      );
    });
  }
}
