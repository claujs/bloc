import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/foundation.dart';
import 'package:mega_flutter_base/utils/bloc_utils.dart';
import 'package:rxdart/rxdart.dart';

import '../models/bank_account.dart';
import 'bank_data_repository.dart';

class BankDataBloc extends BlocBase {
  final BankDataRepository _repository;
  List<BankAccount> banks = [];

  final _pop = BehaviorSubject<bool>();
  Sink<bool> get _popIn => _pop.sink;
  Stream<bool> get pop => _pop.stream;

  BankDataBloc({
    @required BankDataRepository repository,
  })  : assert(repository != null),
        _repository = repository;

  Future<void> loadBanks() async {
    await BlocUtils.load(action: (_) async {
      banks = await _repository.loadBanks();
    });
  }

  @override
  void dispose() {
    _pop.close();
    super.dispose();
  }
}
