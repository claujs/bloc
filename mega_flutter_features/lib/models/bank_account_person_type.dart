import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

@HiveType(typeId: 3)
enum BankAccountPersonType {
  @JsonValue(0)
  @HiveField(0)
  physical,
  @JsonValue(1)
  @HiveField(1)
  legal
}
