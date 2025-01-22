import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/utils/helper.dart';
import 'package:portasauna/core/utils/text_utils.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/loader_widget.dart';
import 'package:portasauna/admin/admin_drawer_page.dart';
import 'package:portasauna/admin/features/all_place/admin_place_details_page.dart';
import 'package:portasauna/admin/features/edit_place/controller/admin_pending_place_controller.dart';
import 'package:portasauna/admin/features/all_place/components/admin_place_list_item.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({super.key});

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AdminPendingPlaceController>().getPendingPlaces(context);
    });
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminPendingPlaceController>(builder: (apc) {
      return LoaderWidget(
        isLoading: apc.isLoading,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const AdminDrawerPage(),
          body: SafeArea(
            child: Container(
              padding: screenPaddingH,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Drawer icon
                    //==================>
                    InkWell(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: 35.w, top: 10.h, bottom: 15.h),
                          child: Icon(
                            Icons.menu,
                            size: Get.width * 0.07,
                          ),
                        )),

                    gapH(10),
                    Text(
                      'Pending places',
                      style: TextUtils.title1(context: context),
                    ),
                    gapH(20),

                    //====================>
                    // Pending places
                    //====================>

                    if (!apc.isLoading && apc.pendingLocations.isEmpty)
                      Text(
                        'No pending place found',
                        style: TextUtils.small1(context: context),
                      ),

                    ListView.builder(
                        itemCount: apc.pendingLocations.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) => AdminPlaceListItem(
                              address: apc.pendingLocations[i].address ?? '-',
                              description:
                                  apc.pendingLocations[i].description ?? '',
                              image: getLocationImage(
                                  apc.pendingLocations[i].imgLinks),
                              onTap: () {
                                final fnc = Get.find<FindNearSaunaController>();

                                apc.setSelectedSaunaPlace(
                                    apc.pendingLocations[i]);

                                fnc.setSelectedSaunaPlace(
                                    apc.pendingLocations[i]);

                                Get.to(const AdminPlaceDetailsPage());
                              },
                            ))
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
