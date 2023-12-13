import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:profile_book_flutter/src/di/di_init.dart';
import 'package:profile_book_flutter/src/profiles/profile.dart';
import 'package:profile_book_flutter/src/profiles/profile_controller.dart';
import 'package:profile_book_flutter/src/settings/settings_controller.dart';
import 'package:profile_book_flutter/src/widgets/profile_avatar.dart';

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

  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: InkResponse(
                  onTap: _pickImage,
                  child: ProfileAvatar(imageFile?.path, radius: 100)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameFieldController,
              decoration: const InputDecoration(hintText: 'Profile name'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        shape: const CircleBorder(),
        tooltip: 'Save',
        onPressed: () => _saveProfile(context),
        child: const Icon(Icons.save, color: Colors.white, size: 28),
      ),
    );
  }

  void _saveProfile(BuildContext context) async {
    var newProfile = Profile(userId: settingsController.userId!);
    newProfile.name = _nameFieldController.text;

    var documents = await getApplicationDocumentsDirectory();
    var savedImage =
        await imageFile?.copy('${documents.path}/${newProfile.name}');

    newProfile.image = savedImage?.path;
    await controller.addOrUpdate(newProfile);

    if (context.mounted) {
      context.beamBack();
    }
  }

  Future<void> _pickImage() async {
    try {
      var source = await _selectSource(context);
      if (source != null) {
        final pickedImage = await ImagePicker().pickImage(source: source);
        if (pickedImage != null) {
          setState(() {
            imageFile = File(pickedImage.path);
          });
        }
      }
    } catch (e) {
      //todo show snackbar
    }
  }
  
  Future<ImageSource?> _selectSource(BuildContext context) {
    return showDialog<ImageSource>(
        context: context,
        builder: (context) => SimpleDialog(
              title: const Text('Pick image source'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                  child: const Text('Camera'),
                ),
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                  child: const Text('Gallery'),
                ),
              ],
            ));
  }
}
