import 'package:flutter/material.dart';
import 'package:portasauna/core/theme/pallete.dart';

showSnackBar(BuildContext context, String msg, color) {
  var snackBar = SnackBar(
    content: Text(
      msg,
      style: Theme.of(context).textTheme.bodySmall,
    ),
    backgroundColor: color,
    duration: const Duration(milliseconds: 4000),
  );

  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

showErrorSnackBar(BuildContext context, String msg) {
  var snackBar = SnackBar(
    content: Text(
      msg,
      style: Theme.of(context).textTheme.bodySmall,
    ),
    backgroundColor: Pallete.redColor,
    duration: const Duration(milliseconds: 4000),
  );

  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

showSuccessSnackBar(BuildContext context, String msg) {
  var snackBar = SnackBar(
    content: Text(
      msg,
      style: Theme.of(context).textTheme.bodySmall,
    ),
    backgroundColor: Pallete.greenColor,
    duration: const Duration(milliseconds: 4000),
  );

  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
