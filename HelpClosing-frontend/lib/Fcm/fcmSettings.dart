import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:help_closing_frontend/firebase_options.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print("Handling a background message: ${message.messageId}");
}

void saveFCMToken(String email, String token) async {
  if(token != null) {
    var url = Uri.parse('https://your-server.com/fb/saveFCMToken'); // 실제 서버 URL

    Map<String, String> headers = {"Content-type": "application/json"};

    Map<String, String> body = {
      'email': email,
      'FCMToken': token,
    };

    var response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      print('FCM Token 저장 완료');
    } else {
      print('FCM Token 저장 실패');
    }
  }
}

Future<String?> fcmSetting() async {
  // // firebase core 기능 사용을 위한 필수 initializing
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // firebase token 발급
  String? firebaseToken = await messaging.getToken();

  print("firebaseToken : ${firebaseToken}");



  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('권한 O');
  } else {
    print('권한 X');
  }

  // foreground에서의 푸시 알림 표시를 위한 알림 중요도 설정 (안드로이드)
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notification',
      description: 'This channel is used for important notifications.',
      importance: Importance.high
  );

  // foreground 에서의 푸시 알림 표시를 위한 local notifications 설정
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =  AndroidInitializationSettings('app_icon');
  await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(android: initializationSettingsAndroid));

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // foreground 푸시 알림 핸들링
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    print('Got a message whilst in the foreground!');
    print('포그라운드에서 메세지 받음');
    print('Message data: ${message.data}');
    print('type : ${message.category}');

    if (message.notification != null && android != null) {
      print("1");
      await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification?.title,
          notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon,
            ),
          ));

      print('Message also contained a notification: ${message.notification}');
      print('알림 제목: ${message.notification?.title}');
      print('알림 내용 : ${message.notification?.body}');
    }
  });



  return firebaseToken;
}
