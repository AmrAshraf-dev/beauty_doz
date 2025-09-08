import 'dart:async';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/preference/preference.dart';
import 'package:beautydoz/core/services/router.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/widgets/notification/notification_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:overlay_support/overlay_support.dart';
import 'package:ui_utils/ui_utils.dart';

class NotificationServices {
  BuildContext context;

  Future<void> init(BuildContext ctx) async {
    context = ctx;
    // await SystemAlertWindow.requestPermissions
    //     .call(prefMode: SystemWindowPrefMode.DEFAULT);

    await initalize();

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.setAutoInitEnabled(false);
    await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    await FirebaseMessaging.instance.subscribeToTopic("users");

    if (locator<AuthenticationService>().userLoged) {
      var user = locator<AuthenticationService>().user;
      await FirebaseMessaging.instance
          .subscribeToTopic("user_" + user.user.id.toString());

      // await locator<HttpApi>().request(EndPoint.updateNotification,
      //     body: {'notification': token},
      //     contentType: Headers.formUrlEncodedContentType,
      //     headers: Header.userAuth,
      //     type: RequestType.post);
    }
    // await messaging.getToken().then(updateFCMToken);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('A new onMessage event was published!');
      operateOnMessage(
          context, message.data['title'], message.data['body'], message.data);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessage event was published!');
      operateOnMessage(
          context, message.data['title'], message.data['body'], message.data);
    });
  }

  // Future<void> updateFCMToken(token) async {
  //   if (token != null) {
  //     try {
  //       Logger().wtf('FCM TOKEN : "$token"');
  //       Preference.setString(PrefKeys.fcmToken, token);
  //       if (locator<AuthenticationService>().userLoged)
  //         await locator<HttpApi>().sendFcmToken(context, token);
  //       else
  //         await locator<HttpApi>().recordFcm(context, fcm: token);
  //     } catch (e) {
  //       print('error updating fcm');
  //     }
  //   }
  // }

  Future<void> initalize() async {
    await Firebase.initializeApp();

    AwesomeNotifications().initialize('resource://drawable/logo', [
      NotificationChannel(
        channelKey: 'basic_channel',
        playSound: true,
        channelShowBadge: true,
      ),
      NotificationChannel(
        channelKey: 'advertisement',
        defaultPrivacy: NotificationPrivacy.Public,
        playSound: true,
        channelShowBadge: true,
      ),
    ]);

    AwesomeNotifications().actionStream.listen((event) {
      if (event.payload.containsKey('itemId') &&
          event.payload.containsKey('imageUrl')) {
        showOverlayNotification(
            (context) => Notify(
                  title: event.title,
                  body: event.body,
                  image: event.payload['imageUrl'],
                  itemId: int.parse(event.payload['itemId']),
                ),
            duration: Duration(seconds: 9999),
            position: NotificationPosition.top);
      }

      if (event.buttonKeyPressed == 'CLEAR') {
        AwesomeNotifications().cancel(event.id);
      }
    }).onError((e) {
      print(e);
    });
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");

  // Use this method to automatically convert the push data, in case you gonna use our data standard
  operateOnMessage(
      null, message.data['title'], message.data['body'], message.data,
      background: true);
  // Use this method to automatically convert the push data, in case you gonna use our data standard
}

operateOnMessage(BuildContext context, String mtitle, String mBody,
    Map<String, dynamic> data,
    {bool background = false}) async {
  if (data.isNotEmpty) {
    if (data.containsKey('itemId') && data.containsKey('imageUrl')) {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: Random().nextInt(10000),
              title: mtitle,
              body: mBody,
              payload: {"itemId": data['itemId'], "imageUrl": data['imageUrl']},
              channelKey: 'advertisement',
              largeIcon: data['imageUrl'],
              bigPicture: data['imageUrl'],
              notificationLayout: NotificationLayout.BigPicture,
              displayOnForeground: true,
              displayOnBackground: true,
              summary: mBody));

      showOverlayNotification(
          (context) => Notify(
                title: mtitle,
                body: mBody,
                image: data['imageUrl'],
                itemId: int.parse(data['itemId']),
              ),
          duration: Duration(seconds: 9999),
          position: NotificationPosition.top);
    } else {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: Random().nextInt(10000),
              title: mtitle,
              body: mBody,
              channelKey: 'basic_channel',
              displayOnForeground: true,
              displayOnBackground: true,
              summary: mBody));

      showOverlayNotification(
          (context) => Notify(
                title: mtitle,
                body: mBody,
                // data: data,
              ),
          duration: Duration(seconds: 10),
          position: NotificationPosition.top);
    }
  } else {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: Random().nextInt(10000),
            title: mtitle,
            body: mBody,
            channelKey: 'basic_channel',
            displayOnForeground: true,
            displayOnBackground: true,
            summary: mBody));

    showOverlayNotification(
        (context) => Notify(
              title: mtitle,
              body: mBody,
              // data: data,
            ),
        duration: Duration(seconds: 10),
        position: NotificationPosition.top);
  }
}
