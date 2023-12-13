import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:profile_book_flutter/src/isar/isar_service.dart';
import 'package:profile_book_flutter/src/settings/settings_controller.dart';
import 'package:profile_book_flutter/src/users/user.dart';
import 'package:profile_book_flutter/src/users/user_service.dart';

@singleton
class AuthenticationService {
  AuthenticationService(this._userService, this._settingsController);

  final UserService _userService;
  final SettingsController _settingsController;

  bool get isLoggedIn => _settingsController.userId != null;

  Future<bool> login(String email, String password,
      {bool stayLoggedIn = false}) async {
    var db = await IsarService.getDB();
    var foundUser = await db.users
        .filter()
        .emailEqualTo(email)
        .passwordEqualTo(password)
        .findFirst();

    _settingsController.setUserId(foundUser?.id, save: stayLoggedIn);

    return foundUser != null;
  }

  void logout() {
    _settingsController.setUserId(null, save: true);
  }

  Future<bool> register(String email, String password) async {
    var db = await IsarService.getDB();
    var foundUser = await db.users.filter().emailEqualTo(email).findFirst();

    if (foundUser == null) {
      var newUser = User();
      newUser.email = email;
      newUser.password = password;

      _userService.add(newUser);
      return true;
    } else {
      return false;
    }
  }
}
