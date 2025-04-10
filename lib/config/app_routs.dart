import 'package:auth_api_dopave_app/features/articles/view/screens/article_webview_screen.dart';
import 'package:auth_api_dopave_app/features/articles/view/screens/articles_screen.dart';
import 'package:auth_api_dopave_app/features/auth/controller/auth_controller.dart';
import 'package:auth_api_dopave_app/features/auth/view/screens/forgot_password_screen.dart';
import 'package:auth_api_dopave_app/features/auth/view/screens/login_screen.dart';
import 'package:auth_api_dopave_app/features/auth/view/screens/otp_verification_screen.dart';
import 'package:auth_api_dopave_app/features/auth/view/screens/phone_input_screen.dart';
import 'package:auth_api_dopave_app/features/auth/view/screens/registration_screen.dart';
import 'package:auth_api_dopave_app/features/auth/view/widgets/user_details_widget.dart';
import 'package:auth_api_dopave_app/features/gold_price/view/goldprice_screen.dart';
import 'package:auth_api_dopave_app/features/home/view/screens/home_screen.dart';
import 'package:auth_api_dopave_app/features/matches/view/screens/matches_screen.dart';
import 'package:get/get.dart';

class AppRouts {
  static List<GetPage<dynamic>>? getPages = [
    GetPage(name: '/phone-input', page: () => PhoneInputScreen()),
    GetPage(name: '/otp-verification', page: () => OtpVerificationScreen()),
    GetPage(name: '/register', page: () => RegistrationScreen()),
    GetPage(name: '/login', page: () => LoginScreen()),
    GetPage(name: '/forgot-password', page: () => ForgotPasswordScreen()),
    GetPage(name: '/matches_screen', page: () => MatchesScreen()),
    GetPage(name: '/about', page: () => UserDetailsWidget()),
    GetPage(name: '/home', page: () => HomeScreen()),
    GetPage(name: '/articles', page: () => ArticlesScreen()),
    GetPage(name: '/article-webview', page: () => const ArticleWebViewScreen()),
    GetPage(name: '/gold_Prices', page: () => const GoldPriceScreen()),
  ];

  // Determine initial route based on authentication status
  static String get initialRoute {
    final authController = Get.find<AuthController>();
    return authController.isLoggedIn ? '/home' : '/login';
  }
}
