import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/text_utils.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/loader_widget.dart';
import 'package:portasauna/features/auth/controller/profile_controller.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (pc) {
      return LoaderWidget(
        isLoading: pc.isLoading,
        child: Scaffold(
          appBar: appbarCommon('', context),
          body: Container(
            padding: screenPaddingH,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Are you sure you want to delete your account?',
                  style: TextUtils.title1(context: context),
                  textAlign: TextAlign.center,
                ),
                gapH(15),
                Text(
                  'You account informations, your sessions and added places will be deleted. This cannot be undone.',
                  style: TextUtils.small1(context: context),
                  textAlign: TextAlign.center,
                ),
                gapH(25),
                ButtonPrimary(
                    text: 'I understand & want to delete my account',
                    bgColor: Pallete.redColor,
                    onPressed: () {
                      pc.deleteAccount(context);
                    })
              ],
            ),
          ),
        ),
      );
    });
  }
}
