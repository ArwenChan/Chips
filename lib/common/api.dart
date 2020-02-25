import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:device_info/device_info.dart';

import '../models/list.dart';

const String fileName = 'words.txt';
const String dictApi =
    'https://api.cognitive.microsofttranslator.com/dictionary/lookup?api-version=3.0';
// TODO: 这个地址是全局的没有分区
// Azure	全局（非区域）	api.cognitive.microsofttranslator.com
// Azure	美国	api-nam.cognitive.microsofttranslator.com
// Azure	欧洲	api-eur.cognitive.microsofttranslator.com
// Azure	亚太区	api-apc.cognitive.microsofttranslator.com

Future<List<WordList>> fromLocal() async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = new File('$dir/$fileName');
  List content = jsonDecode((await file.readAsString()));
  return content.map((e) => WordList.fromJson(e));
}

Future toLocal(List<WordList> content) async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = new File('$dir/$fileName');
  file.writeAsString(content.toString());
}

Future query(String word) async {
  Dio dio = Dio();
  Response response = await dio.post(dictApi, data: [
    {'text': word}
  ]);
}

//_device_info()
