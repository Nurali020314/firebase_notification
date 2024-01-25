// Installion ID

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'firebase_message_provider.dart';
import 'log_service.dart';
import 'not_ser.dart';
import 'notification.dart';
import 'notification_button.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();

  await Firebase.initializeApp();

  FirebaseMessaging.onMessage.listen(
    (RemoteMessage remoteMessage) async {

      await NotificationService.showNotification(
          title: "${remoteMessage.data['name']}",
          body: "${remoteMessage.data['text']}",
          payload: {
            "navigate": "true",
          },
          actionButtons: [
            NotificationActionButton(
              key: 'check',
              label: 'Check it out',
              actionType: ActionType.SilentAction,
              color: Colors.green,
            )
          ]);

      LogService.d(remoteMessage.data.toString());
      sendNotification(
          title: "${remoteMessage.data['name']}",
          body: "${remoteMessage.data['text']}");

    },
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
              navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const MyHomePage(title: 'Flutter Demo Home Page'));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    setState(() {
      NotificationListenerProvider().getMessage(context);
      print("dkfkdfkdjfdkfdfdfdfd");
    });
    getToken();

    setState(() {
      FirebaseMessaging.onMessage.listen((RemoteMessage event) {
        RemoteNotification notification = event.notification!;
        LogService.e("${notification.body}");
      });
    });
  }

  void getToken() async {
    final token = await _firebaseMessaging.getToken();
    print("dlllllllllllllllll $token");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await NotificationService.showNotification(
              title: "Title of the notification",
              body: "Body of the notification",
              payload: {
                "navigate": "true",
              },
              actionButtons: [
                NotificationActionButton(
                  key: 'check',
                  label: 'Check it out',
                  actionType: ActionType.SilentAction,
                  color: Colors.green,
                )
              ]);
          //sendNotification(
          //    title: "Hello worlffffffffffffffffffffd",
          //    body: "My first flutteffffffffffffffr notification");
        },
        tooltip: 'Notification',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  LogService.w("ll");
}
