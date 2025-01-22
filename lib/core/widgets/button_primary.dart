import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portasauna/core/theme/pallete.dart';

class ButtonPrimary extends StatelessWidget {
  const ButtonPrimary(
      {super.key,
      this.paddingVertical,
      this.bgColor,
      required this.text,
      required this.onPressed,
      this.borderRadius,
      this.width,
      this.borderColor,
      this.textColor,
      this.textStyle});

  final double? paddingVertical;
  final Color? bgColor;
  final String text;
  final VoidCallback onPressed;
  final double? borderRadius;
  final double? width;
  final TextStyle? textStyle;
  final Color? borderColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
          width: width ?? double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: paddingVertical ?? 15.h),
          decoration: BoxDecoration(
              color: bgColor ?? Pallete.buttonBgColor,
              border: Border.all(color: borderColor ?? Colors.transparent),
              borderRadius:
                  BorderRadius.all(Radius.circular(borderRadius ?? 8))),
          child: Text(
            text,
            style: textStyle ??
                Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18.sp),
            textAlign: TextAlign.center,
          )),
    );
  }
}
