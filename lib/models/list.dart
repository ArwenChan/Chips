import 'package:json_annotation/json_annotation.dart';

import './word.dart';

part 'list.g.dart';

@JsonSerializable()
class WordList {
  WordList({this.name, this.from, this.updated: false});
  String id;
  String name;
  String from;
  String to;
  bool updated;
  List<Word> words;

  factory WordList.fromJson(Map<String, dynamic> json) =>
      _$WordListFromJson(json);
  Map<String, dynamic> toJson() {
    var temp = _$WordListToJson(this);
    temp['words'] = this.words.map((v) => v.toJson()).toList();
    return temp;
  }
}
