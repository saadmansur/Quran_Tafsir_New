import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Utils.dart';
import '../model/SurahInfo.dart';

import 'package:tafseer_app/model/video.dart';

import 'ChewiePlayerScreen.dart';

class hadeesListPage extends StatelessWidget {
  static const String routeName = '/hadeesListPage';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
//     SystemChrome.setPreferredOrientations(<DeviceOrientation>[
//      DeviceOrientation.portraitUp,
//    ]);
    return Scaffold(
        appBar: AppBar(
          title: Text("Hadees Lectures"),
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
            Center(child: MyHomePage()),
          ],
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
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
            DefaultAssetBundle.of(context).loadString('assets/hadees_details.json'),
        builder: (context, snapshot) {
          // Decode the JSON
          var newData = json.decode(snapshot.data.toString());

          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              SurahInfo surahToPlay = SurahInfo(
                  surahNumber: newData[index]['surah'],
                  arabicTitle: newData[index]['name'],
                  ytLink: newData[index]['yt_link'],
                  englishTitle: "");
              return Container(
                  color: HexColor("05302D"),
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, left: 16, right: 16),
                  child: InkWell(
                      onTap: () {
                        if (newData[index]['surahParts'].length == 0) {
//                          Navigator.push(context, MaterialPageRoute(
//                              builder: (context) =>
//                                  YoutubePlayerDemo(
//                                      surah: surahToPlay)));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChewieDemo(surah: surahToPlay),
                              settings: RouteSettings(name: 'Hadees Player Screen ' + surahToPlay.arabicTitle)));
                        } else {
                          List<String> surahPartsList =
                              newData[index]['surahParts'].cast<String>();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: HexColor("007055"),
                                  title: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                               newData[index]['name'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22.0,
                                                  color: HexColor("#ffe200")),
                                            ),
                                          ),
                                          color: HexColor("05302D"),
                                        )
                                      ]),
                                  content: setupAlertDialoadContainer(
                                      context, surahPartsList),
                                );
                              });
                        }
                      },
                      child: Card(
                        color: HexColor("4F7B6E"),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[

//                                  Text(
//                                    newData[index]['surah'],
//                                    //'Note Text',
//                                    style: TextStyle(color: Colors.white),
//                                  ),
                                  Expanded(child: Text(newData[index]['name'],
                                    //'Note Title',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.0,
                                        color: HexColor("#ffe200")),
                                  ))],
                              ),
                            ],
                          ), /*Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[


                                  Text(
                                    newData[index]['name'],
                                    //'Note Title',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.0,
                                        color: HexColor("#ffe200")),
                                  ),
                                  Text(
                                    newData[index]['surah'],
                                    //'Note Text',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),*/
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

  Widget setupAlertDialoadContainer(context, List<String> surahPartsList) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: HexColor("05302D"),
          height: 300.0, // Change as per your requirement
          width: 300.0, // Change as per your requirement
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: surahPartsList.length,
            itemBuilder: (BuildContext context, int index) {
              SurahInfo surah = createSurahInstance(surahPartsList[index]);
//              return ListTile(
//                title: Card(child: Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Text(surah.arabicTitle),
//                )),
//              );

              return Container(
                  color: HexColor("05302D"),
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 8, right: 8),
                  child: InkWell(
                      onTap: () {
/*                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    YoutubePlayerDemo(surah: surah)));*/
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ChewieDemo(surah: surah),
                                settings: RouteSettings(name: 'Hadees Player Screen ' + surah.arabicTitle)));



//                        Navigator.of(context).push(MaterialPageRoute(
//                            builder: (BuildContext context) => RepositoryProvider<VideoControllerService>(
//                              create: (context) => CachedVideoControllerService(DefaultCacheManager()),
//                              child: MyApp(surah: surah),
//                            )));

                      },
                      child: Card(
                        color: HexColor("4F7B6E"),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                  child: Container(
                                alignment: Alignment.center,
//                                height: MediaQuery.of(context).size.height * 0.8,
//                                padding: EdgeInsets.only(
//                                    left: 0, top: MediaQuery.of(context).size.height * 0.2, right: 0, bottom:50),
//                                child: SingleChildScrollView(
//                                    scrollDirection: Axis.vertical,
//                                    physics: AlwaysScrollableScrollPhysics(),
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 15,
                                            bottom: 5,
                                            right: 15,
                                            top: 5),
                                        //apply padding to some sides only
                                         child:Text(surah.arabicTitle,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                                color: HexColor("#ffe200")))
                                    ),
                              ))
                              /*Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                      child: FittedBox(
                                        child: Text(
                                          surah.arabicTitle,
                                          //'Note Title',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                              color: HexColor("#ffe200")),
                                        ),
                                      )
                                  ),
                                  Center(
                                      child: FittedBox(
                                        child: Text(
                                          surah.englishTitle,
                                          //'Note Title',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0,
                                              color: Colors.white),
                                        ),
                                      )
                                  )
                                ],
                              ),*/
                            ],
                          ),
                        ),
                      )));
            },
          ),
        ),
        /*Align(
          alignment: Alignment.bottomRight,
          child: FlatButton(

            onPressed: (){
              Navigator.pop(context);
            },child: Text("Cancel"),),
        )*/
      ],
    );
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
