// ignore_for_file: unused_local_variable

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../Utils.dart';
import '../model/SurahInfo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChewieDemo extends StatefulWidget {

  ChewieDemo({required this.surah}) : super();
  final SurahInfo surah;

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController1;
  ChewieController? _chewieController;

  final _storage = const FlutterSecureStorage();
  int positionToStart = 0;

  @override
  void initState() {
    super.initState();
    getResumePoint();
//    print(_storage.read(key:widget.surah.surahNumber + widget.surah.englishTitle));
//    positionToStart = containsKeyInSecureData(widget.surah.surahNumber + widget.surah.englishTitle) == false? 0:
//    int.parse((_storage.read(key: widget.surah.surahNumber + widget.surah.englishTitle)).toString());

//    int.parse(_storage.read(key: widget.surah.surahNumber + widget.surah.englishTitle)  != null ? (_storage.read(key: widget.surah.surahNumber + widget.surah.englishTitle)).toString() : '0');
    initializePlayer();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        WakelockPlus.enable();
      });
    });
  }

  void getResumePoint() async {
    if (await _storage.containsKey(
        key: widget.surah.surahNumber + widget.surah.englishTitle,
        aOptions: _getAndroidOptions())) {
      String? value = await _storage.read(
          key: widget.surah.surahNumber + widget.surah.englishTitle);
      positionToStart = int.parse(value == null ? "0" : value);
    } else {
      positionToStart = 0;
    }
  }

  Future<bool> containsKeyInSecureData(String key1) async {
    var containsKey =
        await _storage.containsKey(key: key1, aOptions: _getAndroidOptions());
    print(containsKey);
    if (containsKey) print(_storage.read(key: key1));
    return containsKey;
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: false,
      );

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController?.dispose();
    super.dispose();

    _setOrientation([
      DeviceOrientation.portraitUp,
    ]);
  }

  _setOrientation(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }


  Future<void> initializePlayer() async {
    _videoPlayerController1 =
        VideoPlayerController.network(widget.surah.ytLink);
    await Future.wait([
      _videoPlayerController1.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {

    _videoPlayerController1.addListener(autoNextLis);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: false,
      showOptions: false,

//      additionalOptions: (context) {
//        return <OptionItem>[
//          OptionItem(
//            onTap: toggleVideo,
//            iconData: Icons.live_tv_sharp,
//            title: 'Toggle Video Src',
//          ),
//        ];
//      },
//      subtitle: Subtitles(subtitles),
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(
                text: subtitle,
              )
            : Text(
                subtitle.toString(),
                style: const TextStyle(color: Colors.black),
              ),
      ),

      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );

    _chewieController?.enterFullScreen();
    _chewieController?.seekTo(Duration(seconds: positionToStart));
  }

  int currPlayIndex = 0;

  Future<void> toggleVideo() async {
    await _videoPlayerController1.pause();
    currPlayIndex = currPlayIndex == 0 ? 1 : 0;
    await initializePlayer();
  }

  void autoNextLis() {
    int total = _videoPlayerController1.value.duration.inMilliseconds;
    final int pos = _videoPlayerController1.value.position.inMilliseconds;
    if (total - pos <= 0) {
      _videoPlayerController1.removeListener(autoNextLis);
      saveResumePoint("0");
      Navigator.pop(context);
    }
  }

  void saveResumePoint(String point) {
    _storage.write(
        key: widget.surah.surahNumber + widget.surah.englishTitle,
        value: point);
  }

  @override
  Widget build(BuildContext context) {
    return
        MaterialApp(
      title: widget.surah.arabicTitle,
          debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: HexColor("007055"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              iconSize: 20.0,
              onPressed: () {
                saveResumePoint(_videoPlayerController1.value.position.inSeconds
                    .toString());
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: Text(
                widget.surah.englishTitle.length > 0
                    ? widget.surah.englishTitle +
                        "  -\t" +
                        widget.surah.arabicTitle
                    : widget.surah.arabicTitle,
                style: TextStyle(color: Colors.white))),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.black,
                child: Center(
                  child: _chewieController != null &&
                          _chewieController!
                              .videoPlayerController.value.isInitialized
                      ? Chewie(
                          controller: _chewieController!,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(height: 20),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 15, bottom: 15, right: 15, top: 15),
                                //apply padding to some sides only
                                child: Text(
                                    'Loading Video. Replay the video if it is still not loaded.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.0,
                                        color: Colors.white))),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
