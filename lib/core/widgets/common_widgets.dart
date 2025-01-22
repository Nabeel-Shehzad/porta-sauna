import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/constants/assets_const.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:url_launcher/url_launcher.dart';

updateAppPopup({required BuildContext context}) {
  return Get.defaultDialog(
      title: '',
      backgroundColor: const Color(0xff1F232F),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'New version available',
              style: TextStyle(
                  color: const Color(0xffF5F9FA),
                  fontSize: Get.width * .045,
                  height: 1.3,
                  fontWeight: FontWeight.w800),
            ),
            gapH(2),
            Text(
              'Update to get the latest features',
              style: TextStyle(
                color: const Color(0xffF5F9FA),
                fontSize: Get.width * .035,
                height: 1.3,
              ),
            ),
            gapH(6),
            ButtonPrimary(
                text: 'Update',
                onPressed: () {
                  launchUrl(Uri.parse(portaSaunaAppstoreLink),
                      mode: LaunchMode.externalApplication);
                }),
            ButtonPrimary(
                text: 'Not now',
                borderColor: Colors.transparent,
                onPressed: () {
                  Get.back();
                })
          ],
        ),
      ));
}
