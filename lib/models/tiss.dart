import 'package:json_annotation/json_annotation.dart';
import 'package:tu_wien_addressbook/models/person.dart';

part 'tiss.g.dart';

@JsonSerializable(nullable: false)
class Tiss {
  String query;

  @JsonKey(name: 'total_results')
  int totalResults;

  List<Person> results;

  Tiss();

  factory Tiss.fromJson(Map<String, dynamic> json) => _$TissFromJson(json);
}
