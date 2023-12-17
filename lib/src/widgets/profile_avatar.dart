import 'dart:io';

import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar(this.imagePath, {super.key, this.radius});

  final String? imagePath;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: imagePath ?? 'image',
        child: CircleAvatar(
            backgroundImage: _getImage(imagePath), radius: radius));
  }

  ImageProvider<Object> _getImage(String? path) {
    if (path == null) {
      return const AssetImage('assets/images/flutter_logo.png');
    } else {
      return FileImage(File(path));
    }
  }
}
