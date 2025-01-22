// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/bindings/init_dependencies.dart';
import 'package:portasauna/core/widgets/show_snackbar.dart';
import 'package:portasauna/features/auth/controller/profile_controller.dart';
import 'package:portasauna/features/session/model/session_model.dart';

class FetchSaunaSessionController extends GetxController {
  bool isLoading = false;

  DateTime selectedDate = DateTime.now();

  setSelectedDate(DateTime date) {
    selectedDate = date;
    update();
  }

  setLoadingTrue() {
    isLoading = true;
    update();
  }

  setLoadingFalse() {
    isLoading = false;
    update();
  }

  // ==================>
  // fetch sessions of selected Date
  // ==================>

  List<SessionModel> sessions = [];

  fetchSessions({required BuildContext context}) async {
    final pc = Get.find<ProfileController>();

    if (!pc.isLoggedIn) {
      showSnackBar(context, 'Please login to track your session', Colors.red);
      return;
    }

    try {
      setLoadingTrue();
      sessions.clear();

      final userId = dbClient.auth.currentUser!.id;

      final response = await dbClient
          .from('sauna_sessions')
          .select()
          .eq('date', selectedDate.toIso8601String())
          .eq('user_id', userId);

      for (int i = 0; i < response.length; i++) {
        sessions.add(SessionModel.fromJson(response[i]));
      }
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    } finally {
      setLoadingFalse();
      update();
    }
  }

  // ==================>
  // fetch current month sessions
  // ==================>

  List<SessionModel> currentMonthSessions = [];

  fetchCurrentMonthSessions({required BuildContext context}) async {
    try {
      setLoadingTrue();
      currentMonthSessions.clear();

      final date = DateTime.now();
      final firstDateOfMonth = DateTime(date.year, date.month, 1);
      final lastDateOfMonth = DateTime(date.year, date.month + 1, 0);
      final userId = dbClient.auth.currentUser!.id;

      final response = await dbClient
          .from('sauna_sessions')
          .select("*")
          .gte('date', firstDateOfMonth.toIso8601String())
          .lte('date', lastDateOfMonth.toIso8601String())
          .eq('user_id', userId);

      int loopLength = response.length > 2 ? 2 : response.length;

      for (int i = 0; i < loopLength; i++) {
        currentMonthSessions.add(SessionModel.fromJson(response[i]));
      }
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    } finally {
      setLoadingFalse();
      update();
    }
  }

  // ==================>
  // fetch all sessions
  // ==================>

  int totalSessions = 0;
  String totalAufguss = '';
  String totalColdShowerPlunge = '';
  String avgTemperature = '';
  String avgHumidity = '';
  String avgHeartRate = '';
  String totalDuration = '';
  String avgDuration = '';
  String avgSessionWeek = '';
  String avgSessionMonth = '';

  fetchAllSessions({required BuildContext context}) async {
    try {
      setLoadingTrue();
      List<SessionModel> allSessions = [];
      final userId = dbClient.auth.currentUser!.id;

      final response = await dbClient
          .from('sauna_sessions')
          .select("*")
          .eq('user_id', userId);

      for (int i = 0; i < response.length; i++) {
        allSessions.add(SessionModel.fromJson(response[i]));
      }

      totalSessions = allSessions.length;
      totalColdShowerPlunge = await getTotalColdShowerPlunge(allSessions);
      totalAufguss = await getTotalAufguss(allSessions);
      avgTemperature = await getAvgTemperature(allSessions);
      avgHumidity = await getAvgHumidity(allSessions);
      avgHeartRate = await getAvgHeartRate(allSessions);
      totalDuration = await getTotalDuration(allSessions);
      avgDuration = await getAvgDuration(allSessions);
      avgSessionWeek = await getAvgSessionWeek(allSessions);
      avgSessionMonth = await getAvgSessionMonth(allSessions);
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    } finally {
      setLoadingFalse();
      update();
    }
  }

