import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tafseer_app/pages/homePageWithWidgets.dart';

import '../routes/drawer_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}


class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
// THIS FUNCTION WILL NAVIGATE FROM SPLASH SCREEN TO HOME SCREEN.    // USING NAVIGATOR CLASS.
//   FirebaseMessaging messaging;

  void navigationToNextPage() {
    Navigator.pushReplacementNamed(context, '/homePageWithWidgets');
  }

  startSplashScreenTimer() async {
    var _duration = new Duration(seconds: 3);
    return Timer(_duration, navigationToNextPage);
  }

  @override
  void initState() {
    super.initState();
    // FirebaseMessaging messaging = FirebaseMessaging.instance;
    // messaging.getToken().then((value) {
    //   print('Message is here: ${value}');
    // });
    startSplashScreenTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Column(
      children: [

        Container(
            color: Colors.white,
            alignment: Alignment.center,
            width: size.width,
            height: size.height * 0.92,
            child: Image.asset("lib/images/khuddamLogo.jpeg")),
        Container(
          color: Colors.white,
          alignment: Alignment.center,
          width: size.width,
          height: MediaQuery.of(context).size.height * 0.08,
          padding: EdgeInsets.only(left: 5, top: 0, right: 5, bottom: 0),
          child: Text("Designed & Developed by Saad Mansur for Sadaqah Jariyah",
              style: TextStyle(
                  backgroundColor: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  decoration: TextDecoration.none,
                  color: Colors.black)),
        ),
      ],
    );
  }
}

class MyApp extends StatelessWidget {

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NavigationDrawer Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
      routes: {
        drawer_routes.home: (context) => homePageWithWidgets(),
      },
    );
  }
}
