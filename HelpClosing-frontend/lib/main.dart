import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:help_closing_frontend/Controller/User_Controller.dart';
import 'package:help_closing_frontend/Fcm/fcmSettings.dart';
import 'Controller/Auth_Controller.dart';
import 'Pages/Login_SignUp/Login.dart';
import 'Pages/MainPage.dart';

// late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // notification 설정
  String? firebaseToken = await fcmSetting();

  Get.put(AuthController());
  Get.put(UserController());

  // // notification 설정
  await AuthController.to.storage.write(key: 'fcmToken', value: firebaseToken);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      themeMode: ThemeMode.system,
      home: const LoginPage(),
      // home : const MainPage()
    );
  }
}

