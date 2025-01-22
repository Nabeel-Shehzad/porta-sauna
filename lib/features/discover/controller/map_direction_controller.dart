// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:portasauna/core/constants/app_secrets.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';

class MapDirectionController extends GetxController {
  late GoogleMapController mapController;
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  final Set<Marker> markers = {};

  //===============================
  // Animate Camera To New Position
  //===============================
  animateCameraToNewPosition({double? zoom, lat, long}) {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        cameraPosition(zoom: zoom, lat: lat, long: long)));
  }

  //===============================
  // Camera Position
  //===============================
  CameraPosition cameraPosition({double? zoom, lat, long}) {
    final fnc = Get.find<FindNearSaunaController>();

    return CameraPosition(
      target: LatLng(lat ?? fnc.selectedSaunaPlace.lattitude,
          long ?? fnc.selectedSaunaPlace.longitude),
      zoom: zoom ?? 4,
    );
  }

//==================================>
//Make direction on map
//==================================>

  makeDirectionOnMap(BuildContext context) async {
    final fnc = Get.find<FindNearSaunaController>();
    Position userCurrentLocation = await fnc.getUserCurrentPosition(context);

    try {
      // add marker
      markers.add(
        Marker(
          markerId: MarkerId('${fnc.selectedSaunaPlace.lattitude}'),
          position: LatLng(fnc.selectedSaunaPlace.lattitude,
              fnc.selectedSaunaPlace.longitude),
          infoWindow: InfoWindow(
            title: fnc.selectedSaunaPlace.address ?? '',
            snippet: '',
          ),
          icon: BitmapDescriptor.defaultMarker,
          onTap: () {},
        ),
      );

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: AppSecrets.googleMapApiKey,
        request: PolylineRequest(
          origin: PointLatLng(
              userCurrentLocation.latitude, userCurrentLocation.longitude),
          destination: PointLatLng(fnc.selectedSaunaPlace.lattitude,
              fnc.selectedSaunaPlace.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }

      animateCameraToNewPosition(
          lat: userCurrentLocation.latitude,
          long: userCurrentLocation.longitude,
          zoom: 16);

      addPolyLine();
    } catch (e) {
      showErrorSnackBar(context,
          "Error getting direction. Maybe your location is too far away?");
      debugPrint('$e');
    }
  }

//==================================>
//Add polyline
//==================================>
  addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        visible: true,
        width: 5,
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates);
    polylines[id] = polyline;

    update();
  }
}
