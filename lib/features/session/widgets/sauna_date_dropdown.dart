import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/utils/helper.dart';
import 'package:portasauna/features/session/controller/add_session_controller.dart';
import 'package:portasauna/features/session/widgets/sauna_helper.dart';

class SaunaDateDropdown extends StatelessWidget {
  const SaunaDateDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddSessionController>(builder: (ac) {
      return Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: addSessionTitle(context,
              title: "Date", icon: Icons.calendar_month_outlined),
          trailing: addSessionTrailing(formatDate(ac.date), context),
          children: [
            SizedBox(
              height: 190.h,
              child: CupertinoDatePicker(
                initialDateTime: DateTime.now(),
                mode: CupertinoDatePickerMode.date,
                use24hFormat: false,
                // This shows day of week alongside day of month
                showDayOfWeek: true,

                // This is called when the user changes the date.
                onDateTimeChanged: (DateTime newDate) {
                  ac.setDate(newDate);
                },
              ),
            )
          ],
          onExpansionChanged: (bool expanded) {},
        ),
      );
    });
  }
}
