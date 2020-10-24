import 'package:json_annotation/json_annotation.dart';

part 'app_version.g.dart';

@JsonSerializable()
class AppVersion {
  AppVersion({this.latest, this.minVersion});
  String latest;
  String minVersion;

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('latest')) {
      json['latest'] = json['version'];
    }
    return _$AppVersionFromJson(json);
  }
  Map<String, dynamic> toJson() => _$AppVersionToJson(this);
}
