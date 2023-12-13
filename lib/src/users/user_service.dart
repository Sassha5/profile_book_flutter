import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:profile_book_flutter/src/isar/isar_service.dart';
import 'package:profile_book_flutter/src/users/user.dart';

@singleton
class UserService {

  Future<List<User>> getUsers() async {
    var db = await IsarService.getDB();
    return db.users.where().findAll();
  }

  Future<User?> searchByEmail(String email) async {
    var db = await IsarService.getDB();
    return db.users.filter().emailEqualTo(email).findFirst();
  }

  Future<int> add(User user) async {
    var db = await IsarService.getDB();
    return db.writeTxnSync<int>(() => db.users.putSync(user));
  }

  Future update(User user) async {

  }

  Future delete(User user) async {
    var db = await IsarService.getDB();
    db.writeTxnSync<bool>(() => db.users.deleteSync(user.id));
  }
}
