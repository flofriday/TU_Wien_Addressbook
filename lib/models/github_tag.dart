import 'package:json_annotation/json_annotation.dart';

part 'github_tag.g.dart';

// To build the code generateion run:
// flutter pub run build_runner build
@JsonSerializable()
class Tag {
  String name;

  Tag({required this.name});

  factory Tag.fromJSON(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}
