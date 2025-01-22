import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/features/session/controller/add_session_controller.dart';
import 'package:portasauna/features/session/widgets/sauna_helper.dart';

class SaunaTempDropdown extends StatelessWidget {
  const SaunaTempDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddSessionController>(builder: (ac) {
      return Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: addSessionTitle(context,
              title: "Temperature", icon: Icons.thermostat),
          trailing: addSessionTrailing("${ac.selectedTemp} °C", context),
          children: [
            SizedBox(
              height: 190.h,
              child: CupertinoPicker(
                  magnification: 1.2,
                  itemExtent: 30,
                  scrollController: FixedExtentScrollController(initialItem: 6),
                  onSelectedItemChanged: (v) {
                    ac.setSelectedTemp(v);
                  },
                  children: [
                    for (int i = 0; i < ac.saunaTemps.length; i++)
                      Text("${ac.saunaTemps[i]} °C"),
                  ]),
            )
          ],
          onExpansionChanged: (bool expanded) {},
        ),
      );
    });
  }
}
