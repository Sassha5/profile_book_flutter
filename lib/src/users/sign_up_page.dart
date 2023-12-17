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
  static const _fieldSpacing = 10.0;

  final _authenticationService = getIt.get<AuthenticationService>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Hero(tag: 'signup', child: Material(child: Text('Sign Up', style: TextStyle(fontSize: 20),)))),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Spacer(),
              EmailField(controller: _emailController),
              const SizedBox(height: _fieldSpacing),
              PasswordField(controller: _passwordController),
              const SizedBox(height: _fieldSpacing),
              PasswordField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password'),
              const SizedBox(height: _fieldSpacing),
              const Align(
                alignment: Alignment.centerRight,
                child: Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    showDuration: Duration(seconds: 3),
                    message:
                        'The password should contain at least 8 characters and include a number, a special character, upper and lower case letter',
                    child: Icon(Icons.info)),
              ),
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
      if (_confirmPasswordController.text == _passwordController.text) {
        var result = await _authenticationService.register(
            _emailController.text, _passwordController.text);

        if (context.mounted) {
          if (result) {
            context.beamBack(data: _emailController.text);
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
