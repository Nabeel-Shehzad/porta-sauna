import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/features/session/controller/add_session_controller.dart';
import 'package:portasauna/features/session/widgets/sauna_helper.dart';

class SaunaHeartRateDropdown extends StatelessWidget {
  const SaunaHeartRateDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddSessionController>(builder: (ac) {
      return Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: addSessionTitle(context,
              title: "Heart rate", icon: Icons.favorite_outline),
          trailing: addSessionTrailing(ac.selectedHeartRate, context),
          children: [
            SizedBox(
              height: 190.h,
              child: CupertinoPicker(
                  magnification: 1.2,
                  itemExtent: 30,
                  scrollController: FixedExtentScrollController(),
                  onSelectedItemChanged: (v) {
                    ac.setSelectedHeartRate(v);
                  },
                  children: [
                    for (int i = 0; i < ac.saunaHeartRates.length; i++)
                      Text(ac.saunaHeartRates[i]),
                  ]),
            )
          ],
          onExpansionChanged: (bool expanded) {},
        ),
      );
    });
  }
}
