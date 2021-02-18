import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class MegaBaseBloc extends BlocBase {
  final _isLoading = BehaviorSubject<bool>();
  Sink<bool> get _isLoadingIn => _isLoading.sink;
  Stream<bool> get isLoading => _isLoading.stream;

  final _isLoadingList = BehaviorSubject<bool>();
  Sink<bool> get _isLoadingListIn => _isLoadingList.sink;
  Stream<bool> get isLoadingList => _isLoadingList.stream;

  final _error = BehaviorSubject<String>();
  Sink<String> get _errorIn => _error.sink;
  Stream<String> get error => _error.stream;

  final _message = BehaviorSubject<String>();
  Sink<String> get _messageIn => _message.sink;
  Stream<String> get message => _message.stream;

  void setLoading(bool loading, {bool list = false}) {
    if (list) {
      _isLoadingListIn.add(loading);
    } else {
      _isLoadingIn.add(loading);
    }
  }

  void resetLoading() {
    _isLoadingListIn.add(false);
    _isLoadingIn.add(false);
  }

  void setError(String error) {
    resetLoading();

    _errorIn.add(error);
    _errorIn.add(null);
  }

  void setMessage(String message) {
    resetLoading();
    _messageIn.add(message);
    _messageIn.add(null);
  }

  @override
  void dispose() {
    _isLoading.close();
    _isLoadingList.close();
    _error.close();
    _message.close();
    super.dispose();
  }
}
