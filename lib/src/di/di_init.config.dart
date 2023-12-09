// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../profiles/profile_controller.dart' as _i7;
import '../profiles/profile_service.dart' as _i4;
import '../settings/settings_controller.dart' as _i8;
import '../settings/settings_service.dart' as _i5;
import '../users/authentication_service.dart' as _i3;
import '../users/user_service.dart' as _i6;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i5.SettingsService>(_i5.SettingsService());
    gh.singleton<_i6.UserService>(_i6.UserService());
    gh.singleton<_i8.SettingsController>(
        _i8.SettingsController(gh<_i5.SettingsService>()));
    gh.singleton<_i4.ProfileService>(_i4.ProfileService());
    gh.singleton<_i7.ProfileController>(
        _i7.ProfileController(gh<_i4.ProfileService>()));
    gh.singleton<_i3.AuthenticationService>(_i3.AuthenticationService());
    return this;
  }
}
