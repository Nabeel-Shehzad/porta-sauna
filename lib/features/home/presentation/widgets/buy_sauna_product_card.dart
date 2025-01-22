import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portasauna/core/utils/helper.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/button_primary.dart';

class BuySaunaProductCard extends StatelessWidget {
  const BuySaunaProductCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage('assets/images/learn_more_bg.jpeg'),
              fit: BoxFit.cover),
          // color: const Color(0xff85B4FF),
          borderRadius: radius(3)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Learn more',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontSize: 19.h, color: Colors.black),
                ),
                gapH(20),
                Row(
                  children: [
                    ButtonPrimary(
                        text: 'Shop now',
                        width: 125.w,
                        bgColor: Colors.black,
                        paddingVertical: 13.h,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: 14.h),
                        onPressed: () {
                          goToUrl('https://portasauna.co.uk/');
                        }),
                    gapW(20),
                    ButtonPrimary(
                        text: 'Visit a Retailer',
                        width: 145.w,
                        paddingVertical: 13.h,
                        bgColor: Colors.black,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: 14.h),
                        onPressed: () {
                          goToUrl('https://portasauna.co.uk/pages/retailers');
                        }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
