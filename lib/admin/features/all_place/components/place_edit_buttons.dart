import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/admin/features/edit_place/controller/admin_edit_place_controller.dart';
import 'package:portasauna/admin/features/edit_place/controller/admin_pending_place_controller.dart';
import 'package:portasauna/admin/features/edit_place/presentation/admin_edit_sauna_place_type_page.dart';
import 'package:portasauna/admin/widgets/widget_helper.dart';

class PlaceEditButtons extends StatelessWidget {
  const PlaceEditButtons({
    super.key,
    required this.hideAcceptButton,
  });

  final hideAcceptButton;

  @override
  Widget build(BuildContext context) {
    final apc = Get.find<AdminPendingPlaceController>();
    final epc = Get.find<AdminEditPlaceController>();
    return Column(
      children: [
        if (!hideAcceptButton)
          ButtonPrimary(
              text: 'Accept',
              onPressed: () {
                apc.acceptPlace(context, id: apc.selectedSaunaPlace.id);
              }),
        gapH(20),
        ButtonPrimary(
            text: 'Edit',
            onPressed: () {
              epc.fillCategoriesAndSetEverythingDefault();
              epc.setSelectedSauna(apc.selectedSaunaPlace);
              epc.fillDataFromDb();
              Get.to(const AdminEditSaunaPlaceTypePage());
            }),
        gapH(20),
        Row(
          children: [
            Expanded(
              child: ButtonPrimary(
                  text: 'Contact',
                  onPressed: () {
                    apc.launchEmailApp(email: apc.selectedUserDetails?.email);
                  }),
            ),
            gapW(18),
            Expanded(
                child: ButtonPrimary(
                    text: 'Delete',
                    bgColor: Colors.red[800],
                    onPressed: () {
                      Get.defaultDialog(
                          backgroundColor: Colors.grey[900],
                          title: '',
                          content: deletePlacePopup(
                              context: context,
                              onTap: () {
                                Get.back();
                                Get.find<AdminPendingPlaceController>()
                                    .deletePlace(context,
                                        id: apc.selectedSaunaPlace.id,
                                        editingAcceptedPlace: hideAcceptButton);
                              }));
                    }))
          ],
        ),
      ],
    );
  }
}
