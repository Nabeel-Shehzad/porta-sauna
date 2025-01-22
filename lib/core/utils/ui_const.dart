import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

var screenPaddingH = EdgeInsets.symmetric(horizontal: 18.w);

gapH(double v) => SizedBox(height: v.h);
gapW(double v) => SizedBox(width: v.h);

BorderRadius radius(double number) =>
    BorderRadius.circular(Get.width * number / 100);

BorderRadius radiusTop(double number) {
  return BorderRadius.only(
      topLeft: Radius.circular(Get.width * number / 100),
      topRight: Radius.circular(Get.width * number / 100));
}

BorderRadius radiusLeft(double number) {
  return BorderRadius.only(
      topLeft: Radius.circular(Get.width * number / 100),
      bottomLeft: Radius.circular(Get.width * number / 100));
}

BorderRadius radiusRight(double number) {
  return BorderRadius.only(
      bottomRight: Radius.circular(Get.width * number / 100),
      topRight: Radius.circular(Get.width * number / 100));
}

BorderRadius radiusBottom(double number) {
  return BorderRadius.only(
      bottomLeft: Radius.circular(Get.width * number / 100),
      bottomRight: Radius.circular(Get.width * number / 100));
}

final smallShadow = BoxShadow(
  color: Colors.grey.withOpacity(0.15),
  spreadRadius: 0,
  blurRadius: 2.sp,
  offset: const Offset(0, 2), // changes position of shadow
);

final bigShadow = BoxShadow(
    color: Colors.black.withOpacity(.1),
    spreadRadius: 0,
    blurRadius: 25.sp,
    offset: const Offset(0, 10));

final bigShadowTwo = BoxShadow(
    color: Colors.black.withOpacity(.2),
    spreadRadius: 0,
    blurRadius: 25.sp,
    offset: const Offset(0, 10));
