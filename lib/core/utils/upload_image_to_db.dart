import 'package:flutter/material.dart';
import 'package:portasauna/core/bindings/init_dependencies.dart';

Future uploadImgToDb({required imageFile, required String imageName}) async {
  await dbClient.storage.from('images').upload(
        imageName,
        imageFile,
      );

  final imgLink = dbClient.storage.from('images').getPublicUrl(
        imageName,
      );

  debugPrint('img link is $imgLink');
  return imgLink;
}
