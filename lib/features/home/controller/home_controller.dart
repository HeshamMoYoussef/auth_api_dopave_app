

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {

  final box = GetStorage();
  final pageController = PageController();
  int index = 0;

  void changeThemeModeApp() {
    String? theme = box.read('theme');
    if (theme == null || theme == 'light') {
      Get.changeThemeMode(ThemeMode.dark);
      box.write('theme', 'dark');
    } else {
      Get.changeThemeMode(ThemeMode.light);
      box.write('theme', 'light');
    }
    update();
  }

  IconData changeIconTheme() {
    String? theme = box.read('theme');
    if (theme == 'light') {
      return Icons.light_mode_outlined;
    } else {
      return Icons.dark_mode_outlined;
    }
  }
    void changeIndexNavBar({required int currentIndex}) {
    index = currentIndex;
    update();
  }
  }