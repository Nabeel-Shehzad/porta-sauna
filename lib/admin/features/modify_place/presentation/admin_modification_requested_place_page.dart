import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/admin/features/modify_place/presentation/admin_mod_req_place_details_page.dart';
import 'package:portasauna/core/utils/helper.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/admin/features/all_place/components/admin_place_list_item.dart';
import 'package:portasauna/admin/features/modify_place/controller/admin_modification_requested_controller.dart';

class AdminModificationRequestedPlacePage extends StatefulWidget {
  const AdminModificationRequestedPlacePage({super.key});

  @override
  State<AdminModificationRequestedPlacePage> createState() =>
      _AdminModificationRequestedPlacePageState();
}

class _AdminModificationRequestedPlacePageState
    extends State<AdminModificationRequestedPlacePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AdminModificationRequestedController>().getModReqPlaces(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminModificationRequestedController>(builder: (mrc) {
      return Scaffold(
        appBar: appbarCommon('Modification requested places', context),
        body: SingleChildScrollView(
          child: Container(
            padding: screenPaddingH,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!mrc.isLoading && mrc.modReqPlaceData.isEmpty)
                  Container(
                    alignment: Alignment.center,
                    height: Get.height / 1.3,
                    child: const Text(
                      'No modification request found',
                    ),
                  ),
                //=================================
                // Modification Requested place
                //=================================
                mrc.isLoading
                    ? Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 20.h),
                        child: const CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: mrc.modReqPlaceData.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) => AdminPlaceListItem(
                          address:
                              "Place id: ${mrc.modReqPlaceData[i].placeId}",
                          description: mrc.modReqPlaceData[i].description ?? '',
                          image:
                              getLocationImage(mrc.modReqPlaceData[i].imgLinks),
                          onTap: () {
                            mrc.setSelectedModReqPlaceIndex(i);
                            mrc.getDetailsOfSelectedPlaces(context,
                                placeId: mrc.modReqPlaceData[i].placeId);
                            mrc.getUserDetailsOfSelectedUser(context,
                                userId: mrc.modReqPlaceData[i].userId);

                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              Get.to(const AdminModReqPlaceDetailsPage());
                            });
                          },
                        ),
                      )
              ],
            ),
          ),
        ),
      );
    });
  }
}
