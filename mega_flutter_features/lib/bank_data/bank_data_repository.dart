import 'package:flutter/foundation.dart';
import 'package:mega_flutter_network/mega_dio.dart';

import '../models/bank_account.dart';

class BankDataRepository {
  final MegaDio _httpClient;

  BankDataRepository({
    @required MegaDio httpClient,
  })  : assert(httpClient != null),
        _httpClient = httpClient;

  Future<List<BankAccount>> loadBanks() async {
    final response =
        await _httpClient.get('https://api.megaleios.com/api/v1/Bank/List');
    return (response.data as List)
        .map((b) => BankAccount.fromBankJson(b))
        .toList();
  }
}
