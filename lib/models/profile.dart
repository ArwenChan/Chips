import 'package:json_annotation/json_annotation.dart';

import './user.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  Profile({this.user, this.token, this.lastLogin});

  User user;
  String token; // user token or password
  String lastLogin; // last login username

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
