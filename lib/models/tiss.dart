import 'package:json_annotation/json_annotation.dart';
import 'package:tu_wien_addressbook/models/person.dart';

part 'tiss.g.dart';

@JsonSerializable()
class Tiss {
  String query;

  @JsonKey(name: 'total_results')
  int totalResults;

  List<Person> results;

  Tiss(
      {required this.query, required this.totalResults, required this.results});

  factory Tiss.fromJson(Map<String, dynamic> json) => _$TissFromJson(json);

  Map<String, dynamic> toJson() => _$TissToJson(this);
}
