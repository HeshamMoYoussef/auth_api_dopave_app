import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneInputWidget extends StatelessWidget {
  final Function(String) onInputChanged;
  final String? initialValue;
  final String? Function(String?)? validator;

  const PhoneInputWidget({
    super.key,
    required this.onInputChanged,
    this.initialValue,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: InternationalPhoneNumberInput(
          onInputChanged: (PhoneNumber number) {
            onInputChanged(number.phoneNumber ?? '');
          },
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.DROPDOWN,
          ),
          ignoreBlank: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          selectorTextStyle: const TextStyle(color: Colors.black),
          initialValue:
              initialValue != null
                  ? PhoneNumber(phoneNumber: initialValue, isoCode: 'EG')
                  : PhoneNumber(isoCode: 'EG'),
          formatInput: true,
          keyboardType: const TextInputType.numberWithOptions(signed: true),
          inputDecoration: const InputDecoration(
            hintText: 'رقم الهاتف',
            border: InputBorder.none,
          ),
          validator: validator,
        ),
      ),
    );
  }
}
