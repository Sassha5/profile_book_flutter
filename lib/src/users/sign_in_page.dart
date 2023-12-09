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

  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var stayLoggedIn = false;

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
            Row(
              children: [
                Checkbox(
                  value: stayLoggedIn,
                  onChanged: (value) => stayLoggedIn = value!,
                ),
                const Text('Remember me'),
                const Spacer(),
                ElevatedButton(
                    onPressed: () async {
                      var result = await authService.login(
                          loginController.text, passwordController.text,
                          stayLoggedIn: stayLoggedIn);

                      if (result && context.mounted) {
                        context.beamToNamed(ProfileListPage.routeName);
                      }
                    },
                    child: const SizedBox(
                        height: 50,
                        width: 100,
                        child: Center(
                          child: Text('Sign In'),
                        ))),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Divider(height: 1, thickness: 1, color: Colors.red,),//not visible
                Text('or'),
                Divider(thickness: 1,),
              ],
            ),
            TextButton(
                onPressed: () => context.beamToNamed(SignUpPage.routeName),
                child: const Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}
