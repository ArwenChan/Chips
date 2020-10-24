import 'package:json_annotation/json_annotation.dart';

part 'setting.g.dart';

@JsonSerializable()
class Setting {
  Setting(
      {this.tranlateInplace,
      this.tranlateInplaceWithPronunciation,
      this.pronunciation});

  bool tranlateInplace;
  // last login username
  bool tranlateInplaceWithPronunciation;
  String pronunciation;

  factory Setting.fromJson(Map<String, dynamic> json) =>
      _$SettingFromJson(json);
  Map<String, dynamic> toJson() => _$SettingToJson(this);
}
