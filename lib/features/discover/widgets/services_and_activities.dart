import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/features/add_sauna_place/presentation/add_image_page.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';

class ServicesAndActivities extends StatelessWidget {
  const ServicesAndActivities({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FindNearSaunaController>(builder: (fnc) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //==============================>
        //On Location Services Expandable
        //==============================>
        Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 0),
            title: Text(
              'On Location Services',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down,
                color: Pallete.whiteColor),
            children: [
              gapH(10),
              detailsRowWithPoints(context,
                  details: fnc.selectedSaunaPlace.selectedNearbyService ?? []),
            ],
            onExpansionChanged: (bool expanded) {},
          ),
        ),

        //==============================>
        //Nearby Activities Expandable
        //==============================>
        Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 0),
            title: Text(
              'Nearby Activities',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white),
            ),
            trailing: const Icon(
              Icons.keyboard_arrow_down,
              color: Pallete.whiteColor,
            ),
            children: [
              gapH(10),
              detailsRowWithPoints(context,
                  details:
                      fnc.selectedSaunaPlace.selectedNearbyActivities ?? []),
            ],
            onExpansionChanged: (bool expanded) {},
          ),
        ),
      ]);
    });
  }

  detailsRowWithPoints(BuildContext context,
      {String? title, required List details}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 18.h,
                    ),
              ),
              gapH(20),
            ],
          ),
        for (var v in details) rulesText(context, text: v)
      ],
    );
  }
}
