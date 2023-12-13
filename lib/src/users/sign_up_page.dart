import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:profile_book_flutter/src/di/di_init.dart';
import 'package:profile_book_flutter/src/users/authentication_service.dart';
import 'package:profile_book_flutter/src/widgets/email_field.dart';
import 'package:profile_book_flutter/src/widgets/password_field.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  static const routeName = '/signup';
  static const fieldSpacing = 10.0;

  final authenticationService = getIt.get<AuthenticationService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Spacer(),
              EmailField(controller: emailController),
              const SizedBox(height: fieldSpacing),
              PasswordField(controller: passwordController),
              const SizedBox(height: fieldSpacing),
              PasswordField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password'),
              const Spacer(flex: 2),
              ElevatedButton(
                  onPressed: () async => await _signUp(context),
                  child: const SizedBox(
                      height: 50,
                      width: 220,
                      child: Center(
                        child: Text('Sign Up'),
                      ))),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (confirmPasswordController.text == passwordController.text) {
        var result = await authenticationService.register(
            emailController.text, passwordController.text);

        if (context.mounted) {
          if (result) {
            context.beamBack(data: emailController.text);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not register')));
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Passwords do not match')));
      }
    }
  }
}
