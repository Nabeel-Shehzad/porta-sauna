import 'package:get/get.dart';
import 'package:portasauna/admin/features/edit_place/controller/admin_pending_place_controller.dart';
import 'package:portasauna/admin/features/modify_place/controller/admin_modification_requested_controller.dart';
import 'package:portasauna/core/constants/assets_const.dart';
import 'package:portasauna/core/utils/send_email.dart';

sendModReqAcceptedMail() {
  final mrc = Get.find<AdminModificationRequestedController>();
  sendEmail(
    toEmail: mrc.selectedUserDetails?.email,
    subject: "Your modification request on $appName was approved",
    emailText: "Thank you for your contribution",
  );
}

sendModReqRejectedMail() {
  final mrc = Get.find<AdminModificationRequestedController>();
  sendEmail(
      toEmail: mrc.selectedUserDetails?.email,
      emailText: "Your modification request on $appName was rejected",
      subject: "Your modification request on $appName was rejected");
}

sendPlaceAcceptedMail() {
  final apc = Get.find<AdminPendingPlaceController>();
  sendEmail(
      toEmail: apc.selectedUserDetails?.email,
      emailText: "Thank you for your contribution",
      subject: "Your added place on $appName was approved");
}

sendPlaceRejectedMail() {
  final apc = Get.find<AdminPendingPlaceController>();
  sendEmail(
      toEmail: apc.selectedUserDetails?.email,
      emailText: "Your added place on $appName was rejected",
      subject: "Your added place on $appName was rejected");
}
