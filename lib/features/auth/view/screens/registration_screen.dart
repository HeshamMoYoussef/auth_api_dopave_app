import 'package:auth_api_dopave_app/features/auth/controller/auth_controller.dart';
import 'package:auth_api_dopave_app/utils/validators.dart';
import 'package:auth_api_dopave_app/custom_widgets/custom_button.dart';
import 'package:auth_api_dopave_app/features/auth/view/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RegistrationScreen extends GetView<AuthController> {
  RegistrationScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب جديد'), centerTitle: true),
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
                      'أكمل بياناتك',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Display the phone number (read-only)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.grey),
                        const SizedBox(width: 12),
                        Text(
                          _authController.phone.value,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'الاسم',
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    prefix: const Icon(Icons.person),
                    validator: Validators.validateName,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'كلمة المرور',
                    controller: _passwordController,
                    obscureText: true,
                    prefix: const Icon(Icons.lock),
                    validator: Validators.validatePassword,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'تأكيد كلمة المرور',
                    controller: _confirmPasswordController,
                    obscureText: true,
                    prefix: const Icon(Icons.lock_outline),
                    validator: Validators.validatePassword,
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
                      text: 'إنشاء حساب',
                      isLoading: _authController.isLoading.value,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final result = await _authController.register(
                            _nameController.text,
                            _passwordController.text,
                          );
                          if (result) {
                            Get.offAllNamed('/home');
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
