import 'package:flutter/material.dart';
import 'package:tafseer_app/Utils.dart';
import 'package:tafseer_app/pages/surahListPage.dart';
import 'dart:math';

class hadeesPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
  static const String routeName = '/homePageWithWidgets';
  String hadeesText = "";
}

class _MyHomePageState extends State<hadeesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Hadees of the day"),
        backgroundColor: HexColor("007055"),
      ),

      body: Stack(
        children: <Widget>[
//          Center(
//            child: Image.asset(
//              "lib/images/home_bg.jpg",
//              width: size.width,
//              height: size.height,
//              fit: BoxFit.fill,
//            ),
//          ),
        widget.hadeesText.length == 0? Image.asset(
              "lib/images/home_bg.jpg",
          width: size.width,
          height: size.height - AppBar().preferredSize.height,
          fit: BoxFit.fill,
        ):
        Center(
          child: Image.network(
            widget.hadeesText,
            width: size.width,
            height: (size.height - AppBar().preferredSize.height)  * 0.6,
            fit: BoxFit.fill,
          )),
        ],
      ),
    );
  }
}

/*Warning:
The JKS keystore uses a proprietary format. It is recommended to migrate to PKCS12 which is an industry standard format using "keytool -importkeystore -srckeystore /Users/saadmansur/upload-keystore.jks -destkeystore /Users/saadmansur/upload-keystore.jks -deststoretype pkcs12".*/
