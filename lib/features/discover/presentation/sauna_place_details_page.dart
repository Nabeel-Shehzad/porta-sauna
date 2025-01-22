import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/text_utils.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/features/discover/controller/favourite_controller.dart';
import 'package:portasauna/features/discover/widgets/place_details_image_slider.dart';
import 'package:portasauna/features/discover/widgets/place_details_four_icons.dart';
import 'package:portasauna/features/discover/widgets/ratings_and_created_by.dart';
import 'package:portasauna/features/discover/widgets/services_and_activities.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';

class SaunaPlaceDetailsPage extends StatefulWidget {
  const SaunaPlaceDetailsPage({super.key});

  @override
  State<SaunaPlaceDetailsPage> createState() => _SaunaPlaceDetailsPageState();
}

class _SaunaPlaceDetailsPageState extends State<SaunaPlaceDetailsPage> {
  late double latitude;
  late double longitude;

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
    final fnc = Get.find<FindNearSaunaController>();
    debugPrint('🟢 selected place id ${fnc.selectedSaunaPlace.id} ');
    latitude = fnc.selectedSaunaPlace.lattitude ?? 0.0;
    longitude = fnc.selectedSaunaPlace.longitude ?? 0.0;

    cameraPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 11,
    );

    markers.add(
      Marker(
        markerId: MarkerId('$latitude $longitude'),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(
          title: fnc.selectedSaunaPlace.address ?? '',
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
    return GetBuilder<FavouriteController>(builder: (favContr) {
      return GetBuilder<FindNearSaunaController>(builder: (fnc) {
        return Scaffold(
          appBar: appbarCommon('', context),
          body: SingleChildScrollView(
            child: Container(
              padding: screenPaddingH,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //=============>
                  //image
                  //=============>

                  PlaceDetailsImageSlider(
                    imageList: fnc.selectedSaunaPlace.imgLinks ?? [],
                  ),

                  gapH(30),

                  //=============>
                  //free or commercial
                  //=============>
                  if (fnc.selectedSaunaPlace.selectedWildType != null)
                    Text(
                      fnc.selectedSaunaPlace.selectedWildType!.isNotEmpty
                          ? "Free Sauna Spot | ${fnc.selectedSaunaPlace.selectedWildType?[0]}"
                          : fnc.selectedSaunaPlace.selectedCommercialType!
                                  .isNotEmpty
                              ? "Commercial | ${fnc.selectedSaunaPlace.selectedCommercialType?[0]}"
                              : "",
                      style: TextUtils.small1(
                          context: context,
                          fontSize: 17.h,
                          fontWeight: FontWeight.w600,
                          color: Pallete.primarColor),
                    ),

                  gapH(20),

                  //===================>
                  //Address
                  //===================>
                  Text(
                    fnc.selectedSaunaPlace.zipCode != null
                        ? "(${fnc.selectedSaunaPlace.zipCode}) ${fnc.selectedSaunaPlace.address ?? ''}"
                        : fnc.selectedSaunaPlace.address ?? '',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 22.h,
                        ),
                  ),

                  //===================>
                  //4 icons
                  //===================>
                  gapH(20),
                  const PlaceDetailsFourIcons(),
                  gapH(15),
                  //===================>
                  //Ratings and created by
                  //===================>
                  const RatingsAndCreatedBy(),
                  gapH(20),

                  //===================>
                  //Lattitude longitude
                  //===================>
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Pallete.whiteColor,
                        size: 25.sp,
                      ),
                      gapW(10),
                      Flexible(
                        child: Text(
                          "${fnc.selectedSaunaPlace.lattitude ?? 0}, ${fnc.selectedSaunaPlace.longitude ?? 0} (lat,lng)",
                          style: TextUtils.small1(
                              context: context, fontSize: 15.h),
                        ),
                      ),
                    ],
                  ),

                  gapH(13),

                  //===================>
                  //sevice and activities
                  //===================>\
                  const ServicesAndActivities(),

                  if (fnc.selectedSaunaPlace.description != null)
                    Container(
                      margin: EdgeInsets.only(top: 20.h),
                      child: detailsRow(context,
                          title: 'Description',
                          details: fnc.selectedSaunaPlace.description ?? ''),
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
                          onTap: (argument) {},
                          gestureRecognizers: {
                            Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer()),
                          },
                          onMapCreated: (GoogleMapController c) async {
                            controller = c;
                          },
                        ),
                      ),
                    ),
                  gapH(60),
                ],
              ),
            ),
          ),
        );
      });
    });
  }

  detailsRow(BuildContext context,
      {required String title, required String details}) {
    return Container(
      margin: EdgeInsets.only(bottom: 25.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 18.h,
                ),
          ),
          gapH(10),
          Text(
            details,
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 17.h),
          ),
        ],
      ),
    );
  }
}
