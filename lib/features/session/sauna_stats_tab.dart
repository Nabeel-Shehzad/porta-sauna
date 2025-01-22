import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/features/auth/controller/profile_controller.dart';
import 'package:portasauna/features/auth/presentation/login_page.dart';
import 'package:portasauna/features/session/controller/fetch_sauna_session_controller.dart';
import 'package:portasauna/features/session/skeleton/stats_tab_skeleton.dart';

class SaunaStatsTab extends StatefulWidget {
  const SaunaStatsTab({super.key});

  @override
  State<SaunaStatsTab> createState() => _SaunaLogPageState();
}

class _SaunaLogPageState extends State<SaunaStatsTab> {
  final pc = Get.find<ProfileController>();

  @override
  void initState() {
    if (pc.isLoggedIn) {
      Get.find<FetchSaunaSessionController>()
          .fetchAllSessions(context: context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FetchSaunaSessionController>(builder: (fsc) {
      return pc.isLoggedIn
          ? fsc.isLoading
              ? const StatsTabSkeleton()
              : Container(
                  padding: screenPaddingH,
                  child: Column(
                    children: [
                      gapH(30),
                      Container(
                        height: 220.h,
                        width: 220.h,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Pallete.primarColor, width: 30.h),
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
                              '${fsc.totalSessions}',
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
                      statsRow(context,
                          title: 'Total sessions',
                          result: '${fsc.totalSessions}'),
                      statsRow(context,
                          title: 'Total Aufgusse', result: fsc.totalAufguss),
                      statsRow(context,
                          title: 'Total Cold Showers / Plunges',
                          result: fsc.totalColdShowerPlunge),
                      statsRow(context,
                          title: 'Total Duration', result: fsc.totalDuration),
                      statsRow(context,
                          title: 'Average Duration', result: fsc.avgHeartRate),
                      statsRow(context,
                          title: 'Average Temperature',
                          result: '${fsc.avgTemperature}°c'),
                      statsRow(context,
                          title: 'Average Humidity',
                          result: '${fsc.avgHumidity}%'),
                      statsRow(context,
                          title: 'Average Heart Rate',
                          result: '${fsc.avgHeartRate} bpm'),
                      statsRow(context,
                          title: 'Average Sessions / Week',
                          result: fsc.avgSessionWeek),
                      statsRow(context,
                          title: 'Average Sessions / Month',
                          result: fsc.avgSessionMonth),
                      // statsRow(context,title: 'Avg. Break Between Sessions', result: '0 min'),
                      gapH(85),
                    ],
                  ),
                )
          : Container(
              alignment: Alignment.center,
              height: Get.height / 1.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login to track your stats',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  gapH(25),
                  ButtonPrimary(
                    text: 'Login',
                    width: 200.w,
                    bgColor: Pallete.primarColor,
                    onPressed: () {
                      Get.to(const LoginPage());
                    },
                  )
                ],
              ),
            );
    });
  }
}

statsRow(BuildContext context, {required title, required result}) {
  return Column(
    children: [
      gapH(15),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontSize: 16.h),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  result,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 17.h),
                ),
              ],
            ),
          ),
        ],
      ),
      gapH(15),
      const Divider()
    ],
  );
}
