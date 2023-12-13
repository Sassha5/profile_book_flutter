import 'package:flutter/material.dart';
import 'package:profile_book_flutter/src/helpers/validation_extensions.dart';

class EmailField extends StatelessWidget {
  EmailField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  final _formFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: _formFieldKey,
      autocorrect: false,
      controller: controller,
      decoration: const InputDecoration(hintText: 'Email'),
      validator: _validateEmail,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  String? _validateEmail(String? value) {
    if (value != null && !value.isValidEmail) {
      return 'Please enter a valid email';
    }
    return null;
  }
}
