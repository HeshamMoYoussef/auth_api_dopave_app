import 'dart:developer';

import 'package:auth_api_dopave_app/controllers/auth_controller.dart';
import 'package:auth_api_dopave_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

class OtpVerificationScreen extends GetView<AuthController> {
  OtpVerificationScreen({super.key});

  final AuthController _authController = Get.find<AuthController>();
  final RxString _otpCode = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التحقق من الكود'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'أدخل رمز التحقق',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'تم إرسال الرمز إلى ${_authController.phone.value}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              OtpTextField(
                numberOfFields: 4,
                borderColor: Theme.of(context).primaryColor,
                focusedBorderColor: Theme.of(context).primaryColor,
                showFieldAsBox: true,
                onCodeChanged: (String code) {
                  _otpCode.value = code;
                },
                onSubmit: (String verificationCode) {
                  _otpCode.value = verificationCode;
                },
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
                  text: 'تحقق',
                  isLoading: _authController.isLoading.value,
                  onPressed: () async {
                    if (_otpCode.value.length == 4) {
                      final result = await _authController.verifyOtpCode(
                        _otpCode.value,
                      );
                      if (result) {
                        log(result.toString());
                        Get.toNamed('/register');
                      }
                    } else {
                      Get.snackbar(
                        'خطأ',
                        'يرجى إدخال الرمز المكون من 4 أرقام',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 3),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('لم تستلم الرمز؟', style: TextStyle(fontSize: 16)),
                  TextButton(
                    onPressed: () async {
                      final result = await _authController.sendVerificationCode(
                        _authController.phone.value,
                      );
                      if (result) {
                        Get.snackbar(
                          'تم',
                          'تم إعادة إرسال رمز التحقق',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: const Text(
                      'إعادة الإرسال',
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
    );
  }
}
