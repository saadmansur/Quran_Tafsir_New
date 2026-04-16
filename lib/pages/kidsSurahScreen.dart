import 'package:flutter/material.dart';

import '../Utils.dart';

class SurahScreen extends StatelessWidget {
  int currentPage = 0;

  SurahScreen(index) {
    currentPage = index;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> surahs = [
      "Surah Nas",
      "Surah Falaq",
      "Surah Ikhlas",
      "Surah Qadar"
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(surahs[currentPage]),
        backgroundColor: HexColor("007055"),
      ),
      body: Center(
        child: new Image.asset(
          "lib/images/$currentPage.png",
          width: size.width,
          height: size.height - AppBar().preferredSize.height,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}