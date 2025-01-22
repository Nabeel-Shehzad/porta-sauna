import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portasauna/core/constants/assets_const.dart';
import 'package:portasauna/core/controllers/prefs_controller.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/show_image.dart';
import 'package:portasauna/admin/features/all_place/admin_all_place_page.dart';
import 'package:portasauna/admin/features/modify_place/presentation/admin_modification_requested_place_page.dart';
import 'package:portasauna/features/auth/presentation/login_page.dart';
import 'package:portasauna/features/intro/presentation/splash_page.dart';

class AdminDrawerPage extends StatelessWidget {
  const AdminDrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.w,
      child: Drawer(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 180.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ShowImage(
                      height: 65.h,
                      width: double.infinity,
                      fit: BoxFit.fitHeight,
                      imgLocation: AssetsConst.logoWhiteJustP,
                      isAssetImg: true),
                ],
              ),
            ),
            gapH(30),
            //========================>
            //All place
            //========================>
            const Divider(),
            ListTile(
              title: Text(
                'All places',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20.h,
              ),
              onTap: () {
                Get.to(const AdminAllPlacePage());
              },
            ),

            //========================>
            //See modify requested place
            //========================>
            const Divider(),
            ListTile(
              title: Text(
                'Modification requests',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20.h,
              ),
              onTap: () {
                Get.to(const AdminModificationRequestedPlacePage());
              },
            ),

            //========================>
            //User area
            //========================>
            const Divider(),
            ListTile(
              title: Text(
                'Go to user app',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20.h,
              ),
              onTap: () {
                PrefsController.setLoginAsAdmin = false;
                Get.offAll(const SplashPage());
              },
            ),

            //========================>
            //Logout
            //========================>
            const Divider(),
            ListTile(
              title: Text(
                'Logout',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20.h,
              ),
              onTap: () {
                PrefsController.setLoginAsAdmin = false;
                Get.offAll(const LoginPage());
              },
            ),
            const Divider(),

            gapH(30.h)
          ],
        ),
      )),
    );
  }
}
