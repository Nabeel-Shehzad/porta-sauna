// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';  
import 'package:portasauna/core/bindings/init_dependencies.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/add_sauna_place/model/add_place_around_things_model.dart';
import 'package:portasauna/features/add_sauna_place/model/sauna_place_model.dart';
import 'package:portasauna/features/discover/controller/filter_sauna_place_controller.dart';
import 'package:portasauna/features/discover/controller/map_place_controller.dart';
import 'package:portasauna/features/discover/model/lat_long_from_place_model.dart';
import 'package:portasauna/features/discover/model/map_api_model.dart';
import 'package:portasauna/features/discover/presentation/sauna_place_details_page.dart';
import 'package:portasauna/features/discover/utils/custom_marker_helper.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import 'dart:ui';

class MapController extends GetxController {
  late GoogleMapController controller;
  final searchController = TextEditingController();
  final _controllerReady = false.obs;
  bool showSearchAreaButton = false;
  bool isLoading = false;
  LatLngCustomModel? selectedPlaceLatLong;
  Geometry? selectedPlaceGeometry;
  double? defaultLat = 55.3781;
  double? defaultLong = 3.4360;
  final Set<Marker> markers = {};
  final Set<Marker> tempMarkers = {};
  bool markerPlacedOnMap = false;
  CameraPosition? _lastCameraPosition;
  bool _isMoving = false;
  LatLngBounds? _lastSearchBounds;

  // Map type control
  MapType _currentMapType = MapType.normal;
  MapType get currentMapType => _currentMapType;

  void toggleMapType() {
    switch (_currentMapType) {
      case MapType.normal:
        _currentMapType = MapType.satellite;
        break;
      case MapType.satellite:
        _currentMapType = MapType.terrain;
        break;
      case MapType.terrain:
        _currentMapType = MapType.normal;
        break;
      default:
        _currentMapType = MapType.normal;
        break;
    }
    update();
  }

  void setMapType(MapType type) {
    _currentMapType = type;
    update();
  }

  setLoadingTrue() {
    isLoading = true;
    update();
  }

  setLoadingFalse() {
    isLoading = false;
    update();
  }

  setSelectedPlaceLatLong(LatLngCustomModel? v) {
    selectedPlaceLatLong = v;
    defaultLat = v?.lat ?? 0;
    defaultLong = v?.lng ?? 0;

    print(
        'selected place lat long ${selectedPlaceLatLong?.lat} ${selectedPlaceLatLong?.lng}');
    update();
  }

  setSelectedPlaceGeometry(Geometry? v) {
    selectedPlaceGeometry = v;
    update();
  }

//==================>
//Marker
//==================>
  setMarkerPlaced(v) {
    markerPlacedOnMap = v;
    update();
  }

  keepMarkersToTemp() {
    tempMarkers.clear();
    tempMarkers.addAll(markers);
    markers.clear();
    update();
  }

  fillMarkersWithTemp() {
    markers.clear();
    markers.addAll(tempMarkers);
    update();
  }

  addOneMarker({lat, long, title, subtitle, String? saunaType}) async {
    markers.clear();
    final customIcon = await CustomMarkerHelper.getMarkerIcon(saunaType);
    markers.add(
      Marker(
        markerId: MarkerId('$lat'),
        position: LatLng(lat, long),
        infoWindow: InfoWindow(
          title: title ?? '',
          snippet: subtitle ?? '',
        ),
        icon: customIcon,
      ),
    );
    markerPlacedOnMap = true;
    update();
  }

  addCurrentPlaceMarker({lat, long, title, subtitle}) async {
    final customIcon = await CustomMarkerHelper.getMarkerIcon('current');
    markers.add(
      Marker(
        markerId: MarkerId('$lat'),
        position: LatLng(lat, long),
        infoWindow: InfoWindow(
          title: title ?? '',
          snippet: subtitle ?? '',
        ),
        icon: customIcon,
      ),
    );
    update();
  }

