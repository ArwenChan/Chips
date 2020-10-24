import 'package:json_annotation/json_annotation.dart';

part 'word.g.dart';

@JsonSerializable()
class Word {
  Word({this.word});
  String word;
  String status;
  Map<String, String> pronunciations;
  List<Map<String, String>> defs;

  factory Word.fromJson(Map<String, dynamic> json) {
    for (int i = 0; i < json['defs'].length; i++) {
      var splitDef = json['defs'][i]['def'].split('；');
      if (splitDef.length > 2) {
        json['defs'][i]['def'] = splitDef.getRange(0, 2).join('；');
      }
      json['defs'][i]['def'] = json['defs'][i]['def']
          .replaceAll(RegExp(r'[\（\(][\u4E00-\u9FA5A-Za-z0-9_、,]+[\)\）]'), '');
    }
    return _$WordFromJson(json);
  }
  Map<String, dynamic> toJson() => _$WordToJson(this);
}
