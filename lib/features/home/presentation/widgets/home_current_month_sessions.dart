import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/helper.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/features/auth/controller/profile_controller.dart';
import 'package:portasauna/features/home/controller/landing_controller.dart';
import 'package:portasauna/features/session/controller/fetch_sauna_session_controller.dart';
import 'package:portasauna/features/session/skeleton/sauna_sessions_skeleton.dart';
import 'package:portasauna/features/session/widgets/sauna_sessions_common_widgets.dart';

class HomeCurrentMonthSessions extends StatefulWidget {
  const HomeCurrentMonthSessions({
    super.key,
  });

  @override
  State<HomeCurrentMonthSessions> createState() =>
      _HomeCurrentMonthSessionsState();
}

class _HomeCurrentMonthSessionsState extends State<HomeCurrentMonthSessions> {
  final lc = Get.find<LandingController>();
  final pc = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FetchSaunaSessionController>(builder: (fsc) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your ${getMonthNameFromDate(DateTime.now())} Saunas',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 22.h,
                    ),
              ),
              IconButton(
                  onPressed: () {
                    lc.setSelectedIndex(1);
                    // Get.to(const AddSaunaSessionPage());
                  },
                  icon: Icon(
                    Icons.add_circle,
                    size: 35.sp,
                    color: Pallete.primarColor,
                  ))
            ],
          ),
          gapH(28),
          fsc.isLoading
              ? const SaunaSessionsSkeleton()
              : fsc.currentMonthSessions.isEmpty || !pc.isLoggedIn
                  ? Container(
                      margin: EdgeInsets.only(top: 5.h, bottom: 30.h),
                      child: Text(
                        !pc.isLoggedIn
                            ? "Login to track your sessions"
                            : 'No Session Found',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 17.h,
                            ),
                      ),
                    )
                  : Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: fsc.currentMonthSessions.length,
                            itemBuilder: (_, i) {
                              return Container(
                                  margin: EdgeInsets.only(
                                      bottom: i == 1 ? 0 : 16.h),
                                  child: logRow(context,
                                      saunatype:
                                          fsc.currentMonthSessions[i].saunaType,
                                      temperature: fsc
                                          .currentMonthSessions[i].temperature,
                                      duration:
                                          fsc.currentMonthSessions[i].duration,
                                      humidity:
                                          fsc.currentMonthSessions[i].humidity,
                                      coldShowerPlunge: fsc
                                          .currentMonthSessions[i]
                                          .coldShowerPlunge,
                                      aufguss:
                                          fsc.currentMonthSessions[i].aufguss,
                                      heartRate:
                                          fsc.currentMonthSessions[i].heartRate,
                                      note: fsc.currentMonthSessions[i].note,
                                      date: fsc.currentMonthSessions[i].date));
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                lc.setSelectedIndex(1);
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 20.w, top: 10.h, bottom: 10.h),
                                child: Text('See more',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: Pallete.primarColor,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
        ],
      );
    });
  }
}
