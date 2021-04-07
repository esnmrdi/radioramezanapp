// loading required packages
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:cron/cron.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart';
import 'package:radioramezan/data_models/city_model.dart';
import 'package:radioramezan/data_models/owghat_model.dart';
import 'package:radioramezan/data_models/radio_item_model.dart';
import 'package:radioramezan/data_models/prayer_model.dart';
import 'package:radioramezan/data_models/ad_model.dart';

class Globals {
  BuildContext ctx;
  int navigatorIndex, cityId, owghatMethod;
  PreloadPageController pageController;
  AnimationController playPauseAnimationController;
  Animation<double> playPauseAnimation;
  GlobalKey<ScaffoldState> mainScaffoldKey = GlobalKey<ScaffoldState>();
  List<City> cityList = [];
  List<Ad> adList = [];
  List<Owghat> owghatList = [];
  List<RadioItem> radioItemList = [];
  List<Prayer> prayerList = [];
  City city;
  Owghat owghat;
  tz.Location timeZone;
  String jalaliDate, gregorianDate, hijriDate, smtpUsername, smtpPassword;
  AssetsAudioPlayer radioPlayer, azanNotificationPlayer;
  bool radioPlayerIsPaused,
      radioPlayerIsMuted,
      radioStreamIsLoaded,
      dayIsUpdating,
      cityIsUpdating,
      owghatMethodIsUpdating;
  Metas metas;
  List<int> currentAndNextItem;
  Cron liveCron = Cron();
  Timer twoMinBeforeSobh,
      fiveMinBeforeSobh,
      tenMinBeforeSobh,
      twentyMinBeforeSobh,
      autoStartSobh,
      autoStartZohr,
      autoStartMaghreb,
      autoStopSobh,
      autoStopZohr,
      autoStopMaghreb;
  double webTopPaddingFAB, webAspectRatio, adAspectRatio;

  Future<Null> fetchCityList() async {
    final response = await get('https://m.radioramezan.com/api/cities.php');

    if (response.statusCode == 200) {
      cityList.clear();
      cityList = (json.decode(response.body) as List)
          .map((i) => City.fromJson(i))
          .toList();
    } else {
      throw Exception('Failed to fetch city list!');
    }
  }

  Future<Null> fetchOwghatList() async {
    final response = await get(
      'https://m.radioramezan.com/api/owghat.php?city=' +
          city.cityId.toString() +
          '&method=' +
          owghatMethod.toString(),
    );
    if (response.statusCode == 200) {
      owghatList.clear();
      owghatList = (json.decode(response.body) as List)
          .map((i) => Owghat.fromJson(i))
          .toList();
    } else {
      throw Exception('Failed to fetch the conductor!');
    }
  }

  Future<Null> fetchOwghat() async {
    final response = await get(
      'https://m.radioramezan.com/api/owghat.php?city=' +
          city.cityId.toString() +
          '&date=' +
          intl.DateFormat('yyyy-MM-dd').format(tz.TZDateTime.now(timeZone)) +
          '&method=' +
          owghatMethod.toString(),
    );

    if (response.statusCode == 200) {
      owghat = Owghat.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch owghat!');
    }
  }

  Future<Null> fetchRadioItemList() async {
    final response = await get(
        'https://m.radioramezan.com/api/radio-conductor.php?city=' +
            city.cityId.toString() +
            '&date=' +
            intl.DateFormat('yyyy-MM-dd').format(tz.TZDateTime.now(timeZone)));
    if (response.statusCode == 200) {
      radioItemList.clear();
      radioItemList = (json.decode(response.body) as List)
          .map((i) => RadioItem.fromJson(i))
          .toList();
    } else {
      throw Exception('Failed to fetch the radio item list!');
    }
  }

  Future<Null> fetchAdList() async {
    final response = await get('https://m.radioramezan.com/api/ads.php?city=' +
        city.cityId.toString());
    if (response.statusCode == 200) {
      adList.clear();
      adList = (json.decode(response.body) as List)
          .map((i) => Ad.fromJson(i))
          .toList();
    } else {
      throw Exception('Failed to fetch the ad list!');
    }
  }

