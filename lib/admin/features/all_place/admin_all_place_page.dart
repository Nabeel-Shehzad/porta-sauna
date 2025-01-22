import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/admin/features/all_place/admin_place_details_page.dart';
import 'package:portasauna/admin/features/edit_place/controller/admin_pending_place_controller.dart';
import 'package:portasauna/core/utils/helper.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/admin/features/all_place/components/admin_place_list_item.dart';
import 'package:portasauna/admin/features/all_place/components/admin_place_search_bar.dart';
import 'package:portasauna/admin/features/all_place/controller/admin_all_place_controller.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';

class AdminAllPlacePage extends StatefulWidget {
  const AdminAllPlacePage({super.key});

  @override
  State<AdminAllPlacePage> createState() => _AdminAllPlacePageState();
}

class _AdminAllPlacePageState extends State<AdminAllPlacePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AdminAllPlaceController>().getAllPlaces(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminAllPlaceController>(builder: (allPc) {
      return Scaffold(
        appBar: appbarCommon('All places', context),
        body: SingleChildScrollView(
          child: Container(
            padding: screenPaddingH,
            child: Column(
              children: [
                //=================================
                // search bar
                //=================================
                const AdminPlaceSearchBar(),
                gapH(30),

                //=================================
                // All place / Search result
                //=================================
                allPc.isLoading
                    ? const CircularProgressIndicator()
                    : ListView.builder(
                        itemCount: allPc.allPlaces.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) => AdminPlaceListItem(
                              address: allPc.allPlaces[i].address ?? '-',
                              description:
                                  allPc.allPlaces[i].description ?? '-',
                              image:
                                  getLocationImage(allPc.allPlaces[i].imgLinks),
                              onTap: () {
                                final apc =
                                    Get.find<AdminPendingPlaceController>();
                                final fnc = Get.find<FindNearSaunaController>();

                                apc.setSelectedSaunaPlace(allPc.allPlaces[i]);
                                fnc.setSelectedSaunaPlace(allPc.allPlaces[i]);
                                Get.to(const AdminPlaceDetailsPage(
                                  hideAcceptButton: true,
                                ));
                              },
                            ))
              ],
            ),
          ),
        ),
      );
    });
  }
}
