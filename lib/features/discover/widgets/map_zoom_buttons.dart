import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:portasauna/features/discover/controller/map_controller.dart';

class MapZoomButtons extends StatelessWidget {
  const MapZoomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapController>(
      builder: (mc) {
        return Container(
          margin: const EdgeInsets.only(right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () async {
                    try {
                      if (mc.controller != null && mc.controllerReady.value) {
                        var currentZoomLevel = await mc.controller!.getZoomLevel();
                        await mc.moveCamera(
                          await mc.getCurrentCameraTarget(),
                          zoom: currentZoomLevel + 1,
                        );
                      }
                    } catch (e) {
                      print('Error zooming in: $e');
                    }
                  },
                  icon: const Icon(Icons.add),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () async {
                    try {
                      if (mc.controller != null && mc.controllerReady.value) {
                        var currentZoomLevel = await mc.controller!.getZoomLevel();
                        await mc.moveCamera(
                          await mc.getCurrentCameraTarget(),
                          zoom: currentZoomLevel - 1,
                        );
                      }
                    } catch (e) {
                      print('Error zooming out: $e');
                    }
                  },
                  icon: const Icon(Icons.remove),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
