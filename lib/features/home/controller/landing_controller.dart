import 'package:get/get.dart';

class LandingController extends GetxController {
  int selectedIndex = 0;

  setSelectedIndex(v) {
    selectedIndex = v;
    update();
  }
}
