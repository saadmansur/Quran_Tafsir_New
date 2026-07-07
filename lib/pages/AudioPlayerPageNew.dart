import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../Utils.dart';
import '../model/SurahInfo.dart';

class AudioPlayerPageNew extends StatefulWidget {

  AudioPlayerPageNew({ required this.surah}) : super();
  final SurahInfo surah;
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
  static const String routeName = '/homePage';
}

class _MyHomePageState extends State<AudioPlayerPageNew> {
  AudioPlayer player = AudioPlayer();

  bool isPlaying = false;
  double totalDuration = 0.0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  late AudioPlayer _audioPlayer;
  late Stream<Duration> _positionStream;
  late Stream<Duration?> _durationStream;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _positionStream = _audioPlayer.positionStream;
    _durationStream = _audioPlayer.durationStream;
    _audioPlayer.playbackEventStream.listen(
      (event) {},
      onError: (Object e, StackTrace st) {
        debugPrint('Audio playback error: $e');
      },
    );
    _initAudioSource();
  }

  Future<void> _initAudioSource() async {
    try {
      await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(widget.surah.ytLink)),
      );
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Error loading audio source: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void handlePlayPause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void handleSeek(double value) {
    _audioPlayer.seek(Duration(seconds: value.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.surah.englishTitle.length > 0?  widget.surah.englishTitle + "  -\t" + widget.surah.arabicTitle: widget.surah.arabicTitle),
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
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      "https://qurantafseeraudios.b-cdn.net/audio.jpg",
                      width: size.width * 0.9,
                      height: 350,
                      fit: BoxFit.fill,
                    )),
                const SizedBox(height: 30),
                Text(
                  widget.surah.arabicTitle,
                  style: TextStyle(
                      color: HexColor("#ffe200"),
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0),
                ),
                // Slider(
                //   activeColor: Colors.green, // The color to use for the portion of the slider track that is active.
                //   inactiveColor: Colors.green[100], // The color for the inactive portion of the slider track.
                //   thumbColor: Colors.white,
                //   min: 0,
                //   max: duration.inSeconds.toDouble(),
                //   value: position.inSeconds.toDouble(),
                //   onChanged: (value) async {
                //     final position = Duration(seconds: value.toInt());
                //     await player.seek(position);
                //
                //     // await player.resume();
                //   },
                // ),

                StreamBuilder<Duration?>(
                  stream: _durationStream,
                  builder: (context, snapshot) {
                    duration = snapshot.data ?? Duration.zero;
                    totalDuration = ((duration.inMinutes * 60) + (duration.inSeconds)) + 0.6;

                    return Text(" ",style: TextStyle(
                        color: HexColor("#ffe200"),
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0));//Text(formatDuration(duration));
                  },
                ),
                StreamBuilder<Duration?>(
                  stream: _positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;

                    return Slider(
                      activeColor: Colors.green, // The color to use for the portion of the slider track that is active.
                      inactiveColor: Colors.green[100], // The color for the inactive portion of the slider track.
                      thumbColor: Colors.white,
                      value: position.inSeconds.toDouble(),
                      min: 0.0,
                      max: duration.inSeconds.toDouble() + 16.0,
                        // onChanged: (value) async {
                        //   final position = Duration(seconds: value.toInt());
                        //   await player.seek(position);
                        //
                        //   // await player.resume();
                        // }
                      onChanged: (value) => handleSeek(value),
                    );
                  },
                ),
                // StreamBuilder<PlayerState>(
                //     stream: _audioPlayer.playerStateStream,
                //     builder: (context, snapshot) {
                //       final processingState = snapshot.data?.processingState;
                //       final playing = snapshot.data?.playing;
                //       if (playing != true) {
                //         return IconButton(
                //           icon: const Icon(Icons.play_arrow),
                //           onPressed: handlePlayPause,
                //         );
                //       } else if (processingState != ProcessingState.completed) {
                //         return IconButton(
                //           icon: const Icon(Icons.pause),
                //           onPressed: handlePlayPause,
                //         );
                //       } else {
                //         return IconButton(
                //             icon: const Icon(Icons.replay),
                //             onPressed: () => {});
                //       }
                //     }),

                StreamBuilder<PlayerState>(
                    stream: _audioPlayer.playerStateStream,
                    builder: (context, snapshot) {
                      final processingState = snapshot.data?.processingState;
                      if (processingState == ProcessingState.loading ||
                          processingState == ProcessingState.buffering) {
                        return const CircularProgressIndicator(color: Colors.green);
                      }
                      final playing = snapshot.data?.playing ?? false;
                      return CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: IconButton(
                              icon: Icon(
                                playing ? Icons.pause : Icons.play_arrow,
                                color: Colors.green,
                              ),
                              iconSize: 45,
                              onPressed: handlePlayPause));
                    }),

                // const SizedBox(height: 10),
                // Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 1),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         Text(formatTime(position),style: TextStyle(
                //             color: HexColor("#ffe200"),
                //             fontWeight: FontWeight.bold,
                //             fontSize: 20.0)),
                //         Text(formatTime(duration - position), style: TextStyle(
                //             color: HexColor("#ffe200"),
                //             fontWeight: FontWeight.bold,
                //             fontSize: 20.0))
                //       ],
                //     )),
                // const SizedBox(height: 20),
/*                CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.green,
                      ),
                      iconSize: 45,
                      onPressed: () async {
                        if (!isPlaying) {
                          // player.play(
                          //     widget.surah.ytLink);
                        } else {
                          player.pause();
                        }
                      },
                    ))*/
              ])])
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }
}