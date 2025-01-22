import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowImage extends StatelessWidget {
  const ShowImage(
      {super.key,
      this.height,
      this.width,
      required this.imgLocation,
      this.radius,
      this.fit,
      required this.isAssetImg,
      this.imageAlignment});

  final double? height;
  final double? width;
  final String imgLocation;
  final double? radius;
  final BoxFit? fit;
  final bool isAssetImg;
  final Alignment? imageAlignment;

  @override
  Widget build(BuildContext context) {
    return isAssetImg
        ? ClipRRect(
            borderRadius: BorderRadius.circular(radius ?? 0),
            child: Container(
              height: height ?? 60.h,
              width: width ?? 60.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: imageAlignment ?? Alignment.center,
                  image: AssetImage(imgLocation),
                  fit: fit ?? BoxFit.cover,
                ),
              ),
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(radius ?? 0),
            child: CachedNetworkImage(
              height: height ?? 60.h,
              width: width ?? 60.h,
              imageUrl: imgLocation,
              placeholder: (context, url) => Icon(
                Icons.image_outlined,
                size: 45.sp,
                color: Colors.grey.withOpacity(.4),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: fit ?? BoxFit.cover,
            ),
          );
  }
}
