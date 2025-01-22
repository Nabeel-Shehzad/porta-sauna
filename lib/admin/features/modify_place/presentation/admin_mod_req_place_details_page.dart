// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/admin/features/modify_place/controller/admin_modification_requested_controller.dart';
import 'package:portasauna/admin/features/modify_place/presentation/component/admin_description_expandable_section.dart';
import 'package:portasauna/admin/features/modify_place/presentation/component/admin_image_req_expandable.dart';
import 'package:portasauna/admin/features/modify_place/presentation/component/admin_services_and_activities_expandable.dart';
import 'package:portasauna/admin/widgets/widget_helper.dart';
import 'package:portasauna/core/constants/assets_const.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/text_utils.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/loader_widget.dart';
import 'package:portasauna/admin/features/edit_place/controller/admin_pending_place_controller.dart';
import 'package:portasauna/admin/features/all_place/components/admin_place_details_user_info.dart';
import 'package:portasauna/admin/features/all_place/components/admin_place_details_helper.dart';
import 'package:portasauna/features/discover/widgets/place_details_image_slider.dart';

class AdminModReqPlaceDetailsPage extends StatefulWidget {
  const AdminModReqPlaceDetailsPage({super.key});

  @override
  State<AdminModReqPlaceDetailsPage> createState() =>
      _AdminModReqPlaceDetailsPageState();
}

class _AdminModReqPlaceDetailsPageState
    extends State<AdminModReqPlaceDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminModificationRequestedController>(builder: (mrc) {
      return LoaderWidget(
        isLoading: mrc.isLoading,
        child: Scaffold(
          appBar: appbarCommon('', context),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //====================>
                //User who added this
                //====================>
                if (mrc.selectedUserDetails != null)
                  Container(
                    padding: screenPaddingH,
                    child: AdminPlaceDetailsUserInfo(
                      profileImageUrl: mrc.selectedUserDetails?.profileImg ??
                          defaultUserImage,
                      name: mrc.selectedUserDetails?.name ?? '',
                      email: mrc.selectedUserDetails?.email ?? '',
                    ),
                  ),

                gapH(15),

                //=============>
                //ADdress
                //=============>
                gapH(30),
                Container(
                  padding: screenPaddingH,
                  child: Text(
                    mrc.selectedSaunaPlace.address ?? '',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 22.h,
                        ),
                  ),
                ),
                gapH(20),
                const AdminImageReqExpandable(),
                gapH(20),

                const AdminServicesAndActivitiesExpandable(),

                //===========================>
                //Place Description
                //===========================>
                gapH(20),
                const AdminDescriptionExpandableSection(),

                gapH(40),

                //===========================>
                //Approve reject buttons
                //===========================>

                Container(
                  padding: screenPaddingH,
                  child: Column(
                    children: [
                      ButtonPrimary(
                          text: 'Accept',
                          onPressed: () {
                            mrc.approveModReqPlace(context);
                          }),

                      //
                      gapH(15),
                      //
                      ButtonPrimary(
                          text: 'Delete',
                          bgColor: Colors.red[800],
                          onPressed: () {
                            Get.defaultDialog(
                                backgroundColor: Colors.grey[900],
                                title: '',
                                content: deletePlacePopup(
                                  context: context,
                                  onTap: () {
                                    mrc.deleteModReqPlace(
                                      context,
                                    );
                                    Get.back();
                                  },
                                ));
                          })
                    ],
                  ),
                ),

                gapH(60),
              ],
            ),
          ),
        ),
      );
    });
  }
}
