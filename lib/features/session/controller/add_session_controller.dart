// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/bindings/init_dependencies.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/session/controller/fetch_sauna_session_controller.dart';

import '../../../core/theme/pallete.dart';

class AddSessionController extends GetxController {
  @override
  onInit() {
    fillSaunaDropdownValues();
    super.onInit();
  }

  fillSaunaDropdownValues() {
    //temp
    saunaTemps = [];
    for (int i = 40; i < 121; i += 5) {
      saunaTemps.add("$i");
    }

    //duration
    saunaDurations = [];
    for (int i = 1; i < 90; i++) {
      saunaDurations.add("$i");
    }

    //humidity
    saunaHumiditys = [];
    for (int i = 0; i < 50; i += 5) {
      saunaHumiditys.add("$i");
    }

    update();
  }

  //================>
  //Sauna type
  //================>
  List<String> saunaTypes = [
    "PortaSauna",
    "Sauna Tent",
    "Electric Sauna",
    "Infrared Sauna",
    "Wood Fired Sauna"
  ];
  var selectedSauna = "PortaSauna";

  setSelectedSauna(int i) {
    selectedSauna = saunaTypes[i];
    update();
  }

  //================>
  //temperature
  //================>
  List<String> saunaTemps = [];
  var selectedTemp = "70";

  setSelectedTemp(int i) {
    selectedTemp = saunaTemps[i];
    update();
  }

  //================>
  //Duration
  //================>
  List<String> saunaDurations = [];
  var selectedDuration = "10";

  setSelectedDuration(int i) {
    selectedDuration = saunaDurations[i];
    update();
  }

  //================>
  //Humidity
  //================>
  List<String> saunaHumiditys = [];
  var selectedHumidity = "30";

  setSelectedHumidity(int i) {
    selectedHumidity = saunaHumiditys[i];
    update();
  }

  //================>
  //Start time
  //================>
  var date = DateTime.now();

  setDate(v) {
    date = v;
    update();
  }

  //================>
  //Cold shower / Plunge
  //================>
  bool coldShowerOrPlunge = false;

  setcoldShowerOrPlunge(v) {
    coldShowerOrPlunge = v;
    update();
  }

  //================>
  //Aufguss
  //================>
  bool aufguss = false;

  setAufguss(v) {
    aufguss = v;
    update();
  }

  //================>
  //temperature
  //================>
  List<String> saunaHeartRates = ["--", "60", "70", "80", "90"];
  var selectedHeartRate = "--";

  setSelectedHeartRate(int i) {
    selectedHeartRate = saunaHeartRates[i];
    update();
  }

  //================>
  //Save to Db
  //================>

  bool isLoading = false;
  final noteController = TextEditingController();
  final saunaNameOrLocationController = TextEditingController();

  setLoadingTrue() {
    isLoading = true;
    update();
  }

  setLoadingFalse() {
    isLoading = false;
    update();
  }

  saveSessionToDb({
    required BuildContext context,
  }) async {
    setLoadingTrue();

    final user = await dbClient.auth.getUser();

    try {
      await dbClient.from('sauna_sessions').insert({
        'sauna_type': selectedSauna,
        'temperature': selectedTemp,
        'duration': selectedDuration,
        'humidity': selectedHumidity,
        'heart_rate': selectedHeartRate,
        'cold_shower_plunge': coldShowerOrPlunge,
        'aufguss': aufguss,
        'date': date.toIso8601String(),
        'note': noteController.text.isEmpty ? null : noteController.text,
        'name_or_location': saunaNameOrLocationController.text.isEmpty
            ? null
            : saunaNameOrLocationController.text,
        "user_id": user.user?.id ?? 0,
      });

      final fsc = Get.find<FetchSaunaSessionController>();
      fsc.fetchCurrentMonthSessions(context: context);
      fsc.setSelectedDate(date);
      fsc.fetchSessions(context: context);

      showSnackBar(context, 'Session added successfully', Pallete.primarColor);
      Get.back();
    } catch (e) {
      showSnackBar(context, '$e', Colors.red);
    } finally {
      setLoadingFalse();
    }
  }
}
