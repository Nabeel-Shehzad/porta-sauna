// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portasauna/core/utils/text_utils.dart';
import 'package:portasauna/core/widgets/show_image.dart';

class AdminPlaceListItem extends StatelessWidget {
  const AdminPlaceListItem({
    super.key,
    required this.address,
    required this.description,
    required this.image,
    required this.onTap,
  });

  final address;
  final description;
  final image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 5.h),
      onTap: onTap,
      title: Text(
        address.toString(),
        style: TextUtils.small1(context: context, fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        description,
        style: TextUtils.small1(
            context: context, fontSize: 14.sp, color: Colors.grey[400]),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: ShowImage(radius: 7.sp, imgLocation: image, isAssetImg: false),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
