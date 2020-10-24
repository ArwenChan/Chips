// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    lastLogin: json['lastLogin'] as String,
    settings: json['settings'] == null
        ? null
        : Setting.fromJson(json['settings'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'user': instance.user,
      'lastLogin': instance.lastLogin,
      'settings': instance.settings,
    };
