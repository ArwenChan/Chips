// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Setting _$SettingFromJson(Map<String, dynamic> json) {
  return Setting(
    tranlateInplace: json['tranlateInplace'] as bool,
    tranlateInplaceWithPronunciation:
        json['tranlateInplaceWithPronunciation'] as bool,
    pronunciation: json['pronunciation'] as String,
  );
}

Map<String, dynamic> _$SettingToJson(Setting instance) => <String, dynamic>{
      'tranlateInplace': instance.tranlateInplace,
      'tranlateInplaceWithPronunciation':
          instance.tranlateInplaceWithPronunciation,
      'pronunciation': instance.pronunciation,
    };
