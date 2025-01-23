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
          top: 135.h,  
          right: 25.w, 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Material(
                  elevation: 0,
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _toggleExpanded,
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                      padding: EdgeInsets.all(12.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Icon(
                        Icons.layers,
                        size: 24.h,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ),
              ),
              if (_isExpanded)
                Container(
                  margin: EdgeInsets.only(top: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Column(
                    children: [
                      _MapTypeButton(
                        title: 'Standard',
                        isSelected: mc.currentMapType == MapType.normal,
                        onTap: () {
                          mc.setMapType(MapType.normal);
                          _toggleExpanded();
                        },
                      ),
                      _MapTypeButton(
                        title: 'Satellite',
                        isSelected: mc.currentMapType == MapType.satellite,
                        onTap: () {
                          mc.setMapType(MapType.satellite);
                          _toggleExpanded();
                        },
                      ),
                      _MapTypeButton(
                        title: 'Terrain',
                        isSelected: mc.currentMapType == MapType.terrain,
                        onTap: () {
                          mc.setMapType(MapType.terrain);
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
  final bool isSelected;
  final VoidCallback onTap;

  const _MapTypeButton({
    required this.title,
    required this.isSelected,
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
              color: isSelected ? Colors.blue : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
