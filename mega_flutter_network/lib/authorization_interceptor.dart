import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'database/network_database.dart';
import 'mega_dio.dart';
import 'models/auth_token.dart';
import 'models/mega_response.dart';
import 'request_retrier.dart';

class AuthorizationInterceptor extends InterceptorsWrapper {
  final String authUrl;
  final String defaultUrl;
  final String anonymousAuth;
  final MegaDio httpClient;
  final Dio dio;
  AuthToken _token;

  AuthorizationInterceptor(
    this.authUrl,
    this.defaultUrl,
    this.anonymousAuth,
    this.httpClient,
    this.dio,
  )   : assert(authUrl != null),
        assert(defaultUrl != null),
        assert(dio != null),
        assert(httpClient != null);

  @override
  Future onRequest(RequestOptions options) async {
    options.cancelToken = CancelToken();
    _token = await NetworkDatabase.loadAuthToken();

    //REVALIDATE TOKEN
    if (_token != null && _token.expiresIn != null) {
      final timeExpire = DateTime.fromMillisecondsSinceEpoch(_token.expiresIn);
      final timeExpireRefresh = timeExpire.add(const Duration(minutes: 115));

      if (timeExpire.isBefore(DateTime.now().add(const Duration(minutes: 1)))) {
        if (!timeExpireRefresh.isBefore(DateTime.now())) {
          try {
            _token = await _refreshToken(_token);
          } on MegaResponse catch (_) {
            _token = await _anonymousAuth(options);
          }

          NetworkDatabase.saveAuthToken(_token);
        } else {
          await _unauthorized(options);
        }
      }
    } else {
      await _anonymousAuth(options);
    }

    if (_token != null &&
        _token.accessToken != null &&
        _token.accessToken.isNotEmpty) {
      options.headers.remove('Authorization');
      options.headers.putIfAbsent(
        'Authorization',
        () => 'bearer ${_token.accessToken}',
      );
      options.headers.putIfAbsent('expires', () => _token.expires);
    }

    return super.onRequest(options);
  }

  @override
  Future onError(DioError err) {
    final responseCompleter = Completer();
    if (err.response.statusCode == HttpStatus.unauthorized) {
      _refreshToken(_token).then((value) {
        responseCompleter.complete(
          RequestRetrier(dio: dio).scheduleRequestRetry(err.request),
        );
      });
    } else {
      responseCompleter.complete(super.onError(err));
    }

    return responseCompleter.future;
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future<AuthToken> _anonymousAuth(RequestOptions options) async {
    httpClient.lock();
    if (anonymousAuth != null && anonymousAuth.isNotEmpty) {
      final response = await MegaDio.noRefresh(
        defaultUrl,
      ).get(anonymousAuth);

      final token = AuthToken.fromJson(response.data);
      await NetworkDatabase.saveAuthToken(token);
      await NetworkDatabase.saveLogged(false);
      httpClient.unlock();
      return token;
    } else {
      await _unauthorized(options);
      httpClient.unlock();
      return null;
    }
  }

  Future<AuthToken> _refreshToken(AuthToken token) async {
    httpClient.lock();
    final response = await MegaDio.noRefresh(defaultUrl)
        .post(authUrl, data: {'refreshToken': token.refreshToken});

    final newToken = AuthToken.fromJson(response.data);
    await NetworkDatabase.saveAuthToken(newToken);

    httpClient.unlock();
    return newToken;
  }

  Future<void> _unauthorized(RequestOptions options) async {
    options.cancelToken.cancel();
    await NetworkDatabase.clean();
  }
}
