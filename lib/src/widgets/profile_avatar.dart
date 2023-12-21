import 'dart:io';

import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar(this.imagePath, {super.key, this.radius});

  final String? imagePath;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final avatar =
        CircleAvatar(backgroundImage: _getImage(imagePath), radius: radius);

    return imagePath == null ? avatar : Hero(tag: imagePath!, child: avatar);
  }

  ImageProvider<Object> _getImage(String? path) {
    if (path == null) {
      return const AssetImage('assets/images/flutter_logo.png');
    } else {
      return FileImage(File(path));
    }
  }
}
