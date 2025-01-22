import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/custom_input.dart';
import 'package:portasauna/core/widgets/loader_widget.dart';
import 'package:portasauna/features/discover/controller/rating_controller.dart';

class GiveRatingPopupContent extends StatelessWidget {
  const GiveRatingPopupContent({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RatingController>(builder: (rc) {
      return LoaderWidget(
        isLoading: rc.isloading,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 13.h),
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RatingBar.builder(
                initialRating: 5,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  rc.setRating(rating.round());
                },
              ),
              gapH(30),
              Container(
                color: Colors.grey.withOpacity(.2),
                child: CustomInput(
                  hintText: 'Write feedback',
                  maxLines: 5,
                  controller: rc.feedbackController,
                  borderBottom: InputBorder.none,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 16.h, color: Pallete.hintGreyColor),
                ),
              ),
              gapH(30),
              ButtonPrimary(
                  text: 'Save',
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  bgColor: Pallete.primarColor,
                  onPressed: () {
                    rc.leaveRating(context);
                  }),
              gapH(15),
              ButtonPrimary(
                  text: 'Cancel',
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  onPressed: () {
                    Get.back();
                  }),
            ],
          ),
        ),
      );
    });
  }
}
