import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/features/discover/controller/map_controller.dart';

class DiscoverTopBar extends StatelessWidget {
  const DiscoverTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapController>(
      builder: (mc) => Positioned(
        top: 60.h,
        left: 16.w,
        right: 16.w,
        child: Row(
          children: [
            // Favorites Button
            _TopBarButton(
              icon: Icons.favorite_border,
              onTap: () {
                // TODO: Implement favorites functionality
              },
              label: 'Fav',
            ),
            SizedBox(width: 8.w),

            // Search Button
            Expanded(
              child: _TopBarButton(
                icon: Icons.search,
                onTap: () {
                  mc.toggleSearchBar();
                },
                label: 'Search sauna by location',
                isExpanded: true,
              ),
            ),
            SizedBox(width: 8.w),

            // Map Type Button
            _TopBarButton(
              icon: Icons.map,
              onTap: () {
                mc.toggleMapType();
              },
              label: 'Map',
            ),
            SizedBox(width: 8.w),

            // Filter Button
            _TopBarButton(
              icon: Icons.filter_list,
              onTap: () {
                mc.toggleFilterSheet(context);
              },
              label: 'Filter',
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String label;
  final bool isExpanded;

  const _TopBarButton({
    required this.icon,
    required this.onTap,
    required this.label,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isExpanded ? 16.w : 12.w,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            color: Pallete.whiteColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
            children: [
              Icon(icon, size: 20.h, color: Colors.grey[800]),
              if (isExpanded) ...[
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 14.h,
                          color: Colors.grey[600],
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              if (!isExpanded) ...[
                SizedBox(width: 4.w),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 14.h,
                        color: Colors.grey[800],
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
