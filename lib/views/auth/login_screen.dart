import 'package:auth_api_dopave_app/controllers/auth_controller.dart';
import 'package:auth_api_dopave_app/controllers/user_controller.dart';
import 'package:auth_api_dopave_app/widgets/custom_button.dart';
import 'package:auth_api_dopave_app/widgets/custom_text_field.dart';
import 'package:auth_api_dopave_app/widgets/phone_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<AuthController> {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = Get.find<AuthController>();
    final UserController _userController = Get.find<UserController>();

  final RxString _phoneNumber = ''.obs;
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'مرحبًا بعودتك',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'قم بتسجيل الدخول للمتابعة',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 40),
                  PhoneInputWidget(
                    onInputChanged: (phoneNumber) {
                      _phoneNumber.value = phoneNumber;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال رقم الهاتف';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'كلمة المرور',
                    controller: _passwordController,
                    obscureText: true,
                    prefix: const Icon(Icons.lock),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال كلمة المرور';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed('/forgot-password');
                      },
                      child: const Text(
                        'نسيت كلمة المرور؟',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () =>
                        _authController.errorMessage.isNotEmpty
                            ? Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                _authController.errorMessage.value,
                                style: const TextStyle(color: Colors.red),
                              ),
                            )
                            : const SizedBox.shrink(),
                  ),
                  Obx(
                    () => CustomButton(
                      text: 'تسجيل الدخول',
                      isLoading: _authController.isLoading.value,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final result = await _authController.login(
                            _phoneNumber.value,
                            _passwordController.text,
                          );
                          _userController.getUserProfile();
                          if (result) {
                            Get.offAllNamed('/home');
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'ليس لديك حساب؟',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed('/phone-input');
                        },
                        child: const Text(
                          'إنشاء حساب',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