  Future<Null> fetchHijriDate() async {
    final response = await get(
        'https://m.radioramezan.com/api/ghamari.php?city=' +
            city.cityId.toString() +
            '&date=' +
            intl.DateFormat('yyyy-MM-dd').format(tz.TZDateTime.now(timeZone)));
    if (response.statusCode == 200) {
      hijriDate = json.decode(response.body)[0]['ghamari'];
      hijriDate = json.encode({
        'year': hijriDate.split('-')[0],
        'month': hijriDate.split('-')[1],
        'day': hijriDate.split('-')[2]
      });
    } else {
      throw Exception('Failed to fetch the hijri date!');
    }
  }

  Future<Null> loadPrayerList() async {
    final response = await rootBundle.loadString('assets/texts/prayers.json');
    prayerList.clear();
    prayerList =
        (json.decode(response) as List).map((i) => Prayer.fromJson(i)).toList();
  }

  Future<Null> loadRadioStream() async {
    try {
      await radioPlayer.open(
        Audio.liveStream(city.url, metas: metas),
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
      radioStreamIsLoaded = true;
    } catch (error) {
      print(error);
    }
  }

  Future<Null> loadAzanNotificationAudio(String path) async {
    radioPlayer.setVolume(.25);
    Future.delayed(Duration(seconds: 8), () => radioPlayer.setVolume(1));
    try {
      await azanNotificationPlayer.open(
        Audio(path),
        autoStart: false,
        respectSilentMode: false,
        showNotification: false,
        playInBackground: PlayInBackground.enabled,
        headPhoneStrategy: HeadPhoneStrategy.none,
      );
    } catch (error) {
      print(error);
    }
    if (!radioPlayerIsPaused) azanNotificationPlayer.play();
  }

  Future<Null> launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  List<int> findCurrentAndNextItem() {
    int nowInMinutes = tz.TZDateTime.now(timeZone).hour * 60 +
        tz.TZDateTime.now(timeZone).minute;
    int currentStartInMinutes, nextStartInMinutes;
    for (var i = 0; i < radioItemList.length; i++) {
      currentStartInMinutes =
          int.parse(radioItemList[i].startHour.split(':')[0]) * 60 +
              int.parse(radioItemList[i].startHour.split(':')[1]);
      if (i < radioItemList.length - 1) {
        nextStartInMinutes =
            int.parse(radioItemList[i + 1].startHour.split(':')[0]) * 60 +
                int.parse(radioItemList[i + 1].startHour.split(':')[1]);
        if (nowInMinutes >= currentStartInMinutes &&
            nowInMinutes < nextStartInMinutes) {
          return [i, i + 1];
        }
      } else {
        if (nowInMinutes >= currentStartInMinutes) {
          return [i];
        }
      }
    }
    return null;
  }

  void setAzanNotificationTimers() {
    if (twoMinBeforeSobh != null) {
      twoMinBeforeSobh.cancel();
      fiveMinBeforeSobh.cancel();
      tenMinBeforeSobh.cancel();
      twentyMinBeforeSobh.cancel();
    }
    tz.TZDateTime sobh = tz.TZDateTime.parse(
        timeZone,
        intl.DateFormat('yyyy-MM-dd').format(tz.TZDateTime.now(timeZone)) +
            ' ' +
            owghat.sobh);
    sobh = sobh.add(DateTime.now().timeZoneOffset - sobh.timeZoneOffset);
    twoMinBeforeSobh = Timer(
      sobh.subtract(Duration(minutes: 2)).difference(
            tz.TZDateTime.now(timeZone),
          ),
      () => loadAzanNotificationAudio('assets/audios/azan_alert_2.mp3'),
    );
    fiveMinBeforeSobh = Timer(
      sobh.subtract(Duration(minutes: 5)).difference(
            tz.TZDateTime.now(timeZone),
          ),
      () => loadAzanNotificationAudio('assets/audios/azan_alert_5.mp3'),
    );
    tenMinBeforeSobh = Timer(
      sobh.subtract(Duration(minutes: 10)).difference(
            tz.TZDateTime.now(timeZone),
          ),
      () => loadAzanNotificationAudio('assets/audios/azan_alert_10.mp3'),
    );
    twentyMinBeforeSobh = Timer(
      sobh.subtract(Duration(minutes: 20)).difference(
            tz.TZDateTime.now(timeZone),
          ),
      () => loadAzanNotificationAudio('assets/audios/azan_alert_20.mp3'),
    );
  }

  void setAutoStartStopTimers() {
    if (autoStartSobh != null) {
      autoStartSobh.cancel();
      autoStopSobh.cancel();
    }
    if (autoStartZohr != null) {
      autoStartZohr.cancel();
      autoStopZohr.cancel();
    }
    if (autoStartMaghreb != null) {
      autoStartMaghreb.cancel();
      autoStopMaghreb.cancel();
    }
    if (Settings.getValue<bool>('autoStartStopEnabled', false)) {
      if (Settings.getValue<bool>('autoStartStopSobhEnabled', false)) {
        tz.TZDateTime sobh = tz.TZDateTime.parse(
            timeZone,
            intl.DateFormat('yyyy-MM-dd').format(tz.TZDateTime.now(timeZone)) +
                ' ' +
                owghat.sobh);
        sobh = sobh.add(DateTime.now().timeZoneOffset - sobh.timeZoneOffset);
        Duration nowToStartSobhDiff = sobh
            .subtract(Duration(
                minutes: Settings.getValue<double>('autoStartDuration', 30)
                    .truncate()))
            .difference(
              tz.TZDateTime.now(timeZone),
            );
        if (nowToStartSobhDiff > Duration.zero) {
          autoStartSobh = Timer(
            nowToStartSobhDiff,
            () {
              if (radioPlayerIsPaused) {
                radioPlayer.play();
                playPauseAnimationController.forward();
                radioPlayerIsPaused = false;
              }
            },
          );
        }
        Duration nowToStopSobhDiff = sobh
            .add(Duration(
                minutes: Settings.getValue<double>('autoStopDuration', 30)
                    .truncate()))
            .difference(
              tz.TZDateTime.now(timeZone),
            );
        if (nowToStopSobhDiff > Duration.zero) {
          autoStopSobh = Timer(
            nowToStopSobhDiff,
            () {
              if (!radioPlayerIsPaused) {
                radioPlayer.pause();
                playPauseAnimationController.reverse();
                radioPlayerIsPaused = true;
              }
            },
          );
        }
      }
      if (Settings.getValue<bool>('autoStartStopZohrEnabled', false)) {
        tz.TZDateTime zohr = tz.TZDateTime.parse(
            timeZone,
            intl.DateFormat('yyyy-MM-dd').format(tz.TZDateTime.now(timeZone)) +
                ' ' +
                owghat.zohr);
        zohr = zohr.add(DateTime.now().timeZoneOffset - zohr.timeZoneOffset);
        Duration nowToStartZohrDiff = zohr
            .subtract(Duration(
                minutes: Settings.getValue<double>('autoStartDuration', 30)
                    .truncate()))
            .difference(
              tz.TZDateTime.now(timeZone),
            );
        if (nowToStartZohrDiff > Duration.zero) {
          autoStartZohr = Timer(
            nowToStartZohrDiff,
            () {
              if (radioPlayerIsPaused) {
                radioPlayer.play();
                playPauseAnimationController.forward();
                radioPlayerIsPaused = false;
              }
            },
          );
        }
        Duration nowToStopZohrDiff = zohr
            .add(Duration(
                minutes: Settings.getValue<double>('autoStopDuration', 30)
                    .truncate()))
            .difference(
              tz.TZDateTime.now(timeZone),
            );
        if (nowToStopZohrDiff > Duration.zero) {
          autoStopZohr = Timer(
            nowToStopZohrDiff,
            () {
              if (!radioPlayerIsPaused) {
                radioPlayer.pause();
                playPauseAnimationController.reverse();
                radioPlayerIsPaused = true;
              }
            },
          );
        }
      }
      if (Settings.getValue<bool>('autoStartStopMaghrebEnabled', false)) {
        tz.TZDateTime maghreb = tz.TZDateTime.parse(
            timeZone,
            intl.DateFormat('yyyy-MM-dd').format(tz.TZDateTime.now(timeZone)) +
                ' ' +
                owghat.maghreb);
        maghreb =
            maghreb.add(DateTime.now().timeZoneOffset - maghreb.timeZoneOffset);
        Duration nowToStartMaghrebDiff = maghreb
            .subtract(Duration(
                minutes: Settings.getValue<double>('autoStartDuration', 30)
                    .truncate()))
            .difference(
              tz.TZDateTime.now(timeZone),
            );
        if (nowToStartMaghrebDiff > Duration.zero) {
          autoStartMaghreb = Timer(
            nowToStartMaghrebDiff,
            () {
              if (radioPlayerIsPaused) {
                radioPlayer.play();
                playPauseAnimationController.forward();
                radioPlayerIsPaused = false;
              }
            },
          );
        }
        Duration nowToStopMaghrebDiff = maghreb
            .add(Duration(
                minutes: Settings.getValue<double>('autoStopDuration', 30)
                    .truncate()))
            .difference(
              tz.TZDateTime.now(timeZone),
            );
        if (nowToStopMaghrebDiff > Duration.zero) {
          autoStopMaghreb = Timer(
            nowToStopMaghrebDiff,
            () {
              if (!radioPlayerIsPaused) {
                radioPlayer.pause();
                playPauseAnimationController.reverse();
                radioPlayerIsPaused = true;
              }
            },
          );
        }
      }
    }
  }

  Route createRoute(Widget newPage) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => newPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.decelerate;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 500),
    );
  }

  Future<Null> owghatMethodChangeUpdate() async {
    owghatMethod = Settings.getValue<int>('owghatMethod', 0);
    await Future.wait([
      fetchOwghat(),
      fetchOwghatList(),
    ]);
    setAzanNotificationTimers();
    setAutoStartStopTimers();
  }

  Future<Null> dailyUpdate() async {
    jalaliDate = json.encode({
      'year': Jalali.fromDateTime(tz.TZDateTime.now(timeZone)).formatter.yyyy,
      'month': Jalali.fromDateTime(tz.TZDateTime.now(timeZone)).formatter.mN,
      'day': Jalali.fromDateTime(tz.TZDateTime.now(timeZone)).formatter.d
    });
    gregorianDate = json.encode({
      'year':
          Gregorian.fromDateTime(tz.TZDateTime.now(timeZone)).formatter.yyyy,
      'month': Gregorian.fromDateTime(tz.TZDateTime.now(timeZone)).formatter.m,
      'day': Gregorian.fromDateTime(tz.TZDateTime.now(timeZone)).formatter.d
    });
    await Future.wait([
      fetchHijriDate(),
      owghatMethodChangeUpdate(),
    ]);
  }

  Future<Null> cityChangeUpdate() async {
    cityId = Settings.getValue<int>('cityId', 3);
    city = cityList.firstWhere((city) => city.cityId == cityId);
    timeZone = tz.getLocation(city.timeZone);
    if (!radioPlayerIsPaused) {
      playPauseAnimationController.reverse();
      radioPlayerIsPaused = true;
    }
    await Future.wait([
      dailyUpdate(),
      fetchAdList(),
      fetchRadioItemList(),
      loadRadioStream(),
    ]);
  }

  Future<Null> init() async {
    initializeTimeZones();
    navigatorIndex = 2;
    pageController = PreloadPageController(
      initialPage: navigatorIndex,
      keepPage: true,
    );
    smtpUsername = 'feedback@radioramezan.com';
    smtpPassword = 'Radioabbasehsan123@';
    radioPlayer = AssetsAudioPlayer.newPlayer();
    azanNotificationPlayer = AssetsAudioPlayer.newPlayer();
    radioStreamIsLoaded = false;
    radioPlayerIsMuted = false;
    radioPlayerIsPaused = true;
    dayIsUpdating = false;
    cityIsUpdating = false;
    owghatMethodIsUpdating = false;
    metas = Metas(
      title: 'رادیو رمضان',
      artist: null,
      album: null,
    );
    webTopPaddingFAB = 30;
    webAspectRatio = 16 / 9;
    adAspectRatio = 640 / 100;
    await fetchCityList();
    await Future.wait([
      cityChangeUpdate(),
      loadPrayerList(),
      // FlutterDownloader.initialize(),
    ]);
    currentAndNextItem = findCurrentAndNextItem();
    liveCron.schedule(Schedule.parse('*/1 * * * *'), () async {
      currentAndNextItem = findCurrentAndNextItem();
    });
  }
}

final globals = Globals();
