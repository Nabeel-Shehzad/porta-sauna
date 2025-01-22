import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/constants/api_const.dart';
import 'package:portasauna/core/constants/assets_const.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/helper.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/show_image.dart';
import 'package:portasauna/admin/widgets/widget_helper.dart';
import 'package:portasauna/features/auth/controller/profile_controller.dart';
import 'package:portasauna/features/auth/presentation/login_page.dart';
import 'package:portasauna/features/profile/delete_account_page.dart';
import 'package:portasauna/features/profile/edit_profile_page.dart';
import 'package:portasauna/features/settings/widgets/settings_helper.dart';

class SettingsMenuPage extends StatelessWidget {
  const SettingsMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (pc) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                gapH(30),

                pc.isLoggedIn
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ShowImage(
                            height: 100.h,
                            width: 100.h,
                            imgLocation:
                                pc.userDetails?.profileImg ?? defaultUserImage,
                            isAssetImg: false,
                            radius: 100.sp,
                          ),
                          gapH(20),
                          Text(
                            pc.userDetails?.name ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontSize: 20.h),
                          ),
                        ],
                      )
                    : Container(
                        alignment: Alignment.center,
                        height: 190.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Login to unlock full feature of the app',
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                            gapH(25),
                            ButtonPrimary(
                              text: 'Login',
                              width: 200.w,
                              bgColor: Pallete.primarColor,
                              onPressed: () {
                                Get.to(const LoginPage());
                              },
                            )
                          ],
                        ),
                      ),

                gapH(30),
                //=================>
                //=================>
                if (pc.isLoggedIn)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      ListTile(
                        title: Text(
                          'Edit profile',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 20.h,
                        ),
                        onTap: () {
                          Get.to(EditProfilePage(
                            userName: pc.userDetails?.name ?? "",
                          ));
                        },
                      ),
                    ],
                  ),

                //=================>
                //=================>
                const Divider(),
                ListTile(
                  title: Text(
                    'Privacy & Terms',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 20.h,
                  ),
                  onTap: () {
                    goToUrl(ApiConst.privacyLink);
                  },
                ),

                //=================>
                //=================>
                if (pc.isLoggedIn)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //=================>
                      //=================>
                      const Divider(),
                      ListTile(
                        title: Text(
                          'Delete my account',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 20.h,
                        ),
                        onTap: () {
                          Get.to(const DeleteAccountPage());
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
                          Get.defaultDialog(
                              backgroundColor: Colors.grey[900],
                              title: '',
                              content: logoutPopup(context: context));
                        },
                      ),

                      //========================>
                      //Admin area
                      //========================>
                      const Divider(),
                      ListTile(
                        title: Text(
                          'Admin area',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 20.h,
                        ),
                        onTap: () {
                          Get.defaultDialog(
                              backgroundColor: Colors.grey[900],
                              title: '',
                              content: adminAreaPopup(context: context));
                        },
                      ),
                    ],
                  ),
                const Divider(),

                //=================>
                //Version
                //=================>

                gapH(40),
                ShowImage(
                    height: 65.h,
                    width: double.infinity,
                    fit: BoxFit.fitHeight,
                    imgLocation: AssetsConst.logoWhiteJustP,
                    isAssetImg: true),

                gapH(15),
                Text(
                  'Version: 1.3',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey[400]),
                ),
                gapH(30),
              ],
            ),
          ),
        ),
      );
    });
  }
}