  // ==================>
  // get total cold shower values
  // ==================>
  getTotalColdShowerPlunge(List<SessionModel> sessions) async {
    int totalColdShowerPlunge = 0;

    for (int i = 0; i < sessions.length; i++) {
      if (sessions[i].coldShowerPlunge ?? false) {
        totalColdShowerPlunge += 1;
      }
    }
    return totalColdShowerPlunge.toString();
  }

  // ==================>
  // get total aufguss
  // ==================>
  getTotalAufguss(List<SessionModel> sessions) async {
    int totalAufguss = 0;

    for (int i = 0; i < sessions.length; i++) {
      if (sessions[i].aufguss ?? false) {
        totalAufguss += 1;
      }
    }
    return totalAufguss.toString();
  }

  // ==================>
  // get avg temperature
  // ==================>
  getAvgTemperature(List<SessionModel> sessions) async {
    double totalTemperature = 0; // °C

    if (sessions.isEmpty) {
      return '0';
    }

    for (int i = 0; i < sessions.length; i++) {
      if (sessions[i].temperature != null) {
        totalTemperature += int.parse(sessions[i].temperature!); // °C
      }
    }
    return (totalTemperature ~/ sessions.length).toString();
  }

  // ==================>
  // get avg humidity
  // ==================>
  getAvgHumidity(List<SessionModel> sessions) async {
    double totalHumidity = 0; // °C
    if (sessions.isEmpty) {
      return '0';
    }
    for (int i = 0; i < sessions.length; i++) {
      if (sessions[i].humidity != null) {
        totalHumidity += int.parse(sessions[i].humidity!); // °C
      }
    }
    return (totalHumidity ~/ sessions.length).toString();
  }

  // ==================>
  // get avg heart rate
  // ==================>
  getAvgHeartRate(List<SessionModel> sessions) async {
    double totalHeartRate = 0; // °C
    if (sessions.isEmpty) {
      return '0';
    }
    for (int i = 0; i < sessions.length; i++) {
      if (sessions[i].heartRate != '--') {
        totalHeartRate += int.parse(sessions[i].heartRate!); // °C
      }
    }
    return (totalHeartRate ~/ sessions.length).toString();
  }

  // ==================>
  // get total duration
  // ==================>
  getTotalDuration(List<SessionModel> sessions) async {
    double totalMinutes = 0;
    if (sessions.isEmpty) {
      return '0';
    }
    int totalSessions = sessions.length;

    for (int i = 0; i < sessions.length; i++) {
      if (sessions[i].duration != null) {
        totalMinutes += int.parse(sessions[i].duration!); // °C
      }
    }

    double averageDurationMinutes = totalMinutes / totalSessions;
    double averageDurationHours = averageDurationMinutes / 60;
    int hours = averageDurationHours.floor();
    int minutes = ((averageDurationHours - hours) * 60).round();

    return "$hours hours $minutes min";
  }

  // ==================>
  // get avg duration
  // ==================>
  getAvgDuration(List<SessionModel> sessions) async {
    double totalDuration = 0; // °C
    if (sessions.isEmpty) {
      return '0';
    }
    for (int i = 0; i < sessions.length; i++) {
      if (sessions[i].duration != null) {
        totalDuration += int.parse(sessions[i].duration!); // °C
      }
    }
    return (totalDuration ~/ sessions.length).toString();
  }

  // ==================>
  // get avg session week
  // ==================>
  getAvgSessionWeek(List<SessionModel> sessions) async {
    int totalSession = sessions.length; // °C
    if (sessions.isEmpty) {
      return '0';
    }
    return (totalSession ~/ 52).toString();
  }

  // ==================>
  // get avg session month
  // ==================>
  getAvgSessionMonth(List<SessionModel> sessions) async {
    int totalSession = sessions.length; // °C
    if (sessions.isEmpty) {
      return '0';
    }
    return (totalSession ~/ 12).toString();
  }
}
