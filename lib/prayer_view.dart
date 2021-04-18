// loading required packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:universal_html/js.dart' as js;
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/data_models/prayer_model.dart';

class PrayerView extends StatefulWidget {
  final Prayer prayer;

  PrayerView({Key key, @required this.prayer}) : super(key: key);

  @override
  PrayerViewState createState() => PrayerViewState();
}

class PrayerViewState extends State<PrayerView> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> prayerViewScaffoldKey;
  ScrollController scrollController;
  AssetsAudioPlayer prayerPlayer;
  bool showControls, showTranslation, prayerPlayerIsMuted, prayerPlayerIsPaused, prayerAudioIsLoaded, sliderIsChanging;
  double sliderSelectiveValue, sliderProgressiveValue, fontSize;
  String path;
  Metas metas;
  int positionInSeconds, durationInSeconds, remainingInSeconds;
  Animation<double> playPauseAnimation;
  AnimationController playPauseAnimationController;

  Future<Null> loadPrayer() async {
    if (kIsWeb) {
      js.context.callMethod('loadPrayer', [globals.fixPath(path)]);
      prayerAudioIsLoaded = true;
    } else {
      try {
        await prayerPlayer.open(
          kIsWeb ? Audio.network(path, metas: metas) : Audio(path, metas: metas),
          autoStart: false,
          respectSilentMode: false,
          showNotification: false,
          // notificationSettings: NotificationSettings(
          //   playPauseEnabled: true,
          //   seekBarEnabled: true,
          // ),
          playInBackground: PlayInBackground.enabled,
          headPhoneStrategy: HeadPhoneStrategy.none,
        );
        setState(() {
          durationInSeconds = prayerPlayer.current.valueWrapper.value.audio.duration.inSeconds;
          prayerAudioIsLoaded = true;
        });
      } catch (error) {
        print(error);
      }
    }
  }

  void playPrayer() {
    js.context.callMethod('playPrayer');
  }

  void pausePrayer() {
    js.context.callMethod('pausePrayer');
  }

  void stopPrayer() {
    js.context.callMethod('stopPrayer');
  }

  void setPrayerVolume(double vol) {
    js.context.callMethod('setPrayerVolume', [vol]);
  }

  void seekPrayer(int duration) {
    js.context.callMethod('seekPrayer', [duration]);
  }

  double prayerPos() {
    return js.context.callMethod('prayerPos');
  }

  double prayerDuration() {
    return js.context.callMethod('prayerDuration');
  }

  @override
  void initState() {
    prayerViewScaffoldKey = GlobalKey<ScaffoldState>();
    scrollController = ScrollController();
    if (!kIsWeb) prayerPlayer = AssetsAudioPlayer.newPlayer();
    fontSize = 22;
    showControls = false;
    showTranslation = true;
    prayerAudioIsLoaded = false;
    prayerPlayerIsMuted = false;
    prayerPlayerIsPaused = true;
    sliderIsChanging = false;
    sliderSelectiveValue = 0;
    sliderProgressiveValue = 0;
    path = 'audios/' + (widget.prayer.audio.isNotEmpty ? widget.prayer.audio : 'azan_alert_2.mp3');
    metas = Metas(
      title: widget.prayer.title,
      artist: widget.prayer.reciter,
      album: 'رادیو رمضان',
    );
    loadPrayer();
    playPauseAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    playPauseAnimation = CurvedAnimation(
      curve: Curves.linear,
      parent: playPauseAnimationController,
    );
    super.initState();
  }

  void dispose() {
    playPauseAnimationController.dispose();
    scrollController.dispose();
    prayerPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: kIsWeb && MediaQuery.of(context).size.width > MediaQuery.of(context).size.height / globals.webAspectRatio
          ? EdgeInsets.symmetric(
              horizontal:
                  (MediaQuery.of(context).size.width - MediaQuery.of(context).size.height / globals.webAspectRatio) / 2)
          : null,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: ClipRRect(
        child: Scaffold(
          key: prayerViewScaffoldKey,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: !showControls
              ? FloatingActionButton(
                  elevation: 2,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(Icons.tune),
                  onPressed: () {
                    setState(() {
                      showControls = true;
                    });
                  },
                )
              : null,
          body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('images/golden_mosque_20percent.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    WaveWidget(
                      config: CustomConfig(
                        colors: [Colors.white70, Colors.white54, Colors.white30, Colors.white],
                        durations: [32000, 16000, 8000, 4000],
                        heightPercentages: [.65, .68, .75, .8],
                      ),
                      waveAmplitude: 0,
                      backgroundColor: Theme.of(context).primaryColor,
                      size: Size(
                        MediaQuery.of(context).size.width,
                        100,
                      ),
                    ),
                    Container(
                      height: 100,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.prayer.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          FloatingActionButton(
                            elevation: 2,
                            backgroundColor: Colors.white,
                            child: Icon(
                              CupertinoIcons.xmark,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              if (kIsWeb) stopPrayer();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: DraggableScrollbar.semicircle(
                    controller: scrollController,
                    child: ListView.builder(
                      controller: scrollController,
                      padding: EdgeInsets.all(20),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Column(
                          children: widget.prayer.verses.map(
                            (verse) {
                              return Container(
                                child: Column(
                                  children: [
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
                                                  color: Theme.of(context).primaryColor,
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
                        );
                      },
                    ),
                  ),
                ),
                showControls
                    ? Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            kIsWeb
                                ? SizedBox()
                                : PlayerBuilder.currentPosition(
                                    player: prayerPlayer,
                                    builder: (context, position) {
                                      positionInSeconds = position.inSeconds;
                                      remainingInSeconds = durationInSeconds - positionInSeconds;
                                      sliderProgressiveValue = (positionInSeconds / durationInSeconds) * 100;
                                      return Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                (prayerAudioIsLoaded && widget.prayer.audio.isNotEmpty)
                                                    ? (remainingInSeconds / 60).truncate().toString().padLeft(2, '0') +
                                                        ':' +
                                                        (remainingInSeconds % 60).toString().padLeft(2, '0')
                                                    : '00:00',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: (prayerAudioIsLoaded && widget.prayer.audio.isNotEmpty)
                                                      ? Theme.of(context).primaryColor
                                                      : Theme.of(context).disabledColor,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 14,
                                              child: Directionality(
                                                textDirection: TextDirection.ltr,
                                                child: Slider(
                                                  activeColor: Theme.of(context).primaryColor,
                                                  inactiveColor: Theme.of(context).disabledColor,
                                                  min: 0,
                                                  max: 100,
                                                  value:
                                                      sliderIsChanging ? sliderSelectiveValue : sliderProgressiveValue,
                                                  onChanged: (prayerAudioIsLoaded && widget.prayer.audio.isNotEmpty)
                                                      ? (newSliderValue) {
                                                          sliderIsChanging = true;
                                                          setState(() {
                                                            sliderSelectiveValue = newSliderValue;
                                                          });
                                                        }
                                                      : null,
                                                  onChangeEnd: (prayerAudioIsLoaded && widget.prayer.audio.isNotEmpty)
                                                      ? (newSliderValue) {
                                                          sliderIsChanging = false;
                                                          prayerPlayer.seek(Duration(
                                                              seconds: ((newSliderValue / 100) * durationInSeconds)
                                                                  .truncate()));
                                                        }
                                                      : null,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                (prayerAudioIsLoaded && widget.prayer.audio.isNotEmpty)
                                                    ? (positionInSeconds / 60).truncate().toString().padLeft(2, '0') +
                                                        ':' +
                                                        (positionInSeconds % 60).toString().padLeft(2, '0')
                                                    : '00:00',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: (prayerAudioIsLoaded && widget.prayer.audio.isNotEmpty)
                                                      ? Theme.of(context).primaryColor
                                                      : Theme.of(context).disabledColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      RawMaterialButton(
                                        elevation: 0,
                                        child: Icon(
                                          CupertinoIcons.zoom_in,
                                          size: 32.0,
                                          color: fontSize < 28 ? Colors.black : Theme.of(context).disabledColor,
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
                                          color: fontSize > 22 ? Colors.black : Theme.of(context).disabledColor,
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
                                    children: [
                                      RawMaterialButton(
                                        elevation: 0,
                                        child: Icon(
                                          CupertinoIcons.goforward_10,
                                          size: 32.0,
                                          color: (prayerAudioIsLoaded && widget.prayer.audio.isNotEmpty)
                                              ? Colors.black
                                              : Theme.of(context).disabledColor,
                                        ),
                                        padding: EdgeInsets.all(16.0),
                                        shape: CircleBorder(),
                                        onPressed: (prayerAudioIsLoaded && widget.prayer.audio.isNotEmpty)
                                            ? () {
                                                kIsWeb ? seekPrayer(10) : prayerPlayer.seekBy(Duration(seconds: 10));
                                              }
                                            : null,
                                      ),
                                      RawMaterialButton(
                                        elevation: 0,
                                        child: Icon(
                                          CupertinoIcons.arrow_down_to_line_alt,
                                          size: 32.0,
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
                                    elevation: (prayerAudioIsLoaded && widget.prayer.audio.isNotEmpty) ? 2 : 0,
                                    fillColor: (prayerAudioIsLoaded && widget.prayer.audio.isNotEmpty)
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).disabledColor,
                                    child: prayerAudioIsLoaded
                                        ? AnimatedIcon(
                                            icon: AnimatedIcons.play_pause,
                                            size: 64,
                                            color: Colors.white,
                                            progress: playPauseAnimation,
                                          )
                                        : widget.prayer.audio.isNotEmpty
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
                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                                ),
                                              ),
                                    padding: EdgeInsets.all(18.0),
                                    shape: CircleBorder(),
                                    onPressed: (prayerAudioIsLoaded && widget.prayer.audio.isNotEmpty)
                                        ? () {
                                            if (prayerPlayerIsPaused) {
                                              if (!globals.radioPlayerIsPaused) {
                                                kIsWeb ? globals.stopRadio() : globals.radioPlayer.stop();
                                                globals.radioPlayerIsPaused = true;
                                                globals.playPauseAnimationController.reverse();
                                              }
                                              playPauseAnimationController.forward();
                                              kIsWeb ? playPrayer() : prayerPlayer.play();
                                            } else {
                                              playPauseAnimationController.reverse();
                                              kIsWeb ? pausePrayer() : prayerPlayer.pause();
                                            }
                                            setState(() {
                                              prayerPlayerIsPaused = !prayerPlayerIsPaused;
                                            });
                                          }
                                        : null,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      RawMaterialButton(
                                        elevation: 0,
                                        child: Icon(
                                          CupertinoIcons.gobackward_10,
                                          size: 32.0,
                                          color: (prayerAudioIsLoaded && widget.prayer.audio.isNotEmpty)
                                              ? Colors.black
                                              : Theme.of(context).disabledColor,
                                        ),
                                        padding: EdgeInsets.all(16.0),
                                        shape: CircleBorder(),
                                        onPressed: (prayerAudioIsLoaded && widget.prayer.audio.isNotEmpty)
                                            ? () {
                                                kIsWeb ? seekPrayer(-10) : prayerPlayer.seekBy(Duration(seconds: -10));
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
                                          color: (prayerAudioIsLoaded && widget.prayer.audio.isNotEmpty)
                                              ? Colors.black
                                              : Theme.of(context).disabledColor,
                                        ),
                                        padding: EdgeInsets.all(16.0),
                                        shape: CircleBorder(),
                                        onPressed: (prayerAudioIsLoaded && widget.prayer.audio.isNotEmpty)
                                            ? () {
                                                prayerPlayerIsMuted
                                                    ? kIsWeb
                                                        ? setPrayerVolume(1)
                                                        : prayerPlayer.setVolume(1)
                                                    : kIsWeb
                                                        ? setPrayerVolume(0)
                                                        : prayerPlayer.setVolume(0);
                                                setState(() {
                                                  prayerPlayerIsMuted = !prayerPlayerIsMuted;
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
                                    children: [
                                      RawMaterialButton(
                                        elevation: 0,
                                        child: Icon(
                                          Icons.translate,
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
                                          CupertinoIcons.chevron_down,
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
          ),
        ),
      ),
    );
  }
}
