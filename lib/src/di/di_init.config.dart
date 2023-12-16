// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../profiles/profile_controller.dart' as _i8;
import '../profiles/profile_service.dart' as _i6;
import '../settings/settings_controller.dart' as _i7;
import '../settings/settings_service.dart' as _i3;
import '../users/authentication_service.dart' as _i5;
import '../users/user_service.dart' as _i4;

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
    gh.singleton<_i3.SettingsService>(_i3.SettingsService());
    gh.singleton<_i4.UserService>(_i4.UserService());
    gh.singleton<_i5.AuthenticationService>(_i5.AuthenticationService(
      gh<_i4.UserService>(),
      gh<_i3.SettingsService>(),
    ));
    gh.singleton<_i6.ProfileService>(
        _i6.ProfileService(gh<_i5.AuthenticationService>()));
    gh.singleton<_i7.SettingsController>(_i7.SettingsController(
      gh<_i3.SettingsService>(),
      gh<_i5.AuthenticationService>(),
    ));
    gh.singleton<_i8.ProfileController>(
        _i8.ProfileController(gh<_i6.ProfileService>()));
    return this;
  }
}