  addMultipleMarkers() async {
    markers.clear();

    for (int i = 0; i < placesList.length; i++) {
      if (placesList[i].lattitude != null && placesList[i].longitude != null) {
        final customIcon = await CustomMarkerHelper.getMarkerIcon(placesList[i].saunaType);
        markers.add(
          Marker(
            markerId: MarkerId(placesList[i].id.toString()),
            position: LatLng(
              double.parse(placesList[i].lattitude.toString()),
              double.parse(placesList[i].longitude.toString()),
            ),
            infoWindow: InfoWindow(
              title: placesList[i].saunaType ?? '',
              snippet: placesList[i].description ?? '',
            ),
            icon: customIcon,
            onTap: () {
              showSaunaDetails(placesList[i]);
            },
          ),
        );
      }
    }
    update();
  }

  CameraPosition cameraPosition({double? zoom, lat, long}) {
    return CameraPosition(
      target: LatLng(lat ?? defaultLat, long ?? defaultLong),
      zoom: zoom ?? 15,
    );
  }

  animateCameraToNewPosition({double? zoom, lat, long}) {
    controller.animateCamera(CameraUpdate.newCameraPosition(
        cameraPosition(zoom: zoom, lat: lat, long: long)));
  }

//==================>
//Searching a place on map
//==================>

  List<String> suggestedPlaces = [];

  makeSuggestedPlaceEmpty() {
    suggestedPlaces = [];
    update();
  }

  searchPlace({required placeName}) async {
    makeSuggestedPlaceEmpty();

    final suggestions = await Get.find<MapPlaceController>()
        .getPlaceSuggestion(placeName: placeName);

    final data = MapPredictionModel.fromJson(suggestions);

    for (int i = 0; i < data.predictions.length; i++) {
      suggestedPlaces.add(data.predictions[i].description ?? '');
    }

    update();
  }

  Future<bool> moveCameraToPlace(BuildContext context,
      {required placeName, bool animateCamera = true}) async {
    try {
      final placeLatLong = await Get.find<MapPlaceController>()
          .getLatLongFromPlaceName(placeName: placeName);

      final latLongFromApi = LatLongFromPlaceModel.fromJson(placeLatLong);
      final lat = latLongFromApi.results[0].geometry?.location?.lat ?? 0;
      final long = latLongFromApi.results[0].geometry?.location?.lng ?? 0;

      setSelectedPlaceLatLong(latLongFromApi.results[0].geometry?.location);
      setSelectedPlaceGeometry(latLongFromApi.results[0].geometry);

      if (animateCamera) {
        animateCameraToNewPosition(
          lat: lat,
          long: long,
        );
      }

      getSaunaPlacesOnMap(context);
      return true;
    } catch (e) {
      showSnackBar(context, e.toString(), Pallete.redColor);
      print(e);
      return false;
    }
  }

//==================>
//Bottom nav
//==================>

  bool showBottomNav = false;
  setShowBottomNav(v) {
    showBottomNav = v;

    markerPlacedOnMap = false;
    update();
  }

  //==================>
  //Get sauna Location from db
  //==================>

  List<SaunaPlaceModel> placesList = [];

  bool showHorizontalCard = false;
  setShowHorizontalCard(bool v) {
    showHorizontalCard = v;
    update();
  }

  Future<void> loadSaunaPlaces() async {
    try {
      final saunaPlaces = await dbClient
          .from('sauna_locations')
          .select()
          .eq('is_approved', true);

      print('Loaded ${saunaPlaces.length} saunas');
      markers.clear();

      for (var sauna in saunaPlaces) {
        print('Sauna type from database: "${sauna['sauna_type']}"');
        if (sauna['latitude'] != null && sauna['longitude'] != null) {
          final customIcon = await CustomMarkerHelper.getMarkerIcon(sauna['sauna_type']);
          
          final position = LatLng(
            double.parse(sauna['latitude'].toString()),
            double.parse(sauna['longitude'].toString()),
          );

          final marker = Marker(
            markerId: MarkerId(sauna['id'].toString()),
            position: position,
            icon: customIcon,
            infoWindow: InfoWindow(
              title: sauna['sauna_type'] ?? 'Sauna',
              snippet: sauna['description'] ?? 'No description available',
            ),
            onTap: () {
              showSaunaDetails(SaunaPlaceModel.fromJson(sauna));
            },
          );
          
          markers.add(marker);
        }
      }
      update();
    } catch (e) {
      print('Error loading sauna places: $e');
    }
  }

