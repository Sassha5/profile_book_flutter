import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:profile_book_flutter/src/di/di_init.dart';
import 'package:profile_book_flutter/src/users/authentication_service.dart';
import 'package:profile_book_flutter/src/users/sign_in_page.dart';
import 'package:profile_book_flutter/src/users/sign_up_page.dart';

import 'profiles/profile_add_edit_page.dart';
import 'profiles/profile_list_page.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_page.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });

  late final settingsController = getIt.get<SettingsController>();
  late final authService = getIt.get<AuthenticationService>();

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.

    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          initialRoute: authService.userId == null
              ? SignInPage.routeName
              : ProfileListPage.routeName,
          routes: {
            SignInPage.routeName: (context) => const SignInPage(),
            SignUpPage.routeName: (context) => SignUpPage(),
            SettingsPage.routeName: (context) => SettingsPage(),
            ProfileListPage.routeName: (context) => const ProfileListPage(),
            ProfileAddEditPage.routeName: (context) =>
                const ProfileAddEditPage(),
          },
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',
          locale: settingsController.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ru'),
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: settingsController.themeMode,
        );
      },
    );
  }
}

ThemeData lightTheme = ThemeData(primaryColor: Colors.amberAccent);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.amber,
);
