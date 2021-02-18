// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankAccount _$BankAccountFromJson(Map<String, dynamic> json) {
  return BankAccount(
    accountableName: json['accountableName'] as String,
    accountableCpf: json['accountableCpf'] as String,
    bankAccount: json['bankAccount'] as String,
    bankAgency: json['bankAgency'] as String,
    bank: json['bank'] as String,
    bankCode: json['bankCode'] as String,
    typeAccount:
        _$enumDecodeNullable(_$BankAccountTypeEnumMap, json['typeAccount']),
    personType: _$enumDecodeNullable(
        _$BankAccountPersonTypeEnumMap, json['personType']),
    cnpj: json['cnpj'] as String,
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$BankAccountToJson(BankAccount instance) =>
    <String, dynamic>{
      'accountableName': instance.accountableName,
      'accountableCpf': instance.accountableCpf,
      'bankAccount': instance.bankAccount,
      'bankAgency': instance.bankAgency,
      'bank': instance.bank,
      'bankCode': instance.bankCode,
      'typeAccount': _$BankAccountTypeEnumMap[instance.typeAccount],
      'personType': _$BankAccountPersonTypeEnumMap[instance.personType],
      'cnpj': instance.cnpj,
      'id': instance.id,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$BankAccountTypeEnumMap = {
  BankAccountType.currentAccount: 0,
  BankAccountType.savingsAccount: 1,
};

const _$BankAccountPersonTypeEnumMap = {
  BankAccountPersonType.physical: 0,
  BankAccountPersonType.legal: 1,
};