  Future<void> getSaunaPlacesOnMap(
    BuildContext context,
  ) async {
    try {
      setLoadingTrue();
      placesList.clear();

      final fc = Get.find<FilterSaunaPlaceController>();
      List<AddPlaceAroundThingsModel> wildType = fc.wildTypeList;
      List<AddPlaceAroundThingsModel> commercialType = fc.commercialList;
      List<AddPlaceAroundThingsModel> nearbyService = fc.nearbyServiceList;
      List<AddPlaceAroundThingsModel> nearbyActivity = fc.nearbyActivityList;

      final minLongitude = selectedPlaceGeometry?.viewport?.southwest?.lng;
      final minLatitude = selectedPlaceGeometry?.viewport?.southwest?.lat;
      final maxLongitude = selectedPlaceGeometry?.viewport?.northeast?.lng;
      final maxLatitude = selectedPlaceGeometry?.viewport?.northeast?.lat;

      final response = await dbClient
          .from('sauna_locations')
          .select()
          .gte('latitude', minLatitude?.floor() ?? 0)
          .lte('latitude', maxLatitude?.ceil() ?? 0)
          .gte('longitude', minLongitude?.floor() ?? 0)
          .lte('longitude', maxLongitude?.ceil() ?? 0)
          .eq('is_approved', true);

      //Below codes are for filters
      //=======================>
      List<String>? selectedWildType = [];
      List<String>? selectedCommercialType = [];
      List<String>? selectedNearbyService = [];
      List<String>? selectedNearbyActivities = [];

      for (int i = 0; i < wildType.length; i++) {
        if (wildType[i].selected) {
          selectedWildType.add(wildType[i].name);
        }
      }
      for (int i = 0; i < commercialType.length; i++) {
        if (commercialType[i].selected) {
          selectedCommercialType.add(commercialType[i].name);
        }
      }
      for (int i = 0; i < nearbyService.length; i++) {
        if (nearbyService[i].selected) {
          selectedNearbyService.add(nearbyService[i].name);
        }
      }
      for (int i = 0; i < nearbyActivity.length; i++) {
        if (nearbyActivity[i].selected) {
          selectedNearbyActivities.add(nearbyActivity[i].name);
        }
      }

      List mergedList = selectedWildType +
          selectedCommercialType +
          selectedNearbyService +
          selectedNearbyActivities;

      for (int i = 0; i < response.length; i++) {
        var responseData = response[i];

        if (selectedWildType.isEmpty &&
            selectedCommercialType.isEmpty &&
            selectedNearbyService.isEmpty &&
            selectedNearbyActivities.isEmpty) {
          placesList.add(SaunaPlaceModel.fromJson(responseData));
        } else {
          for (int i = 0; i < mergedList.length; i++) {
            if (responseData['wild_location'].contains(mergedList[i])) {
              placesList.add(SaunaPlaceModel.fromJson(responseData));
            } else if (responseData['commercial_location']
                .contains(mergedList[i])) {
              placesList.add(SaunaPlaceModel.fromJson(responseData));
            } else if (responseData['nearby_service'].contains(mergedList[i])) {
              placesList.add(SaunaPlaceModel.fromJson(responseData));
            } else if (responseData['nearby_activity']
                .contains(mergedList[i])) {
              placesList.add(SaunaPlaceModel.fromJson(responseData));
            }
          }
        }
      }

      //sort place based on which one is closer
      placesList.sort((a, b) {
        final distanceA = Geolocator.distanceBetween(
          selectedPlaceGeometry?.location?.lat ?? 0.0,
          selectedPlaceGeometry?.location?.lng ?? 0.0,
          a.lattitude,
          a.longitude,
        );
        final distanceB = Geolocator.distanceBetween(
          selectedPlaceGeometry?.location?.lat ?? 0.0,
          selectedPlaceGeometry?.location?.lng ?? 0.0,
          b.lattitude,
          b.longitude,
        );
        return distanceA.compareTo(distanceB);
      });

      // placesList.sort((a, b) => a.lattitude.compareTo(b.lattitude));

      addMultipleMarkers();

      addCurrentPlaceMarker(
        lat: selectedPlaceGeometry?.location?.lat ?? 0.0,
        long: selectedPlaceGeometry?.location?.lng ?? 0.0,
      );

      if (placesList.isEmpty) {
        setShowHorizontalCard(false);
      } else {
        setShowHorizontalCard(true);
      }
    } catch (e) {
      showSnackBar(context, 'Failed to load sauna places', Colors.red);
      print('$e');
    } finally {
      setLoadingFalse();
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    showSearchAreaButton = true;
    ever(_controllerReady, (ready) {
      if (ready) {
        getCurrentLocation();
      }
    });
    update();
  }

  @override
  void onMapCreated(GoogleMapController mapController) {
    controller = mapController;
    _controllerReady.value = true;
    loadSaunaPlaces();
    update();
  }

  @override
  void onClose() {
    controller.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> getCurrentLocation() async {
    try {
      print('Starting location request process...');
      
      // 1. Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print('Location services enabled: $serviceEnabled');
      
      if (!serviceEnabled) {
        Get.snackbar(
          'Location Services Disabled',
          'Please enable location services in your device settings.',
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[900],
          duration: const Duration(seconds: 4),
          mainButton: TextButton(
            onPressed: () async {
              await Geolocator.openLocationSettings();
            },
            child: const Text('Open Settings'),
          ),
        );
        return;
      }

      // 2. Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      print('Current permission status: $permission');
      
      if (permission == LocationPermission.denied) {
        print('Permission denied, requesting permission...');
        permission = await Geolocator.requestPermission();
        
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Permission Denied',
            'Location permission is required to show your location.',
            backgroundColor: Colors.red[100],
            colorText: Colors.red[900],
            duration: const Duration(seconds: 4),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permission Permanently Denied',
          'Please enable location permission in app settings.',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
          duration: const Duration(seconds: 4),
          mainButton: TextButton(
            onPressed: () async {
              await Geolocator.openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        );
        return;
      }

      print('Getting current position...');
      // 3. Get current position with timeout
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        ).timeout(const Duration(seconds: 10));
      } on TimeoutException {
        print('Location request timed out');
        throw 'Location request timed out. Please try again.';
      }

      print('Position received: ${position.latitude}, ${position.longitude}');

      // 4. Check if controller is ready and not disposed
      if (!isClosed && controller != null && _controllerReady.value) {
        print('Moving camera to current location...');
        await controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15,
            ),
          ),
        );
        print('Camera moved successfully');
      } else {
        print('Controller not ready: isClosed=$isClosed, controller=${controller != null}, ready=${_controllerReady.value}');
      }

    } catch (e, stackTrace) {
      print('Error getting location: $e');
      print('Stack trace: $stackTrace');
      
      String errorMessage = 'Unable to get your location.';
      if (e is String && e.contains('timed out')) {
        errorMessage = e;
      } else if (e is PermissionDeniedException) {
        errorMessage = 'Location permission denied. Please check your settings.';
      } else if (e is LocationServiceDisabledException) {
        errorMessage = 'Location services are disabled. Please enable them in settings.';
      }

      Get.snackbar(
        'Location Error',
        errorMessage,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
        mainButton: TextButton(
          onPressed: () => getCurrentLocation(),
          child: const Text('Retry'),
        ),
      );
    }
  }

  Future<void> searchInCurrentArea(BuildContext context) async {
    try {
      setLoadingTrue();
      showSearchAreaButton = false;
      update();

      // Get visible region bounds
      final visibleRegion = await controller.getVisibleRegion();
      print('Searching in bounds: NE(${visibleRegion.northeast.latitude}, ${visibleRegion.northeast.longitude}), SW(${visibleRegion.southwest.latitude}, ${visibleRegion.southwest.longitude})');
      _lastSearchBounds = visibleRegion;

      // Query database
      print('Querying database for saunas...');
      final saunaPlaces = await dbClient
          .from('sauna_locations')
          .select()
          .eq('is_approved', true)
          .gte('latitude', visibleRegion.southwest.latitude)
          .lte('latitude', visibleRegion.northeast.latitude)
          .gte('longitude', visibleRegion.southwest.longitude)
          .lte('longitude', visibleRegion.northeast.longitude);

      print('Query result: Found ${saunaPlaces.length} saunas');

      markers.clear();

      if (saunaPlaces.isEmpty) {
        print('No saunas found in the visible area');
        Get.snackbar(
          'No Results',
          'No saunas found in this area. Try zooming out or moving to a different location.',
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[900],
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Add markers for found saunas
      for (var sauna in saunaPlaces) {
        print('Processing sauna: ${sauna['id']} at ${sauna['latitude']}, ${sauna['longitude']}');
        
        if (sauna['latitude'] != null && sauna['longitude'] != null) {
          try {
            final customIcon = await CustomMarkerHelper.getMarkerIcon(sauna['sauna_type']);
            
            final position = LatLng(
              double.parse(sauna['latitude'].toString()),
              double.parse(sauna['longitude'].toString()),
            );

            final marker = Marker(
              markerId: MarkerId(sauna['id'].toString()),
              position: position,
              icon: customIcon,
              infoWindow: InfoWindow(
                title: sauna['sauna_type'] ?? 'Sauna',
                snippet: sauna['description'] ?? 'No description available',
              ),
              onTap: () {
                showSaunaDetails(SaunaPlaceModel.fromJson(sauna));
              },
            );
            
            markers.add(marker);
            print('Added marker for sauna ${sauna['id']}');
          } catch (e) {
            print('Error creating marker for sauna ${sauna['id']}: $e');
          }
        }
      }

      print('Successfully added ${markers.length} markers');
      Get.snackbar(
        'Success',
        'Found ${saunaPlaces.length} saunas in this area',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        duration: const Duration(seconds: 2),
      );
      
      update();
    } catch (e, stackTrace) {
      print('Error searching sauna places: $e');
      print('Stack trace: $stackTrace');
      Get.snackbar(
        'Search Error',
        'Unable to search for saunas. Please check your internet connection and try again.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 3),
      );
    } finally {
      setLoadingFalse();
    }
  }

  void onCameraMove(CameraPosition position) {
    _lastCameraPosition = position;
    _isMoving = true;

    // Hide search area button while moving
    if (showSearchAreaButton) {
      showSearchAreaButton = false;
      update();
    }
  }

  void onCameraIdle(BuildContext context) async {
    _isMoving = false;

    // Show search button when camera stops moving
    if (_lastCameraPosition != null) {
      final visibleRegion = await controller.getVisibleRegion();
      final northeast = visibleRegion.northeast;
      final southwest = visibleRegion.southwest;

      // Always show search button when camera stops
      showSearchAreaButton = true;
      update();
    }
  }

  bool _isSameArea(LatLng northeast, LatLng southwest) {
    if (_lastSearchBounds == null) return false;

    const tolerance = 0.001; // About 100 meters tolerance
    return (northeast.latitude - _lastSearchBounds!.northeast.latitude).abs() < tolerance &&
           (northeast.longitude - _lastSearchBounds!.northeast.longitude).abs() < tolerance &&
           (southwest.latitude - _lastSearchBounds!.southwest.latitude).abs() < tolerance &&
           (southwest.longitude - _lastSearchBounds!.southwest.longitude).abs() < tolerance;
  }

  Future<void> launchMapsUrl(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar(
        'Error',
        'Could not open maps',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }

  Future<BitmapDescriptor> createCustomMarkerBitmap() async {
    const double size = 120; // Size of the marker icon
    
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blue; // Solid blue color
    
    // Draw circle background
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2,
      paint,
    );
    
    // Add text "S"
    const TextSpan span = TextSpan(
      text: 'S',
      style: TextStyle(
        fontSize: 80,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
    
    final TextPainter painter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    
    painter.layout();
    painter.paint(
      canvas,
      Offset(
        (size - painter.width) / 2,
        (size - painter.height) / 2,
      ),
    );
    
    final image = await pictureRecorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  void showSaunaDetails(SaunaPlaceModel sauna) {
    // Set the selected sauna place
    Get.find<FindNearSaunaController>().setSelectedSaunaPlace(sauna);
    // Navigate to the dark-themed details page
    Get.to(() => const SaunaPlaceDetailsPage());
  }
}
