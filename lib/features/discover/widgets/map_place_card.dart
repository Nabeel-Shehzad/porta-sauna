// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/text_utils.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/show_image.dart';

class MapPlaceCard extends StatelessWidget {
  const MapPlaceCard({
    super.key,
    required this.imgLink,
    required this.title,
    required this.subTitle,
    required this.cardWidth,
  });

  final String imgLink;
  final String title;
  final String subTitle;
  final cardWidth;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(left: 25.w),
            width: cardWidth,
            height: 250.h,
            decoration: BoxDecoration(
                boxShadow: [bigShadowTwo],
                color: Pallete.whiteColor,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: SizedBox(
                    width: cardWidth,
                    child: ShowImage(
                      imgLocation: imgLink,
                      isAssetImg: false,
                      height: 130.h,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                gapH(2),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.h, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextUtils.small1(
                            context: context,
                            color: Pallete.primarColor,
                            fontSize: 18.h,
                            fontWeight: FontWeight.w600),
                      ),
                      gapH(7),
                      Text(
                        subTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextUtils.small1(
                            context: context,
                            color: Colors.grey[800],
                            fontSize: 14.h),
                      ),
                      gapH(4),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
