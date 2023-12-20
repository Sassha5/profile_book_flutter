import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:profile_book_flutter/src/di/di_init.dart';
import 'package:profile_book_flutter/src/profiles/profile.dart';
import 'package:profile_book_flutter/src/profiles/profile_controller.dart';
import 'package:profile_book_flutter/src/users/authentication_service.dart';
import 'package:profile_book_flutter/src/widgets/profile_avatar.dart';

class ProfileAddEditPage extends StatefulWidget {
  const ProfileAddEditPage({super.key});

  static const routeName = '/addeditprofile';

  @override
  State<ProfileAddEditPage> createState() => _ProfileAddEditPageState();
}

class _ProfileAddEditPageState extends State<ProfileAddEditPage> {
  final ProfileController _controller = getIt.get<ProfileController>();
  final AuthenticationService _authService = getIt.get<AuthenticationService>();

  final _nameFieldController = TextEditingController();

  late Profile profile = Profile(userId: _authService.userId!);

  @override
  Widget build(BuildContext context) {
    if (context.currentBeamLocation.data is Profile) {
      profile = context.currentBeamLocation.data as Profile;
      _nameFieldController.text = profile.name;

      context.currentBeamLocation.data = null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${context.currentBeamLocation.data is Profile ? 'Add new' : 'Edit'} profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: InkResponse(
                  onTap: _pickImage,
                  child: ProfileAvatar(profile.image, radius: 100)),
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

  @override
  void dispose() {
    _nameFieldController.dispose();
    super.dispose();
  }

  void _saveProfile(BuildContext context) async {
    profile.name = _nameFieldController.text;

    var documents = await getApplicationDocumentsDirectory();

    if (profile.image != null) {
      var savedImage =
          await File(profile.image!).copy('${documents.path}/${profile.name}');

      profile.image = savedImage.path;
    }

    await _controller.addOrUpdate(profile);

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
            profile.image = pickedImage.path;
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
                  child: const Row(
                    children: [
                      Icon(Icons.camera),
                      SizedBox(width: 10),
                      Text('Camera'),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                  child: const Row(
                    children: [
                      Icon(Icons.image),
                      SizedBox(width: 10),
                      Text('Gallery'),
                    ],
                  ),
                ),
              ],
            ));
  }
}
