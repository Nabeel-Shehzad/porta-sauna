import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/helper.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/features/session/controller/fetch_sauna_session_controller.dart';
import 'package:portasauna/features/session/skeleton/sauna_sessions_skeleton.dart';
import 'package:portasauna/features/session/widgets/sauna_sessions_common_widgets.dart';

class SaunaSessionTab extends StatefulWidget {
  const SaunaSessionTab({super.key});

  @override
  State<SaunaSessionTab> createState() => _SaunaSessionTabState();
}

class _SaunaSessionTabState extends State<SaunaSessionTab> {
  final EasyInfiniteDateTimelineController _controller =
      EasyInfiniteDateTimelineController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FetchSaunaSessionController>(builder: (fsc) {
      return Column(
        children: [
          gapH(20),

          EasyInfiniteDateTimeLine(
            showTimelineHeader: false,
            dayProps: EasyDayProps(
                borderColor: Colors.transparent,
                todayStyle: DayStyle(
                    dayNumStyle: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontSize: 22.h, color: Pallete.primarColor)),
                inactiveDayStyle: const DayStyle(
                    monthStrStyle: TextStyle(color: Colors.grey),
                    dayNumStyle: TextStyle(color: Colors.grey)),
                activeDayStyle: DayStyle(
                    monthStrStyle: const TextStyle(color: Colors.white),
                    dayNumStyle: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontSize: 22.h))),
            controller: _controller,
            firstDate: DateTime(2024, 10, 10),
            focusDate: fsc.selectedDate,
            lastDate: DateTime.now(),
            activeColor: Pallete.buttonBgColor,
            onDateChange: (selectedDate) {
              fsc.setSelectedDate(selectedDate);
              fsc.fetchSessions(context: context);
            },
          ),

          gapH(40),

          //Session
          Container(
            color: Pallete.greyHightlightColor,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getMonthYearFromDate(fsc.selectedDate),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 17.h),
                ),
                Text(
                  '${fsc.sessions.length} Session(s)',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 17.h),
                ),
              ],
            ),
          ),

          //=============>
          //Records
          //=============>

          gapH(30),

          fsc.isLoading
              ? const SaunaSessionsSkeleton()
              : fsc.sessions.isEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 30.h),
                      child: Text(
                        'No Session Found',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 17.h,
                            ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: fsc.sessions.length,
                      itemBuilder: (_, i) {
                        return Container(
                            padding: screenPaddingH,
                            margin: EdgeInsets.only(bottom: 20.h),
                            child: logRow(context,
                                saunatype: fsc.sessions[i].saunaType,
                                temperature: fsc.sessions[i].temperature,
                                duration: fsc.sessions[i].duration,
                                humidity: fsc.sessions[i].humidity,
                                coldShowerPlunge:
                                    fsc.sessions[i].coldShowerPlunge,
                                aufguss: fsc.sessions[i].aufguss,
                                heartRate: fsc.sessions[i].heartRate,
                                note: fsc.sessions[i].note,
                                date: fsc.sessions[i].date));
                      }),
        ],
      );
    });
  }
}
