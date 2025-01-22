import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/widgets/custom_input.dart';
import 'package:portasauna/admin/features/all_place/controller/admin_all_place_controller.dart';

class AdminPlaceSearchBar extends StatelessWidget {
  const AdminPlaceSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminAllPlaceController>(builder: (allpc) {
      return Column(
        children: [
          //=================================
          // search bar
          //=================================
          Container(
            color: Colors.grey.withOpacity(.2),
            child: CustomInput(
              onChanged: (v) {
                if (v.isEmpty) {
                  allpc.getAllPlaces(context);
                }
                allpc.searchLocation(context);
              },
              hintText: 'Search sauna by location',
              controller: allpc.searchController,
              suffixIcon: Icons.clear,
              onSuffixTap: () {
                allpc.searchController.clear();
                allpc.getAllPlaces(context);
              },
              borderBottom: InputBorder.none,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontSize: 16.h, color: Pallete.hintGreyColor),
            ),
          ),
        ],
      );
    });
  }
}
