// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:portasauna/features/auth/controller/profile_controller.dart';
import 'package:portasauna/features/discover/presentation/discover_page.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';
import 'package:portasauna/features/home/controller/landing_controller.dart';
import 'package:portasauna/features/home/presentation/tabs/home_page.dart';
import 'package:portasauna/features/session/controller/fetch_sauna_session_controller.dart';
import 'package:portasauna/features/session/sauna_session_landing_page.dart';
import 'package:portasauna/features/settings/settings_menu_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key, this.loadLandingInit = true});

  final bool loadLandingInit;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final pc = Get.find<ProfileController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.loadLandingInit) return;
      Get.find<FindNearSaunaController>().getNearestSaunaLocation(context);
      initAtLandingPage();
    });

    super.initState();
  }

  initAtLandingPage() async {
    if (pc.isLoggedIn) {
      Future.delayed(const Duration(seconds: 1), () {
        Get.find<ProfileController>().getLoggedInUserDetails(context);
      });
      Get.find<FetchSaunaSessionController>()
          .fetchCurrentMonthSessions(context: context);
      Get.find<FetchSaunaSessionController>().fetchSessions(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    List widgetOptions = <Widget>[
      const HomePage(),
      const SaunaSessionLandingPage(),
      const DiscoverPage(),
      const SettingsMenuPage()
    ];

    return GetBuilder<LandingController>(builder: (lc) {
      return Scaffold(
        body: Center(
          child: widgetOptions.elementAt(lc.selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: const Color(0xff010002),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: const Color.fromARGB(255, 231, 231, 231),
                iconSize: 30.h,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey.withOpacity(.25),
                color: Colors.grey.withOpacity(.9),
                tabs: const [
                  GButton(
                    icon: Icons.home_outlined,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.calendar_month_outlined,
                    text: 'Record',
                  ),
                  GButton(
                    icon: Icons.location_on_outlined,
                    text: 'Discover',
                  ),
                  GButton(
                    icon: Icons.person_outline,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: lc.selectedIndex,
                onTabChange: (index) {
                  lc.setSelectedIndex(index);
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}
