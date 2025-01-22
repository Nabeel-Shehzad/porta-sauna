import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/show_image.dart';

class HomeCards extends StatelessWidget {
  const HomeCards({
    super.key,
    required this.imgLink,
    required this.title,
  });

  final String imgLink;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 25.w),
      child: Stack(
        children: [
          SizedBox(
            width: 240.w,
            child: ShowImage(
              imgLocation: imgLink,
              isAssetImg: false,
              radius: 10.sp,
              height: 290.h,
              width: double.infinity,
            ),
          ),
          gapH(12),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 20.h),
              color: Colors.black.withOpacity(.5),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontSize: 17.h),
              ),
            ),
          )
        ],
      ),
    );
  }
}
