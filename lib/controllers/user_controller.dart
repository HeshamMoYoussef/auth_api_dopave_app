import 'package:auth_api_dopave_app/config/api_constants.dart';
import 'package:auth_api_dopave_app/models/user_model.dart';
import 'package:auth_api_dopave_app/services/api_service.dart';
import 'package:auth_api_dopave_app/services/storage_service.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  // Observables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    // Load initial user data
    getUserProfile();
  }

  // Get user profile
  Future<void> getUserProfile() async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await _apiService.postRequest(
      ApiConstants.userProfile,
      {},
    );

    isLoading.value = false;

    if (response.status) {
      final userData = response.data as Map<String, dynamic>;
      user.value = UserModel.fromJson(userData);
      await _storageService.saveUserData(user.value!);
    } else {
      errorMessage.value = response.message ?? 'فشل في تحميل بيانات المستخدم';
    }
  }

  // Update user profile
  Future<bool> updateProfile(String name) async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await _apiService.postRequest(ApiConstants.updateProfile, {
      'name': name,
    });

    isLoading.value = false;

    if (response.status) {
      final userData = response.data as Map<String, dynamic>;
      user.value = UserModel.fromJson(userData);
      await _storageService.saveUserData(user.value!);
      return true;
    } else {
      errorMessage.value = response.message ?? 'فشل تحديث البيانات';
      return false;
    }
  }
}
