// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'dart:io' show Platform;
// import 'package:rxdart/subjects.dart';

// class NotificationPlugin {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   final BehaviorSubject<ReceivedNotification>
//       didReceivedLocalNotificationSubject =
//       BehaviorSubject<ReceivedNotification>();
//   var initializationSettings;
//   NotificationPlugin._() {
//     init();
//   }
//   init() async {
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     if (Platform.isIOS) {
//       _requestIOSPermission();
//     }
//     initializePlatformSpecifics();
//   }

//   initializePlatformSpecifics() {
//     var initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettingsIOS = IOSInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: false,
//       onDidReceiveLocalNotification: (id, title, body, payload) async {
//         ReceivedNotification receivedNotification = ReceivedNotification(
//             id: id, title: title, body: body, payload: payload);
//         didReceivedLocalNotificationSubject.add(receivedNotification);
//       },
//     );
//     initializationSettings = InitializationSettings(
//         initializationSettingsAndroid, initializationSettingsIOS);
//   }

//   _requestIOSPermission() {
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         .requestPermissions(
//           alert: false,
//           badge: true,
//           sound: true,
//         );
//   }

//   setListenerForLowerVersions(Function onNotificationInLowerVersions) {
//     didReceivedLocalNotificationSubject.listen((receivedNotification) {
//       onNotificationInLowerVersions(receivedNotification);
//     });
//   }

//   setOnNotificationClick(Function onNotificationClick) async {
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: (String payload) async {
//       onNotificationClick(payload);
//     });
//   }

//   Future<void> showNotification(String title, String message) async {
//     var androidChannelSpecifics = AndroidNotificationDetails(
//       'CHANNEL_ID_0',
//       'NORMAL_NOTIFICATION',
//       "CHANNEL_DESCRIPTION",
//       importance: Importance.Max,
//       priority: Priority.High,
//       timeoutAfter: 5000,
//       playSound: false,
//       styleInformation: BigTextStyleInformation(
//         message,
//         summaryText: 'hoho',
//         contentTitle: title,
//         htmlFormatContentTitle: true,
//         htmlFormatBigText: true,
//       ),
//     );
//     var iosChannelSpecifics = IOSNotificationDetails();
//     var platformChannelSpecifics =
//         NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       message,
//       platformChannelSpecifics,
//       payload: 'New Payload',
//     );
//   }

//   Future<int> getPendingNotificationCount() async {
//     List<PendingNotificationRequest> p =
//         await flutterLocalNotificationsPlugin.pendingNotificationRequests();
//     return p.length;
//   }

//   Future<void> cancelNotification() async {
//     await flutterLocalNotificationsPlugin.cancel(0);
//   }

//   Future<void> cancelAllNotification() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }
// }

// NotificationPlugin notificationPlugin = NotificationPlugin._();

// class ReceivedNotification {
//   final int id;
//   final String title;
//   final String body;
//   final String payload;
//   ReceivedNotification({
//     @required this.id,
//     @required this.title,
//     @required this.body,
//     @required this.payload,
//   });
// }
