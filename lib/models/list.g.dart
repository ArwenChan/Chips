// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordList _$WordListFromJson(Map<String, dynamic> json) {
  return WordList(
    name: json['name'] as String,
    from: json['from'] as String,
    updated: json['updated'] as bool,
  )
    ..id = json['id'] as String
    ..to = json['to'] as String
    ..words = (json['words'] as List)
        ?.map(
            (e) => e == null ? null : Word.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$WordListToJson(WordList instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'from': instance.from,
      'to': instance.to,
      'updated': instance.updated,
      'words': instance.words,
    };
