// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:dict/common/api.dart' show query;
// import 'package:dict/common/global.dart';
// import 'package:dict/models/word.dart';
// import 'package:dict/widgets/notifications.dart';
// import 'package:flutter/widgets.dart' show debugPrint;
// import 'package:flutter/services.dart';

// final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

// class Event {
//   String _channelName;
//   EventChannel _channel;

//   Event(this._channelName) {
//     this._channel = EventChannel(this._channelName);
//   }

//   listenClipboardChanges() {
//     return this._channel.receiveBroadcastStream().listen(clipboardHandler);
//   }

//   String getMessage(Word word) {
//     String message = '';
//     for (var i = 0; i < 2 && i < word.defs.length; i++) {
//       message = message + word.defs[i]['pos'] + word.defs[i]['def'];
//     }
//     debugPrint(message);
//     return message;
//   }

//   clipboardHandler(onData) async {
//     if (Global.profile.settings.tranlateInplace && onData != '') {
//       try {
//         Word word = await query(onData);
//         notificationPlugin.setOnNotificationClick((data) {});
//         notificationPlugin.showNotification(
//             '<b>' + word.word + '</b>', getMessage(word));
//         if (Global.profile.settings.tranlateInplaceWithPronunciation) {
//           await audioPlayer.open(
//             Audio.network(
//                 word.pronunciations[Global.profile.settings.pronunciation]),
//           );
//         }
//       } catch (e) {
//         debugPrint(e.toString());
//       }
//     }
//   }
// }
