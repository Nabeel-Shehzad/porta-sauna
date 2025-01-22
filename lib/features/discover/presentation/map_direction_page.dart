// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/features/discover/controller/map_direction_controller.dart';

class MapDirectionPage extends StatefulWidget {
  const MapDirectionPage({super.key});

  @override
  State<MapDirectionPage> createState() => _MapDirectionPageState();
}

class _MapDirectionPageState extends State<MapDirectionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<MapDirectionController>().makeDirectionOnMap(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapDirectionController>(builder: (mdc) {
      return Scaffold(
        appBar: appbarCommon('Direction', context),
        body: GoogleMap(
          polylines: Set<Polyline>.of(mdc.polylines.values),
          markers: mdc.markers,
          initialCameraPosition: mdc.cameraPosition(),
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          onMapCreated: (GoogleMapController c) async {
            mdc.mapController = c;
          },
        ),
      );
    });
  }
}
