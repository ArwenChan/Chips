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
      case 'zh_CN':
        return '设置';
      default:
        return 'settings';
    }
  }

  String get translateInPlace {
    switch (lang) {
      case 'zh_CN':
        return '划词查询';
      default:
        return 'TranslateInPlace';
    }
  }

  String get translateInPlaceWithPronunciation {
    switch (lang) {
      case 'zh_CN':
        return '划词查询发音';
      default:
        return 'TranslateInPlaceWithPronunciation';
    }
  }

  String get pronunciationType {
    switch (lang) {
      case 'zh_CN':
        return '发音类型';
      default:
        return 'PronunciationType';
    }
  }

  String get features {
    switch (lang) {
      case 'zh_CN':
        return '功能介绍';
      default:
        return 'Features';
    }
  }

  String get review {
    switch (lang) {
      case 'zh_CN':
        return '去评分';
      default:
        return 'Review';
    }
  }

  String get feedback {
    switch (lang) {
      case 'zh_CN':
        return '反馈';
      default:
        return 'Feedback';
    }
  }

  String get share {
    switch (lang) {
      case 'zh_CN':
        return '分享此APP给朋友';
      default:
        return 'Share this app';
    }
  }

  String get privacy {
    switch (lang) {
      case 'zh_CN':
        return '隐私协议';
      default:
        return 'Privacy policy';
    }
  }

  String get update {
    switch (lang) {
      case 'zh_CN':
        return '更新版本';
      default:
        return 'Update';
    }
  }

  String get logout {
    switch (lang) {
      case 'zh_CN':
        return '退出登录';
      default:
        return 'Logout';
    }
  }

  String get login {
    switch (lang) {
      case 'zh_CN':
        return '登录';
      default:
        return 'Login';
    }
  }

  String get signup {
    switch (lang) {
      case 'zh_CN':
        return '注册';
      default:
        return 'Sign up';
    }
  }

  String get forgetPassword {
    switch (lang) {
      case 'zh_CN':
        return '忘记密码?';
      default:
        return 'Forgot password?';
    }
  }

  String get writeFeedback {
    switch (lang) {
      case 'zh_CN':
        return '请在后面写下你遇到的问题.';
      default:
        return 'write your problems here.';
    }
  }

  String get loading {
    switch (lang) {
      case 'zh_CN':
        return '加载中..';
      default:
        return 'loading..';
    }
  }

  String get subscribe {
    switch (lang) {
      case 'zh_CN':
        return '订阅';
      default:
        return 'Subscribe';
    }
  }

  String get confirm {
    switch (lang) {
      case 'zh_CN':
        return '确认';
      default:
        return 'Confirm';
    }
  }

  String get cancel {
    switch (lang) {
      case 'zh_CN':
        return '取消';
      default:
        return 'Cancel';
    }
  }

  String get bought {
    switch (lang) {
      case 'zh_CN':
        return '已购';
      default:
        return 'Bought';
    }
  }

  String get connectionLost {
    switch (lang) {
      case 'zh_CN':
        return '请检查网络连接';
      default:
        return 'Internet connection lost';
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
        DefaultLocalizations('${locale.languageCode}_${locale.countryCode}'));
  }

  @override
  bool shouldReload(DefaultLocalizationsDelegate old) => false;
}
