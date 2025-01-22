import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/features/discover/controller/map_controller.dart';

class MapTypeSelector extends StatefulWidget {
  const MapTypeSelector({super.key});

  @override
  State<MapTypeSelector> createState() => _MapTypeSelectorState();
}

class _MapTypeSelectorState extends State<MapTypeSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapController>(
      builder: (mc) {
        return Positioned(
          top: 180.h,
          right: 50.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,
                  child: InkWell(
                    onTap: _toggleExpanded,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: Icon(
                        Icons.layers,
                        size: 20.sp,
                        color: Pallete.primarColor,
                      ),
                    ),
                  ),
                ),
              ),
              if (_isExpanded)
                Container(
                  margin: EdgeInsets.only(top: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _MapTypeButton(
                        title: 'Standard',
                        onTap: () {
                          Get.find<MapController>().setMapType(MapType.normal);
                          _toggleExpanded();
                        },
                      ),
                      const Divider(height: 1),
                      _MapTypeButton(
                        title: 'Satellite',
                        onTap: () {
                          Get.find<MapController>()
                              .setMapType(MapType.satellite);
                          _toggleExpanded();
                        },
                      ),
                      const Divider(height: 1),
                      _MapTypeButton(
                        title: 'Terrain',
                        onTap: () {
                          Get.find<MapController>().setMapType(MapType.terrain);
                          _toggleExpanded();
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _MapTypeButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _MapTypeButton({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          width: 120.w,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
