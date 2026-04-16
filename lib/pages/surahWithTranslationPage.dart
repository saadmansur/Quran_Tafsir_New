import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import '../model/SurahReciteInfo.dart';
import '../Utils.dart';
import '../model/SurahInfo.dart';
import 'package:tafseer_app/pages/ChewiePlayerScreen.dart';


class surahWithTranslationPage extends StatelessWidget {
  static const String routeName = '/surahWithTranslationPage';
  surahWithTranslationPage({required this.surah}) : super();
  final SurahReciteInfo surah;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
//     SystemChrome.setPreferredOrientations(<DeviceOrientation>[
//      DeviceOrientation.portraitUp,
//    ]);
    return Scaffold(
        appBar: AppBar(
          title: Text(surah.arabicTitle,style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 30.0,
              fontFamily: 'naskhregular',
              color: HexColor("#FFFFFF"))),
          backgroundColor: HexColor("007055"),
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: Image.asset(
                "lib/images/home_bg.jpg",
                width: size.width,
                height: size.height,
                fit: BoxFit.fill,
              ),
            ),
            Center(child: MyHomePage(surah:surah)),
          ],
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePage({required this.surah}) : super();
final SurahReciteInfo surah;
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FutureBuilder(
        future:
        this.widget.surah.reciteMode == 0 || widget.surah.reciteMode == 1? DefaultAssetBundle.of(context).loadString('assets/verses_en/' + widget.surah.surahNumber.toString() + '.json'): DefaultAssetBundle.of(context).loadString('assets/verses/' + widget.surah.surahNumber.toString() + '.json'),
        builder: (context, snapshot) {
          // Decode the JSON
          var newData = json.decode(snapshot.data.toString());

          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {

              return Container(
                  color: HexColor("05302D"),
                  // padding: const EdgeInsets.only(
                  //     top: 0, bottom: 0, left: 4, right: 4),
                  child: InkWell(
                      child: Card(
                        color: HexColor("FFFFFF"),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            textDirection: TextDirection.ltr,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 0, bottom: 0, right: 0, top: 10),
                                  //apply padding to some sides only
                                  child: Text( newData[index]['text'] + " [" + newData[index]['id'].toString() + "]" ,
                                    //'Note Title',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 48.0,
                                        fontFamily: 'naskhregular',
                                        color: HexColor("#000000")),
                                  )),
                              newData[index]['translation'].length > 0 && (this.widget.surah.reciteMode == 1 || this.widget.surah.reciteMode == 2)?  Padding(
                                  padding: EdgeInsets.only(
                                      left: 0, bottom: 0, right: 0, top: 10),
                                  //apply padding to some sides only
                                  child:Text(
                                    newData[index]['translation'] + " [" + newData[index]['id'].toString() + "]" ,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(fontWeight: FontWeight.bold,
                                        fontSize: 34.0,
                                        fontFamily: 'urdu',
                                        color: Colors.green),
                                  )): Flexible(child: Text("",
                                //'Note Title',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 1.0,
                                    color: HexColor("#ffe200")),
                              )),
                            ],
                          ),
                        ),
                      )));
            },
            itemCount: newData == null ? 0 : newData.length,
          );
        },
      ),
    ));
  }

  SurahInfo createSurahInstance(String surahPartText) {
    List<String> parts = surahPartText.split('|');
    return SurahInfo(
        surahNumber: parts[0],
        arabicTitle: parts[1],
        ytLink: parts[2].trim(),
        englishTitle: parts[3]);
  }
}

class MyApp extends StatelessWidget {
  MyApp({ required this.surah}) : super();
  final SurahInfo surah;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Video Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: ChewieDemo(surah: this.surah)/*VideoPageCached(
        video: Video(
          title: 'Fluttering Butterfly',
          url: 'https://drive.google.com/uc?export=download&id=117vlngjbaBkZQoe9D8DIQ40-5xUAMIpi',
        ),*/
      );
  }
}
