import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mega_flutter_network/mega_dio.dart';
import 'package:mega_flutter_network/models/mega_response.dart';

class ChangePasswordRepository {
  final String changePath;
  ChangePasswordRepository({
    @required this.changePath,
  }) : assert(changePath != null && changePath.isNotEmpty);

  Future<MegaResponse> changePass({String current, String newPass}) async {
    return await Modular.get<MegaDio>().post(
      this.changePath,
      data: {
        'currentPassword': current,
        'newPassword': newPass,
      },
    );
  }
}
