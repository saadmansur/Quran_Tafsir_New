import 'package:flutter/material.dart';
import 'package:tafseer_app/Utils.dart';

import 'package:tafseer_app/pages/surahListPage.dart';
import '/pages/surahAudiosListPage.dart';
import 'package:tafseer_app/pages/surahRecitingListPage.dart';
import 'package:tafseer_app/pages/hadeesListPage.dart';
import 'package:tafseer_app/pages/MuntakhibNisaabLocal.dart';
import 'package:tafseer_app/pages/aboutUsPage.dart';
import '/pages/kidsSurahScreen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

class homePageWithWidgets extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
  static const String routeName = '/homePageWithWidgets';
  String hadeesText = "";
}

class _MyHomePageState extends State<homePageWithWidgets> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            title: Center(child: Text("Home")),
            backgroundColor: HexColor("007055"),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.share,
                ),
                onPressed: () {
                  print("It has all the Quran tafseer audio/video and hadees lectures by Dr. Israr Ahmed.\nFor iPhones users:\nhttps://apps.apple.com/nz/app/quran-tafseer/id6443613667\nFor Android users:\nhttps://play.google.com/store/apps/details?id=com.innovative.solutions.qurantafseer\nShare it with others as Sadqah Jariya.");

                  Share.share("It has all the Quran tafseer audio/video and hadees lectures by Dr. Israr Ahmed.\nFor iPhones users:\nhttps://apps.apple.com/nz/app/quran-tafseer/id6443613667\nFor Android users:\nhttps://play.google.com/store/apps/details?id=com.khuddam.ul.quran.tafseer.tafseer_app\nShare it with others as Sadqah Jariya.");
                }),
          ]),
        body: Column(children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.all(15.0),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: HexColor("B9D187"),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: List.generate(
                6,
                (index) {
                  return buildCard(index);
                },
              ),
            ),
          ))
        ]));
  }

  String getCountryISOCode() {
    final WidgetsBinding? instance = WidgetsBinding.instance;
    if (instance != null) {
      final List<Locale> systemLocales = instance.window.locales;
//      systemLocales.first.countryCode
      Locale myLocale = Localizations.localeOf(context);
      String? isoCountryCode = myLocale.languageCode;
      if (isoCountryCode != null) {
        return isoCountryCode;
      } else {
        throw Exception("Unable to get Country ISO code");
      }
    } else {
      throw Exception("Unable to get Country ISO code");
    }
  }

  Card buildCard(int index) {
    var tilesText = [
      "Quran Tafseer Lectures by Dr. Israr",
      "Hadees Lectures by Dr. Israr",
      "Muntikhab Nisaab Lectures",
      /*"Motivational Islamic Lectures ",*/
      "Recite Quran Majeed",
      /*"Hadees of the day",*/
      "Kids Corner",
      "About Us"
    ];
    var tilesIcons = [
      "tafseer.png",
      "hadees.png",
      "nisaab.png",
      /*"lectures.png",*/
      "quran_recite.png",
      /*"day.png",*/
      "kids.png",
      "info.png"
    ];
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(80),
        //set border radius more than 50% of height and width to make circle
      ),
      child: InkWell(
          onTap: () {
            openCardDetailsPage(index);
          },
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: new BorderRadius.all(const Radius.circular(15.0)),
                image: DecorationImage(
                    image: AssetImage("lib/images/home_bg.jpg"),
                    fit: BoxFit.fill)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "lib/images/" + tilesIcons[index],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  alignment: Alignment.center,
                  child: Text(
                    tilesText[index],
                    style: TextStyle(
                        color: HexColor("#ffe200"),
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future<void> openCardDetailsPage(int index) async {
    if (index == 0) {
      createTafseerLecturesContainer();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => surahListPage(),
      //     settings: RouteSettings(
      //         name: 'Surah List Video Screen View'),
      //   ),
      // );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => hadeesListPage(),
          settings: RouteSettings(name: 'Hadees List Screen View'),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MuntakhibNisaabLocal(),
          settings:
              RouteSettings(name: 'Muntikhab Nisaab Videos List Screen View'),
        ),
      );
    } /*else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BayanVideosPage(),
          settings: RouteSettings(name: 'Video Lectures List Screen View'),
        ),
      );
    }*/ else if (index == 3) {
     createQuranReadContainer();
    } /*else if (index == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => hadeesPage(),
          settings: RouteSettings(name: 'Hadees Screen View'),
        ),
      );
    }*/ else if (index == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => aboutUsPage(),
          settings: RouteSettings(name: 'About Screen View'),
        ),
      );
    } else if (index == 4) {
      createKidsSurahContainer();
/*      await LaunchApp.openApp(
        androidPackageName: 'com.digital.quranicdictionary',
        iosUrlScheme: 'arabicdictionary://',
        appStoreLink:
        'https://apps.apple.com/sg/app/digital-quranic-dictionary/id1638033757',
         openStore: true
      );*/
    }
  }

  void createTafseerLecturesContainer() {
    String _selectedGender = 'male';
    var _result;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: HexColor("007055"),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile(
                          title: const Text('Listen Audio Lectures',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18.0)),
                          value: 4,
                          groupValue: _result,
                          onChanged: (value) {
                            setState(() {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => surahAudiosListPage(),
                                  settings: RouteSettings(
                                      name: 'Surah List Audio Screen View'),
                                ),
                              );
                            });
                          }),
                      RadioListTile(
                          title: const Text('Watch Video Lectures',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18.0)),
                          value: 5.4,
                          groupValue: _result,
                          onChanged: (value) {
                            setState(() {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => surahListPage(),
                                  settings: RouteSettings(
                                      name: 'Surah List Video Screen View'),
                                ),
                              );
                            });
                          }),
                    ],
                  );
                },
              ));
        });
  }
  void createQuranReadContainer() {
    var _result;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: HexColor("007055"),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile(
                          title: const Text('Read Quran',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18.0)),
                          value: 4,
                          groupValue: _result,
                          onChanged: (value) {
                            setState(() {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => surahRecitingListPage(reciteMode: 0),
                                  settings: RouteSettings(
                                      name: 'Surah List Read Quran Screen View'),
                                ),
                              );
                            });
                          }),
                      RadioListTile(
                          title: const Text('Read Quran with English Translation',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18.0)),
                          value: 5.4,
                          groupValue: _result,
                          onChanged: (value) {
                            setState(() {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => surahRecitingListPage(reciteMode: 1),
                                  settings: RouteSettings(
                                      name: 'Read Quran with English Translation Screen View'),
                                ),
                              );
                            });
                          }),
                      RadioListTile(
                          title: const Text('Read Quran with Urdu Translation',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18.0)),
                          value: 5.4,
                          groupValue: _result,
                          onChanged: (value) {
                            setState(() {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => surahRecitingListPage(reciteMode: 2),
                                  settings: RouteSettings(
                                      name: 'Read Quran with Urdu Translation Screen View'),
                                ),
                              );
                            });
                          }),
                    ],
                  );
                },
              ));
        });
  }

  void createKidsSurahContainer() {
    List<String> surahs = [
      "Surah Nas",
      "Surah Falaq",
      "Surah Ikhlas",
      "Surah Qadar"
    ];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: HexColor("007055"),
            title: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Surah's",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: HexColor("#ffe200")),
                  ),
                ),
                color: HexColor("05302D"),
              )
            ]),
            content: setupAlertDialoadContainer(context, surahs),
          );
        });
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
//              SurahInfo surah = createSurahInstance(surahPartsList[index]);

              return Container(
                  color: HexColor("05302D"),
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 8, right: 8),
                  child: InkWell(
                      onTap: () {
                        openSurahFragment(index, context);
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
                                        left: 15, bottom: 5, right: 15, top: 5),
                                    //apply padding to some sides only
                                    child: Text(surahPartsList[index],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: HexColor("#ffe200")))),
                              ))
                            ],
                          ),
                        ),
                      )));
            },
          ),
        ),
      ],
    );
  }

  openSurahFragment(number, context) {
    if (number <= 3) {
      // termination case
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => SurahScreen(number)));
    } else {
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => homePageWithWidgets()));
      // function invokes itself
    }
  }
}

/*Warning:
The JKS keystore uses a proprietary format. It is recommended to migrate to PKCS12 which is an industry standard format using "keytool -importkeystore -srckeystore /Users/saadmansur/upload-keystore.jks -destkeystore /Users/saadmansur/upload-keystore.jks -deststoretype pkcs12".*/
