// loading required packages
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:radioramezan/theme.dart';

class AudioPlayer extends StatefulWidget {
  @override
  _AudioPlayer createState() => _AudioPlayer();
}

class _AudioPlayer extends State<AudioPlayer>
    with SingleTickerProviderStateMixin {
  AssetsAudioPlayer player;
  bool audioPaused;
  IconData playPauseButtonIcon;

  Future<void> load(String type, Audio audio) async {
    try {
      await player.open(
        type == 'file'
            ? Audio.file(audio.path)
            : type == 'network'
                ? Audio.network(audio.path)
                : Audio.liveStream(audio.path),
        autoStart: false,
        respectSilentMode: false,
        showNotification: true,
        notificationSettings: NotificationSettings(
          playPauseEnabled: true,
          seekBarEnabled: true,
        ),
        playInBackground: PlayInBackground.enabled,
        headPhoneStrategy: HeadPhoneStrategy.none,
      );
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    audioPaused = true;
    playPauseButtonIcon = Icons.play_arrow_rounded;
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

// Audio streamingAudio = Audio(
//   'https://stream1.radioramezan.com:8443/montreal.mp3',
//   metas: Metas(
//     title: 'دعای سحر',
//     artist: 'محسن فرهمند صمیمی',
//     album: 'رادیو رمضان',
//     image: MetasImage.asset('assets/images/praying_hands.jpg'),
//   ),

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Container(
                    child: Image.asset('assets/images/praying_hands.jpg'),
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromRGBO(0, 0, 0, 0.0),
                          const Color.fromRGBO(0, 0, 0, 0.8),
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.0, 1.0),
                        stops: [0.7, 1.0],
                        tileMode: TileMode.clamp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: RawMaterialButton(
                            elevation: 0,
                            child: Icon(
                              Icons.share_outlined,
                              size: 24.0,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(12.0),
                            shape: CircleBorder(),
                            onPressed: () {},
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Marquee(
                            child: Text(
                              'دعای عهد با امام زمان (با صدای محسن فرهمند صمیمی)',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            direction: Axis.horizontal,
                            textDirection: TextDirection.rtl,
                            animationDuration: Duration(seconds: 5),
                            backDuration: Duration(seconds: 5),
                            pauseDuration: Duration(seconds: 1),
                            directionMarguee: DirectionMarguee.TwoDirection,
                            forwardAnimation: Curves.easeInOut,
                            backwardAnimation: Curves.easeInOut,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: RawMaterialButton(
                            elevation: 0,
                            child: Icon(
                              Icons.favorite_outline_rounded,
                              size: 24.0,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(12.0),
                            shape: CircleBorder(),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Slider(
                  activeColor: RadioRamezanColors.ramady,
                  inactiveColor: Colors.black12,
                  value: 0,
                  min: 0,
                  max: 100,
                  // divisions: 5,
                  // label: _currentSliderValue.round().toString(),
                  onChanged: (double value) {},
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '00:00',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '00:00',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        RawMaterialButton(
                          elevation: 0,
                          child: Icon(
                            Icons.forward_10_rounded,
                            size: 32.0,
                            color: Colors.black,
                          ),
                          padding: EdgeInsets.all(16.0),
                          shape: CircleBorder(),
                          onPressed: () {},
                        ),
                        RawMaterialButton(
                          elevation: 0,
                          child: Icon(
                            Icons.cast_rounded,
                            size: 32.0,
                            color: Colors.black,
                          ),
                          padding: EdgeInsets.all(16.0),
                          shape: CircleBorder(),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: RawMaterialButton(
                      elevation: 2.0,
                      fillColor: Theme.of(context).primaryColor,
                      child: Icon(
                        playPauseButtonIcon,
                        size: 64.0,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(36.0),
                      shape: CircleBorder(),
                      onPressed: () {
                        setState(() {
                          player.playOrPause();
                          playPauseButtonIcon = audioPaused
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded;
                          audioPaused = !audioPaused;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        RawMaterialButton(
                          elevation: 0,
                          child: Icon(
                            Icons.replay_10_rounded,
                            size: 32.0,
                            color: Colors.black,
                          ),
                          padding: EdgeInsets.all(16.0),
                          shape: CircleBorder(),
                          onPressed: () {},
                        ),
                        RawMaterialButton(
                          elevation: 0,
                          child: Icon(
                            Icons.volume_up_rounded,
                            size: 32.0,
                            color: Colors.black,
                          ),
                          padding: EdgeInsets.all(16.0),
                          shape: CircleBorder(),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
