// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
    cityId: json['cityId'] as String,
    cityName: json['cityName'] as String,
    complement: json['complement'] as String,
    name: json['name'] as String,
    neighborhood: json['neighborhood'] as String,
    number: json['number'] as String,
    stateId: json['stateId'] as String,
    stateName: json['stateName'] as String,
    stateUf: json['stateUf'] as String,
    streetAddress: json['streetAddress'] as String,
    zipCode: json['zipCode'] as String,
  );
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'cityId': instance.cityId,
      'cityName': instance.cityName,
      'complement': instance.complement,
      'name': instance.name,
      'neighborhood': instance.neighborhood,
      'number': instance.number,
      'stateId': instance.stateId,
      'stateName': instance.stateName,
      'stateUf': instance.stateUf,
      'streetAddress': instance.streetAddress,
      'zipCode': instance.zipCode,
    };
