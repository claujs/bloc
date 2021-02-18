import 'package:json_annotation/json_annotation.dart';

part 'mega_file.g.dart';

@JsonSerializable()
class MegaFile {
  final String fileName;

  MegaFile({this.fileName});

  factory MegaFile.fromJson(Map<String, dynamic> json) =>
      _$MegaFileFromJson(json);
  Map<String, dynamic> toJson() => _$MegaFileToJson(this);
}
