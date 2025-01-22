import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImage({bool pickFromCamera = false}) async {
  try {
    final xFile = await ImagePicker().pickImage(
      source: pickFromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (xFile != null) {
      return File(xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}
