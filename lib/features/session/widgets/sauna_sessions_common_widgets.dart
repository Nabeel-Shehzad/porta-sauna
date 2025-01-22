import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portasauna/core/utils/helper.dart';
import 'package:portasauna/core/utils/ui_const.dart';

Container logRow(
  BuildContext context, {
  String? saunatype,
  String? temperature,
  String? duration,
  String? humidity,
  bool? coldShowerPlunge,
  bool? aufguss,
  String? heartRate,
  String? note,
  DateTime? date,
}) {
  return Container(
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              saunatype ?? '',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontSize: 17.h),
            ),
            Text(
              formatDate(date) ?? '',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontSize: 17.h),
            ),
          ],
        ),
        gapH(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            logInformations(context, bigText: '$temperature', smallText: '°c'),
            logInformations(context, bigText: '$humidity', smallText: '%'),
            logInformations(context, bigText: '$duration', smallText: 'min'),
          ],
        ),
        gapH(20),
        const Divider()
      ],
    ),
  );
}

RichText logInformations(BuildContext context,
    {required bigText, required smallText}) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: bigText,
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(fontWeight: FontWeight.normal, fontSize: 40.h),
        ),
        TextSpan(
          text: ' $smallText',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFeatures: [
            const FontFeature.subscripts(),
          ], fontSize: 17.h),
        ),
      ],
    ),
  );
}
