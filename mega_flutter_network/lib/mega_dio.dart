import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import 'authorization_interceptor.dart';
import 'database/network_database.dart';
import 'environment.dart';
import 'headers_interceptor.dart';
import 'improve_interceptor.dart';
import 'log_interceptor.dart';
import 'models/mega_file.dart';
import 'models/mega_response.dart';
import 'urls.dart';

class MegaDio {
  static const int _timeout = 1000 * 60 * 2;
  Dio _client;

  MegaDio(
    String defaultUrl, {
    @required String authUrl,
    String anonymousAuth,
  }) {
    _setup(
      defaultUrl: defaultUrl,
      authUrl: authUrl,
      anonymousAuth: anonymousAuth,
    );
  }

  MegaDio.noRefresh(
    String defaultUrl,
  ) {
    _setup(
      defaultUrl: defaultUrl,
    );
  }

  MegaDio.fromTemplate() {
    _setup(template: true);
  }

  void _setup({
    String defaultUrl = MegaUrls.templateUrl,
    bool template = false,
    String authUrl,
    String anonymousAuth,
  }) {
    _client = Dio();
    _client.options.sendTimeout = _timeout;
    _client.options.connectTimeout = _timeout;
    _client.options.receiveTimeout = _timeout;
    _client.options.maxRedirects = 2;
    _client.options.responseType = ResponseType.json;

    _client.interceptors.add(ImproveInterceptor());
    _client.interceptors.add(HeadersInterceptor());
    if (authUrl != null && authUrl.isNotEmpty) {
      _client.interceptors.add(AuthorizationInterceptor(
        authUrl,
        defaultUrl,
        anonymousAuth,
        this,
        _client,
      ));
    }
    _client.interceptors.add(MegaLogInterceptor());

    if (defaultUrl.contains('/api/v1')) {
      _client.options.baseUrl = defaultUrl;
    } else {
      _client.options.baseUrl = '$defaultUrl/api/v1';
    }

    if (!template) {
      NetworkDatabase.loadEnvironment().then((env) {
        if (env == Environment.custom) {
          NetworkDatabase.loadEnvironmentUrl().then((value) {
            _client.options.baseUrl = value;
          });
        } else {
          _client.options.baseUrl = env.api;
        }
      });
    }
  }

  String get baseUrl => _client.options.baseUrl;

  void changeUrl(String url) {
    _client.options.baseUrl = url;
  }

  void lock() {
    _client.lock();
  }

  void unlock() {
    _client.unlock();
  }

  Future<MegaResponse> get(
    String path, {
    Map<String, dynamic> queryParameters,
  }) async {
    try {
      final response = await _client.get(
        path,
        queryParameters: queryParameters,
      );
      return MegaResponse.fromJson(response.data);
    } on DioError catch (e) {
      throw MegaResponse.fromDioError(e);
    }
  }

  Future<MegaResponse> post(
    String path, {
    data,
    Map<String, dynamic> queryParameters,
  }) async {
    try {
      final response = await _client.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return MegaResponse.fromJson(response.data);
    } on DioError catch (e) {
      throw MegaResponse.fromDioError(e);
    }
  }

  Future<MegaFile> upload({@required File file}) async {
    try {
      final String fileName = file.path.split('/').last;
      final String mime = lookupMimeType(file.path);
      final FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType(mime.split('/').first, mime.split('/').last),
        ),
      });

      final env = await NetworkDatabase.loadEnvironment();
      final response = await this._client.post(
            env.upload,
            data: formData,
          );
      final data = MegaResponse.fromJson(response.data);
      return MegaFile.fromJson(data.data);
    } on DioError catch (e) {
      throw MegaResponse.fromDioError(e);
    }
  }
}
