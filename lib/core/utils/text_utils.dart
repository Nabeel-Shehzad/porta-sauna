import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portasauna/core/theme/pallete.dart';

class TextUtils {
  static TextStyle? small1({
    Color? color,
    required BuildContext context,
    FontWeight? fontWeight,
    double? fontSize,
    TextDecoration? decoration = TextDecoration.none,
  }) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(
        fontSize: fontSize ?? 17.h,
        fontWeight: fontWeight ?? FontWeight.normal,
        decoration: decoration,
        color: color ?? Pallete.whiteColor);
  }

  static TextStyle? title1(
      {color, required BuildContext context, fontWeight, fontSize}) {
    return Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontSize: fontSize ?? 22.h,
        );
  }

  static TextStyle? inputLabel(
      {color, required BuildContext context, fontWeight}) {
    return Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontSize: 18.h,
        );
  }

  static TextStyle? inputHintStyle(
      {color, required BuildContext context, fontWeight}) {
    return Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(fontSize: 16.h, color: Pallete.hintGreyColor);
  }
}
