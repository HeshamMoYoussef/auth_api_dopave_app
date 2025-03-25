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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      defaultTransition: Transition.fade,
      initialRoute: AppRouts.initialRoute,
      getPages: AppRouts.getPages,
    );
  }
}
