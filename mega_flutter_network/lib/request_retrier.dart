import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RequestRetrier {
  final Dio dio;

  RequestRetrier({
    @required this.dio,
  });

  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    return await dio.request(
      requestOptions.path,
      cancelToken: requestOptions.cancelToken,
      data: requestOptions.data,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
      queryParameters: requestOptions.queryParameters,
      options: requestOptions,
    );
  }
}
