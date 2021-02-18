import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mega_flutter_network/models/mega_response.dart';

import '../mega_base_bloc.dart';

class BlocUtils {
  static load({
    bool showLoading = true,
    bool showLoadingList = false,
    @required Function(MegaBaseBloc) action,
    Function(MegaResponse, MegaBaseBloc) onError,
  }) async {
    final appBloc = Modular.get<MegaBaseBloc>();

    if (showLoading && !showLoadingList) {
      appBloc.setLoading(true);
    }
    if (showLoadingList) {
      appBloc.setLoading(true, list: true);
    }

    try {
      if (action != null) {
        await action(appBloc);
      }
    } on MegaResponse catch (e) {
      if (onError != null)
        await onError(e, appBloc);
      else
        appBloc.setError(e.message);
    } finally {
      if (showLoading) {
        appBloc.resetLoading();
      }
    }
  }
}
