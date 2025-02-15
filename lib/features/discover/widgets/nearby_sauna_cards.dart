import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/helper.dart';
import 'package:portasauna/features/discover/controller/map_controller.dart';
import 'package:portasauna/features/discover/presentation/sauna_place_details_page.dart';
import 'package:portasauna/features/discover/utils/scroll_manager.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';

class NearbySaunaCards extends StatefulWidget {
  const NearbySaunaCards({super.key});

  @override
  State<NearbySaunaCards> createState() => _NearbySaunaCardsState();
}

class _NearbySaunaCardsState extends State<NearbySaunaCards> {
  @override
  void initState() {
    super.initState();
    ScrollManager.horizontalScrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    ScrollManager.horizontalScrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!ScrollManager.horizontalScrollController.hasClients) return;
    
    // Get the position of the scroll view
    final scrollPosition = ScrollManager.horizontalScrollController.position;
    final viewportWidth = scrollPosition.viewportDimension;
    final scrollOffset = scrollPosition.pixels;

    // Calculate which card is most visible
    final cardWidth = Get.width * 0.92 + 12.0; // card width + margin
    final visibleIndex = (scrollOffset + (viewportWidth / 2)) ~/ cardWidth;

    // Get the MapController
    final mc = Get.find<MapController>();
    if (visibleIndex >= 0 && visibleIndex < mc.placesList.length) {
      mc.setSelectedSauna(mc.placesList[visibleIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapController>(
      builder: (mc) {
        if (mc.placesList.isEmpty) return const SizedBox();
        
        return Positioned(
          bottom: 25.h,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 190.h, 
            child: ListView.builder(
              controller: ScrollManager.horizontalScrollController,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: mc.placesList.length,
              itemBuilder: (context, index) {
                final place = mc.placesList[index];
                final isSelected = mc.selectedSauna?.id == place.id;
                
                return GestureDetector(
                  onTap: () {
                    Get.find<FindNearSaunaController>()
                        .setSelectedSaunaPlace(place);
                    Get.to(() => const SaunaPlaceDetailsPage());
                  },
                  child: Container(
                    width: Get.width * 0.92,
                    margin: EdgeInsets.only(right: 12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                      border: isSelected ? Border.all(
                        color: Pallete.primarColor,
                        width: 2,
                      ) : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 110.h,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(getLocationImage(place.imgLinks)),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.3),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8.h,
                                right: 8.w,
                                child: Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.star_border,
                                    color: Colors.white,
                                    size: 18.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 8.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  place.address ?? '',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.lightBlue[300], 
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  place.description ?? '',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.grey[400], 
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
