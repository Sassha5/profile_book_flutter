import 'package:flutter/material.dart';
import 'package:profile_book_flutter/src/di/di_init.dart';
import 'package:profile_book_flutter/src/profiles/profile.dart';
import 'package:profile_book_flutter/src/profiles/profile_controller.dart';
import 'package:profile_book_flutter/src/settings/settings_controller.dart';

/// Displays detailed information about a SampleItem.
class ProfileAddEditPage extends StatefulWidget {
  const ProfileAddEditPage({super.key});

  static const routeName = '/addeditprofile';

  @override
  State<ProfileAddEditPage> createState() => _ProfileAddEditPageState();
}

class _ProfileAddEditPageState extends State<ProfileAddEditPage> {
  final ProfileController controller = getIt.get<ProfileController>();
  final SettingsController settingsController = getIt.get<SettingsController>();

  final _nameFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Text('Enter name'),
            TextField(controller: _nameFieldController),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        shape: const CircleBorder(),
        tooltip: 'Save',
        onPressed: () {
          var newProfile = Profile(userId: settingsController.userId!);
          newProfile.name = _nameFieldController.text;
          controller.addOrUpdate(newProfile);
          Navigator.of(context).maybePop();
        },
        child: const Icon(Icons.save, color: Colors.white, size: 28),
      ),
    );
  }
}
