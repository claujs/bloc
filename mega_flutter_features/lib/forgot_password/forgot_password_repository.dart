import 'package:flutter/foundation.dart';
import 'package:mega_flutter_network/mega_dio.dart';
import 'package:mega_flutter_network/models/mega_response.dart';

class ForgotPasswordRepository {
  final MegaDio _dio;
  final String forgotPassPath;
  final String forgotPassKey;

  ForgotPasswordRepository(
    this._dio, {
    @required this.forgotPassPath,
    this.forgotPassKey = 'document',
  })  : assert(_dio != null),
        assert(forgotPassPath != null && forgotPassPath.isNotEmpty),
        assert(forgotPassKey != null && forgotPassKey.isNotEmpty);

  Future<MegaResponse> forgotPassword(String document) async {
    return await _dio.post(
      forgotPassPath,
      data: {forgotPassKey: document},
    );
  }
}
