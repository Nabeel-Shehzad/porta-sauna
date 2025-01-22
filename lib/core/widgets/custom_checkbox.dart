import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.onChanged,
    required this.isChecked,
    required this.text,
  });

  final Function(bool?)? onChanged;
  final bool isChecked;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 1.2.h,
            child: Checkbox(
              value: isChecked,
              onChanged: onChanged,
              activeColor: Pallete.primarColor,
            ),
          ),
          gapW(5),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}
