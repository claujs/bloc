import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';

@HiveType(typeId: 4)
enum BankAccountType {
  @JsonValue(0)
  @HiveField(0)
  currentAccount,
  @JsonValue(1)
  @HiveField(1)
  savingsAccount
}

extension BankAccountTypeExtension on BankAccountType {
  String get name {
    final localization =
        MegaleiosLocalizations.of(Modular.navigatorKey.currentContext);

    switch (this) {
      case BankAccountType.currentAccount:
        return localization.translate('current_account');
      case BankAccountType.savingsAccount:
        return localization.translate('savings_account');
      default:
        return '';
    }
  }

  static BankAccountType fromIndex(int index) {
    switch (index) {
      case 0:
        return BankAccountType.currentAccount;
      case 1:
        return BankAccountType.savingsAccount;
      default:
        return BankAccountType.currentAccount;
    }
  }
}
