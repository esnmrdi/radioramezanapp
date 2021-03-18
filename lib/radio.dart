// loading required packages
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:share/share.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cron/cron.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/theme.dart';

class RadioPlayer extends StatefulWidget {
  @override
  _RadioPlayer createState() => _RadioPlayer();
}

class _RadioPlayer extends State<RadioPlayer> with TickerProviderStateMixin {
  Cron liveRadioCron = Cron();
  TextEditingController recipientController, bodyController;
  String commentText;
  Metas metas;
  bool radioItemIsLiked;
  Animation<double> playPauseAnimation;
  AnimationController playPauseAnimationcontroller;

  Future<void> displayCommentDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'نظردهی در مورد آیتم',
              style: TextStyle(color: RadioRamezanColors.ramady),
            ),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: recipientController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ایمیل یا شماره تلفن',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: bodyController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'نظرات شما',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              RawMaterialButton(
                child: Text(
                  'ارسال',
                  style: TextStyle(
                    color: RadioRamezanColors.ramady,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              RawMaterialButton(
                child: Text(
                  'انصراف',
                  style: TextStyle(
                    color: RadioRamezanColors.ramady,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    liveRadioCron.schedule(Schedule.parse('*/1 * * * *'), () async {
      setState(() {});
    });
    radioItemIsLiked = false;
    recipientController = TextEditingController();
    bodyController = TextEditingController();
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

  @override
  void dispose() {
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Image.asset('assets/images/praying_hands.jpg'),
              Container(
                padding: EdgeInsets.all(10),
                height: 50,
                width: MediaQuery.of(context).size.width,
                color: Colors.black54,
                child: CarouselSlider.builder(
                  itemCount: globals.currentAndNextItem.length,
                  options: CarouselOptions(
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: true,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 10),
                    autoPlayAnimationDuration: Duration(seconds: 1),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollDirection: Axis.horizontal,
                  ),
                  itemBuilder: (BuildContext context, int index, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5),
                          width: 90,
                          decoration: BoxDecoration(
                            color: index == 0
                                ? Colors.red.withOpacity(.5)
                                : Colors.lightGreen.withOpacity(.5),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              index == 0 ? 'پخش زنده' : 'برنامه بعد',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              globals.currentAndNextItem[index].description !=
                                      ''
                                  ? globals.currentAndNextItem[index].title +
                                      ' (' +
                                      globals.currentAndNextItem[index]
                                          .description +
                                      ')'
                                  : globals.currentAndNextItem[index].title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          Container(
            color: RadioRamezanColors.ramady,
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RawMaterialButton(
                  elevation: 0,
                  child: Icon(
                    radioItemIsLiked ? CupertinoIcons.suit_heart_fill : CupertinoIcons.suit_heart,
                    size: 32.0,
                    color: radioItemIsLiked ? Colors.red : Colors.white,
                  ),
                  padding: EdgeInsets.all(16.0),
                  shape: CircleBorder(),
                  onPressed: () {
                    setState(() {
                      radioItemIsLiked = !radioItemIsLiked;
                    });
                  },
                ),
                RawMaterialButton(
                  elevation: 0,
                  child: Icon(
                    CupertinoIcons.arrow_down_to_line_alt,
                    size: 32.0,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(16.0),
                  shape: CircleBorder(),
                  onPressed: () {
                    // FlutterDownloader.enqueue(
                    //   url:
                    //       'https:\/\/m.radioramezan.com\/api\/readfile.php?media_address=media\/22-music\/1613288065-Alireza_Ghorbani.mp3',
                    //   savedDir: '/sdcard/download/',
                    //   showNotification: true,
                    //   openFileFromNotification: true,
                    // );
                  },
                ),
                RawMaterialButton(
                  elevation: 0,
                  child: Icon(
                    CupertinoIcons.square_arrow_up,
                    size: 32.0,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(16.0),
                  shape: CircleBorder(),
                  onPressed: () {
                    Share.share(
                      'https:\/\/m.radioramezan.com\/api\/readfile.php?media_address=media\/22-music\/1613288065-Alireza_Ghorbani.mp3',
                      subject: 'یک آیتم صوتی جذاب از رادیو رمضان!',
                    );
                  },
                ),
                RawMaterialButton(
                  elevation: 0,
                  child: Icon(
                    CupertinoIcons.chat_bubble,
                    size: 32.0,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(16.0),
                  shape: CircleBorder(),
                  onPressed: () {
                    displayCommentDialog(context);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: RawMaterialButton(
                          elevation: 0,
                          child: Icon(
                            Icons.cast,
                            size: 32.0,
                            color: Theme.of(context).disabledColor,
                          ),
                          padding: EdgeInsets.all(16.0),
                          shape: CircleBorder(),
                          onPressed: null,
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: RawMaterialButton(
                          elevation: globals.radioStreamIsLoaded ? 2 : 0,
                          fillColor: globals.radioStreamIsLoaded
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).disabledColor,
                          child: globals.radioStreamIsLoaded
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
                          onPressed: globals.radioStreamIsLoaded
                              ? () {
                                  if (globals.radioPlayerIsPaused) {
                                    playPauseAnimationcontroller.forward();
                                    globals.radioPlayer.play();
                                  } else {
                                    playPauseAnimationcontroller.reverse();
                                    globals.radioPlayer.pause();
                                  }
                                  setState(() {
                                    globals.radioPlayerIsPaused =
                                        !globals.radioPlayerIsPaused;
                                  });
                                }
                              : null,
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: RawMaterialButton(
                          elevation: 0,
                          child: Icon(
                            globals.radioPlayerIsMuted
                                ? CupertinoIcons.speaker_slash_fill
                                : CupertinoIcons.speaker_1_fill,
                            size: 32.0,
                            color: globals.radioStreamIsLoaded
                                ? Colors.black
                                : Theme.of(context).disabledColor,
                          ),
                          padding: EdgeInsets.all(16.0),
                          shape: CircleBorder(),
                          onPressed: globals.radioStreamIsLoaded
                              ? () {
                                  globals.radioPlayerIsMuted
                                      ? globals.radioPlayer.setVolume(100)
                                      : globals.radioPlayer.setVolume(0);
                                  setState(() {
                                    globals.radioPlayerIsMuted =
                                        !globals.radioPlayerIsMuted;
                                  });
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
