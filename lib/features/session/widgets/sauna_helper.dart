import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portasauna/core/utils/ui_const.dart';

addSessionTrailing(String data, BuildContext context) {
  return Text(
    data,
    style: Theme.of(context).textTheme.bodySmall,
  );
}

addSessionTitle(BuildContext context, {required IconData icon, title}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        alignment: Alignment.centerLeft,
        width: 35.w,
        child: Icon(
          icon,
          size: 24.h,
          color: Colors.white,
        ),
      ),
      gapW(10),
      Text(
        title,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}
