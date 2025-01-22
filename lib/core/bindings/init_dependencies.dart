import 'package:get/get.dart';
import 'package:portasauna/core/constants/app_secrets.dart';
import 'package:portasauna/core/controllers/prefs_controller.dart';
import 'package:portasauna/features/add_sauna_place/controller/add_sauna_place_controller.dart';
import 'package:portasauna/admin/features/all_place/controller/admin_all_place_controller.dart';
import 'package:portasauna/admin/features/modify_place/controller/admin_modification_requested_controller.dart';
import 'package:portasauna/features/discover/controller/map_direction_controller.dart';
import 'package:portasauna/features/request_place_edit/controller/request_edit_place_controller.dart';
import 'package:portasauna/admin/features/edit_place/controller/admin_edit_place_controller.dart';
import 'package:portasauna/admin/features/edit_place/controller/admin_pending_place_controller.dart';
import 'package:portasauna/features/auth/controller/auth_controller.dart';
import 'package:portasauna/features/auth/controller/change_password_controller.dart';
import 'package:portasauna/features/auth/controller/profile_controller.dart';
import 'package:portasauna/features/discover/controller/favourite_controller.dart';
import 'package:portasauna/features/discover/controller/filter_sauna_place_controller.dart';
import 'package:portasauna/features/discover/controller/map_controller.dart';
import 'package:portasauna/features/discover/controller/map_place_controller.dart';
import 'package:portasauna/features/discover/controller/place_added_by_user_controller.dart';
import 'package:portasauna/features/discover/controller/place_details_modal_controller.dart';
import 'package:portasauna/features/discover/controller/rating_controller.dart';
import 'package:portasauna/features/home/controller/find_near_sauna_controller.dart';
import 'package:portasauna/features/home/controller/landing_controller.dart';
import 'package:portasauna/features/session/controller/add_session_controller.dart';
import 'package:portasauna/features/session/controller/fetch_sauna_session_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

late SupabaseClient dbClient;

Future<void> initAtStart() async {
  await PrefsController.onInit();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  dbClient = supabase.client;

  // Get.put(supabase.client);
  Get.lazyPut(() => AddSessionController(), fenix: true);
  Get.lazyPut(() => AddSaunaPlaceController(), fenix: true);
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.lazyPut(() => ChangePasswordController(), fenix: true);
  Get.lazyPut(() => MapPlaceController(), fenix: true);
  Get.lazyPut(() => RatingController(), fenix: true);
  Get.lazyPut(() => PlaceAddedByUserController(), fenix: true);
  Get.lazyPut(() => PlaceDetailsModalController(), fenix: true);
  Get.lazyPut(() => RequestEditPlaceController(), fenix: true);
  Get.lazyPut(() => MapDirectionController(), fenix: true);
  Get.lazyPut(() => AdminAllPlaceController(), fenix: true);
  Get.lazyPut(() => AdminModificationRequestedController(), fenix: true);
  Get.put(FilterSaunaPlaceController());
  Get.put(FindNearSaunaController());
  Get.put(FetchSaunaSessionController());
  Get.put(MapController());
  Get.put(LandingController());
  Get.put(ProfileController());
  Get.put(FavouriteController());

  //===============================
  //admin
  //===============================
  Get.lazyPut(() => AdminPendingPlaceController(), fenix: true);
  Get.lazyPut(() => AdminEditPlaceController(), fenix: true);
}
