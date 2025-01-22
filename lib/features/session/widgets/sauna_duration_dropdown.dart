import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/features/session/controller/add_session_controller.dart';
import 'package:portasauna/features/session/widgets/sauna_helper.dart';

class SaunaDurationDropdown extends StatelessWidget {
  const SaunaDurationDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddSessionController>(builder: (ac) {
      return Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: addSessionTitle(context,
              title: "Duration", icon: Icons.alarm_on_outlined),
          trailing: addSessionTrailing("${ac.selectedDuration} min", context),
          children: [
            SizedBox(
              height: 190.h,
              child: CupertinoPicker(
                magnification: 1.2,
                itemExtent: 30,
                scrollController: FixedExtentScrollController(initialItem: 9),
                onSelectedItemChanged: (v) {
                  ac.setSelectedDuration(v);
                },
                children: [
                  for (int i = 0; i < ac.saunaDurations.length; i++)
                    Text("${ac.saunaDurations[i]} min"),
                ],
              ),
            )
          ],
          onExpansionChanged: (bool expanded) {},
        ),
      );
    });
  }
}
