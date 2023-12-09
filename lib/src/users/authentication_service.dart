import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:profile_book_flutter/src/di/di_init.dart';
import 'package:profile_book_flutter/src/isar/isar_service.dart';
import 'package:profile_book_flutter/src/settings/settings_controller.dart';
import 'package:profile_book_flutter/src/users/user.dart';
import 'package:profile_book_flutter/src/users/user_service.dart';

@singleton
class AuthenticationService {
  final userService = getIt.get<UserService>();
  final settingsController = getIt.get<SettingsController>();

  Id? get userId => settingsController.userId;
  bool get stayLoggedIn => settingsController.stayLoggedIn;

  Future<bool> login(String login, String password,
      {bool stayLoggedIn = false}) async {
    var db = await IsarService.getDB();
    var foundUser = await db.users
        .filter()
        .loginEqualTo(login)
        .passwordEqualTo(password)
        .findFirst();

    settingsController.userId = foundUser?.id;
    settingsController.stayLoggedIn = stayLoggedIn;

    return foundUser != null;
  }

  void logout() {
    settingsController.userId = null;
  }

  Future<bool> register(String login, String password) async {
    var db = await IsarService.getDB();
    var foundUser = await db.users.filter().loginEqualTo(login).findFirst();

    if (foundUser == null) {
      var newUser = User();
      newUser.login = login;
      newUser.password = password;

      userService.add(newUser);
      return true;
    } else {
      return false;
    }
  }
}
