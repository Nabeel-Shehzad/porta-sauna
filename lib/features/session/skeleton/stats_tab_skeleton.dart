import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/features/session/sauna_stats_tab.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StatsTabSkeleton extends StatelessWidget {
  const StatsTabSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Column(
        children: [
          gapH(30),
          Container(
            height: 220.h,
            width: 220.h,
            decoration: BoxDecoration(
                border: Border.all(color: Pallete.primarColor, width: 30.h),
                shape: BoxShape.circle),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 15.h),
                ),
                Text(
                  '3',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  'Sessions',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 15.h),
                ),
              ],
            ),
          ),
          gapH(30),
          statsRow(context, title: 'Total sessions', result: '3'),
          statsRow(context, title: 'Total Aufgusse', result: '0'),
          statsRow(context, title: 'Total Cold Showers / Plunges', result: '0'),
          statsRow(context, title: 'Total Duration', result: '4 hours, 38 min'),
          statsRow(context,
              title: 'Average Duration', result: '1 hour, 32 min'),
          statsRow(context, title: 'Average Temperature', result: '75°c'),
          statsRow(context, title: 'Average Humidity', result: '40%'),
          statsRow(context, title: 'Average Heart Rate', result: '40'),
          statsRow(context, title: 'Average Sessions / Week', result: '2'),
          statsRow(context, title: 'Average Sessions / Month', result: '3'),
          statsRow(context,
              title: 'Avg. Break Between Sessions', result: '0 min'),
          gapH(85),
        ],
      ),
    );
  }
}
