// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:portasauna/core/bindings/init_dependencies.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/add_sauna_place/model/sauna_place_model.dart';
import 'package:portasauna/features/discover/controller/map_place_controller.dart';
import 'package:portasauna/features/discover/model/lat_long_from_place_model.dart';
import 'package:portasauna/features/discover/model/map_api_model.dart';
import 'package:portasauna/features/discover/presentation/sauna_place_details_page.dart';
import 'package:portasauna/features/discover/utils/scroll_manager.dart';
import 'package:portasauna/features/discover/utils/custom_marker_helper.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:portasauna/features/discover/widgets/discover_page_filter_content.dart';

class MapController extends GetxController {
  GoogleMapController? controller;
  final searchController = TextEditingController();
  final controllerReady = false.obs;
  bool showSearchAreaButton = false;
  bool isLoading = false;
  LatLngCustomModel? selectedPlaceLatLong;
  Geometry? selectedPlaceGeometry;
  double defaultLat = 55.3781;
  double defaultLong = 3.4360;
  final Set<Marker> markers = {};
  final Set<Marker> tempMarkers = {};
  bool markerPlacedOnMap = false;
  CameraPosition? _lastCameraPosition;
  bool _isMoving = false;
  LatLngBounds? _lastSearchBounds;
  bool showSearchBar = false;
  bool showFilterSheet = false;

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
    defaultLat = v?.lat ?? 55.3781;
    defaultLong = v?.lng ?? 3.4360;

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

  addOneMarker(
      {required double lat,
      required double long,
      String? title,
      String? subtitle,
      String? saunaType}) async {
    try {
      if (!isValidCoordinate(lat, long)) {
        print('Invalid coordinates: $lat, $long');
        return;
      }

      markers.clear();
      final customIcon = await CustomMarkerHelper.createCustomMarker(
        color: Colors.red, // Use red for new markers
      );

      markers.add(
        Marker(
          markerId:
              MarkerId('new_marker_${DateTime.now().millisecondsSinceEpoch}'),
          position: LatLng(lat, long),
          icon: customIcon,
          consumeTapEvents: true,
        ),
      );

      markerPlacedOnMap = true;
      update();

      // Move camera to the new marker
      await moveCamera(LatLng(lat, long), zoom: 15);
    } catch (e) {
      print('Error adding marker: $e');
    }
  }

  addCurrentPlaceMarker(
      {required double lat,
      required double long,
      String? title,
      String? subtitle}) async {
    if (!isValidCoordinate(lat, long)) {
      print('Invalid coordinates for current location: $lat, $long');
      return;
    }

    final customIcon = await CustomMarkerHelper.getMarkerIcon('current');
    markers.add(
      Marker(
        markerId: MarkerId('current_location'),
        position: LatLng(lat, long),
        icon: customIcon,
        consumeTapEvents: true,
      ),
    );
    update();
  }

  addMultipleMarkers() async {
    markers.clear();

    for (int i = 0; i < placesList.length; i++) {
      if (placesList[i].lattitude != null && placesList[i].longitude != null) {
        // Determine if it's a free or commercial sauna
        bool isFree = placesList[i].selectedWildType != null &&
            placesList[i].selectedWildType!.isNotEmpty;

        final customIcon = await CustomMarkerHelper.createCustomMarker(
          color: isFree
              ? const Color(0xFF5ce65c)
              : Colors.blue, // Green for free, blue for commercial
        );

        markers.add(
          Marker(
            markerId: MarkerId(placesList[i].id.toString()),
            position: LatLng(
              double.parse(placesList[i].lattitude.toString()),
              double.parse(placesList[i].longitude.toString()),
            ),
            icon: customIcon,
            onTap: () {
              setSelectedSauna(placesList[i]);
              // Get the card width and scroll to the corresponding card
              final cardWidth = Get.width * 0.92 + 12.0;
              ScrollManager.scrollToIndex(i, cardWidth);
            },
            consumeTapEvents: true,
          ),
        );
      }
    }
    update();
  }

  CameraPosition cameraPosition({double? zoom, double? lat, double? long}) {
    final latitude = lat ?? defaultLat;
    final longitude = long ?? defaultLong;

    return CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: zoom ?? 15,
    );
  }

  Future<LatLng> getCurrentCameraTarget() async {
    if (controller != null) {
      final bounds = await controller!.getVisibleRegion();
      // Get center point of visible region
      return LatLng((bounds.northeast.latitude + bounds.southwest.latitude) / 2,
          (bounds.northeast.longitude + bounds.southwest.longitude) / 2);
    }
    return LatLng(defaultLat, defaultLong);
  }

  Future<void> moveCamera(LatLng target, {double zoom = 15}) async {
    try {
      if (controller != null && controllerReady.value) {
        await controller!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: target,
              zoom: zoom,
            ),
          ),
        );
      } else {
        print('Map controller not ready for camera movement');
      }
    } catch (e) {
      print('Error moving camera: $e');
    }
  }

