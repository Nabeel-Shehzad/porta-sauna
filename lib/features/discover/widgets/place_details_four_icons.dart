import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/constants/assets_const.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/helper.dart';
import 'package:portasauna/core/utils/text_utils.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/add_sauna_place/presentation/add_image_page.dart';
import 'package:portasauna/features/auth/controller/profile_controller.dart';
import 'package:portasauna/features/discover/controller/favourite_controller.dart';
import 'package:portasauna/features/discover/controller/place_details_modal_controller.dart';
import 'package:portasauna/features/discover/presentation/map_direction_page.dart';
import 'package:portasauna/features/discover/presentation/report_error_form_page.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';
import 'package:portasauna/features/request_place_edit/controller/request_edit_place_controller.dart';
import 'package:portasauna/features/request_place_edit/presentation/request_edit_nearby_service_page.dart';

class PlaceDetailsFourIcons extends StatelessWidget {
  const PlaceDetailsFourIcons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fnc = Get.find<FindNearSaunaController>();
    Color? phoneIconColor = Pallete.whiteColor;

    if ((fnc.selectedSaunaPlace.selectedCommercialType?.isEmpty ?? true) &&
        fnc.selectedSaunaPlace.commercialPhone == null) {
      phoneIconColor = Colors.grey[700];
    }

    return GetBuilder<FavouriteController>(builder: (favContr) {
      bool favourite =
          favContr.favouritePlaceList.contains(fnc.selectedSaunaPlace.id);

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Direction
          iconBtn(
            onTap: () {
              Get.to(const MapDirectionPage());
            },
            icon: Icons.directions,
          ),

          //Favourite
          iconBtn(
            onTap: () {
              favContr.favouriteOrUnfavouriteAPlace(context,
                  placeId: fnc.selectedSaunaPlace.id);
            },
            icon: favourite ? Icons.favorite : Icons.favorite_outline,
            color: favourite ? Pallete.redColor : Pallete.whiteColor,
            borderColor: favourite ? Pallete.redColor : Pallete.whiteColor,
          ),

          //Call
          iconBtn(
              onTap: () {
                if ((fnc.selectedSaunaPlace.selectedCommercialType?.isEmpty ??
                        true) &&
                    fnc.selectedSaunaPlace.commercialPhone == null) {
                  return;
                }
                goToUrl('tel:${fnc.selectedSaunaPlace.commercialPhone}');
              },
              icon: Icons.call_outlined,
              color: phoneIconColor,
              borderColor: phoneIconColor),

          //More
          iconBtn(onTap: () => _showModal(context), icon: Icons.more_horiz),
        ],
      );
    });
  }

  //================>
  //Icon Button
  //================>
  iconBtn(
      {required VoidCallback onTap,
      required IconData icon,
      color,
      borderColor}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15.sp),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor ?? Colors.grey)),
        child: Icon(
          icon,
          color: color ?? Pallete.whiteColor,
          size: 25.sp,
        ),
      ),
    );
  }

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<PlaceDetailsModalController>(builder: (pdc) {
          return CupertinoActionSheet(
            title: Text(appName),
            message: const Text('Choose an action'),
            actions: [
              //================>
              //I am here
              //================>
              CupertinoActionSheetAction(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (pdc.isLoading)
                      Container(
                          height: 15.sp,
                          width: 15.sp,
                          margin: EdgeInsets.only(right: 10.w),
                          child: const CircularProgressIndicator()),
                    Text(
                      'I\'m here',
                      style: TextUtils.small1(context: context),
                    ),
                  ],
                ),
                onPressed: () {
                  bool isLoggedIn = Get.find<ProfileController>().isLoggedIn;
                  if (!isLoggedIn) {
                    showErrorSnackBar(context,
                        'You must be logged in to access this feature');
                    Get.back();
                    return;
                  }
                  pdc.saveIamHere(context);
                },
              ),

              //================>
              //Share
              //================>
              CupertinoActionSheetAction(
                child: Text(
                  'Share this place',
                  style: TextUtils.small1(context: context),
                ),
                onPressed: () {
                  pdc.sharePlace(context);
                },
              ),

              //================>
              //Report
              //================>
              CupertinoActionSheetAction(
                child: Text(
                  'Report errors',
                  style: TextUtils.small1(context: context),
                ),
                onPressed: () {
                  bool isLoggedIn = Get.find<ProfileController>().isLoggedIn;
                  if (!isLoggedIn) {
                    showErrorSnackBar(context,
                        'You must be logged in to access this feature');
                    Get.back();
                    return;
                  }
                  Get.to(const ReportErrorFormPage());
                },
              ),

              //================>
              //Add a photo
              //================>
              CupertinoActionSheetAction(
                child: Text(
                  'Add a photo',
                  style: TextUtils.small1(context: context),
                ),
                onPressed: () {
                  bool isLoggedIn = Get.find<ProfileController>().isLoggedIn;
                  if (!isLoggedIn) {
                    showErrorSnackBar(context,
                        'You must be logged in to access this feature');
                    Get.back();
                    return;
                  }
                  Get.back();
                  Get.to(const AddImagePage(
                    fromAddImageByOtherUserPage: true,
                  ));
                },
              ),

              //================>
              //Edit this place
              //================>
              CupertinoActionSheetAction(
                child: Text(
                  'Edit this place',
                  style: TextUtils.small1(context: context),
                ),
                onPressed: () {
                  bool isLoggedIn = Get.find<ProfileController>().isLoggedIn;
                  if (!isLoggedIn) {
                    showErrorSnackBar(context,
                        'You must be logged in to access this feature');
                    Get.back();
                    return;
                  }

                  Get.back();
                  final rec = Get.find<RequestEditPlaceController>();
                  rec.fillCategoriesAndSetEverythingDefault();
                  rec.fillServicesAndActivitiesFromSelectedPlace();
                  Get.to(const RequestEditNearbyServicePage());
                },
              ),
            ],

            //================>
            //Cancel
            //================>
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
                style: TextUtils.small1(context: context),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
        });
      },
    );
  }
}
