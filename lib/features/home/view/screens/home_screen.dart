import 'dart:developer';

import 'package:auth_api_dopave_app/features/articles/view/screens/articles_screen.dart';
import 'package:auth_api_dopave_app/features/auth/controller/auth_controller.dart';
import 'package:auth_api_dopave_app/features/gold_price/view/goldprice_screen.dart';
import 'package:auth_api_dopave_app/features/home/controller/home_controller.dart';
import 'package:auth_api_dopave_app/features/matches/view/screens/matches_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<HomeController>();
    Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Sports App'),
        actions: [
          GetBuilder<HomeController>(
            builder:
                (controller) => IconButton(
                  onPressed: () {
                    controller.changeThemeModeApp();
                    log(controller.box.read('theme').toString());
                  },
                  icon: Icon(controller.changeIconTheme()),
                ),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _showLogoutDialog(),
            tooltip: 'تسجيل الخروج',
          ),
        ],
      ),
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (index) {
          controller.changeIndexNavBar(currentIndex: index);
        },
        children: [ArticlesScreen(), MatchesScreen(), GoldPriceScreen()],
      ),
      bottomNavigationBar: GetBuilder<HomeController>(
        builder:
            (controller) => BottomNavigationBar(
              currentIndex: controller.index,
              fixedColor: Colors.blue,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                controller.changeIndexNavBar(currentIndex: index);
                controller.pageController.jumpToPage(index);
                log(index.toString());
              },
              // type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.article_outlined),
                  label: 'أخبار رياضية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.sports_soccer_outlined),
                  label: 'مباريات',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.monetization_on_outlined),
                  label: 'أسعار الذهب',
                ),
              ],
            ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
          GetBuilder<AuthController>(
            builder:
                (controller) => TextButton(
                  onPressed: () {
                    Get.back();
                    controller.logout();
                  },
                  child: const Text('تأكيد'),
                ),
          ),
        ],
      ),
    );
  }
}
