import 'dart:convert';

import 'package:isar/isar.dart';

part 'profile.g.dart';

@Collection()
class Profile {
  Profile({required this.userId});

  Profile.fromJson(Map<String, dynamic> json)
      : id = json['id'] as Id,
        userId = json['userId'] as int,
        name = json['name'] as String,
        image = json['image'] as String,
        creationDate = DateTime.parse(json['creationDate']);

  Id id = Isar.autoIncrement;

  int userId;

  String name = "test";

  String? image;

  DateTime creationDate = DateTime.now();

  @Ignore()
  bool isSelected = false;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'name': name,
        'image': image,
        'creationDate': creationDate.toIso8601String(),
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
