import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:profile_book_flutter/src/isar/isar_service.dart';
import 'package:profile_book_flutter/src/settings/settings_service.dart';
import 'package:profile_book_flutter/src/users/user.dart';
import 'package:profile_book_flutter/src/users/user_service.dart';

@singleton
class AuthenticationService {
  AuthenticationService(this._userService, this._settingsService);

  final UserService _userService;
  final SettingsService _settingsService;

  Id? _userId;
  Id? get userId => _userId;

  void setUserId(Id? value, {bool save = false}){
    _userId = value;

    if (save){
      _settingsService.updateUserId(value);
    }
  }

  bool get isLoggedIn => userId != null;

  Future<bool> login(String email, String password,
      {bool stayLoggedIn = false}) async {
    var db = await IsarService.getDB();
    var foundUser = await db.users
        .filter()
        .emailEqualTo(email)
        .passwordEqualTo(password)
        .findFirst();

    setUserId(foundUser?.id, save: stayLoggedIn);

    return foundUser != null;
  }

  void logout() {
    setUserId(null, save: true);
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
