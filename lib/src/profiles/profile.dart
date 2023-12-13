import 'package:isar/isar.dart';

part 'profile.g.dart';

@Collection()
class Profile {
  Profile({required this.userId});

  Id id = Isar.autoIncrement;

  int userId;

  String name = "test";

  String? image;

  DateTime creationDate = DateTime.now();
}
