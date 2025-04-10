// lib/main.dart
import 'package:auth_api_dopave_app/config/app_bindings.dart';
import 'package:auth_api_dopave_app/config/app_routs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize GetStorage
  await GetStorage.init();
  // Initialize services
  AppBindings().dependencies();
  // await initServices();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      initialRoute: AppRouts.initialRoute,
      getPages: AppRouts.getPages,
      locale: const Locale('ar', 'AR'), // Set the default locale to Arabic
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode:
          box.read('theme') == null || box.read('theme') == 'light'
              ? ThemeMode.light
              : ThemeMode.dark, 
    );
  }
}
