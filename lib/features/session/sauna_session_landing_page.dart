import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/auth/controller/profile_controller.dart';
import 'package:portasauna/features/session/add_sauna_session_page.dart';
import 'package:portasauna/features/session/sauna_session_tab.dart';
import 'package:portasauna/features/session/sauna_stats_tab.dart';

class SaunaSessionLandingPage extends StatefulWidget {
  const SaunaSessionLandingPage({super.key});

  @override
  State<SaunaSessionLandingPage> createState() => _PracticePageState();
}

class _PracticePageState extends State<SaunaSessionLandingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  int tabIndex = 0;

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        tabIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          onTap: (value) {
            tabIndex = value;
          },

          labelColor: Pallete.primarColor,
          unselectedLabelColor: Pallete.greyColor,
          indicatorColor: Pallete.primarColor,
          // unselectedLabelStyle: TextUtils.paragraph2(context: context),
          // labelStyle: TextUtils.paragraph2(context: context),
          // dividerColor: Colors.transparent,
          isScrollable: false,
          // tabAlignment: TabAlignment.start,
          controller: _tabController,
          tabs: const [
            Tab(text: "Sessions"),
            Tab(text: "Stats"),
          ],
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        gapH(3),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  clipBehavior: Clip.none,
                  child: Container(
                    child: [
                      const SaunaSessionTab(),
                      const SaunaStatsTab()
                    ][tabIndex],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
      floatingActionButton: InkWell(
        onTap: () {
          final pc = Get.find<ProfileController>();
          if (!pc.isLoggedIn) {
            showSnackBar(
                context, 'Please login to track your session', Colors.red);
            return;
          }

          Get.to(const AddSaunaSessionPage());
        },
        child: Container(
            height: 55.h,
            width: 190.w,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
                color: Pallete.primarColor,
                borderRadius: BorderRadius.circular(100)),
            child: Row(
              children: [
                const Icon(Icons.add_circle_outline),
                gapW(10),
                Text(
                  'Add session',
                  style: Theme.of(context).textTheme.titleMedium,
                )
              ],
            )),
      ),
    );
  }
}
