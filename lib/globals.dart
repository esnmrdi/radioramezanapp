// loading required packages
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:universal_html/js.dart' as js;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cron/cron.dart';
import 'package:workmanager/workmanager.dart';
import 'package:radioramezan/data_models/city_model.dart';
import 'package:radioramezan/data_models/owghat_model.dart';
import 'package:radioramezan/data_models/radio_item_model.dart';
import 'package:radioramezan/data_models/prayer_model.dart';
import 'package:radioramezan/data_models/ad_model.dart';

class Globals {
  int navigatorIndex, cityId, owghatMethod;
  PreloadPageController pageController;
  AnimationController playPauseAnimationController;
  Animation<double> playPauseAnimation;
  GlobalKey<ScaffoldState> mainScaffoldKey = GlobalKey<ScaffoldState>();
  List<City> cityList = [];
  List<Ad> adList = [];
  List<Owghat> owghatList = [];
  List<RadioItem> radioItemList = [];
  List<RadioItem> radioItemListToday = [];
  List<RadioItem> radioItemListYesterday = [];
  List<RadioItem> currentAndNextItem;
  City city;
  Owghat owghat;
  String jalaliDate, gregorianDate, hijriDate, smtpUsername, smtpPassword;
  AssetsAudioPlayer radioPlayer, azanNotificationPlayer;
  bool radioPlayerIsPaused,
      radioPlayerIsMuted,
      radioStreamIsLoaded,
      dayIsUpdating,
      cityIsUpdating,
      owghatMethodIsUpdating;
  Metas metas;
  Cron liveCron = Cron();
  double webAspectRatio, adAspectRatio;
  Map<String, List<Prayer>> sources;
  Timer twoMinBeforeSobh, fiveMinBeforeSobh, tenMinBeforeSobh, twentyMinBeforeSobh;
  Workmanager workmanager;
  Map<String, int> azanSobhNotificationTasks;

  Future<Null> fetchCityList() async {
    final response = await get(Uri.parse('https://m.radioramezan.com/api/cities.php'));

    if (response.statusCode == 200) {
      cityList.clear();
      cityList = (json.decode(response.body) as List).map((i) => City.fromJson(i)).toList();
    } else {
      throw Exception('Failed to fetch city list!');
    }
  }

  Future<Null> fetchOwghatList() async {
    final response = await get(
      Uri.parse(
        'https://m.radioramezan.com/api/owghat.php?city=' +
            city.cityId.toString() +
            '&method=' +
            owghatMethod.toString(),
      ),
    );
    if (response.statusCode == 200) {
      owghatList.clear();
      owghatList = (json.decode(response.body) as List).map((i) => Owghat.fromJson(i)).toList();
    } else {
      throw Exception('Failed to fetch owghat list!');
    }
  }

  Future<Null> fetchOwghat() async {
    final response = await get(
      Uri.parse(
        'https://m.radioramezan.com/api/owghat.php?city=' +
            city.cityId.toString() +
            '&date=' +
            intl.DateFormat('yyyy-MM-dd').format(DateTime.now()) +
            '&method=' +
            owghatMethod.toString(),
      ),
    );

    if (response.statusCode == 200) {
      owghat = Owghat.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch owghat!');
    }
  }

