// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/constants/assets_const.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/helper.dart';
import 'package:portasauna/core/utils/text_utils.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/loader_widget.dart';
import 'package:portasauna/core/widgets/show_image.dart';
import 'package:portasauna/features/discover/controller/rating_controller.dart';
import 'package:portasauna/features/discover/widgets/give_rating_popup_content.dart';

class RatingModalContent extends StatelessWidget {
  const RatingModalContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RatingController>(builder: (rc) {
      return Container(
        height: 650.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        color: Pallete.backgroundColor,
        child: LoaderWidget(
          isLoading: rc.isloading,
          child: Column(
            children: [
              //===================>
              //Your feedback
              //===================>
              InkWell(
                onTap: () {
                  Get.defaultDialog(
                      backgroundColor: Colors.grey[900],
                      title: '',
                      content: const GiveRatingPopupContent());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Add a feedback to help others',
                        style:
                            TextUtils.title1(context: context, fontSize: 20.h),
                      ),
                      gapH(8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < 5; i++)
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Icon(Icons.star,
                                    size: 28.h, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),

              rc.ratingsList.isEmpty && !rc.isloading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        gapH(80),
                        Icon(
                          Icons.star_outline,
                          size: 30.sp,
                          color: Colors.grey,
                        ),
                        gapH(10),
                        Text('No ratings found',
                            style: TextUtils.small1(context: context)),
                      ],
                    )
                  :
                  //===================>
                  //Ratings & feedbacks
                  //===================>
                  Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            gapH(20),
                            ListView.builder(
                                itemCount: rc.ratingsList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (_, i) {
                                  return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //===================>
                                        //profile image and name
                                        //===================>
                                        Row(
                                          children: [
                                            ShowImage(
                                              imgLocation: rc.ratedUsersList[i]
                                                      .profileImg ??
                                                  defaultUserImage,
                                              isAssetImg: false,
                                              height: 40.sp,
                                              width: 40.sp,
                                              radius: 100,
                                            ),
                                            gapW(10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${rc.ratedUsersList[i].name}',
                                                  style: TextUtils.title1(
                                                      context: context,
                                                      fontSize: 16.sp),
                                                ),
                                                gapH(5),
                                                Text(
                                                  '${formatDate(rc.ratingsList[i].createdAt)}',
                                                  style: TextUtils.small1(
                                                      context: context,
                                                      fontSize: 14.h),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        //===================>
                                        //Stars
                                        //===================>
                                        gapH(13),
                                        Row(
                                          children: [
                                            for (int r = 0; r < 5; r++)
                                              Icon(
                                                r >= rc.ratingsList[i].rating
                                                    ? Icons.star_border
                                                    : Icons.star,
                                                color: r >=
                                                        rc.ratingsList[i].rating
                                                    ? Colors.grey
                                                    : Pallete.yellowColor,
                                                size: 23.sp,
                                              ),
                                            gapW(9),
                                            Text(
                                              '${rc.ratingsList[i].rating}/5',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(fontSize: 17.h),
                                            ),
                                          ],
                                        ),
                                        //===================>
                                        //Feedback
                                        //===================>
                                        gapH(11),
                                        Text(
                                          rc.ratingsList[i].feedback,
                                          style: TextUtils.small1(
                                              context: context,
                                              fontSize: 16.sp),
                                        ),

                                        gapH(20),
                                        const Divider(),
                                        gapH(20)
                                      ]);
                                })
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }
}
