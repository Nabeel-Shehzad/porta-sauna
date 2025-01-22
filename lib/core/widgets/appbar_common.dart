import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';

appbarCommon(String title, BuildContext context,
    {bool hasBackButton = true,
    bool centerTitle = true,
    IconData? backIcon,
    actions,
    VoidCallback? pressed,
    double? appbarSize,
    PreferredSizeWidget? bottom}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(appbarSize ?? 70.h),
    child: AppBar(
      centerTitle: centerTitle,
      iconTheme: const IconThemeData(color: Pallete.whiteColor),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: actions,
      leadingWidth: 75.w,
      bottom: bottom,
      leading: hasBackButton
          ? InkWell(
              onTap: pressed ??
                  () {
                    print('back pressed');
                    Get.back();
                  },
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(
                    backIcon ?? Icons.arrow_back_ios,
                    size: 27.sp,
                    color: Pallete.whiteColor,
                  )),
            )
          : Container(),
    ),
  );
}
