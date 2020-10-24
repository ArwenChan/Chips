// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersion _$AppVersionFromJson(Map<String, dynamic> json) {
  return AppVersion(
    latest: json['latest'] as String,
    minVersion: json['minVersion'] as String,
  );
}

Map<String, dynamic> _$AppVersionToJson(AppVersion instance) =>
    <String, dynamic>{
      'latest': instance.latest,
      'minVersion': instance.minVersion,
    };
