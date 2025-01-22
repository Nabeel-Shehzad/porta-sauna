// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:portasauna/core/constants/assets_const.dart';
import 'package:portasauna/core/utils/text_utils.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/loader_widget.dart';
import 'package:portasauna/admin/features/edit_place/controller/admin_edit_place_controller.dart';
import 'package:portasauna/admin/features/edit_place/controller/admin_pending_place_controller.dart';
import 'package:portasauna/admin/features/all_place/components/admin_place_details_user_info.dart';
import 'package:portasauna/admin/features/all_place/components/admin_place_details_helper.dart';
import 'package:portasauna/admin/features/all_place/components/place_edit_buttons.dart';
import 'package:portasauna/features/discover/widgets/place_details_image_slider.dart';
import 'package:portasauna/features/discover/widgets/ratings_and_created_by.dart';

class AdminPlaceDetailsPage extends StatefulWidget {
  const AdminPlaceDetailsPage({super.key, this.hideAcceptButton = false});

  final bool hideAcceptButton;

  @override
  State<AdminPlaceDetailsPage> createState() => _AdminPlaceDetailsPageState();
}

class _AdminPlaceDetailsPageState extends State<AdminPlaceDetailsPage> {
  late double latitude;
  late double longitude;
  final epc = Get.find<AdminEditPlaceController>();
  late GoogleMapController controller;
  CameraPosition? cameraPosition;
  final Set<Marker> markers = {};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      runOnInitState();
    });
    super.initState();
  }

  runOnInitState() {
    final apc = Get.find<AdminPendingPlaceController>();
    apc.getUserDetailsOfSelectedUser(context,
        userId: apc.selectedSaunaPlace.userId);

    latitude = apc.selectedSaunaPlace.lattitude ?? 0.0;
    longitude = apc.selectedSaunaPlace.longitude ?? 0.0;

    cameraPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 11,
    );

    markers.add(
      Marker(
        markerId: MarkerId('$latitude $longitude'),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(
          title: apc.selectedSaunaPlace.address ?? '',
          snippet: '',
        ),
        icon: BitmapDescriptor.defaultMarker,
        onTap: () {},
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminPendingPlaceController>(builder: (apc) {
      return LoaderWidget(
        isLoading: apc.isLoading,
        child: Scaffold(
          appBar: appbarCommon('', context),
          body: SingleChildScrollView(
            child: Container(
              padding: screenPaddingH,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //====================>
                  //User who added this
                  //====================>
                  if (apc.selectedUserDetails != null)
                    AdminPlaceDetailsUserInfo(
                      profileImageUrl: apc.selectedUserDetails?.profileImg ??
                          defaultUserImage,
                      name: apc.selectedUserDetails?.name ?? '',
                      email: apc.selectedUserDetails?.email ?? '',
                    ),

                  gapH(25),

                  //=============>
                  //image
                  //=============>
                  PlaceDetailsImageSlider(
                      imageList: apc.selectedSaunaPlace.imgLinks ?? []),

                  //==================>
                  //Address
                  //==================>
                  gapH(30),
                  Text(
                    apc.selectedSaunaPlace.address ?? '',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 22.h,
                        ),
                  ),
                  gapH(8),
                  Text("Place id: ${apc.selectedSaunaPlace.id}",
                      style:
                          TextUtils.small1(context: context, fontSize: 15.sp)),
                  gapH(17),
                  //===================>
                  //Ratings and created by
                  //===================>
                  const RatingsAndCreatedBy(),
                  gapH(17),

                  //===================>
                  //Details
                  //===================>

                  detailsRowWithPoints(context,
                      title: 'Type of Location',
                      details: apc.selectedSaunaPlace.selectedWildType ?? []),
                  detailsRowWithPoints(context,
                      details:
                          apc.selectedSaunaPlace.selectedCommercialType ?? []),
                  detailsRowWithPoints(context,
                      details:
                          apc.selectedSaunaPlace.selectedNearbyService ?? []),
                  detailsRowWithPoints(context,
                      details:
                          apc.selectedSaunaPlace.selectedNearbyActivities ??
                              []),

                  if (apc.selectedSaunaPlace.description != null)
                    Container(
                      margin: EdgeInsets.only(top: 15.h),
                      child: detailsRow(context,
                          title: 'Description',
                          details: apc.selectedSaunaPlace.description ?? ''),
                    ),

                  gapH(10),

                  //=============>
                  //Map
                  //=============>
                  if (cameraPosition != null)
                    ClipRRect(
                      borderRadius: radius(3),
                      child: SizedBox(
                        height: 250.h,
                        child: GoogleMap(
                          initialCameraPosition: cameraPosition!,
                          markers: markers,
                          mapType: MapType.normal,
                          myLocationEnabled: false,
                          myLocationButtonEnabled: false,
                          compassEnabled: true,
                          zoomControlsEnabled: false,
                          zoomGesturesEnabled: true,
                          scrollGesturesEnabled: true,
                          gestureRecognizers: {
                            Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer()),
                          },
                          onTap: (argument) {},
                          onMapCreated: (GoogleMapController c) async {
                            controller = c;
                          },
                        ),
                      ),
                    ),

                  gapH(30),

                  //=============>
                  //Buttons
                  //=============>
                  PlaceEditButtons(
                    hideAcceptButton: widget.hideAcceptButton,
                  ),

                  gapH(60),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
