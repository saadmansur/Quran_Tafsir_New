import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:tafseer_app/Utils.dart';
import '../model/SurahInfo.dart';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

// void main() => runApp(MyApp());

class MyAppNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Audio Player'),
        ),
        body: AudioPlayerPage(),
      ),
    );
  }
}

class AudioPlayerPage extends StatefulWidget {
  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  late AudioPlayer _audioPlayer;
  late Stream<Duration> _positionStream;
  late Stream<Duration?> _durationStream;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _positionStream = _audioPlayer.positionStream;
    _durationStream = (_audioPlayer.durationStream);
    _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(
        "https://qurantafseeraudios.b-cdn.net/10%20%5BQuran%20Tafseer%20Urdu%5D%20AL-BAQARAH%20108-141.mp3")));
    _audioPlayer.play();
  }

  @override
  void dispose() {
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

  // Widget _progessBar() {
  //   return StreamBuilder<Duration?>(
  //     stream: _audioPlayer.positionStream,
  //     builder: (context, snapshot) {
  //       return ProgressBar(
  //         progress: snapshot.data ?? Duration.zero,
  //         buffered: _audioPlayer.bufferedPosition,
  //         total: _audioPlayer.duration ?? Duration.zero,
  //         onSeek: (duration) {
  //           _audioPlayer.seek(duration);
  //         },
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var duration = Duration.zero;
    return Column(
      children: [
        StreamBuilder<Duration?>(
          stream: _durationStream,
          builder: (context, snapshot) {
            duration = snapshot.data ?? Duration.zero;
            return Text(formatDuration(duration));
          },
        ),
        StreamBuilder<Duration?>(
          stream: _positionStream,
          builder: (context, snapshot) {
            final position = snapshot.data ?? Duration.zero;
            return Slider(
              value: position.inSeconds.toDouble(),
              min: 0.0,
              max: duration.inSeconds.toDouble(),
              onChanged: (value) => handleSeek(value),
            );
          },
        ),
        StreamBuilder<PlayerState>(
            stream: _audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final processingState = snapshot.data?.processingState;
              final playing = snapshot.data?.playing;
               if (playing != true) {
                return IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: handlePlayPause,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: const Icon(Icons.pause),
                  onPressed: handlePlayPause,
                );
              } else {
                return IconButton(
                    icon: const Icon(Icons.replay),
                    onPressed: () => {});
              }
            }),
      ],
    );
  }
}



//




/*Warning:
The JKS keystore uses a proprietary format. It is recommended to migrate to PKCS12 which is an industry standard format using "keytool -importkeystore -srckeystore /Users/saadmansur/upload-keystore.jks -destkeystore /Users/saadmansur/upload-keystore.jks -deststoretype pkcs12".*/
/*
enum AudioSourceOption { Network, Asset }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _setupAudioPlayer(AudioSourceOption.Network);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Audio Player",
          )),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                _sourceSelect(),
                // _progessBar(),
                Row(
                  children: [
                    _controlButtons(),
                    _playbackControlButton(),
                  ],
                )
              ]),
        ),
      ),
    );
  }

  Future<void> _setupAudioPlayer(AudioSourceOption option) async {
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stacktrace) {
          print("A stream error occurred: $e");
        });
    try {
      if (option == AudioSourceOption.Network) {
        await _player.setAudioSource(AudioSource.uri(Uri.parse(
            "https://orangefreesounds.com/wp-content/uploads/2023/10/Calm-sea-sound-effect.mp3")));
      } else if (option == AudioSourceOption.Asset) {
        await _player.setAudioSource(
            AudioSource.asset("assets/audio/pixabay_audio.mp3"));
      }
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  Widget _sourceSelect() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      MaterialButton(
        color: Colors.purple,
        child: Text("Network"),
        onPressed: () => _setupAudioPlayer(AudioSourceOption.Network),
      ),
      MaterialButton(
        color: Colors.purple,
        child: Text("Asset"),
        onPressed: () => _setupAudioPlayer(AudioSourceOption.Asset),
      ),
    ]);
  }

  // Widget _progessBar() {
  //   return StreamBuilder<Duration?>(
  //     stream: _player.positionStream,
  //     builder: (context, snapshot) {
  //       return ProgressBar(
  //         progress: snapshot.data ?? Duration.zero,
  //         buffered: _player.bufferedPosition,
  //         total: _player.duration ?? Duration.zero,
  //         onSeek: (duration) {
  //           _player.seek(duration);
  //         },
  //       );
  //     },
  //   );
  // }

  Widget _playbackControlButton() {
    return StreamBuilder<PlayerState>(
        stream: _player.playerStateStream,
        builder: (context, snapshot) {
          final processingState = snapshot.data?.processingState;
          final playing = snapshot.data?.playing;
          if (processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering) {
            return Container(
              margin: const EdgeInsets.all(8.0),
              width: 64,
              height: 64,
              child: const CircularProgressIndicator(),
            );
          } else if (playing != true) {
            return IconButton(
              icon: const Icon(Icons.play_arrow),
              iconSize: 64,
              onPressed: _player.play,
            );
          } else if (processingState != ProcessingState.completed) {
            return IconButton(
              icon: const Icon(Icons.pause),
              iconSize: 64,
              onPressed: _player.pause,
            );
          } else {
            return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64,
                onPressed: () => _player.seek(Duration.zero));
          }
        });
  }

  Widget _controlButtons() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      StreamBuilder(
          stream: _player.speedStream,
          builder: (context, snapshot) {
            return Row(children: [
              const Icon(
                Icons.speed,
              ),
              Slider(
                  min: 1,
                  max: 3,
                  value: snapshot.data ?? 1,
                  divisions: 3,
                  onChanged: (value) async {
                    await _player.setSpeed(value);
                  })
            ]);
          }),
      StreamBuilder(
          stream: _player.volumeStream,
          builder: (context, snapshot) {
            return Row(children: [
              const Icon(
                Icons.volume_up,
              ),
              Slider(
                  min: 0,
                  max: 3,
                  value: snapshot.data ?? 1,
                  divisions: 4,
                  onChanged: (value) async {
                    await _player.setVolume(value);
                  })
            ]);
          }),
    ]);
  }
}
*/