
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fn/log_service.dart';


import 'notification.dart';

class NotificationListenerProvider {
  final _firebaseMessaging = FirebaseMessaging.instance.getInitialMessage();

  void getMessage(BuildContext context) {

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event)  async{
      RemoteNotification notification = event.notification!;


      AndroidNotification androidNotification = event.notification!.android!;

      if (notification != null && androidNotification != null) {

        ///Show local notification
        LogService.e(notification.title!);
        LogService.e(notification.body!);
        sendNotification(title: notification.title!, body: notification.body);

        ///Show Alert dialog 
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(notification.title!),
                content: Text(notification.body!),
              );
            });
      }
    });
  }
}

