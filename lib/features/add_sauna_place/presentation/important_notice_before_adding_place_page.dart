import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/text_utils.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/features/add_sauna_place/presentation/add_sauna_place_type_page.dart';

class ImportantNoticeBeforeAddingPlacePage extends StatelessWidget {
  const ImportantNoticeBeforeAddingPlacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarCommon('', context),
      body: SingleChildScrollView(
        child: Container(
          padding: screenPaddingH,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Important',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 24.h,
                    ),
              ),
              gapH(20),
              Text(
                "I Agree to only add sauna locations to the app that are public with a right of way. Do not include illegal or unsafe locations, or areas where fires are restricted.",
                style: TextUtils.small1(context: context),
              ),
              gapH(30),

              //===================>
              //Section 2
              //===================>
              Text(
                'Sauna etiquette',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 24.h,
                    ),
              ),
              gapH(11),
              Text(
                'Be a responsible sauna user',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 17.h, fontWeight: FontWeight.w600),
              ),

              //===================>
              // Section 3
              // ==================>

              gapH(20),
              rowData(context,
                  title: "1. Respect the Location",
                  content:
                      "Ensure your campsite or outdoor spot permits sauna use. Always check in advance."),
              rowData(context,
                  title: "2. Keep Noise Down",
                  content:
                      "Enjoy the heat without disturbing others. Avoid loud voices and unnecessary noise."),
              rowData(context,
                  title: "3. Mind the Smoke",
                  content:
                      "Choose a spot where smoke won’t bother others, especially during busy times."),
              rowData(context,
                  title: "4. Respect Nearby Activities",
                  content:
                      "If anglers or others are nearby, be mindful not to disturb their experience."),
              rowData(context,
                  title: "5. Dispose of Ashes Properly",
                  content:
                      "Place cooled ashes in a bucket and dispose of them responsibly, or take them home."),
              rowData(context,
                  title: "6. Leave No Trace",
                  content:
                      "Take all your rubbish with you. Leave the area cleaner than you found it."),
              rowData(context,
                  title: "7. Share the Experience",
                  content:
                      "If someone is curious, invite them to join in and enjoy the PortaSauna!"),

              //===================>
              //Button
              //===================>
              gapH(20),
              ButtonPrimary(
                  text: 'I understand',
                  bgColor: Pallete.primarColor,
                  onPressed: () {
                    Get.to(const AddSaunaPlaceTypePage());
                  }),

              gapH(40),
            ],
          ),
        ),
      ),
    );
  }

  rowData(BuildContext context, {required title, required content}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title',
              style: TextUtils.small1(
                  context: context, fontWeight: FontWeight.w600)),
          gapH(10),
          Text(
            content,
            style: TextUtils.small1(context: context),
          ),
        ],
      ),
    );
  }
}
