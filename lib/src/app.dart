import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:profile_book_flutter/src/di/di_init.dart';

import 'profiles/profile_add_edit_page.dart';
import 'profiles/profile_list_page.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_page.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });

  final routerDelegate = BeamerDelegate(
    locationBuilder: RoutesLocationBuilder(
      routes: {
        // Return either Widgets or BeamPages if more customization is needed
        '/': (context, state, data) => const ProfileListPage(),
        SettingsPage.routeName: (context, state, data) => SettingsPage(),
        ProfileAddEditPage.routeName: (context, state, data) => const ProfileAddEditPage(),
        // '/books/:bookId': (context, state, data) {
        //   // Take the path parameter of interest from BeamState
        //   final bookId = state.pathParameters['bookId']!;
        //   // Collect arbitrary data that persists throughout navigation
        //   final info = (data as MyObject).info;
        //   // Use BeamPage to define custom behavior
        //   return BeamPage(
        //     key: ValueKey('book-$bookId'),
        //     title: 'A Book #$bookId',
        //     popToNamed: '/',
        //     type: BeamPageType.scaleTransition,
        //     child: BookDetailsScreen(bookId, info),
        //   );
        // }
      },
    ).call,
  );

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    var settingsController = getIt.get<SettingsController>();

    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          routeInformationParser: BeamerParser(),
          routerDelegate: routerDelegate,
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

          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
        );
      },
    );
  }
}
