// loading required packages
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/theme.dart';
import 'package:radioramezan/data_models/prayer_model.dart';

class PrayerView extends StatefulWidget {
  final Prayer prayer;

  PrayerView({Key key, @required this.prayer}) : super(key: key);

  @override
  _PrayerView createState() => _PrayerView();
}

class _PrayerView extends State<PrayerView> with TickerProviderStateMixin {
  AssetsAudioPlayer prayerPlayer;
  bool showControls,
      showTranslation,
      prayerPlayerIsMuted,
      prayerPlayerIsPaused,
      prayerAudioIsLoaded,
      sliderIsChanging;
  double sliderSelectiveValue, sliderProgressiveValue, fontSize;
  String path;
  Metas metas;
  int positionInSeconds, durationInSeconds, remainingInSeconds;
  Animation<double> playPauseAnimation;
  AnimationController playPauseAnimationcontroller;

  Future<Null> loadPrayerAudio(String path, Metas metas) async {
    try {
      await prayerPlayer.open(
        Audio(path, metas: metas),
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
      setState(() {
        durationInSeconds = prayerPlayer.current.value.audio.duration.inSeconds;
        prayerAudioIsLoaded = true;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    prayerPlayer = AssetsAudioPlayer.newPlayer();
    fontSize = 22;
    showControls = false;
    showTranslation = false;
    prayerAudioIsLoaded = false;
    prayerPlayerIsMuted = false;
    prayerPlayerIsPaused = true;
    sliderIsChanging = false;
    sliderSelectiveValue = 0;
    sliderProgressiveValue = 0;
    path = 'assets/audios/' + widget.prayer.audio;
    metas = Metas(
      title: widget.prayer.title,
      artist: widget.prayer.reciter,
      album: 'رادیو رمضان',
    );
    loadPrayerAudio(path, metas);
    playPauseAnimationcontroller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    playPauseAnimation = CurvedAnimation(
      curve: Curves.linear,
      parent: playPauseAnimationcontroller,
    );
    super.initState();
  }

  void dispose() {
    prayerPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/golden_mosque_20percent.png'),
          fit: BoxFit.fitWidth,
          alignment: Alignment.bottomCenter,
        ),
      ),
      foregroundDecoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/modal_top.png'),
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: 90),
              Center(
                child: Text(
                  widget.prayer.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: RadioRamezanColors.ramady,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Column(
                    children: widget.prayer.verses.map(
                      (verse) {
                        return Container(
                          child: Column(
                            children: <Widget>[
                              verse.arabic != ''
                                  ? Text(
                                      verse.arabic,
                                      style: TextStyle(
                                        fontFamily: 'tahrir',
                                        fontSize: fontSize,
                                        height: 1.5,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  : SizedBox(),
                              verse.arabic != ''
                                  ? SizedBox(
                                      height: 10,
                                    )
                                  : SizedBox(),
                              showTranslation
                                  ? verse.farsi != ''
                                      ? Text(
                                          verse.farsi,
                                          style: TextStyle(
                                            fontFamily: 'tahrir',
                                            fontSize: fontSize,
                                            height: 1.5,
                                            color: RadioRamezanColors.ramady,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      : SizedBox()
                                  : SizedBox(),
                              showTranslation
                                  ? verse.farsi != ''
                                      ? SizedBox(
                                          height: 10,
                                        )
                                      : SizedBox()
                                  : SizedBox(),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
              showControls
                  ? Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PlayerBuilder.currentPosition(
                            player: prayerPlayer,
                            builder: (context, position) {
                              positionInSeconds = position.inSeconds;
                              remainingInSeconds =
                                  durationInSeconds - positionInSeconds;
                              sliderProgressiveValue =
                                  (positionInSeconds / durationInSeconds) * 100;
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        prayerAudioIsLoaded
                                            ? (remainingInSeconds / 60)
                                                    .truncate()
                                                    .toString()
                                                    .padLeft(2, '0') +
                                                ':' +
                                                (remainingInSeconds % 60)
                                                    .toString()
                                                    .padLeft(2, '0')
                                            : '00:00',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: prayerAudioIsLoaded
                                                ? RadioRamezanColors.ramady
                                                : Theme.of(context)
                                                    .disabledColor),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 14,
                                      child: Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Slider(
                                          activeColor:
                                              RadioRamezanColors.ramady,
                                          inactiveColor:
                                              Theme.of(context).disabledColor,
                                          min: 0,
                                          max: 100,
                                          value: sliderIsChanging
                                              ? sliderSelectiveValue
                                              : sliderProgressiveValue,
                                          onChanged: prayerAudioIsLoaded
                                              ? (newSliderValue) {
                                                  sliderIsChanging = true;
                                                  setState(() {
                                                    sliderSelectiveValue =
                                                        newSliderValue;
                                                  });
                                                }
                                              : null,
                                          onChangeEnd: prayerAudioIsLoaded
                                              ? (newSliderValue) {
                                                  sliderIsChanging = false;
                                                  prayerPlayer.seek(Duration(
                                                      seconds: ((newSliderValue /
                                                                  100) *
                                                              durationInSeconds)
                                                          .truncate()));
                                                }
                                              : null,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        prayerAudioIsLoaded
                                            ? (positionInSeconds / 60)
                                                    .truncate()
                                                    .toString()
                                                    .padLeft(2, '0') +
                                                ':' +
                                                (positionInSeconds % 60)
                                                    .toString()
                                                    .padLeft(2, '0')
                                            : '00:00',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: prayerAudioIsLoaded
                                                ? RadioRamezanColors.ramady
                                                : Theme.of(context)
                                                    .disabledColor),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: <Widget>[
                                    RawMaterialButton(
                                      elevation: 0,
                                      child: Icon(
                                        CupertinoIcons.zoom_in,
                                        size: 32.0,
                                        color: fontSize < 28
                                            ? Colors.black
                                            : Theme.of(context).disabledColor,
                                      ),
                                      padding: EdgeInsets.all(16.0),
                                      shape: CircleBorder(),
                                      onPressed: fontSize < 28
                                          ? () {
                                              if (fontSize < 28)
                                                setState(() {
                                                  fontSize += 2;
                                                });
                                            }
                                          : null,
                                    ),
                                    RawMaterialButton(
                                      elevation: 0,
                                      child: Icon(
                                        CupertinoIcons.zoom_out,
                                        size: 32.0,
                                        color: fontSize > 22
                                            ? Colors.black
                                            : Theme.of(context).disabledColor,
                                      ),
                                      padding: EdgeInsets.all(16.0),
                                      shape: CircleBorder(),
                                      onPressed: fontSize > 22
                                          ? () {
                                              if (fontSize > 22)
                                                setState(() {
                                                  fontSize -= 2;
                                                });
                                            }
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: <Widget>[
                                    RawMaterialButton(
                                      elevation: 0,
                                      child: Icon(
                                        CupertinoIcons.goforward_10,
                                        size: 32.0,
                                        color: prayerAudioIsLoaded
                                            ? Colors.black
                                            : Theme.of(context).disabledColor,
                                      ),
                                      padding: EdgeInsets.all(16.0),
                                      shape: CircleBorder(),
                                      onPressed: prayerAudioIsLoaded
                                          ? () {
                                              prayerPlayer.seekBy(
                                                  Duration(seconds: 10));
                                            }
                                          : null,
                                    ),
                                    RawMaterialButton(
                                      elevation: 0,
                                      child: Icon(
                                        CupertinoIcons.speedometer,
                                        size: 32.0,
                                        // color: _prayerAudioIsLoaded
                                        //     ? Colors.black
                                        //     : Theme.of(context).disabledColor,
                                        color: Theme.of(context).disabledColor,
                                      ),
                                      padding: EdgeInsets.all(16.0),
                                      shape: CircleBorder(),
                                      onPressed: null,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: RawMaterialButton(
                                  elevation: prayerAudioIsLoaded ? 2 : 0,
                                  fillColor: prayerAudioIsLoaded
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).disabledColor,
                                  child: prayerAudioIsLoaded
                                      ? AnimatedIcon(
                                          icon: AnimatedIcons.play_pause,
                                          size: 64,
                                          color: Colors.white,
                                          progress: playPauseAnimation,
                                        )
                                      : Container(
                                          height: 64,
                                          width: 64,
                                          padding: EdgeInsets.all(18.0),
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        ),
                                  padding: EdgeInsets.all(18.0),
                                  shape: CircleBorder(),
                                  onPressed: prayerAudioIsLoaded
                                      ? () {
                                          if (prayerPlayerIsPaused) {
                                            globals.radioPlayer.pause();
                                            globals.radioPlayerIsPaused = true;
                                            playPauseAnimationcontroller
                                                .forward();
                                            prayerPlayer.play();
                                          } else {
                                            playPauseAnimationcontroller
                                                .reverse();
                                            prayerPlayer.pause();
                                          }
                                          setState(() {
                                            prayerPlayerIsPaused =
                                                !prayerPlayerIsPaused;
                                          });
                                        }
                                      : null,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: <Widget>[
                                    RawMaterialButton(
                                      elevation: 0,
                                      child: Icon(
                                        CupertinoIcons.gobackward_10,
                                        size: 32.0,
                                        color: prayerAudioIsLoaded
                                            ? Colors.black
                                            : Theme.of(context).disabledColor,
                                      ),
                                      padding: EdgeInsets.all(16.0),
                                      shape: CircleBorder(),
                                      onPressed: prayerAudioIsLoaded
                                          ? () {
                                              prayerPlayer.seekBy(
                                                  Duration(seconds: -10));
                                            }
                                          : null,
                                    ),
                                    RawMaterialButton(
                                      elevation: 0,
                                      child: Icon(
                                        prayerPlayerIsMuted
                                            ? CupertinoIcons.speaker_slash_fill
                                            : CupertinoIcons.speaker_1_fill,
                                        size: 32.0,
                                        color: prayerAudioIsLoaded
                                            ? Colors.black
                                            : Theme.of(context).disabledColor,
                                      ),
                                      padding: EdgeInsets.all(16.0),
                                      shape: CircleBorder(),
                                      onPressed: prayerAudioIsLoaded
                                          ? () {
                                              prayerPlayerIsMuted
                                                  ? prayerPlayer.setVolume(100)
                                                  : prayerPlayer.setVolume(0);
                                              setState(() {
                                                prayerPlayerIsMuted =
                                                    !prayerPlayerIsMuted;
                                              });
                                            }
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: <Widget>[
                                    RawMaterialButton(
                                      elevation: 0,
                                      child: Icon(
                                        CupertinoIcons.textformat_alt,
                                        size: 32.0,
                                        color: Colors.black,
                                      ),
                                      padding: EdgeInsets.all(16.0),
                                      shape: CircleBorder(),
                                      onPressed: () {
                                        setState(() {
                                          showTranslation = !showTranslation;
                                        });
                                      },
                                    ),
                                    RawMaterialButton(
                                      elevation: 0,
                                      child: Icon(
                                        CupertinoIcons.xmark,
                                        size: 32.0,
                                        color: Colors.black,
                                      ),
                                      padding: EdgeInsets.all(16.0),
                                      shape: CircleBorder(),
                                      onPressed: () {
                                        setState(() {
                                          showControls = false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : SizedBox()
            ],
          ),
          !showControls
              ? Positioned(
                  left: 10,
                  bottom: 10,
                  child: FloatingActionButton(
                    elevation: 2,
                    backgroundColor: RadioRamezanColors.ramady,
                    child: Icon(CupertinoIcons.control),
                    onPressed: () {
                      setState(() {
                        showControls = true;
                      });
                    },
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