  Future<List<RadioItem>> fetchRadioItemList(DateTime date) async {
    final response = await get(
      Uri.parse(
        'https://m.radioramezan.com/api/radio-conductor.php?city=' +
            city.cityId.toString() +
            '&date=' +
            intl.DateFormat('yyyy-MM-dd').format(date),
      ),
    );
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List).map((i) => RadioItem.fromJson(i)).toList();
    } else {
      throw Exception('Failed to fetch radio item list!');
    }
  }

  Future<Null> fetchRadioItemLists() async {
    radioItemList = radioItemListToday = await fetchRadioItemList(DateTime.now());
    radioItemListYesterday = await fetchRadioItemList(DateTime.now().subtract(Duration(days: 1)));
  }

  Future<Null> fetchAdList() async {
    final response = await get(
      Uri.parse(
        'https://m.radioramezan.com/api/ads.php?city=' + city.cityId.toString(),
      ),
    );
    if (response.statusCode == 200) {
      adList.clear();
      adList = (json.decode(response.body) as List).map((i) => Ad.fromJson(i)).toList();
    } else {
      throw Exception('Failed to fetch the ad list!');
    }
  }

  Future<Null> fetchHijriDate() async {
    final response = await get(
      Uri.parse(
        'https://m.radioramezan.com/api/ghamari.php?city=' +
            city.cityId.toString() +
            '&date=' +
            intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
      ),
    );
    if (response.statusCode == 200) {
      hijriDate = json.decode(response.body)[0]['ghamari'];
      hijriDate = json
          .encode({'year': hijriDate.split('-')[0], 'month': hijriDate.split('-')[1], 'day': hijriDate.split('-')[2]});
    } else {
      throw Exception('Failed to fetch the hijri date!');
    }
  }

  Future<Null> loadSources() async {
    final response = await rootBundle.loadString('texts/prayers.json');
    Map<String, dynamic> sourcesInitial = json.decode(response);
    sourcesInitial.forEach((key, value) {
      sources.putIfAbsent(key, () => (value as List<dynamic>).map((item) => Prayer.fromJson(item)).toList());
    });
  }

  Future<Null> loadRadio() async {
    if (kIsWeb) {
      js.context.callMethod('loadRadio', [city.url]);
      radioStreamIsLoaded = true;
    } else {
      try {
        await radioPlayer.open(
          Audio.liveStream(city.url, metas: metas),
          autoStart: false,
          respectSilentMode: false,
          showNotification: true,
          notificationSettings: NotificationSettings(
            playPauseEnabled: false,
            nextEnabled: false,
            prevEnabled: false,
            stopEnabled: false,
            seekBarEnabled: false,
          ),
          playInBackground: PlayInBackground.enabled,
          headPhoneStrategy: HeadPhoneStrategy.none,
        );
        radioStreamIsLoaded = true;
      } catch (error) {
        print(error);
      }
    }
  }

  void playRadio() {
    js.context.callMethod('playRadio');
  }

  void stopRadio() {
    js.context.callMethod('stopRadio');
  }

  void setRadioVolume(double vol) {
    js.context.callMethod('setRadioVolume', [vol]);
  }

  void playAzanNotification() {
    js.context.callMethod('playAzanNotification');
  }

  Future<Null> loadAzanNotificationAudio(String path) async {
    kIsWeb ? setRadioVolume(.25) : radioPlayer.setVolume(.25);
    Future.delayed(Duration(seconds: 8), () => kIsWeb ? setRadioVolume(1) : radioPlayer.setVolume(1));
    if (kIsWeb) {
      js.context.callMethod('loadAzanNotification', [path]);
    } else {
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
    }
    if (!radioPlayerIsPaused) kIsWeb ? playAzanNotification() : azanNotificationPlayer.play();
  }

  Future<Null> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  String fixPath(String url) {
    return kIsWeb ? 'https://m.radioramezan.com/assets/' + url : url;
  }

  List<RadioItem> findCurrentAndNextItem() {
    int nowInMinutes = DateTime.now().hour * 60 + DateTime.now().minute;
    int currentStartInMinutes, nextStartInMinutes;
    for (var i = 0; i < radioItemListToday.length; i++) {
      currentStartInMinutes = int.parse(radioItemListToday[i].startHour.split(':')[0]) * 60 +
          int.parse(radioItemListToday[i].startHour.split(':')[1]);
      if (nowInMinutes >= currentStartInMinutes) {
        if (i < radioItemListToday.length - 1) {
          nextStartInMinutes = int.parse(radioItemListToday[i + 1].startHour.split(':')[0]) * 60 +
              int.parse(radioItemListToday[i + 1].startHour.split(':')[1]);
          if (nowInMinutes >= currentStartInMinutes && nowInMinutes < nextStartInMinutes) {
            return [radioItemListToday[i], radioItemListToday[i + 1]];
          }
        } else {
          return [radioItemListToday[i]];
        }
      }
    }
    return [radioItemListYesterday.last, radioItemListToday.first];
  }

  void callbackDispatcher() {
    workmanager.executeTask((task, inputData) async {
      loadAzanNotificationAudio(fixPath('audios/azan_alert_' + task + '.mp3'));
      return Future.value(true);
    });
  }

  void setAzanSobhNotificationTasks() async {
    await workmanager.cancelAll();
    workmanager.initialize(
      callbackDispatcher,
    );
    DateTime sobh = DateTime.parse(intl.DateFormat('yyyy-MM-dd').format(DateTime.now()) + ' ' + owghat.sobh);
    azanSobhNotificationTasks.keys.forEach((element) {
      Duration nowToEventDiff =
          sobh.subtract(Duration(minutes: azanSobhNotificationTasks[element])).difference(DateTime.now());
      if (nowToEventDiff > Duration.zero) {
        workmanager.registerOneOffTask(
          element,
          element,
          initialDelay: nowToEventDiff,
        );
      }
    });
  }

  void setAzanNotificationTimers() {
    if (twoMinBeforeSobh != null) {
      twoMinBeforeSobh.cancel();
      fiveMinBeforeSobh.cancel();
      tenMinBeforeSobh.cancel();
      twentyMinBeforeSobh.cancel();
    }
    DateTime sobh = DateTime.parse(intl.DateFormat('yyyy-MM-dd').format(DateTime.now()) + ' ' + owghat.sobh);
    Duration nowToTwoMinutesBeforeSobhDiff = sobh.subtract(Duration(minutes: 2)).difference(DateTime.now());
    if (nowToTwoMinutesBeforeSobhDiff > Duration.zero) {
      twoMinBeforeSobh =
          Timer(nowToTwoMinutesBeforeSobhDiff, () => loadAzanNotificationAudio(fixPath('audios/azan_alert_two.mp3')));
    }
    Duration nowToFiveMinutesBeforeSobhDiff = sobh.subtract(Duration(minutes: 5)).difference(DateTime.now());
    if (nowToFiveMinutesBeforeSobhDiff > Duration.zero) {
      fiveMinBeforeSobh =
          Timer(nowToFiveMinutesBeforeSobhDiff, () => loadAzanNotificationAudio(fixPath('audios/azan_alert_five.mp3')));
    }
    Duration nowToTenMinutesBeforeSobhDiff = sobh.subtract(Duration(minutes: 10)).difference(DateTime.now());
    if (nowToTenMinutesBeforeSobhDiff > Duration.zero) {
      tenMinBeforeSobh =
          Timer(nowToTenMinutesBeforeSobhDiff, () => loadAzanNotificationAudio(fixPath('audios/azan_alert_ten.mp3')));
    }
    Duration nowToTwentyMinutesBeforeSobhDiff = sobh.subtract(Duration(minutes: 20)).difference(DateTime.now());
    if (nowToTwentyMinutesBeforeSobhDiff > Duration.zero) {
      twentyMinBeforeSobh =
          Timer(nowToTwentyMinutesBeforeSobhDiff, () => loadAzanNotificationAudio(fixPath('audios/azan_alert_twenty.mp3')));
    }
  }

  Route createRoute(Widget newPage) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => newPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.decelerate;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

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
    // setAzanSobhNotificationTasks();
    setAzanNotificationTimers();
  }

  Future<Null> dailyUpdate() async {
    jalaliDate = json.encode({
      'year': Jalali.fromDateTime(DateTime.now()).formatter.yyyy,
      'month': Jalali.fromDateTime(DateTime.now()).formatter.mN,
      'day': Jalali.fromDateTime(DateTime.now()).formatter.d
    });
    gregorianDate = json.encode({
      'year': Gregorian.fromDateTime(DateTime.now()).formatter.yyyy,
      'month': Gregorian.fromDateTime(DateTime.now()).formatter.m,
      'day': Gregorian.fromDateTime(DateTime.now()).formatter.d
    });
    await Future.wait([
      fetchHijriDate(),
      fetchRadioItemLists(),
      owghatMethodChangeUpdate(),
    ]);
  }

  Future<Null> cityChangeUpdate() async {
    cityId = Settings.getValue<int>('cityId', 3);
    city = cityList.firstWhere((city) => city.cityId == cityId);
    if (!radioPlayerIsPaused) {
      kIsWeb ? stopRadio() : radioPlayer.stop();
      playPauseAnimationController.reverse();
      radioPlayerIsPaused = true;
    }
    await Future.wait([
      dailyUpdate(),
      fetchAdList(),
      loadRadio(),
    ]);
  }

  Future<Null> init() async {
    navigatorIndex = 2;
    pageController = PreloadPageController(
      initialPage: navigatorIndex,
      keepPage: true,
    );
    smtpUsername = 'feedback@radioramezan.com';
    smtpPassword = 'Radioabbasehsan123@';
    if (!kIsWeb) radioPlayer = AssetsAudioPlayer.newPlayer();
    if (!kIsWeb) azanNotificationPlayer = AssetsAudioPlayer.newPlayer();
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
    webAspectRatio = 1.5;
    adAspectRatio = 6.4;
    sources = {};
    workmanager = Workmanager();
    azanSobhNotificationTasks = {'two': 2, 'five': 5, 'ten': 10, 'twenty': 20};
    await fetchCityList();
    await Future.wait([
      cityChangeUpdate(),
      loadSources(),
    ]);
    currentAndNextItem = findCurrentAndNextItem();
    liveCron.schedule(Schedule.parse('*/1 * * * *'), () async {
      currentAndNextItem = findCurrentAndNextItem();
    });
  }
}

final globals = Globals();
