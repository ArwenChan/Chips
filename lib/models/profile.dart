import 'package:json_annotation/json_annotation.dart';

import './user.dart';
import './setting.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  Profile({this.user, this.lastLogin, this.settings});

  User user;
  // last login username
  String lastLogin;
  Setting settings;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
