import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:profile_book_flutter/src/isar/isar_service.dart';
import 'package:profile_book_flutter/src/profiles/profile.dart';
import 'package:profile_book_flutter/src/users/authentication_service.dart';

@singleton
class ProfileService {
  ProfileService(this._authService);

  final AuthenticationService _authService;

  Future<List<Profile>> getUserProfiles() async {
    if (_authService.userId == null)
    {
      return List<Profile>.empty();
    }
    
    var db = await IsarService.getDB();
    return db.profiles.filter().userIdEqualTo(_authService.userId!).findAll();
  }

  Future<int> put(Profile profile) async {
    var db = await IsarService.getDB();
    return db.writeTxnSync<int>(() => db.profiles.putSync(profile));
  }

  Future<bool> delete(Profile profile) async {
    var db = await IsarService.getDB();
    return db.writeTxnSync<bool>(() => db.profiles.deleteSync(profile.id));
  }

  Future<int> deleteMany(Iterable<Profile> profiles) async {
    var db = await IsarService.getDB();
    return db.writeTxnSync<int>(() => db.profiles.deleteAllSync(profiles.map((e) => e.id).toList()));
  }
}
