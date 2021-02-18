import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mega_flutter_base/mega_base_bloc.dart';
import 'package:mega_flutter_base/utils/bloc_utils.dart';
import 'package:mega_flutter_base/utils/formats.dart';
import 'package:mega_flutter_network/models/mega_response.dart';
import 'package:mega_flutter_services/google_signin/google_signin.dart';
import 'package:mega_flutter_services/google_signin/google_user.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';
import 'package:rxdart/subjects.dart';

import 'login_provider_type.dart';
import 'login_repository.dart';

class LoginBloc extends BlocBase {
  final MegaBaseBloc _appBloc;
  final LoginRepository _repository;

  LoginBloc(this._appBloc, this._repository);

  final _pop = BehaviorSubject<bool>();
  Sink<bool> get _popIn => _pop.sink;
  Stream<bool> get pop => _pop.stream;

  final _popSignUp = BehaviorSubject<bool>();
  Sink<bool> get _popSignUpIn => _popSignUp.sink;
  Stream<bool> get popSignUp => _popSignUp.stream;

  Future<void> authenticate({
    String document,
    String password,
  }) async {
    BlocUtils.load(action: (_) async {
      String doc = Formats.cpfMaskFormatter.unmaskText(document);
      doc = Formats.cnpjMaskFormatter.unmaskText(document);
      await _repository.authenticate(doc, password);
      _popIn.add(true);
    }, onError: (e, bloc) async {
      bloc.setError(e.message);
    });
  }

  Future<void> googleLogin({
    Function(GoogleUser) onUserNotFound,
    Function(GoogleUser) onUserFound,
  }) async {
    _appBloc.setLoading(true);
    GoogleUser googleUser;
    try {
      googleUser = await MegaGoogleSignIn().signInWithGoogle();
      await _repository.authenticateExternalLogin(
        googleUser.uid,
        LoginProviderType.google,
      );
      _popIn.add(true);
    } on Exception catch (_) {
      _appBloc.setError(
          MegaleiosLocalizations.of(Modular.navigatorKey.currentContext)
              .translate('google_login_error'));
      _appBloc.setLoading(false);
    } on MegaResponse catch (e) {
      _appBloc.setError(e.message);
      _appBloc.setLoading(false);
      onUserNotFound(googleUser);
    } on Error catch (_) {
      _appBloc.setError(
          MegaleiosLocalizations.of(Modular.navigatorKey.currentContext)
              .translate('google_login_error'));
      _appBloc.setLoading(false);
    }
  }

  @override
  void dispose() {
    _pop.close();
    _popSignUp.close();
    super.dispose();
  }
}
