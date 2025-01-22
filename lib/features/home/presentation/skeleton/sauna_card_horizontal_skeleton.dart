import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portasauna/features/home/presentation/widgets/home_cards.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/utils/ui_const.dart';

class SaunaCardHorizontalSkeleton extends StatelessWidget {
  const SaunaCardHorizontalSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Container(
        padding: screenPaddingH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sauna spots around you',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 22.h,
                  ),
            ),
            gapH(32),
            SizedBox(
              height: 290.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                clipBehavior: Clip.none,
                children: [
                  const HomeCards(
                    imgLink:
                        "https://img.freepik.com/premium-vector/scenic-sunset-illustration-with-river_104785-513.jpg",
                    title: 'New york, beach',
                  ),
                  gapW(25),
                  const HomeCards(
                    imgLink:
                        "https://img.freepik.com/premium-vector/flat-nature-fluid-background-pro-vector_636253-24.jpg",
                    title: 'New york, forest',
                  ),
                  gapW(25),
                  const HomeCards(
                    imgLink:
                        "https://img.freepik.com/free-vector/flat-design-mountain-landscape_23-2149154926.jpg",
                    title: 'Others',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
