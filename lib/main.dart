import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'notification_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission();
  FirebaseMessaging.onBackgroundMessage(handlePushNotification);
  AwesomeNotifications().initialize(
    'resource://drawable/notification',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification basic tests',
        defaultColor: Color(0xFF9D50DD),
        playSound: true,
        channelShowBadge: true,
        ledColor: Colors.white,
      ),
      NotificationChannel(
          channelKey: 'schedule key',
          channelName: 'schedule notifications',
          channelDescription: 'Notification schedule test',
          defaultColor: Color(0xFF9D50DD),
          playSound: true,
          channelShowBadge: true,
          ledColor: Colors.white,
          soundSource: ''),
      NotificationChannel(
          channelKey: 'firebase key',
          channelName: 'firebase notifications',
          channelDescription: 'Notification firebase test',
          defaultColor: Color(0xFF9D50DD),
          playSound: true,
          channelShowBadge: true,
          ledColor: Colors.white,
          soundSource: ''),
    ],
  );
  runApp(const MyApp());
}

Future<void> handlePushNotification(RemoteMessage message) async {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 235,
      channelKey: 'firebase key',
      title: message.notification!.title,
      body: message.notification!.body,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Notification(),
    );
  }
}

class Notification extends StatefulWidget {
  const Notification({Key? key}) : super(key: key);

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 265,
          channelKey: 'firebase key',
          title: message.notification!.title,
          body: message.notification!.body,
        ),
      );
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        AwesomeNotifications().setListeners(
          onActionReceivedMethod: (receivedAction) async {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NotificationScreen()));
          },
          onDismissActionReceivedMethod: (receivedAction) async {
            print('Dismissed');
          },
          onNotificationDisplayedMethod: (receivedAction) async {
            print('Displayed Method');
          },
          onNotificationCreatedMethod: (receivedAction) async {
            print('Created Method');
          },

        );
      });
      // AwesomeNotifications().createNotificationFromJsonData(message.data);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  AwesomeNotifications().requestPermissionToSendNotifications();
                },
                child: Text('requset permisssion')),
            ElevatedButton(
                onPressed: () {
                  AwesomeNotifications().createNotification(
                    content: NotificationContent(
                      id: 0,
                      channelKey: 'basic_channel',
                      title: 'Test Title',
                      body: 'Text Body Notifications',
                      bigPicture: 'asset://assets/notification.png',
                      notificationLayout: NotificationLayout.BigPicture,
                    ),
                  );
                },
                child: Text('Create')),
            ElevatedButton(
                onPressed: () {
                  AwesomeNotifications().createNotification(
                    schedule: NotificationCalendar.fromDate(
                        date: DateTime.now().add(Duration(seconds: 3))),
                    content: NotificationContent(
                      id: 0,
                      channelKey: 'schedule key',
                      title: 'Test Title schedule',
                      body: 'Text Body schedule',
                      bigPicture: 'asset://assets/notification',
                      notificationLayout: NotificationLayout.BigPicture,
                    ),
                  );
                },
                child: Text('schedule')),
          ],
        ),
      ),
    );
  }
}
