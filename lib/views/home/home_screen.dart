// lib/views/home/home_screen.dart
import 'package:auth_api_dopave_app/controllers/auth_controller.dart';
import 'package:auth_api_dopave_app/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<AuthController> {
  HomeScreen({super.key});

  final AuthController _authController = Get.find<AuthController>();
  final UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    final user = _userController.user.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة الرئيسية'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('حذف الحساب'),
                  content: const Text('هل أنت متأكد من حذف الحساب ؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        _authController.deleteUser();
                      },
                      child: const Text('تأكيد'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('تسجيل الخروج'),
                  content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        _authController.logout();
                      },
                      child: const Text('تأكيد'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Obx(() {
              if (_userController.isLoading.value) {
                return const CircularProgressIndicator();
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'تم تسجيل الدخول بنجاح',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Text(
                            'بيانات المستخدم',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 10),
                          _buildUserInfoRow('الاسم', user?.name ?? 'غير متوفر'),
                          _buildUserInfoRow(
                            'رقم الهاتف',
                            user?.phone ?? 'غير متوفر',
                          ),
                          _buildUserInfoRow(
                            'تاريخ التسجيل',
                            user?.createdAt ?? 'غير متوفر',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  // Helper method to build user info row
  Widget _buildUserInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// import 'package:auth_api_dopave_app/controllers/auth_controller.dart';
// import 'package:auth_api_dopave_app/controllers/user_controller.dart';
// import 'package:auth_api_dopave_app/widgets/custom_button.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class HomeScreen extends GetView<AuthController> {
//   HomeScreen({super.key});

//   final AuthController _authController = Get.find<AuthController>();
//   final UserController _userController = Get.find<UserController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('الصفحة الرئيسية'),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               _authController.logout();
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 20),
//                 const Text(
//                   'مرحبًا بك في التطبيق',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 40),
//                 Obx(() {
//                   if (_authController.isLoading.value) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   final user = _authController.currentUser.value;

//                   if (user == null) {
//                     return const Center(
//                       child: Text('لم يتم العثور على بيانات المستخدم'),
//                     );
//                   }

//                   return Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Column(
//                         children: [
//                           const CircleAvatar(
//                             radius: 50,
//                             backgroundColor: Colors.grey,
//                             child: Icon(
//                               Icons.person,
//                               size: 50,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           Text(
//                             user.name,
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             user.phone,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'عضو منذ: ${user.createdAt}',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//                 const SizedBox(height: 40),
//                 Obx(
//                   () => CustomButton(
//                     text: 'تحديث البيانات الشخصية',
//                     isLoading: _userController.isLoading.value,
//                     onPressed: () {
//                       final TextEditingController nameController =
//                           TextEditingController(
//                             text: _authController.currentUser.value?.name,
//                           );

//                       Get.dialog(
//                         AlertDialog(
//                           title: const Text('تحديث البيانات'),
//                           content: TextField(
//                             controller: nameController,
//                             decoration: const InputDecoration(
//                               labelText: 'الاسم',
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Get.back();
//                               },
//                               child: const Text('إلغاء'),
//                             ),
//                             TextButton(
//                               onPressed: () async {
//                                 if (nameController.text.isNotEmpty) {
//                                   final result = await _userController
//                                       .updateProfile(nameController.text);
//                                   if (result) {
//                                     Get.back();
//                                     Get.snackbar(
//                                       'تم',
//                                       'تم تحديث البيانات بنجاح',
//                                       snackPosition: SnackPosition.BOTTOM,
//                                       backgroundColor: Colors.green,
//                                       colorText: Colors.white,
//                                     );

//                                     // Update currentUser in AuthController
//                                     _authController.currentUser.value =
//                                         _userController.user.value;
//                                   }
//                                 }
//                               },
//                               child: const Text('تحديث'),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
