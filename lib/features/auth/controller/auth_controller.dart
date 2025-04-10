import 'dart:developer';

import 'package:auth_api_dopave_app/config/api_constants.dart';
import 'package:auth_api_dopave_app/features/auth/model/user_model.dart';
import 'package:auth_api_dopave_app/services/api_service.dart';
import 'package:auth_api_dopave_app/services/storage_service.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  // Observables
  final RxString phone = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    // Load user data from storage if available
    currentUser.value = _storageService.getUserData();
  }

  // Check if user is logged in
  bool get isLoggedIn => _storageService.isLoggedIn();

  // Send verification code to phone number
  Future<bool> sendVerificationCode(String phoneNumber) async {
    isLoading.value = true;
    errorMessage.value = '';
    phone.value = phoneNumber;

    final response = await _apiService.postRequest(
      ApiConstants.sendVerificationCode,
      {'phone': phoneNumber},
    );

    isLoading.value = false;

    if (response.status) {
      return true;
    } else {
      errorMessage.value = response.message ?? 'حدث خطأ، حاول مرة أخرى';
      return false;
    }
  }

  // Verify OTP code
  Future<bool> verifyOtpCode(String code) async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await _apiService.postRequest(
      ApiConstants.checkVerificationCode,
      {'phone': phone.value, 'code': code},
    );

    isLoading.value = false;

    if (response.status) {
      return true;
    } else {
      errorMessage.value = response.message ?? 'كود التحقق غير صحيح';
      return false;
    }
  }

  // Register new user
  Future<bool> register(String name, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await _apiService.postRequest(ApiConstants.register, {
      'name': name,
      'phone': phone.value,
      'password': password,
      'password_confirmation': password,
    });

    isLoading.value = false;

    if (response.status) {
      // Save token and user data
      final token = response.data['token'] as String;
      await _storageService.saveToken(token);

      final userData = response.data['user_data'] as Map<String, dynamic>;
      final user = UserModel.fromJson(userData);
      currentUser.value = user;
      await _storageService.saveUserData(user);

      return true;
    } else {
      errorMessage.value = response.message ?? 'فشل التسجيل';
      return false;
    }
  }

  // Login user
  Future<bool> login(String phoneNumber, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await _apiService.postRequest(ApiConstants.login, {
      'phone': phoneNumber,
      'password': password,
    });

    isLoading.value = false;

    if (response.status) {
      // Save token and user data
      final token = response.data['token'] as String;
      log('Token: $token');
      await _storageService.saveToken(token);

      final userData = response.data['user_data'] as Map<String, dynamic>;
      final user = UserModel.fromJson(userData);
      currentUser.value = user;
      await _storageService.saveUserData(user);

      return true;
    } else {
      errorMessage.value = response.message ?? 'فشل تسجيل الدخول';
      return false;
    }
  }

  // Forgot password
  Future<bool> forgotPassword(String phoneNumber) async {
    isLoading.value = true;
    errorMessage.value = '';

    final response = await _apiService.postRequest(
      ApiConstants.forgotPassword,
      {'phone': phoneNumber},
    );

    isLoading.value = false;

    if (response.status) {
      return true;
    } else {
      errorMessage.value = response.message ?? 'حدث خطأ، حاول مرة أخرى';
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    isLoading.value = true;

    // Call logout API
    await _apiService.postRequest(ApiConstants.logout, {});

    // Navigate to login screen
    Get.offAllNamed('/login');

    // Clear local storage
    await _storageService.clearAll();
    currentUser.value = null;

    isLoading.value = false;
    update();
  }

  // Delete user account
  // ToDo: Implement delete user account
  Future<void> deleteUser() async {
    isLoading.value = true;

    // Call logout API
    final response = await _apiService.postRequest(ApiConstants.deleteUser, {});

    // Navigate to login screen
    Get.offAllNamed('/phone-input');

    // Clear local storage
    await _storageService.clearAll();
    currentUser.value = null;

    isLoading.value = false;
    if (response.status) {
      return;
    } else {
      errorMessage.value = response.message ?? 'حدث خطأ، حاول مرة أخرى';
      return;
    }
  }
}
