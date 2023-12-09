import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/languages.dart';
import 'package:profile_book_flutter/src/di/di_init.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  static const routeName = '/settings';

  final SettingsController controller = getIt.get<SettingsController>();

  @override
  Widget build(BuildContext context) {
    var app = context.findAncestorWidgetOfExactType<MaterialApp>();
    var supportedLocales = app?.supportedLocales;

    var drowpownLanguages = List.generate(
        supportedLocales?.length ?? 0,
        (index) => Language.fromIsoCode(
            supportedLocales!.elementAt(index).languageCode));

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Glue the SettingsController to the theme selection DropdownButton.
            //
            // When a user selects a theme from the dropdown list, the
            // SettingsController is updated, which rebuilds the MaterialApp.
            DropdownButton<ThemeMode>(
              // Read the selected themeMode from the controller
              value: controller.themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: controller.updateThemeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                )
              ],
            ),
            LanguagePickerDropdown(
                initialValue:
                    Language.fromIsoCode(app?.locale?.languageCode ?? 'en'),
                languages: drowpownLanguages,
                onValuePicked: (Language language) {
                  controller.setLocale(Locale(language.isoCode));
                })
          ],
        ),
      ),
    );
  }
}
