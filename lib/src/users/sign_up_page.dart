import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:profile_book_flutter/src/di/di_init.dart';
import 'package:profile_book_flutter/src/users/authentication_service.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  static const routeName = '/signup';
  static const fieldSpacing = 10.0;

  final authenticationService = getIt.get<AuthenticationService>();

  late final BeamerDelegate beamer;

  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    beamer = Beamer.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const Spacer(),
            TextField(
              autocorrect: false,
              controller: loginController,
              decoration: const InputDecoration(hintText: 'Login'),
            ),
            const SizedBox(height: fieldSpacing),
            TextField(
              controller: passwordController,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            const SizedBox(height: fieldSpacing),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Confirm Password',
              ),
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () async {
                  await _signUp();
                  beamer.beamBack();
                },
                child: const SizedBox(
                    height: 50,
                    width: 220,
                    child: Center(
                      child: Text('Sign Up'),
                    ))),
          ],
        ),
      ),
    );
  }

  Future _signUp() async {
    if (confirmPasswordController.text == passwordController.text) {
      return authenticationService.register(
          loginController.text, passwordController.text);
    }
  }
}
