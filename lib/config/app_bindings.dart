import 'package:auth_api_dopave_app/controllers/auth_controller.dart';
import 'package:auth_api_dopave_app/controllers/user_controller.dart';
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
  }
}
