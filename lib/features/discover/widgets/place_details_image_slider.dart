import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portasauna/core/constants/assets_const.dart';
import 'package:portasauna/core/widgets/show_image.dart';

class PlaceDetailsImageSlider extends StatelessWidget {
  const PlaceDetailsImageSlider({
    super.key,
    required this.imageList,
  });

  final List imageList;

  @override
  Widget build(BuildContext context) {
    return imageList.isEmpty
        ? Container()
        : CarouselSlider.builder(
            options: CarouselOptions(
              autoPlay: imageList.length == 1 ? false : true,
              enlargeCenterPage: true,
              viewportFraction: 1,
              aspectRatio: 1.7,
              initialPage: 2,
            ),
            itemCount: imageList.length,
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) =>
                    ShowImage(
              imgLocation: imageList[itemIndex] ?? defaultNatureImage,
              isAssetImg: false,
              height: 280.h,
              width: double.infinity,
              fit: BoxFit.cover,
              radius: 10.sp,
            ),
          );
  }
}
