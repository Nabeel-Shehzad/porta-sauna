import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class CustomMarkerHelper {
  static final Map<String, BitmapDescriptor> _markerCache = {};

  // Commercial place types from database
  static final List<String> _commercialTypes = [
    "Swimming Pool / Lido",
    "Outdoor Sports Centre",
    "Wellness Retreat",
    "Campsite",
    "Farm / Vineyard"
  ];

  // Wild/Free place types from database
  static final List<String> _wildTypes = [
    "Beach",
    "Riverside",
    "Picnic Area",
    "Secluded Park",
    "Lake Side",
    "Off-Road (4x4)"
  ];

  static Future<BitmapDescriptor> createCustomMarker({
    required Color color,
    double size = 120,
  }) async {
    print('Creating marker with color: $color');
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint()..color = color;
    
    // Draw circle background
    canvas.drawCircle(
      Offset(size / 2, size / 2),
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
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> getMarkerIcon(String? saunaType) async {
    // Convert saunaType to lowercase for case-insensitive comparison
    final type = saunaType?.trim() ?? '';
    print('Getting marker icon for sauna type: "$type"');
    
    // Check cache first
    if (_markerCache.containsKey(type)) {
      print('Using cached marker for type: $type');
      return _markerCache[type]!;
    }

    // Create marker based on type
    BitmapDescriptor marker;
    
    // Commercial places (BLUE)
    if (_commercialTypes.contains(type)) {
      print('Creating BLUE marker for commercial type: $type');
      marker = await createCustomMarker(color: Colors.blue);
    }
    // Wild/Free places (GREEN)
    else if (_wildTypes.contains(type)) {
      print('Creating GREEN marker for free/wild type: $type');
      marker = await createCustomMarker(color: Colors.green);
    }
    // Default (BLUE)
    else {
      print('Creating default BLUE marker for unknown type: $type');
      marker = await createCustomMarker(color: Colors.blue);
    }

    // Cache the marker
    _markerCache[type] = marker;
    return marker;
  }
}
