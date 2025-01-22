import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/loader_widget.dart';
import 'package:portasauna/features/discover/controller/place_added_by_user_controller.dart';

class PlaceAddedByAnUserOnMapPage extends StatefulWidget {
  const PlaceAddedByAnUserOnMapPage({super.key});

  @override
  State<PlaceAddedByAnUserOnMapPage> createState() =>
      _PlaceAddedByAnUserOnMapPageState();
}

class _PlaceAddedByAnUserOnMapPageState
    extends State<PlaceAddedByAnUserOnMapPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<PlaceAddedByUserController>().getPlacesOfSelectedUser(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlaceAddedByUserController>(builder: (pac) {
      return PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            pac.fillDatasFromTempPlaceRatingUserDetails();
          }
        },
        child: Scaffold(
          appBar: appbarCommon(
              'Places by ${pac.selectedUserDetails?.name ?? '-'}', context),
          body: LoaderWidget(
            isLoading: pac.isLoading,
            child: GoogleMap(
              initialCameraPosition: pac.cameraPosition(),
              markers: pac.markers,
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              onMapCreated: (GoogleMapController c) async {
                pac.mapController = c;
              },
            ),
          ),
        ),
      );
    });
  }
}
