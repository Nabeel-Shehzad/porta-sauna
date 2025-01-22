import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';
import 'package:portasauna/core/widgets/appbar_common.dart';
import 'package:portasauna/core/widgets/button_primary.dart';
import 'package:portasauna/core/widgets/custom_input.dart';
import 'package:portasauna/core/widgets/loader_widget.dart';
import 'package:portasauna/features/session/controller/add_session_controller.dart';
import 'package:portasauna/features/session/widgets/humidity_dropdown.dart';
import 'package:portasauna/features/session/widgets/sauna_duration_dropdown.dart';
import 'package:portasauna/features/session/widgets/sauna_date_dropdown.dart';
import 'package:portasauna/features/session/widgets/sauna_heart_rate_dropdown.dart';
import 'package:portasauna/features/session/widgets/sauna_temp_dropdown.dart';
import 'package:portasauna/features/session/widgets/sauna_type_dropdown.dart';

class AddSaunaSessionPage extends StatefulWidget {
  const AddSaunaSessionPage({super.key});

  @override
  State<AddSaunaSessionPage> createState() => _AddSaunaLogPageState();
}

class _AddSaunaLogPageState extends State<AddSaunaSessionPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddSessionController>(builder: (ac) {
      return LoaderWidget(
        isLoading: ac.isLoading,
        child: Scaffold(
            appBar: appbarCommon('Add session', context),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: screenPaddingH,
                    child: Container(
                      color: Colors.grey.withOpacity(.2),
                      child: CustomInput(
                        hintText: 'Enter sauna name / locations',
                        maxLines: 1,
                        controller: ac.saunaNameOrLocationController,
                        onChanged: (text) {
                          if (text.isEmpty) return;
                          setState(() {
                            ac.saunaNameOrLocationController.text =
                                text.substring(0, 1).toUpperCase() +
                                    text.substring(1);
                          });
                        },
                        borderBottom: InputBorder.none,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                                fontSize: 16.h, color: Pallete.hintGreyColor),
                      ),
                    ),
                  ),

                  gapH(15),
                  const SaunaTypeDropdown(),
                  const Divider(),
                  gapH(10),
                  const SaunaTempDropdown(),
                  const SaunaDurationDropdown(),
                  const HumidityDropdown(),
                  const SaunaDateDropdown(),

                  //================>
                  //Cold shower / Plunge
                  //================>
                  ListTile(
                    leading: const Icon(Icons.ac_unit),
                    title: Text(
                      'Cold Shower / Plunge',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Switch(
                      value: ac.coldShowerOrPlunge,
                      activeColor: Pallete.primarColor,
                      onChanged: (bool value) {
                        ac.setcoldShowerOrPlunge(value);
                      },
                    ),
                  ),

                  //================>
                  // Aufguss
                  //================>
                  ListTile(
                    leading: const Icon(Icons.breakfast_dining_outlined),
                    title: Text(
                      'Aufguss',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Switch(
                      // This bool value toggles the switch.
                      value: ac.aufguss,
                      activeColor: Pallete.primarColor,
                      onChanged: (bool value) {
                        ac.setAufguss(value);
                      },
                    ),
                  ),

                  gapH(10),
                  const Divider(),
                  const SaunaHeartRateDropdown(),

                  gapH(35),

                  Container(
                      padding: screenPaddingH,
                      child: Column(
                        children: [
                          Container(
                            color: Colors.grey.withOpacity(.2),
                            child: CustomInput(
                              hintText: 'Add note',
                              maxLines: 2,
                              controller: ac.noteController,
                              borderBottom: InputBorder.none,
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontSize: 16.h,
                                      color: Pallete.hintGreyColor),
                            ),
                          ),
                          gapH(25),
                          ButtonPrimary(
                              text: 'Save',
                              bgColor: Pallete.primarColor,
                              onPressed: () {
                                ac.saveSessionToDb(context: context);
                              }),
                          gapH(70),
                        ],
                      )),
                ],
              ),
            )),
      );
    });
  }
}
