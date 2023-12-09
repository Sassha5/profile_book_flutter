import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:profile_book_flutter/src/di/di_init.dart';
import 'package:profile_book_flutter/src/profiles/profile_list_page.dart';
import 'package:profile_book_flutter/src/users/authentication_service.dart';
import 'package:profile_book_flutter/src/users/sign_up_page.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  static const routeName = '/signin';

  final authService = getIt.get<AuthenticationService>();

  late final BeamerDelegate beamer;

  final loginController = TextEditingController();
  final passwordController = TextEditingController();

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
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () async {
                  var result = await authService.login(
                      loginController.text, passwordController.text);

                  if (result) {
                    beamer.beamToReplacementNamed(ProfileListPage.routeName);
                  }
                },
                child: const SizedBox(
                    height: 50,
                    width: 220,
                    child: Center(
                      child: Text('Sign In'),
                    ))),
            TextButton(
                onPressed: () =>
                    Beamer.of(context).beamToNamed(SignUpPage.routeName),
                child: const Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}
