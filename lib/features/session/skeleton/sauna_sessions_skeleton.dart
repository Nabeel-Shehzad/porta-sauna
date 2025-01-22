import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portasauna/features/session/widgets/sauna_sessions_common_widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SaunaSessionsSkeleton extends StatelessWidget {
  const SaunaSessionsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20.h),
            child: logRow(context,
                saunatype: "Sauna",
                temperature: "1sdf",
                duration: "1sdf",
                humidity: "1sdf",
                coldShowerPlunge: false,
                aufguss: false,
                heartRate: "1",
                note: "1",
                date: DateTime.now()),
          )
        ],
      ),
    );
  }
}
