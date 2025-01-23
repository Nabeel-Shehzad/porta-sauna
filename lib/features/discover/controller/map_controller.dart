// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:longitude_and_latitude_calculator/longitude_and_latitude_calculator.dart';
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
  GoogleMapController? controller;  
  final searchController = TextEditingController();
  final controllerReady = false.obs;  
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
              setSelectedSauna(placesList[i]);
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

  Future<LatLng> getCurrentCameraTarget() async {
    if (controller != null) {
      final bounds = await controller!.getVisibleRegion();
      // Get center point of visible region
      return LatLng(
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2
      );
    }
    return LatLng(defaultLat!, defaultLong!);
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

  searchPlace({required placeName}) async {
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
      {required placeName, bool animateCamera = true, bool clearMarkers = false}) async {
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
    update();
  }

  void onMapCreated(GoogleMapController mapController) async {
    try {
      controller = mapController;
      controllerReady.value = true;
      update();
      
      // Wait for map to be ready
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Get initial location and load saunas
      final position = await getCurrentLocation();
      if (position != null) {
        await moveCamera(
          LatLng(position.latitude, position.longitude),
          zoom: 12,
        );
      }
      
      // Load initial saunas
      await getSaunaPlacesOnMap(Get.context!, addCurrentLocation: true);
    } catch (e) {
      print('Error in onMapCreated: $e');
      if (Get.context != null) {
        showSnackBar(Get.context!, 'Error initializing map', Pallete.redColor);
      }
    }
  }

  // Selected sauna for showing in bottom card
  SaunaPlaceModel? selectedSauna;
  
  void setSelectedSauna(SaunaPlaceModel? sauna) {
    selectedSauna = sauna;
    setShowHorizontalCard(true);
    update();
  }

  void hideBottomCard() {
    selectedSauna = null;
    setShowHorizontalCard(false);
    update();
  }

  void addSaunaMarker(SaunaPlaceModel sauna) async {
    if (sauna.lattitude != null && sauna.longitude != null) {
      bool isFree = sauna.selectedWildType != null && 
                    sauna.selectedWildType!.isNotEmpty;
      String? locationType = isFree ? 
          sauna.selectedWildType?.first : 
          sauna.selectedCommercialType?.first;

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
          infoWindow: InfoWindow(
            title: isFree ? 
              "Free Sauna Spot | ${locationType ?? ''}" :
              "Commercial | ${locationType ?? ''}",
            snippet: sauna.description ?? '',
          ),
          icon: customIcon,
          onTap: () {
            setSelectedSauna(sauna);
          },
        ),
      );
    }
  }

  Future<void> getSaunaPlacesOnMap(BuildContext context, {bool addCurrentLocation = false}) async {
    try {
      if (controller == null || !controllerReady.value) {
        print('Map controller not ready yet');
        return;
      }

      final bounds = await controller!.getVisibleRegion();
      final center = await getCurrentCameraTarget();
      
      if (_lastSearchBounds != null && _isSameArea(bounds.northeast, bounds.southwest)) {
        return;
      }
      _lastSearchBounds = bounds;

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
            final currentLocationIcon = await CustomMarkerHelper.createCustomMarker(
              color: Colors.red,
            );
            markers.add(
              Marker(
                markerId: const MarkerId('current_location'),
                position: LatLng(position.latitude, position.longitude),
                icon: currentLocationIcon,
                infoWindow: const InfoWindow(
                  title: 'Your Location',
                ),
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
            continue;
          }
        }

        setShowHorizontalCard(placesList.isNotEmpty);
        if (placesList.isNotEmpty) {
          print('✅ Successfully loaded ${placesList.length} saunas');
          showSnackBar(context, 'Found ${placesList.length} saunas in this area', Colors.green);
        } else {
          setShowHorizontalCard(false);
          showSnackBar(context, 'No sauna spots found in this area', Colors.orange);
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

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  Future<void> searchInCurrentArea(BuildContext context) async {
    try {
      setLoadingTrue();
      showSearchAreaButton = false;
      
      // Get current visible region bounds
      final bounds = await controller!.getVisibleRegion();
      _lastSearchBounds = bounds;
      
      print('🔍 Searching in bounds: ${bounds.toString()}');

      // Query Supabase for saunas in this area - using only columns that exist in the schema
      final response = await dbClient
          .from('sauna_locations')
          .select('''
            id,
            created_at,
            latitude,
            longitude,
            wild_location,
            commercial_location,
            nearby_service,
            nearby_activity,
            description,
            img_links,
            user_id,
            address,
            is_approved,
            zip_code,
            commercial_phone,
            checked_in_users
          ''')
          .gte('latitude', bounds.southwest.latitude)
          .lte('latitude', bounds.northeast.latitude)
          .gte('longitude', bounds.southwest.longitude)
          .lte('longitude', bounds.northeast.longitude)
          .eq('is_approved', true);

      print('📍 Found ${response.length} saunas in this area');

      // Clear existing places and markers
      placesList.clear();
      markers.clear();

      // Process results
      if (response.isNotEmpty) {
        for (var place in response) {
          try {
            // Determine the marker type based on location type
            String markerType = place['commercial_location'] == true ? 'commercial' : 
                              place['wild_location'] == true ? 'wild' : 'default';
            
            final saunaPlace = SaunaPlaceModel.fromJson(place);
            placesList.add(saunaPlace);
            
            // Add marker for this place
            if (saunaPlace.lattitude != null && saunaPlace.longitude != null) {
              // Determine if it's a free or commercial sauna
              bool isFree = saunaPlace.selectedWildType != null && 
                           saunaPlace.selectedWildType!.isNotEmpty;
              String? locationType = isFree ? 
                  saunaPlace.selectedWildType?.first : 
                  saunaPlace.selectedCommercialType?.first;

              final customIcon = await CustomMarkerHelper.createCustomMarker(
                color: isFree ? const Color(0xFF5ce65c) : Colors.blue,
              );

              markers.add(
                Marker(
                  markerId: MarkerId(saunaPlace.id.toString()),
                  position: LatLng(
                    double.parse(saunaPlace.lattitude.toString()),
                    double.parse(saunaPlace.longitude.toString()),
                  ),
                  infoWindow: InfoWindow(
                    title: isFree ? 
                      "Free Sauna Spot | ${locationType ?? ''}" :
                      "Commercial | ${locationType ?? ''}",
                    snippet: saunaPlace.description ?? '',
                  ),
                  icon: customIcon,
                  onTap: () {
                    setSelectedSauna(saunaPlace);
                  },
                ),
              );
            }
          } catch (e) {
            print('Error processing sauna: $e');
          }
        }
        
        // Show the horizontal card if places were found
        setShowHorizontalCard(true);
        
        print('✅ Successfully loaded ${placesList.length} saunas');
        showSnackBar(context, 'Found ${placesList.length} saunas in this area', Colors.green);
      } else {
        setShowHorizontalCard(false);
        showSnackBar(context, 'No sauna spots found in this area', Colors.orange);
      }
    } catch (e) {
      print('❌ Error searching area: $e');
      showSnackBar(context, 'Error searching this area', Colors.red);
    } finally {
      setLoadingFalse();
      update();
    }
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
}
