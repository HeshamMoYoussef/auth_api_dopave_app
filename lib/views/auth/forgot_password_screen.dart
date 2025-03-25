import 'package:auth_api_dopave_app/controllers/auth_controller.dart';
import 'package:auth_api_dopave_app/utils/validators.dart';
import 'package:auth_api_dopave_app/widgets/custom_button.dart';
import 'package:auth_api_dopave_app/widgets/phone_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  ForgotPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = Get.find<AuthController>();
  final RxString _phoneNumber = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('استعادة كلمة المرور'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'استعادة كلمة المرور',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'أدخل رقم الهاتف وسنرسل لك كلمة مرور جديدة',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                PhoneInputWidget(
                  onInputChanged: (phoneNumber) {
                    _phoneNumber.value = phoneNumber;
                  },
                  validator: Validators.validatePhone,
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
                    text: 'إرسال',
                    isLoading: _authController.isLoading.value,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final result = await _authController.forgotPassword(
                          _phoneNumber.value,
                        );
                        if (result) {
                          Get.dialog(
                            AlertDialog(
                              title: const Text('تم'),
                              content: const Text(
                                'تم إرسال كلمة مرور جديدة إلى هاتفك',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                    Get.offNamed('/login');
                                  },
                                  child: const Text('موافق'),
                                ),
                              ],
                            ),
                          );
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
                      'تذكرت كلمة المرور؟',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        'تسجيل الدخول',
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
    );
  }
}
