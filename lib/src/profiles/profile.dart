import 'package:isar/isar.dart';

part 'profile.g.dart';

@Collection()
class Profile {
  Profile();

  Id id = Isar.autoIncrement;

  String name = "test";

  DateTime creationDate = DateTime.now();
}
