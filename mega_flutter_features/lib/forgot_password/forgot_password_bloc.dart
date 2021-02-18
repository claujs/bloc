import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mega_flutter_base/utils/bloc_utils.dart';

import 'forgot_password_repository.dart';

class ForgotPasswordBloc extends BlocBase {
  final ForgotPasswordRepository _repository;

  ForgotPasswordBloc(this._repository);

  Future<void> forgotPassword({String email}) async {
    BlocUtils.load(
      action: (bloc) async {
        final response = await _repository.forgotPassword(email);
        bloc.setMessage(response.message);
      },
      onError: (e, appBloc) {
        appBloc.setError(e.message);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
