import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_chat_app/send_message.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import 'package:my_chat_app/themes/themes.dart';
import 'login_page.dart';
import 'package:my_chat_app/controllers/string_controller.dart';
import 'register_page.dart';
import 'edit_profile_page.dart';
//import 'chat_window.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MyThemeData().MyThemeDataForApp(context),
      
      themeMode: ThemeMode.light,
      darkTheme: ThemeData(
        brightness: Brightness.light
      ),

      debugShowCheckedModeBanner: false,

      initialRoute: "/",

      routes: {
        homeRoute:(context) => HomePage(),
        loginRoute:(context) => LoginPage(),
        registerRoute:(context) => RegisterPage(),
        editProfileRoute:(context) => EditProfilePage(),
        //chatWindowForUserRoute:(context) => ChatWindow("", "", "", ""),
        sendMessageRoute:(context) => SendMessage(),
      }
    );
  }
}

