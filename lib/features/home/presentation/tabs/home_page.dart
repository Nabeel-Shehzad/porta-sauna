import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/features/home/controller/landing_controller.dart';
import 'package:portasauna/features/home/presentation/widgets/home_header.dart';
import 'package:portasauna/features/home/presentation/widgets/sauna_spots_around_you.dart';
import 'package:portasauna/features/home/presentation/widgets/home_extra_section.dart';
import 'package:portasauna/features/home/presentation/widgets/buy_sauna_product_card.dart';
import 'package:portasauna/features/home/presentation/widgets/home_current_month_sessions.dart';

import '../../../../core/widgets/show_image.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gapH(10),

              //=============>
              // Header
              //=============>
              const HomeHeader(),

              gapH(32),
              //====================>
              //Current month sauna
              //====================>
              Container(
                  padding: screenPaddingH,
                  child: const HomeCurrentMonthSessions()),

              //====================>
              // Horizontal cards
              //====================>
              gapH(20),

              const SaunaSpotsAroundYou(),

              gapH(32),
              //Add location
              Container(
                padding: screenPaddingH,
                child: InkWell(
                  onTap: () {
                    final lc = Get.find<LandingController>();
                    lc.setSelectedIndex(2);
                  },
                  child: ShowImage(
                    radius: 10,
                    imgLocation: 'assets/images/add_location.png',
                    isAssetImg: true,
                    width: Get.width,
                    height: 70.w,
                  ),
                ),
              ),

              gapH(32),

              //===================
              //buy sauna products
              //===================
              Container(
                  padding: screenPaddingH, child: const BuySaunaProductCard()),

              gapH(32),
              const HomeExtraSection(),

              gapH(32),
            ],
          ),
        ),
      ),
    );
  }
}
