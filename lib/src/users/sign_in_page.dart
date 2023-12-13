import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:profile_book_flutter/src/di/di_init.dart';
import 'package:profile_book_flutter/src/profiles/profile_list_page.dart';
import 'package:profile_book_flutter/src/users/authentication_service.dart';
import 'package:profile_book_flutter/src/users/sign_up_page.dart';
import 'package:profile_book_flutter/src/widgets/email_field.dart';
import 'package:profile_book_flutter/src/widgets/password_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  static const routeName = '/signin';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final authService = getIt.get<AuthenticationService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool stayLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    if (context.currentBeamLocation.data is String) {
      setState(() {
        emailController.text = context.currentBeamLocation.data as String;
      });
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const Spacer(),
            EmailField(controller: emailController),
            const SizedBox(height: 10),
            PasswordField(controller: passwordController),
            const Spacer(flex: 2),
            Row(
              children: [
                Checkbox(
                  value: stayLoggedIn,
                  onChanged: (value) => setState(() => stayLoggedIn = value!),
                ),
                const Text('Remember me'),
                const Spacer(),
                ElevatedButton(
                    onPressed: () async {
                      var result = await authService.login(
                          emailController.text, passwordController.text,
                          stayLoggedIn: stayLoggedIn);

                      if (result && context.mounted) {
                        context.beamToReplacementNamed(
                            ProfileListPage.routeName,
                            stacked: false);
                      }
                    },
                    child: const SizedBox(
                        height: 50,
                        width: 100,
                        child: Center(child: Text('Sign In')))),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Divider(thickness: 1, endIndent: 10)),
                Text('or'),
                Expanded(child: Divider(thickness: 1, indent: 10)),
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
