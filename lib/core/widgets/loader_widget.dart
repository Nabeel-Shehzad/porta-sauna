import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portasauna/core/theme/pallete.dart';

class LoaderWidget extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  const LoaderWidget({super.key, required this.child, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
              child: WillPopScope(
                  onWillPop: () async => !isLoading,
                  child: Container(
                      color: Colors.black26,
                      child: Center(
                        child: Container(
                            decoration: BoxDecoration(
                              color: Pallete.backgroundColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: SizedBox(
                                width: 35.sp,
                                height: 35.sp,
                                child: const CircularProgressIndicator(
                                  color: Pallete.primarColor,
                                ))),
                      )))),
      ],
    );
  }
}
