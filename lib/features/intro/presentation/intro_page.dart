import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:portasauna/core/constants/assets_const.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/widgets/show_image.dart';
import 'package:portasauna/features/intro/presentation/important_notice_after_intro_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    var pageDecoration = PageDecoration(
      bodyAlignment: Alignment.topCenter,
      titleTextStyle:
          Theme.of(context).textTheme.headlineSmall ?? const TextStyle(),
      bodyTextStyle: Theme.of(context).textTheme.bodySmall ?? const TextStyle(),
      pageColor: Pallete.backgroundColor,
      imagePadding: EdgeInsets.zero,
    );

    List<PageViewModel> pages = [
      PageViewModel(
        title: "PortaSauna Rules & Etiquette",
        body:
            "Please note that each sauna session may have its own specific rules regarding dress code, towel usage, conversation, and infusions. It’s important to familiarise yourself with these guidelines and understand before enjoying your session for the best experience for all",
        image: topImage(iconLocation: AssetsConst.rulesIconImg),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "Listern to your body",
        body:
            "If you start to feel uncomfortable during your sauna session, it’s important to step out and take a break. Rest, hydrate, and allow your body to recover before continuing. If the feeling continue consult a heathcare professional.",
        image: topImage(iconLocation: AssetsConst.bathIconImg),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "Hygiene Matters",
        body:
            "It's always a good idea to shower before entering the sauna. Please use a towel to sit on during your session to help protect the hygiene of yourself and other sauna users.",
        image: topImage(iconLocation: AssetsConst.showerIconImg),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "Stay Hydrated, Not Intoxicated",
        body:
            "For your safety, please avoid consuming alcohol before or during your sauna session. Be sure to drink plenty of water to stay hydrated.",
        image: topImage(iconLocation: AssetsConst.wineIconImg),
        decoration: pageDecoration,
      ),
    ];

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 90.h, bottom: 10.h),
        child: IntroductionScreen(
          pages: pages,
          showNextButton: true,
          showBackButton: true,
          dotsDecorator: const DotsDecorator(activeColor: Pallete.primarColor),
          next: const Icon(
            Icons.arrow_forward_ios,
            color: Pallete.whiteColor,
          ),
          back: const Icon(Icons.arrow_back_ios, color: Pallete.whiteColor),
          done: Text(
            "Done",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          onDone: () {
            Get.to(const ImportantNoticeAfterIntroPage());
          },
        ),
      ),
    );
  }

  Column topImage({required String iconLocation}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ShowImage(
            height: 80.h,
            width: double.infinity,
            fit: BoxFit.fitHeight,
            imgLocation: AssetsConst.logoWhiteJustP,
            isAssetImg: true),
        ShowImage(
            height: 140.h,
            width: double.infinity,
            fit: BoxFit.fitHeight,
            imgLocation: iconLocation,
            isAssetImg: true),
      ],
    );
  }
}
