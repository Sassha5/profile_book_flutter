import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:profile_book_flutter/src/di/di_init.dart';
import 'package:profile_book_flutter/src/isar/isar_service.dart';
import 'package:profile_book_flutter/src/profiles/profile.dart';
import 'package:profile_book_flutter/src/settings/settings_controller.dart';

@singleton
class ProfileService {
  final settingsController = getIt.get<SettingsController>();

  Future<List<Profile>> getUserProfiles() async {
    var db = await IsarService.getDB();
    return db.profiles.filter().userIdEqualTo(settingsController.userId!).findAll();
  }

  Future add(Profile profile) async {
    var db = await IsarService.getDB();
    db.writeTxnSync<int>(() => db.profiles.putSync(profile));
  }

  Future update(Profile profile) async {

  }

  Future delete(Profile profile) async {
    var db = await IsarService.getDB();
    db.writeTxnSync<bool>(() => db.profiles.deleteSync(profile.id));
  }
}
