import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/features/discover/controller/map_controller.dart';

class SearchAreaButton extends StatelessWidget {
  const SearchAreaButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapController>(
      builder: (mc) {
        if (!mc.showSearchAreaButton) return const SizedBox.shrink();
        
        return Positioned(
          top: 180.h, // Adjusted position to be more visible
          left: 16.w,
          right: 16.w,
          child: Center(
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
              child: InkWell(
                onTap: () => mc.searchInCurrentArea(context),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search,
                        size: 20.sp,
                        color: Pallete.primarColor,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Search this area',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Pallete.primarColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
