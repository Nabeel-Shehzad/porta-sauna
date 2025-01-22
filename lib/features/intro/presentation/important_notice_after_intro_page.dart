import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/features/auth/presentation/login_page.dart';

class ImportantNoticeAfterIntroPage extends StatelessWidget {
  const ImportantNoticeAfterIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarCommon('', context),
      body: SingleChildScrollView(
        child: Container(
          padding: screenPaddingH,
          child: Column(
            children: [
              Text(
                'Important Notice',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 24.h,
                    ),
              ),
              gapH(25),
              Text(
                "The PortaSauna app and associated features are not designed for use in high-temperature environments, including saunas. Prolonged exposure of electronic devices, such as smartwatches, to high temperatures may result in damage to the device and pose health risks.",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 17.h),
              ),
              gapH(20),
              Text(
                "We strongly recommend removing your smartwatch or covering it with a cooling wrap or protective accessory before entering the sauna. If you choose to use this app in a sauna, you do so at your own risk.",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 17.h),
              ),
              gapH(20),
              Text(
                "Please ensure you regularly monitor your device's temperature and immediately discontinue use if you observe any signs of overheating.",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 17.h),
              ),
              gapH(30),
              ButtonPrimary(
                  text: 'I understand',
                  bgColor: Pallete.primarColor,
                  onPressed: () {
                    Get.to(const LoginPage());
                  })
            ],
          ),
        ),
      ),
    );
  }
}
