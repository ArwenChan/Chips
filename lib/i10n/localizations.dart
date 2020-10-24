import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DefaultLocalizations {
  DefaultLocalizations(this.lang);
  String lang;
  //为了使用方便，我们定义一个静态方法
  static DefaultLocalizations of(BuildContext context) {
    return Localizations.of<DefaultLocalizations>(
        context, DefaultLocalizations);
  }

  //Locale相关值
  String get settings {
    switch (lang) {
      case 'en':
        return 'settings';
      case 'zh':
        return '设置';
      default:
        return 'settings';
    }
  }

  String get translateInPlace {
    switch (lang) {
      case 'en':
        return 'TranslateInPlace';
      case 'zh':
        return '划词查询';
      default:
        return 'TranslateInPlace';
    }
  }

  String get translateInPlaceWithPronunciation {
    switch (lang) {
      case 'en':
        return 'TranslateInPlaceWithPronunciation';
      case 'zh':
        return '划词查询发音';
      default:
        return 'TranslateInPlaceWithPronunciation';
    }
  }

  String get pronunciationType {
    switch (lang) {
      case 'en':
        return 'PronunciationType';
      case 'zh':
        return '发音类型';
      default:
        return 'PronunciationType';
    }
  }

  String get features {
    switch (lang) {
      case 'en':
        return 'Features';
      case 'zh':
        return '功能介绍';
      default:
        return 'Features';
    }
  }

  String get review {
    switch (lang) {
      case 'en':
        return 'Review';
      case 'zh':
        return '去评分';
      default:
        return 'Review';
    }
  }

  String get feedback {
    switch (lang) {
      case 'en':
        return 'Feedback';
      case 'zh':
        return '反馈';
      default:
        return 'Feedback';
    }
  }

  String get update {
    switch (lang) {
      case 'en':
        return 'Update';
      case 'zh':
        return '更新版本';
      default:
        return 'Update';
    }
  }

  String get logout {
    switch (lang) {
      case 'en':
        return 'Logout';
      case 'zh':
        return '退出登录';
      default:
        return 'Logout';
    }
  }

  String get writeFeedback {
    switch (lang) {
      case 'en':
        return 'write your problems here.';
      case 'zh':
        return '请在后面写下你遇到的问题.';
      default:
        return 'write your problems here.';
    }
  }
}

class DefaultLocalizationsDelegate
    extends LocalizationsDelegate<DefaultLocalizations> {
  const DefaultLocalizationsDelegate();

  //是否支持某个Local
  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  // Flutter会调用此类加载相应的Locale资源类
  @override
  Future<DefaultLocalizations> load(Locale locale) {
    return SynchronousFuture<DefaultLocalizations>(
        DefaultLocalizations(locale.languageCode));
  }

  @override
  bool shouldReload(DefaultLocalizationsDelegate old) => false;
}
