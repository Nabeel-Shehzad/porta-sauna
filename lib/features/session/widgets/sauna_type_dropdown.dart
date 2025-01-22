import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/features/session/controller/add_session_controller.dart';
import 'package:portasauna/features/session/widgets/sauna_helper.dart';

class SaunaTypeDropdown extends StatelessWidget {
  const SaunaTypeDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddSessionController>(builder: (ac) {
      return Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: addSessionTitle(context,
              title: "Sauna type", icon: Icons.bathtub_outlined),
          trailing: addSessionTrailing(ac.selectedSauna, context),
          children: [
            SizedBox(
              height: 190.h,
              child: CupertinoPicker(
                  magnification: 1.2,
                  itemExtent: 30,
                  scrollController: FixedExtentScrollController(),
                  onSelectedItemChanged: (v) {
                    ac.setSelectedSauna(v);
                  },
                  children: [
                    for (int i = 0; i < ac.saunaTypes.length; i++)
                      Text(ac.saunaTypes[i]),
                  ]),
            )
          ],
          onExpansionChanged: (bool expanded) {},
        ),
      );
    });
  }
}
