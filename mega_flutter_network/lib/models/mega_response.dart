import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';

part 'mega_response.g.dart';

@JsonSerializable()
class MegaResponse extends Error {
  dynamic data;
  bool erro;
  dynamic errors;
  String message;
  int statusCode;

  MegaResponse(
      {this.data, this.erro, this.errors, this.message, this.statusCode});

  factory MegaResponse.fromJson(Map<String, dynamic> json) =>
      _$MegaResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MegaResponseToJson(this);

  MegaResponse.fromDioError(DioError e) {
    if (e.response != null &&
        e.response.data != null &&
        e.response.data is Map) {
      final json = e.response.data;
      data = json['data'];
      erro = json['erro'];
      errors = json['errors'];
      message = json['message'];
    } else if (e.type == DioErrorType.CONNECT_TIMEOUT ||
        e.type == DioErrorType.RECEIVE_TIMEOUT ||
        e.type == DioErrorType.SEND_TIMEOUT) {
      message = MegaleiosLocalizations.of(Modular.navigatorKey.currentContext)
          .translate('connection_timeout');
    } else {
      message =
          // ignore: lines_longer_than_80_chars
          '${MegaleiosLocalizations.of(Modular.navigatorKey.currentContext).translate('connection_timeout')}\n\n${e.message}';
    }

    statusCode = e?.response?.statusCode ?? HttpStatus.badRequest;
  }
}
