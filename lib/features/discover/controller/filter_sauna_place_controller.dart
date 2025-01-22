import 'package:get/get.dart';
import 'package:portasauna/core/constants/place_category_const.dart';
import 'package:portasauna/features/add_sauna_place/model/add_place_around_things_model.dart';

class FilterSaunaPlaceController extends GetxController {
  @override
  onInit() {
    fillCategories();
    super.onInit();
  }

  List<AddPlaceAroundThingsModel> wildTypeList = [];
  List<AddPlaceAroundThingsModel> commercialList = [];
  List<AddPlaceAroundThingsModel> nearbyServiceList = [];
  List<AddPlaceAroundThingsModel> nearbyActivityList = [];

  setSelectedWildType(int i) {
    wildTypeList[i].selected = !wildTypeList[i].selected;
    update();
  }

  setSelectedCommercialType(int i) {
    commercialList[i].selected = !commercialList[i].selected;
    update();
  }

  setSelectedNearbyService(int i) {
    nearbyServiceList[i].selected = !nearbyServiceList[i].selected;
    update();
  }

  setSelectedNearbyActivities(int i) {
    nearbyActivityList[i].selected = !nearbyActivityList[i].selected;
    update();
  }

  fillCategories() {
    //fill wild places
    for (int i = 0; i < wildPlaces.length; i++) {
      wildTypeList.add(AddPlaceAroundThingsModel(
        name: wildPlaces[i],
        selected: false,
      ));
    }

    //fill commercial places
    for (int i = 0; i < commercialPlaces.length; i++) {
      commercialList.add(AddPlaceAroundThingsModel(
        name: commercialPlaces[i],
        selected: false,
      ));
    }

    //fill nearby service
    for (int i = 0; i < nearbyServicePlaces.length; i++) {
      nearbyServiceList.add(AddPlaceAroundThingsModel(
        name: nearbyServicePlaces[i],
        selected: false,
      ));
    }

    //fill nearby activities
    for (int i = 0; i < nearbyActivityPlaces.length; i++) {
      nearbyActivityList.add(AddPlaceAroundThingsModel(
        name: nearbyActivityPlaces[i],
        selected: false,
      ));
    }
  }
}
