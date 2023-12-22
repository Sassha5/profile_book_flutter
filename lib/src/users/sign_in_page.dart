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
  final _authService = getIt.get<AuthenticationService>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _stayLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const Spacer(),
            EmailField(controller: _emailController),
            const SizedBox(height: 10),
            PasswordField(controller: _passwordController),
            const Spacer(flex: 2),
            Row(
              children: [
                Checkbox(
                  value: _stayLoggedIn,
                  onChanged: (value) => setState(() => _stayLoggedIn = value!),
                ),
                const Text('Remember me'),
                const Spacer(),
                ElevatedButton(
                    onPressed: () => _logIn(context),
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
                onPressed: () async {
                  var resultEmail = await Navigator.of(context)
                      .pushNamed(SignUpPage.routeName);
                  setState(() => _emailController.text = resultEmail as String);
                },
                child: const Text('Sign Up')),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _logIn(BuildContext context) async {
    var result = await _authService.login(
        _emailController.text, _passwordController.text,
        stayLoggedIn: _stayLoggedIn);

    if (context.mounted) {
      if (result) {
        Navigator.of(context).pushNamedAndRemoveUntil(ProfileListPage.routeName, (_) => false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Could not log in')));
      }
    }
  }
}
