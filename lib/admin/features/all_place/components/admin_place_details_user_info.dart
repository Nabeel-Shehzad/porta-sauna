// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:portasauna/core/utils/text_utils.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/show_image.dart';

class AdminPlaceDetailsUserInfo extends StatelessWidget {
  const AdminPlaceDetailsUserInfo({
    super.key,
    required this.profileImageUrl,
    required this.name,
    required this.email,
  });

  final profileImageUrl;
  final name;
  final email;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ShowImage(
          imgLocation: profileImageUrl,
          isAssetImg: false,
          radius: 100,
        ),
        gapW(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextUtils.small1(
                  context: context, fontWeight: FontWeight.bold),
            ),
            Text(
              email,
              style: TextUtils.small1(context: context),
            ),
          ],
        )
      ],
    );
  }
}
