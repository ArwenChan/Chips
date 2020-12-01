import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:dict/common/exception.dart';
import 'package:dict/common/global.dart';
import 'package:dict/models/list.dart';
import 'package:dict/models/user.dart';
import 'package:dict/models/word.dart';
import 'package:dict/states.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dict/common/constants.dart' show HOST;

const String fileName = 'words.json';

Dio dio = Dio(new BaseOptions(
  baseUrl: HOST,
  connectTimeout: 5000,
  headers: {
    'Content-Type': 'application/json',
    'info': Global.deviceId,
    'device-info': Global.deviceInfoString.split(',')[0],
  },
  validateStatus: (status) {
    return true;
  },
));

void errorHandle(Response response) {
  if (response.statusCode >= 500) {
    throw SystemException(
        response.statusCode == 503 ? 'retry later' : 'system error',
        response.statusCode);
  }
  if (response.statusCode >= 400) {
    if (response.data == 'Not authorized to access this resource') {
      if (Global.profile.user != null) {
        UserState().user = null;
      }
      throw CustomException('请登录后继续', 4003);
    } else {
      throw AuthException(response.data, response.statusCode);
    }
  }
  if (response.data is Map && response.data['errCode'] != null) {
    debugPrint(response.data.toString());
    throw CustomException(response.data['errMsg'], response.data['errCode'],
        detail: response.data['detail']);
  }
}

Future fromLocal({init: false}) async {
  String fileContent;
  try {
    if (!init) {
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = new File('$dir/$fileName');
      fileContent = await file.readAsString();
    }
  } on FileSystemException catch (e) {
    debugPrint(e.toString());
    init = true;
  }
  if (init) {
    fileContent = await rootBundle.loadString('files/$fileName');
  }
  var data = jsonDecode(fileContent);
  data['words'] =
      data['words'].map<WordList>((e) => WordList.fromJson(e)).toList();
  return data;
}

Future toLocal(List<WordList> content, memorized) async {
  try {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final File file = new File('$dir/$fileName');
    file.writeAsString(jsonEncode({'words': content, 'memorized': memorized}));
  } on FileSystemException catch (e) {
    debugPrint(e.toString());
    debugPrint(content.toString());
  }
}

Future update(List<WordList> content) async {
  if (Global.profile.user == null) return;
  var data =
      content.where((v) => !v.updated).toList().asMap().entries.map((entry) {
    var result = entry.value.toJson();
    result['order'] = entry.key;
    return result;
  }).toList();
  if (data.isEmpty) return;
  debugPrint('to update:${data.toString()}');
  dio.options.headers['Authorization'] = 'Bearer ${Global.profile.user.token}';
  Response response = await dio.post(
    '/list/update',
    data: data,
  );
  errorHandle(response);
  return response.data;
}

Future updateMemorized(content) async {
  if (Global.profile.user == null) return;
  dio.options.headers['Authorization'] = 'Bearer ${Global.profile.user.token}';
  debugPrint('to update memorized:${content.toString()}');
  Response response = await dio.post(
    '/list/updatememorized',
    data: content,
  );
  errorHandle(response);
  return response.data;
}

Future removeList(String id) async {
  if (Global.profile.user == null) return;
  dio.options.headers['Authorization'] = 'Bearer ${Global.profile.user.token}';
  Response response = await dio.delete(
    '/list/remove',
    queryParameters: {'id': id},
  );
  debugPrint(response.data.toString());
  errorHandle(response);
}

Future<Word> query(String word) async {
  if (Global.profile.user != null) {
    dio.options.headers['Authorization'] =
        'Bearer ${Global.profile.user.token}';
  }
  Response response = await dio.get(
    '/query/entozh',
    queryParameters: {'q': word},
  );
  errorHandle(response);
  Word w = Word.fromJson(response.data);
  w.status = 'normal';
  return w;
}

Future<User> register(String email, String password) async {
  Response response = await dio.post(
    '/users/',
    data: {'username': email, 'password': password},
  );
  errorHandle(response);
  User user = User.fromJson(response.data['user']);
  user.token = response.data['token'];
  return user;
}

Future thirdLogin(String uid, String platform) async {
  Response response = await dio.post(
    '/users/thirdlogin',
    data: {'uid': uid, 'platform': platform},
  );
  errorHandle(response);
  User user = User.fromJson(response.data['user']);
  user.token = response.data['token'];
  return {'user': user, 'existed': response.data['existed']};
}

Future<User> login(String email, String password) async {
  Response response;
  response = await dio.post(
    '/users/login',
    data: {'username': email, 'password': password},
  );
  errorHandle(response);
  User user = User.fromJson(response.data['user']);
  user.token = response.data['token'];
  return user;
}

Future logout() async {
  if (Global.profile.user == null) {
    throw AuthException('No auth', 400);
  }
  dio.options.headers['Authorization'] = 'Bearer ${Global.profile.user.token}';
  Response response = await dio.post(
    '/users/logout',
  );
  errorHandle(response);
}

Future getVersion() async {
  if (Global.profile.user != null) {
    dio.options.headers['Authorization'] =
        'Bearer ${Global.profile.user.token}';
  }
  Response response = await dio.get(
    '/version',
  );
  errorHandle(response);
  return response.data;
}

Future getWords() async {
  try {
    if (Global.profile.user == null) {
      throw AuthException('No auth', 400);
    }
    dio.options.headers['Authorization'] =
        'Bearer ${Global.profile.user.token}';
    Response response = await dio.get(
      '/list/words',
    );
    errorHandle(response);
    List<WordList> result = response.data.map<WordList>((e) {
      e['id'] = e['_id'];
      WordList r = WordList.fromJson(e);
      r.updated = true;
      return r;
    }).toList();
    return result;
  } catch (e) {
    return Future.error(e.toString());
  }
}

Future getMemorized() async {
  try {
    if (Global.profile.user == null) {
      throw AuthException('No auth', 400);
    }
    dio.options.headers['Authorization'] =
        'Bearer ${Global.profile.user.token}';
    Response response = await dio.get(
      '/list/memorized',
    );
    errorHandle(response);
    if (response.data is Map) {
      response.data['updated'] = true;
      response.data['id'] = response.data['_id'];
    }
    return response.data;
  } catch (e) {
    return Future.error(e.toString());
  }
}

Future<int> verifyPurchase(String receipt) async {
  if (Global.profile.user == null) {
    throw AuthException('No auth', 400);
  }
  dio.options.headers['Authorization'] = 'Bearer ${Global.profile.user.token}';
  dio.options.connectTimeout = 10000;
  Response response = await dio.post(
    '/purchase/verify',
    data: {
      'receipt': receipt,
    },
  );
  errorHandle(response);
  debugPrint(response.data.toString());
  return response.data['status'];
}

Future<dynamic> order(String productId) async {
  if (Global.profile.user == null) {
    throw AuthException('No auth', 400);
  }
  dio.options.headers['Authorization'] = 'Bearer ${Global.profile.user.token}';
  Response response = await dio.post(
    '/purchase/order',
    data: {
      'productId': productId,
      'quantity': 1,
    },
  );
  errorHandle(response);
  return response.data;
}

Future<void> forgetpsw(String email) async {
  Response response = await dio.get(
    '/users/forget',
    queryParameters: {'email': email},
  );
  errorHandle(response);
}

Future<dynamic> getProducts() async {
  if (Global.profile.user == null) {
    throw AuthException('No auth', 400);
  }
  dio.options.headers['Authorization'] = 'Bearer ${Global.profile.user.token}';
  Response response = await dio.get('/purchase/products');
  errorHandle(response);
  return response.data;
}
