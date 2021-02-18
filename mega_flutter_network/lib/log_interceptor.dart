import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class MegaLogInterceptor extends InterceptorsWrapper {
  @override
  Future onResponse(Response response) {
    if (!kReleaseMode) {
      final request = response.request;

      print(
          '================= MEGALEIOS REPSONSE SUCCESS LOG =================');
      print(
          // ignore: lines_longer_than_80_chars
          'REQUEST <${request.baseUrl}${request.path}>[${request.method.toUpperCase()}]');
      print('STATUS CODE => ${response.statusCode}');
      print('REQUEST HEADERS => ${request.headers ?? 'NO HEADER'}');
      print(
        // ignore: lines_longer_than_80_chars
        'REQUEST PARAMS => ${response.request.queryParameters ?? 'NO QUERY PARAMETERS'}',
      );

      try {
        if (response.request.data is FormData) {
          printWrapped('REQUEST BODY => NO JSON OBJECT');
        } else {
          printWrapped(
            // ignore: lines_longer_than_80_chars
            'REQUEST BODY => ${jsonEncode(response.request.data ?? '{"message": NO BODY DATA}') ?? 'NO BODY DATA'}',
          );
        }
      } on Exception {
        printWrapped('REQUEST BODY => NO JSON OBJECT');
      }
      printWrapped(
        // ignore: lines_longer_than_80_chars
        'RESPONSE BODY => ${jsonEncode(response.data ?? '{"message": NO BODY DATA}') ?? 'NO BODY'}',
      );
      print(
          '==================================================================');
    }
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    if (err.type == DioErrorType.CANCEL) {
      return super.onError(err);
    }

    if (!kReleaseMode) {
      final request = err.request;
      final response = err.response;

      print(
          '================== MEGALEIOS REPSONSE ERROR LOG ==================');
      print(
          'REQUEST <${request?.baseUrl}${request?.path}>[${request?.method}]');
      print('TYPE => ${err.type}');
      print('REQUEST HEADERS => ${request.headers ?? 'NO HEADER'}');
      print(
        // ignore: lines_longer_than_80_chars
        'REQUEST PARAMS => ${response.request.queryParameters ?? 'NO QUERY PARAMETERS'}',
      );
      try {
        if (response.request.data is FormData) {
          printWrapped('REQUEST BODY => NO JSON OBJECT');
        } else {
          printWrapped(
            // ignore: lines_longer_than_80_chars
            'REQUEST BODY => ${jsonEncode(response.request.data ?? '{"message": NO BODY DATA}') ?? 'NO BODY DATA'}',
          );
        }
      } on Exception {
        printWrapped('REQUEST BODY => NO JSON OBJECT');
      }
      print('MESSAGE => ${err.message ?? 'NO MESSAGE'}');
      printWrapped('BODY => ${response?.data ?? 'NO BODY'}');
      print(
          '==================================================================');
    }

    return super.onError(err);
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
