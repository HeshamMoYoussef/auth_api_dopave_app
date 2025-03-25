import 'package:auth_api_dopave_app/controllers/auth_controller.dart';
import 'package:auth_api_dopave_app/views/auth/forgot_password_screen.dart';
import 'package:auth_api_dopave_app/views/auth/login_screen.dart';
import 'package:auth_api_dopave_app/views/auth/otp_verification_screen.dart';
import 'package:auth_api_dopave_app/views/auth/phone_input_screen.dart';
import 'package:auth_api_dopave_app/views/auth/registration_screen.dart';
import 'package:auth_api_dopave_app/views/home/home_screen.dart';
import 'package:get/get.dart';

class AppRouts {
  static List<GetPage<dynamic>>? getPages = [
    GetPage(name: '/phone-input', page: () => PhoneInputScreen()),
    GetPage(name: '/otp-verification', page: () => OtpVerificationScreen()),
    GetPage(name: '/register', page: () => RegistrationScreen()),
    GetPage(name: '/login', page: () => LoginScreen()),
    GetPage(name: '/forgot-password', page: () => ForgotPasswordScreen()),
    GetPage(name: '/home', page: () => HomeScreen()),
  ];

  // Determine initial route based on authentication status
  static String get initialRoute {
    final authController = Get.find<AuthController>();
    return authController.isLoggedIn ? '/home' : '/login';
  }
}
