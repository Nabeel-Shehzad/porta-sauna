import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/features/add_sauna_place/presentation/add_image_page.dart';

detailsRow(BuildContext context,
    {required String title, required String details, bool showTitle = true}) {
  return Container(
    margin: EdgeInsets.only(bottom: 25.h),
    alignment: Alignment.centerLeft,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle)
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 18.h,
                ),
          ),
        gapH(10),
        Text(
          details,
          textAlign: TextAlign.left,
          style:
              Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 17.h),
        ),
      ],
    ),
  );
}

detailsRowWithPoints(BuildContext context,
    {String? title, required List details}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title != null)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 18.h,
                  ),
            ),
            gapH(20),
          ],
        ),
      for (var v in details) rulesText(context, text: v)
    ],
  );
}
