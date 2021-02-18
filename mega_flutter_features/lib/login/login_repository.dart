import 'package:flutter/foundation.dart';
import 'package:mega_flutter_network/database/network_database.dart';
import 'package:mega_flutter_network/mega_dio.dart';
import 'package:mega_flutter_network/models/auth_token.dart';

import 'login_provider_type.dart';

class LoginRepository {
  final MegaDio _noRefreshDio;
  final String loginPath;
  final String loginDocumentKey;
  final String loginPassKey;

  LoginRepository(
    this._noRefreshDio, {
    @required this.loginPath,
    this.loginDocumentKey = 'document',
    this.loginPassKey = 'password',
  })  : assert(_noRefreshDio != null),
        assert(loginPath != null),
        assert(loginDocumentKey != null),
        assert(loginPassKey != null);

  Future<AuthToken> authenticate(String document, String password) async {
    final response = await this._noRefreshDio.post(this.loginPath, data: {
      loginDocumentKey: document,
      loginPassKey: password,
    });

    final token = AuthToken.fromJson(response.data);
    await NetworkDatabase.saveAuthToken(token);
    await NetworkDatabase.saveLogged(true);

    return token;
  }

  Future<AuthToken> authenticateExternalLogin(
    String providerId,
    LoginProviderType provider,
  ) async {
    final response = await this._noRefreshDio.post(
      this.loginPath,
      data: {
        'providerId': providerId,
        'typeProvider': provider.index,
      },
    );

    final token = AuthToken.fromJson(response.data);
    await NetworkDatabase.saveAuthToken(token);
    await NetworkDatabase.saveLogged(true);

    return token;
  }
}
