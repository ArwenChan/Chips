// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Word _$WordFromJson(Map<String, dynamic> json) {
  return Word(
    word: json['word'] as String,
  )
    ..status = json['status'] as String
    ..pronunciations = (json['pronunciations'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    )
    ..defs = (json['defs'] as List)
        ?.map((e) => (e as Map<String, dynamic>)?.map(
              (k, e) => MapEntry(k, e as String),
            ))
        ?.toList();
}

Map<String, dynamic> _$WordToJson(Word instance) => <String, dynamic>{
      'word': instance.word,
      'status': instance.status,
      'pronunciations': instance.pronunciations,
      'defs': instance.defs,
    };
