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
import 'package:portasauna/features/discover/controller/rating_controller.dart';
import 'package:portasauna/features/discover/widgets/place_details_image_slider.dart';
import 'package:portasauna/features/discover/widgets/place_details_four_icons.dart';
import 'package:portasauna/features/discover/widgets/ratings_and_created_by.dart';
import 'package:portasauna/features/discover/widgets/services_and_activities.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';
import 'package:url_launcher/url_launcher.dart';

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

    // Initialize ratings
    Get.find<RatingController>()
        .fetchRatings(context, locationId: fnc.selectedSaunaPlace.id);

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
          snippet: fnc.selectedSaunaPlace.description ?? '',
        ),
        icon: BitmapDescriptor.defaultMarker,
        onTap: () {
          // Focus the map on the marker location
          controller.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(latitude, longitude),
              15.0, // Zoom level
            ),
          );
        },
      ),
    );

    setState(() {});
  }

  Future<void> _launchUrl(String? url) async {
    if (url == null || url.isEmpty) return;

    // Add https:// if not present and remove any whitespace
    url = url.trim();
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open website: $url')),
          );
        }
      }
    } catch (e) {
      print('Error launching URL: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid website URL')),
        );
      }
    }
  }

  Future<void> _launchInstagram(String? username) async {
    if (username == null || username.isEmpty) return;

    // Remove @ if present and trim whitespace
    username = username.trim();
    username = username.startsWith('@') ? username.substring(1) : username;

    try {
      // Try app first
      final appUri = Uri.parse('instagram://user?username=$username');
      if (await canLaunchUrl(appUri)) {
        await launchUrl(appUri);
        return;
      }

      // Fallback to website
      final webUri = Uri.parse('https://instagram.com/$username');
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Could not open Instagram profile: @$username')),
          );
        }
      }
    } catch (e) {
      print('Error launching Instagram: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid Instagram username')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavouriteController>(builder: (favContr) {
      return GetBuilder<FindNearSaunaController>(builder: (fnc) {
        // Debug prints
        print("Website: ${fnc.selectedSaunaPlace.website}");
        print("Instagram: ${fnc.selectedSaunaPlace.instagram}");
        return Scaffold(
          appBar: appbarCommon('', context),
          body: SingleChildScrollView(
            child: Container(
              padding: screenPaddingH,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location and Rating Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fnc.selectedSaunaPlace.address ?? '',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (fnc.selectedSaunaPlace.lattitude != null)
                              Text(
                                'N ${fnc.selectedSaunaPlace.lattitude}° W ${fnc.selectedSaunaPlace.longitude}°',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[400],
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Rating
                      GetBuilder<RatingController>(
                        builder: (rc) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => Icon(
                                    index < (rc.averageRating)
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                              rc.isloading
                                  ? SizedBox(
                                      height: 15.h,
                                      width: 15.h,
                                      child: const CircularProgressIndicator(),
                                    )
                                  : Text(
                                      '${rc.averageRating}/5',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  gapH(20),
                  //==============>
                  //image
                  //==============>

                  PlaceDetailsImageSlider(
                    imageList: fnc.selectedSaunaPlace.imgLinks ?? [],
                  ),

                  gapH(30),

                  //==============>
                  //free or commercial
                  //==============>
                  if (fnc.selectedSaunaPlace.selectedWildType != null)
                    Text(
                      fnc.selectedSaunaPlace.selectedWildType!.isNotEmpty
                          ? "Free Sauna Spot | ${fnc.selectedSaunaPlace.selectedWildType?[0]}"
                          : fnc.selectedSaunaPlace.selectedCommercialType !=
                                      null &&
                                  fnc.selectedSaunaPlace.selectedCommercialType!
                                      .isNotEmpty
                              ? "Commercial | ${fnc.selectedSaunaPlace.selectedCommercialType?[0]}"
                              : "",
                      style: TextUtils.small1(
                          context: context,
                          fontSize: 17.h,
                          fontWeight: FontWeight.w600,
                          color: fnc.selectedSaunaPlace.selectedWildType!
                                  .isNotEmpty
                              ? const Color(0xFF5ce65c) // Green color for Free
                              : Pallete
                                  .primarColor), // Blue color for Commercial
                    ),

                  gapH(20),

                  //====================>
                  //Address
                  //====================>
                  Text(
                    fnc.selectedSaunaPlace.zipCode != null
                        ? "(${fnc.selectedSaunaPlace.zipCode}) ${fnc.selectedSaunaPlace.address ?? ''}"
                        : fnc.selectedSaunaPlace.address ?? '',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 22.h,
                        ),
                  ),

                  //====================>
                  // Website and Instagram Links
                  //====================>

                  if (fnc.selectedSaunaPlace.website != null ||
                      fnc.selectedSaunaPlace.instagram != null)
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      child: Row(
                        children: [
                          if (fnc.selectedSaunaPlace.website != null)
                            GestureDetector(
                              onTap: () =>
                                  _launchUrl(fnc.selectedSaunaPlace.website),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.language,
                                        size: 18.sp, color: Colors.white),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Website',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.sp),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          SizedBox(width: 10.w),
                          if (fnc.selectedSaunaPlace.instagram != null)
                            GestureDetector(
                              onTap: () => _launchInstagram(
                                  fnc.selectedSaunaPlace.instagram),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.camera_alt,
                                        size: 18.sp, color: Colors.white),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Instagram',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.sp),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                  gapH(20),
                  const PlaceDetailsFourIcons(),
                  gapH(15),
                  //====================>
                  //Reviews and Feedback
                  //====================>
                  GetBuilder<RatingController>(
                    builder: (rc) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reviews',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            gapH(10),
                            // Overall Rating
                            Row(
                              children: [
                                Row(
                                  children: List.generate(
                                    5,
                                    (index) => Icon(
                                      index < rc.averageRating
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 24.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  '${rc.averageRating}/5',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                            gapH(20),
                            // Add Review Section
                            Text(
                              'Add a feedback',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            gapH(10),
                            // Star Rating Input
                            Row(
                              children: List.generate(
                                5,
                                (index) => GestureDetector(
                                  onTap: () {
                                    rc.setRating(index + 1);
                                  },
                                  child: Icon(
                                    index < rc.rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 30.sp,
                                  ),
                                ),
                              ),
                            ),
                            gapH(10),
                            // Review Input
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                maxLines: 3,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText:
                                      'Add a feedback to help other users',
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  border: InputBorder.none,
                                ),
                                controller: rc.feedbackController,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  gapH(20),

                  //====================>
                  //Lattitude longitude
                  //====================>
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

                  //====================>
                  //sevice and activities
                  //====================>\
                  const ServicesAndActivities(),

                  //====================>
                  //Description
                  //====================>
                  if (fnc.selectedSaunaPlace.description != null &&
                      fnc.selectedSaunaPlace.description!.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontSize: 18.h,
                                ),
                          ),
                          gapH(10),
                          _buildClickableDescription(
                            context,
                            fnc.selectedSaunaPlace.description ?? '',
                          ),
                        ],
                      ),
                    ),

                  gapH(10),

                  //==============>
                  //Map
                  //==============>
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

  Widget _buildClickableDescription(BuildContext context, String description) {
    final List<InlineSpan> spans = [];
    final lines = description.split('\n');

    for (final line in lines) {
      if (line.trim().isEmpty) continue;

      if (line.contains('Website:')) {
        final url = line.split('Website:')[1].trim();
        spans.add(TextSpan(
            text: 'Website:\n', style: TextUtils.small1(context: context)));
        spans.add(
          TextSpan(
            text: url,
            style: TextUtils.small1(
              context: context,
              color: Colors.blue,
              decoration: TextDecoration.none,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => _launchUrl(url),
          ),
        );
        spans.add(TextSpan(
            text: '\n',
            style: TextUtils.small1(context: context))); // Add extra line break
      } else if (line.contains('Instagram:')) {
        final username = line.split('Instagram:')[1].trim();
        spans.add(TextSpan(
            text: 'Instagram:\n', style: TextUtils.small1(context: context)));
        spans.add(
          TextSpan(
            text: username,
            style: TextUtils.small1(
              context: context,
              color: Colors.blue,
              decoration: TextDecoration.none,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _launchInstagram(username),
          ),
        );
      } else {
        spans.add(TextSpan(
          text: '$line\n',
          style: TextUtils.small1(context: context),
        ));
      }
    }

    return RichText(
      text: TextSpan(children: spans),
    );
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
