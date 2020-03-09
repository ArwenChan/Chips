// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Word _$WordFromJson(Map<String, dynamic> json) {
  return Word(
    spelling: json['spelling'] as String,
  )..translations = (json['translations'] as List)
      ?.map((e) => (e as List)?.map((e) => e as String)?.toList())
      ?.toList();
}

Map<String, dynamic> _$WordToJson(Word instance) => <String, dynamic>{
      'spelling': instance.spelling,
      'translations': instance.translations,
    };
