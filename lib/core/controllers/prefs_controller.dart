import 'package:shared_preferences/shared_preferences.dart';

class PrefsController {
  static late SharedPreferences _preferences;

  static Future<bool> onInit() async {
    _preferences = await SharedPreferences.getInstance();

    int userEntered = getUserEnteredAppCount;
    setUserEnteredAppCount = userEntered + 1;

    return true;
  }

  //How many times user entering the app
  static get getUserEnteredAppCount => _preferences.getInt("userEntered") ?? 0;
  static set setUserEnteredAppCount(int value) =>
      _preferences.setInt("userEntered", value);

  //Login as admin
  static get getLoginAsAdmin => _preferences.getBool("loginAsAdmin") ?? false;
  static set setLoginAsAdmin(bool value) =>
      _preferences.setBool("loginAsAdmin", value);

  // keepLoggedIn
  static get getKeepLoggedIn => _preferences.getBool("keepLoggedIn") ?? true;
  static set setKeepLoggedIn(bool value) =>
      _preferences.setBool("keepLoggedIn", value);
}
