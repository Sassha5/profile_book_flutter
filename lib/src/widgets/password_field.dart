import 'package:flutter/material.dart';
import 'package:profile_book_flutter/src/helpers/validation_extensions.dart';

class PasswordField extends StatelessWidget {
  PasswordField({
    super.key,
    required this.controller,
    this.hintText = 'Password'
  });

  final String hintText;

  final TextEditingController controller;

  final _formFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: _formFieldKey,
      controller: controller,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: _validatePassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  String? _validatePassword(String? value) {
    if (value != null && !value.isValidPassword) {
      return 'Please enter a valid password';
    }
    return null;
  }
}