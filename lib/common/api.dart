import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:device_info/device_info.dart';

import '../models/list.dart';
import 'global.dart';

const String fileName = 'words.json';
const String dictApi =
    'https://api.cognitive.microsofttranslator.com/dictionary/lookup?api-version=3.0';
// TODO: 这个地址是全局的没有分区
// Azure	全局（非区域）	api.cognitive.microsofttranslator.com
// Azure	美国	api-nam.cognitive.microsofttranslator.com
// Azure	欧洲	api-eur.cognitive.microsofttranslator.com
// Azure	亚太区	api-apc.cognitive.microsofttranslator.com

Future<List<WordList>> fromLocal() async {
  String fileContent;
  if (Global.isRelease) {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$fileName');
    fileContent = await file.readAsString();
  } else {
    fileContent = await rootBundle.loadString('files/words.json');
  }

  List content = jsonDecode(fileContent);
  return content.map((e) => WordList.fromJson(e)).toList();
}

Future toLocal(List<WordList> content) async {
  final String dir = (await getApplicationDocumentsDirectory()).path;
  final File file = new File('$dir/$fileName');
  file.writeAsString(content.toString());
}

Future query(String word) async {
  Dio dio = Dio();
  Response response = await dio.post(dictApi, data: [
    {'text': word}
  ]);
}

//_device_info()
