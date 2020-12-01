import 'package:dict/models/list.dart';
import 'package:flutter/material.dart';

import './common/global.dart';
import './common/api.dart' show fromLocal, getMemorized, getWords, removeList;
import './models/profile.dart';
import './models/user.dart';
import './models/word.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  Profile get _profile => Global.profile;

  @override
  void notifyListeners() {
    Global.saveProfile();
    super.notifyListeners();
  }
}

class UserState extends ProfileChangeNotifier {
  User get user => _profile.user;

  bool get isLogin => user != null;

  set user(User user) {
    if (user?.username != _profile.user?.username) {
      _profile.lastLogin = _profile.user?.username ?? _profile.lastLogin;
      _profile.user = user;
      notifyListeners();
    }
  }
}

class DataSheet extends ChangeNotifier {
  List<GlobalKey<AnimatedListState>> listKeys = initListKeys();

  int get dataIndex => Global.wordListIndex;
  int get length => Global.words.length;

  static initListKeys() {
    return List.generate(
        Global.words.length, (index) => GlobalKey<AnimatedListState>());
  }

  Future reloadRemote() {
    return Future.wait([getWords(), getMemorized()], eagerError: true)
        .then((result) {
      if (result[0].length == 0 && result[1] == '') {
        // new user has no data
        reloadLocal();
      } else {
        Global.words = result[0];
        Global.memorized =
            result[1] != '' ? result[1] : {"updated": false, "words": []};
        Global.wordListIndex = 0;
        listKeys = initListKeys();
        super.notifyListeners();
      }
    });
  }

  reloadLocal() async {
    await Future.wait<void>([
      fromLocal(init: true).then((result) {
        Global.words = result['words'];
        Global.memorized = result['memorized'];
      }),
    ]);
    Global.wordListIndex = 0;
    listKeys = initListKeys();
    super.notifyListeners();
  }

  List<Word> get data {
    return Global.words[dataIndex].words;
  }

  List get memorized {
    return Global.memorized['words'];
  }

  String get title {
    if (dataIndex == -1)
      return 'Memorized Words';
    else
      return Global.words[dataIndex].name;
  }

  // choose a word list
  set dataIndex(int index) {
    Global.wordListIndex = index;
    super.notifyListeners();
  }

  // add word list
  add(String name) {
    Global.words.add(WordList.fromJson({
      "name": name,
      "from": "en",
      "to": "zh-Hans",
      "updated": false,
      "words": []
    }));
    listKeys.add(GlobalKey<AnimatedListState>());
    super.notifyListeners();
  }

  // remove word list
  remove(int index) async {
    if (Global.words[index].id != null) {
      await removeList(Global.words[index].id);
    }
    Global.words.removeAt(index);
    listKeys.removeAt(index);
    super.notifyListeners();
  }

  // add word
  dataInsert(Word newItem) {
    data.insert(0, newItem);
    Global.words[dataIndex].updated = false;
  }

  // memorized word
  dataRemove(int index) {
    memorized.insert(0, {
      'word': data[index].word,
      'time': DateTime.now().millisecondsSinceEpoch
    });
    Word removedItem = data.removeAt(index);
    Global.words[dataIndex].updated = false;
    Global.memorized['updated'] = false;
    return removedItem;
  }

  // move word
  dataMove(int currentIndex, int index, Word word) {
    data.removeAt(currentIndex);
    data.insert(currentIndex > index ? index : index - 1, word);
    Global.words[dataIndex].updated = false;
  }

  // move word to last
  dataMoveToLast(int currentIndex, Word word) {
    data.removeAt(currentIndex);
    data.add(word);
    Global.words[dataIndex].updated = false;
  }

  dataChangeStatus(int index, String status) {
    data[index].status = status;
    Global.words[dataIndex].updated = false;
  }
}

class UserSetting extends ChangeNotifier {
  bool get tranlateInplace => Global.profile.settings.tranlateInplace;
  bool get tranlateInplaceWithPronunciation =>
      Global.profile.settings.tranlateInplaceWithPronunciation;
  String get pronunciation => Global.profile.settings.pronunciation;

  set tranlateInplace(bool value) {
    Global.profile.settings.tranlateInplace = value;
    if (value == false) {
      Global.profile.settings.tranlateInplaceWithPronunciation = false;
    }
    super.notifyListeners();
  }

  set tranlateInplaceWithPronunciation(bool value) {
    Global.profile.settings.tranlateInplaceWithPronunciation = value;
    super.notifyListeners();
  }

  set pronunciation(String value) {
    Global.profile.settings.pronunciation = value;
    super.notifyListeners();
  }
}
