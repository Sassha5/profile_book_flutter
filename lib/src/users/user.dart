import 'package:isar/isar.dart';

part 'user.g.dart';

@Collection()
class User {
  User();

  Id id = Isar.autoIncrement;

  String login = '';
  //todo add security
  String password = '';
}
