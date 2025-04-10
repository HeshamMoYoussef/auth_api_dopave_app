import 'package:auth_api_dopave_app/features/articles/controller/articles_controller.dart';
import 'package:auth_api_dopave_app/features/auth/controller/auth_controller.dart';
import 'package:auth_api_dopave_app/features/auth/controller/user_controller.dart';
import 'package:auth_api_dopave_app/features/gold_price/controller/gold_price_controller.dart';
import 'package:auth_api_dopave_app/features/home/controller/home_controller.dart';
import 'package:auth_api_dopave_app/features/matches/controller/matches_controller.dart';
import 'package:auth_api_dopave_app/services/api_service.dart';
import 'package:auth_api_dopave_app/services/storage_service.dart';
import 'package:auth_api_dopave_app/utils/connectivity_checker.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  // Initialize all required services

  @override
  void dependencies() async {
    // Initialize services
    await Get.putAsync(() => StorageService().init());
    await Get.putAsync(() => ConnectivityChecker().init());
    await Get.putAsync(() => ApiService().init());

    // Initialize controllers
    Get.put(AuthController());
    Get.put(UserController());
    Get.put(MatchesController());
    Get.put(HomeController());
    // Get.put(ArticlesController());

    Get.lazyPut(() => ArticlesController());
    Get.lazyPut(() => GoldPriceController());

    // Get.lazyPut(() => ArticlesController());
    // Get.lazyPut(() => GoldPriceController());
  }
}
