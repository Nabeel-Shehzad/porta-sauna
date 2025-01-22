import 'package:app_version_update/app_version_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:portasauna/core/bindings/init_dependencies.dart';
import 'package:portasauna/core/theme/app_theme.dart';
import 'package:portasauna/core/widgets/common_widgets.dart';
import 'package:portasauna/features/intro/presentation/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAtStart();

  //turn off screen rotation
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    checkUpdate(context: context);
    return ScreenUtilInit(
        designSize: const Size(428, 926),
        builder: (_, __) {
          return GetMaterialApp(
            title: 'Where will you sauna?',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme,
            home: const SplashPage(),
          );
        });
  }

  checkUpdate({required BuildContext context}) async {
    // const appleId =
    //     '1234567890'; // If this value is null, its packagename will be considered
    // const playStoreId = '';
    await AppVersionUpdate.checkForUpdates(
      appleId: null,
      // playStoreId: playStoreId,
    ).then((data) async {
      if (data.canUpdate!) {
        updateAppPopup(context: context);
      }
    });
  }
}
