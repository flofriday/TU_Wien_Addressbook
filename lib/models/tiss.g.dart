// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tiss.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tiss _$TissFromJson(Map<String, dynamic> json) {
  return Tiss(
    query: json['query'] as String,
    totalResults: json['total_results'] as int,
    results: (json['results'] as List<dynamic>)
        .map((e) => Person.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$TissToJson(Tiss instance) => <String, dynamic>{
      'query': instance.query,
      'total_results': instance.totalResults,
      'results': instance.results,
    };
