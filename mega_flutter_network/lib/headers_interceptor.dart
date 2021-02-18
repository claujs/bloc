import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';
import 'package:package_info/package_info.dart';

class HeadersInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    try {
      final userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
      final pack = await PackageInfo.fromPlatform();

      final customUserAgent =
          '${pack.packageName}/${pack.version}(${pack.buildNumber}) $userAgent';
      options.headers.putIfAbsent('User-Agent', () => customUserAgent);
    } on PlatformException {}

    options.headers.putIfAbsent('accept', () => 'application/json');
    options.headers.putIfAbsent(
      'accept-language',
      () => MegaleiosLocalizations.of(Modular.navigatorKey.currentContext)
          .locale
          .languageCode,
    );

    return super.onRequest(options);
  }
}