//==================>
//Searching a place on map
//==================>

  List<String> suggestedPlaces = [];

  makeSuggestedPlaceEmpty() {
    suggestedPlaces = [];
    showSearchAreaButton = true;
    update();
  }

  searchPlace({required String placeName}) async {
    if (placeName.isEmpty) {
      makeSuggestedPlaceEmpty();
      return;
    }

    showSearchAreaButton = false;
    suggestedPlaces = [];
    update();

    final suggestions = await Get.find<MapPlaceController>()
        .getPlaceSuggestion(placeName: placeName);

    final data = MapPredictionModel.fromJson(suggestions);

    for (int i = 0; i < data.predictions.length; i++) {
      suggestedPlaces.add(data.predictions[i].description ?? '');
    }

    update();
  }

  Future<bool> moveCameraToPlace(BuildContext context,
      {required String placeName,
      bool animateCamera = true,
      bool clearMarkers = false}) async {
    try {
      if (clearMarkers) {
        markers.clear();
        update();
      }

      final placeLatLong = await Get.find<MapPlaceController>()
          .getLatLongFromPlaceName(placeName: placeName);

      final latLongFromApi = LatLongFromPlaceModel.fromJson(placeLatLong);
      final lat = latLongFromApi.results[0].geometry?.location?.lat ?? 0;
      final long = latLongFromApi.results[0].geometry?.location?.lng ?? 0;

      setSelectedPlaceLatLong(latLongFromApi.results[0].geometry?.location);
      setSelectedPlaceGeometry(latLongFromApi.results[0].geometry);

      if (animateCamera) {
        await moveCamera(
          LatLng(lat, long),
          zoom: 13.0,
        );
      }

      // Wait for camera movement to complete
      await Future.delayed(const Duration(milliseconds: 500));
      await getSaunaPlacesOnMap(context, addCurrentLocation: false);
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

  void setShowHorizontalCard(bool show) {
    showHorizontalCard = show;
    showBottomNav = !show;
    selectedSauna = null;
    update();
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    this.controller = controller;
    controllerReady.value = true;
    update();

    // Load nearby sauna places
    await getSaunaPlacesOnMap(Get.context!);
  }

  // Selected sauna for showing in bottom card
  SaunaPlaceModel? selectedSauna;

  void setSelectedSauna(SaunaPlaceModel? sauna) {
    selectedSauna = sauna;
    if (sauna != null) {
      showHorizontalCard = true;
      showBottomNav = false;
    }
    update();
  }

  void hideBottomCard() {
    selectedSauna = null;
    setShowHorizontalCard(false);
    update();
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'Location Services Disabled',
          'Please enable location services in your device settings.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          mainButton: TextButton(
            onPressed: () async {
              await Geolocator.openLocationSettings();
            },
            child: const Text('OPEN SETTINGS',
                style: TextStyle(color: Colors.white)),
          ),
        );
        return null;
      }

      // Check location permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Location Permission Denied',
            'Please grant location permission to use this feature.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Location Permission Denied',
          'Location permissions are permanently denied. Please enable them in settings.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          mainButton: TextButton(
            onPressed: () async {
              await Geolocator.openAppSettings();
            },
            child: const Text('OPEN SETTINGS',
                style: TextStyle(color: Colors.white)),
          ),
        );
        return null;
      }

      // Get current position with timeout
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );
    } catch (e) {
      print('Error getting current location: $e');
      Get.snackbar(
        'Location Error',
        'Could not get your current location. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  bool isValidCoordinate(double? lat, double? long) {
    if (lat == null || long == null) return false;
    return lat >= -90 && lat <= 90 && long >= -180 && long <= 180;
  }

  void addSaunaMarker(SaunaPlaceModel sauna) async {
    try {
      if (!isValidCoordinate(double.tryParse(sauna.lattitude.toString()),
          double.tryParse(sauna.longitude.toString()))) {
        print('Invalid coordinates for sauna: ${sauna.id}');
        return;
      }

      bool isFree =
          sauna.selectedWildType != null && sauna.selectedWildType!.isNotEmpty;
      String? locationType = isFree
          ? sauna.selectedWildType?.first
          : sauna.selectedCommercialType?.first;

      final customIcon = await CustomMarkerHelper.createCustomMarker(
        color: isFree ? const Color(0xFF5ce65c) : Colors.blue,
      );

      markers.add(
        Marker(
          markerId: MarkerId(sauna.id.toString()),
          position: LatLng(
            double.parse(sauna.lattitude.toString()),
            double.parse(sauna.longitude.toString()),
          ),
          icon: customIcon,
          onTap: () {
            setSelectedSauna(sauna);
          },
          consumeTapEvents: true,
        ),
      );
      update();
    } catch (e) {
      print('Error adding marker for sauna ${sauna.id}: $e');
    }
  }

  Future<void> getSaunaPlacesOnMap(BuildContext context,
      {bool addCurrentLocation = false}) async {
    try {
      if (controller == null) {
        print('Map controller not initialized');
        return;
      }

      final bounds = await controller!.getVisibleRegion();
      setLoadingTrue();
      markers.clear();

      try {
        final saunaPlaces = await dbClient
            .from('sauna_locations')
            .select()
            .eq('is_approved', true)
            .gte('latitude', bounds.southwest.latitude)
            .lte('latitude', bounds.northeast.latitude)
            .gte('longitude', bounds.southwest.longitude)
            .lte('longitude', bounds.northeast.longitude);

        placesList.clear();

        if (addCurrentLocation) {
          final position = await getCurrentLocation();
          if (position != null) {
            final currentLocationIcon =
                await CustomMarkerHelper.createCustomMarker(
              color: Colors.red,
            );
            markers.add(
              Marker(
                markerId: const MarkerId('current_location'),
                position: LatLng(position.latitude, position.longitude),
                icon: currentLocationIcon,
                consumeTapEvents: true,
              ),
            );
          }
        }

        for (var place in saunaPlaces) {
          try {
            final saunaPlace = SaunaPlaceModel.fromJson(place);
            placesList.add(saunaPlace);
            addSaunaMarker(saunaPlace);
          } catch (e) {
            print('Error processing sauna: $e');
          }
        }

        if (placesList.isNotEmpty) {
          setShowHorizontalCard(true);
          print('✅ Successfully loaded ${placesList.length} saunas');
          showSnackBar(context,
              'Found ${placesList.length} saunas in this area', Colors.green);
        } else {
          setShowHorizontalCard(false);
          showSnackBar(
              context, 'No sauna spots found in this area', Colors.orange);
        }
      } catch (e) {
        print('Error fetching sauna places: $e');
        showSnackBar(context, 'Error fetching sauna places', Pallete.redColor);
      }
    } catch (e) {
      print('❌ Error in getSaunaPlacesOnMap: $e');
      showSnackBar(context, 'Error loading sauna places', Pallete.redColor);
    } finally {
      setLoadingFalse();
      update();
    }
  }

  Future<void> searchInCurrentArea(BuildContext context) async {
    try {
      setLoadingTrue();

      // Get the current visible region bounds
      if (controller != null) {
        final bounds = await controller!.getVisibleRegion();
        _lastSearchBounds = bounds;

        // Find saunas in this area
        await Get.find<FindNearSaunaController>().findNearSaunas(
          lat: bounds.northeast.latitude,
          long: bounds.northeast.longitude,
          radius: calculateRadius(bounds),
        );

        // Update markers on the map
        await addMultipleMarkers();

        // Show the horizontal cards
        setShowHorizontalCard(true);
      }

      setLoadingFalse();
      showSearchAreaButton = false;
      update();
    } catch (e) {
      setLoadingFalse();
      print('Error searching in area: $e');
    }
  }

  // Helper method to calculate search radius based on visible bounds
  double calculateRadius(LatLngBounds bounds) {
    final ne = bounds.northeast;
    final sw = bounds.southwest;

    // Calculate the diagonal distance in kilometers
    final latDiff = (ne.latitude - sw.latitude).abs();
    final lngDiff = (ne.longitude - sw.longitude).abs();

    // Use the larger difference to ensure we cover the visible area
    return math.max(latDiff, lngDiff) *
        111.0; // Convert degrees to kilometers (approx)
  }

  void showSaunaDetails(SaunaPlaceModel sauna) {
    Get.find<FindNearSaunaController>().setSelectedSaunaPlace(sauna);
    Get.to(() => const SaunaPlaceDetailsPage());
  }

  @override
  void onInit() {
    super.onInit();
    initializeMap();
  }

  @override
  void onClose() {
    controller?.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> initializeMap() async {
    try {
      final position = await getCurrentLocation();
      if (position != null) {
        defaultLat = position.latitude;
        defaultLong = position.longitude;
        update();
      }
    } catch (e) {
      print('Error initializing map: $e');
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
      final visibleRegion = await controller!.getVisibleRegion();
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
    return (northeast.latitude - _lastSearchBounds!.northeast.latitude).abs() <
            tolerance &&
        (northeast.longitude - _lastSearchBounds!.northeast.longitude).abs() <
            tolerance &&
        (southwest.latitude - _lastSearchBounds!.southwest.latitude).abs() <
            tolerance &&
        (southwest.longitude - _lastSearchBounds!.southwest.longitude).abs() <
            tolerance;
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

  void toggleSearchBar() {
    showSearchBar = !showSearchBar;
    if (!showSearchBar) {
      searchController.clear();
      makeSuggestedPlaceEmpty();
    }
    update();
  }

  void toggleFilterSheet(BuildContext context) {
    showFilterSheet = !showFilterSheet;
    if (showFilterSheet) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const DiscoverPageFilterContent(),
      );
    }
    update();
  }
}
