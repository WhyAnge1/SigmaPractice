// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_practice/network/api_client.dart' as _i3;
import 'package:flutter_practice/services/authorization_service.dart' as _i4;
import 'package:flutter_practice/services/comments_service.dart' as _i8;
import 'package:flutter_practice/services/ip_service.dart' as _i5;
import 'package:flutter_practice/services/text_convertion_service.dart' as _i6;
import 'package:flutter_practice/services/user_service.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

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
    gh.singleton<_i3.ApiClient>(
      _i3.ApiClient(),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i4.AuthorizationService>(() => _i4.AuthorizationService());
    gh.factory<_i5.IpService>(() => _i5.IpService(gh<_i3.ApiClient>()));
    gh.factory<_i6.TextConvertionService>(
        () => _i6.TextConvertionService(gh<_i3.ApiClient>()));
    gh.factory<_i7.UserService>(() => _i7.UserService());
    gh.factory<_i8.CommentsService>(
        () => _i8.CommentsService(gh<_i7.UserService>()));
    return this;
  }
}
