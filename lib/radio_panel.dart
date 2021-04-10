// loading required packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:share/share.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cron/cron.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/theme.dart';
import 'package:radioramezan/data_models/radio_item_model.dart';

class RadioPanel extends StatefulWidget {
  @override
  RadioPanelState createState() => RadioPanelState();
}

class RadioPanelState extends State<RadioPanel>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> radioPanelScaffoldKey;
  GlobalKey<FormState> commentFormKey;
  Cron liveRadioCron = Cron();
  TextEditingController senderController, emailController, commentController;
  bool commentIsSending;
  String commentText;
  Metas metas;
  bool radioItemIsLiked;

  Future<Null> sendMail() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'امکان ارسال ایمیل در نسخه وب وجود ندارد.',
            style: TextStyle(fontFamily: 'Sans'),
          ),
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            textColor: RadioRamezanColors.goldy,
            label: 'ای بابا!',
            onPressed: () {},
          ),
        ),
      );
      return null;
    }
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (commentFormKey.currentState.validate()) {
      setState(() {
        commentIsSending = true;
      });
      final smtpServer = SmtpServer(
        'smtp.ionos.com',
        port: 465,
        ssl: true,
        username: globals.smtpUsername,
        password: globals.smtpPassword,
      );
      final message = Message()
        ..from = Address(emailController.text)
        ..recipients.add('esn.mrd@gmail.com')
        ..ccRecipients.add('abbas.soltanian@gmail.com')
        ..subject = 'نظر کاربران در مورد آیتم ها'
        ..text = senderController.text +
            '\n' +
            globals.radioItemList[globals.currentAndNextItem[0]].mediaId
                .toString() +
            '\n' +
            globals.radioItemList[globals.currentAndNextItem[0]].title +
            '\n' +
            commentController.text;

      try {
        await send(message, smtpServer);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'نظر شما با موفقیت ثبت شد.',
              style: TextStyle(fontFamily: 'Sans'),
            ),
            duration: Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              textColor: RadioRamezanColors.goldy,
              label: 'مرسی!',
              onPressed: () {},
            ),
          ),
        );
        setState(() {
          commentIsSending = false;
        });
        commentFormKey.currentState.reset();
        senderController.text = '';
        emailController.text = '';
        commentController.text = '';
        Navigator.pop(context);
      } on MailerException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'مشکلی در ثبت نظر ایجاد شد.',
              style: TextStyle(fontFamily: 'Sans'),
            ),
            duration: Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              textColor: RadioRamezanColors.goldy,
              label: 'ای بابا!',
              onPressed: () {},
            ),
          ),
        );
        setState(() {
          commentIsSending = false;
        });
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
    }
  }

  Future<void> displayCommentDialog(
      BuildContext context, RadioItem radioItem) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: .75 *
                MediaQuery.of(context).size.height /
                globals.webAspectRatio,
            child: SingleChildScrollView(
              child: Form(
                key: commentFormKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: senderController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'نام کامل',
                        errorStyle: TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) return 'فیلد نام خالی است!';
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'ایمیل',
                        errorStyle: TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),
                      textDirection: TextDirection.ltr,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) return 'فیلد ایمیل خالی است!';
                        Pattern pattern =
                            '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}';
                        RegExp regex = RegExp(pattern);
                        if (!regex.hasMatch(value))
                          return 'ایمیل را در قالب صحیح وارد کنید!';
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: commentController,
                      maxLines: 8,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        labelText: 'نظر شما در مورد این آیتم',
                        errorStyle: TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.isEmpty) return 'متن نظر خالی است!';
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: RawMaterialButton(
                        elevation: commentIsSending ? 0 : 2,
                        fillColor: commentIsSending
                            ? Theme.of(context).disabledColor
                            : Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onPressed: !commentIsSending
                            ? () {
                                sendMail();
                              }
                            : null,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 10,
                          ),
                          child: !commentIsSending
                              ? Text(
                                  'ثبت نظر',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              : Container(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Null> download(String url) async {
    await Permission.storage.request();
    if (!await Permission.storage.status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'دسترسی به حافظه وجود ندارد.',
            style: TextStyle(fontFamily: 'Sans'),
          ),
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            textColor: RadioRamezanColors.goldy,
            label: 'اجازه بده!',
            onPressed: () async {
              await download(url);
            },
          ),
        ),
      );
    } else {
      FlutterDownloader.enqueue(
        url: url,
        savedDir: '/sdcard/download/',
        showNotification: true,
        openFileFromNotification: true,
        requiresStorageNotLow: true,
      );
    }
  }

  @override
  void initState() {
    liveRadioCron.schedule(Schedule.parse('*/1 * * * *'), () async {
      setState(() {});
    });
    radioPanelScaffoldKey = GlobalKey<ScaffoldState>();
    globals.playPauseAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    globals.playPauseAnimation = CurvedAnimation(
      curve: Curves.linear,
      parent: globals.playPauseAnimationController,
    );
    if (!globals.radioPlayerIsPaused)
      globals.playPauseAnimationController.forward();
    commentFormKey = GlobalKey<FormState>();
    senderController = TextEditingController();
    emailController = TextEditingController();
    commentController = TextEditingController();
    commentIsSending = false;
    radioItemIsLiked =
        globals.radioItemList[globals.currentAndNextItem[0]].isLiked;
    super.initState();
  }

  @override
  void dispose() {
    senderController.dispose();
    emailController.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Settings.getValue<bool>("darkThemeEnabled", false)
          ? Color.fromRGBO(50, 50, 50, 1)
          : RadioRamezanColors.ramady,
      margin:
          kIsWeb && MediaQuery.of(context).orientation == Orientation.landscape
              ? EdgeInsets.symmetric(
                  horizontal: (MediaQuery.of(context).size.width -
                          MediaQuery.of(context).size.height /
                              globals.webAspectRatio) /
                      2)
              : null,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: ClipRRect(
        child: Scaffold(
          key: radioPanelScaffoldKey,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: kIsWeb
                    ? globals.webTopPaddingFAB
                    : MediaQuery.of(context).padding.top,
              ),
              child: FloatingActionButton(
                elevation: 2,
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(CupertinoIcons.chevron_down),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/golden_mosque_20percent.png'),
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
                    Image.asset('images/poster_' +
                        globals.radioItemList[globals.currentAndNextItem[0]]
                            .category +
                        '.jpg'),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black54,
                      child: CarouselSlider.builder(
                        itemCount: globals.currentAndNextItem.length,
                        options: CarouselOptions(
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 10),
                          autoPlayAnimationDuration: Duration(seconds: 1),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          scrollDirection: Axis.vertical,
                        ),
                        itemBuilder: (BuildContext context, int index, _) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: Text(
                                    globals
                                                .radioItemList[globals
                                                    .currentAndNextItem[index]]
                                                .description !=
                                            ''
                                        ? globals
                                                .radioItemList[globals
                                                    .currentAndNextItem[index]]
                                                .title +
                                            ' (' +
                                            globals
                                                .radioItemList[globals
                                                    .currentAndNextItem[index]]
                                                .description +
                                            ')'
                                        : globals
                                            .radioItemList[globals
                                                .currentAndNextItem[index]]
                                            .title,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                width: 90,
                                decoration: BoxDecoration(
                                  color: index == 0
                                      ? Colors.red
                                      : Colors.lightGreen,
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
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Theme.of(context).primaryColor,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RawMaterialButton(
                        elevation: 0,
                        child: Icon(
                          radioItemIsLiked
                              ? CupertinoIcons.suit_heart_fill
                              : CupertinoIcons.suit_heart,
                          size: 32.0,
                          color: radioItemIsLiked ? Colors.red : Colors.white,
                        ),
                        padding: EdgeInsets.all(16.0),
                        shape: CircleBorder(),
                        onPressed: () {
                          setState(() {
                            radioItemIsLiked = !radioItemIsLiked;
                            globals.radioItemList[globals.currentAndNextItem[0]]
                                .isLiked = radioItemIsLiked;
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
                          download(
                            globals.radioItemList[globals.currentAndNextItem[0]]
                                .address,
                          );
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
                          displayCommentDialog(
                            context,
                            globals
                                .radioItemList[globals.currentAndNextItem[0]],
                          );
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
                                        progress: globals.playPauseAnimation,
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
                                onPressed: globals.radioStreamIsLoaded
                                    ? () {
                                        if (globals.radioPlayerIsPaused) {
                                          globals.playPauseAnimationController
                                              .forward();
                                          globals.radioPlayer.play();
                                        } else {
                                          globals.playPauseAnimationController
                                              .reverse();
                                          globals.radioPlayer.pause();
                                        }
                                        globals.radioPlayerIsPaused =
                                            !globals.radioPlayerIsPaused;
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
          ),
        ),
      ),
    );
  }
}
