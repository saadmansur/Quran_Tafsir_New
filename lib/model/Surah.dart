

class Surah {
  final String surah;
  final String name;
  final String yt_link;
  final List<SurahPart> surahPart;

  Surah({required this.surah, required this.name, required this.yt_link, required this.surahPart});

  factory Surah.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['surahParts'] as List;
    print(list.runtimeType);
    List<SurahPart> imagesList = list.map((i) => SurahPart.fromJson(i)).toList();


    return Surah(
        surah: parsedJson['surah'],
        name: parsedJson['name'],
        yt_link: parsedJson['yt_link'],
        surahPart: imagesList

    );
  }
}

//class SurahPart {
//  final int imageId;
//  final String imageName;
//
//  Image({this.imageId, this.imageName});
//
//  factory Image.fromJson(Map<String, dynamic> parsedJson){
//    return Image(
//        imageId:parsedJson['id'],
//        imageName:parsedJson['imageName']
//    );
//  }
//}

class SurahPart{
  final String title;
  final String yt_link;
  final String en_title;

  SurahPart({
    required this.title,
    required this.yt_link,
    required this.en_title
  });

  factory SurahPart.fromJson(Map<String, dynamic> json){
    return SurahPart(
      title: json['title'],
      yt_link: json['yt_link'],
      en_title: json['en_title'],
    );
  }
}