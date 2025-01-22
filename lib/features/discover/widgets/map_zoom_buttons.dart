import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:portasauna/features/discover/controller/map_controller.dart';

class MapZoomButtons extends StatelessWidget {
  const MapZoomButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapController>(builder: (mc) {
      return Positioned(
        bottom: 20,
        left: 5,
        child: Card(
          elevation: 2,
          child: Container(
            color: const Color(0xFFFAFAFA),
            width: 40,
            height: 100,
            child: Column(
              children: <Widget>[
                IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      var currentZoomLevel = await mc.controller.getZoomLevel();

                      currentZoomLevel = currentZoomLevel + 2;
                      mc.controller.animateCamera(
                        CameraUpdate.newCameraPosition(mc.cameraPosition(
                            zoom: currentZoomLevel,
                            lat: mc.selectedPlaceLatLong?.lat,
                            long: mc.selectedPlaceLatLong?.lng)),
                      );
                    }),
                const SizedBox(height: 2),
                IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () async {
                      var currentZoomLevel = await mc.controller.getZoomLevel();

                      currentZoomLevel = currentZoomLevel - 2;
                      mc.controller.animateCamera(
                        CameraUpdate.newCameraPosition(mc.cameraPosition(
                            zoom: currentZoomLevel,
                            lat: mc.selectedPlaceLatLong?.lat,
                            long: mc.selectedPlaceLatLong?.lng)),
                      );
                    }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
