// loading required packages
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
import 'package:radioramezan/data_models/city_model.dart';
import 'package:radioramezan/data_models/owghat_model.dart';
import 'package:radioramezan/data_models/radio_item_model.dart';
import 'package:radioramezan/data_models/prayer_model.dart';
import 'package:radioramezan/data_models/ad_model.dart';

class Globals {
  int navigatorIndex;
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
  String jalaliDate, gregorianDate, hijriDate, smtpUsername, smtpPassword;
  AssetsAudioPlayer radioPlayer;
  bool radioPlayerIsPaused, radioPlayerIsMuted, radioStreamIsLoaded;
  Metas metas;
  List<int> currentAndNextItem;
  Cron liveCron = Cron();

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

  Future<Null> fetchOwghatList(City city) async {
    final response = await get(
        'https://m.radioramezan.com/api/owghat.php?city=' +
            city.cityId.toString());
    if (response.statusCode == 200) {
      owghatList.clear();
      owghatList = (json.decode(response.body) as List)
          .map((i) => Owghat.fromJson(i))
          .toList();
    } else {
      throw Exception('Failed to fetch the conductor!');
    }
  }

  Future<Null> fetchOwghat(City city) async {
    final response = await get(
      'https://m.radioramezan.com/api/owghat.php?city=' +
          city.cityId.toString() +
          '&date=' +
          intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );

    if (response.statusCode == 200) {
      owghat = Owghat.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch owghat!');
    }
  }

  Future<Null> fetchRadioItemList(City city) async {
    final response = await get(
      'https://m.radioramezan.com/api/radio-conductor.php?city=' +
          city.cityId.toString() +
          '&date=' +
          intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    if (response.statusCode == 200) {
      radioItemList.clear();
      radioItemList = (json.decode(response.body) as List)
          .map((i) => RadioItem.fromJson(i))
          .toList();
    } else {
      throw Exception('Failed to fetch the radio item list!');
    }
  }

  Future<Null> fetchAdList(City city) async {
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

  Future<Null> fetchHijriDate(City city) async {
    final response = await get(
      'https://m.radioramezan.com/api/ghamarai.php?city=' +
          city.cityId.toString() +
          '&date=' +
          intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
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

  Future<Null> loadRadioStream(City city, Metas metas) async {
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

  Future<Null> launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  List<int> findCurrentAndNextItem() {
    int nowInMinutes = DateTime.now().hour * 60 + DateTime.now().minute;
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

  Future<Null> midnightCron() async {
    city = Settings.getValue<City>(
        'city',
        City.fromJson(json.decode(
            '{"country_id":"1","country_name_en":"Canada","country_name_fa":"کانادا","city_id": "3","city_name_en": "Montreal","city_name_fa":"مونترال","latitude":"45.504502","longitude":"-73.639600","time_zone":"America\/Toronto","radius":"35","url":"https:\/\/stream1.radioramezan.com:8443\/montreal.mp3"}')));
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
      fetchHijriDate(city),
      fetchOwghat(city),
      fetchRadioItemList(city),
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
    radioPlayer = AssetsAudioPlayer.newPlayer();
    radioStreamIsLoaded = false;
    radioPlayerIsMuted = false;
    radioPlayerIsPaused = true;
    metas = metas = Metas(
      title: 'رادیو رمضان',
      artist: 'رادیو رمضان',
      album: 'رادیو رمضان',
    );
    await Future.wait([
      midnightCron(),
      fetchAdList(city),
      fetchCityList(),
      fetchOwghatList(city),
      loadPrayerList(),
      FlutterDownloader.initialize(),
      loadRadioStream(city, metas),
    ]);
    currentAndNextItem = findCurrentAndNextItem();
    liveCron.schedule(Schedule.parse('*/1 * * * *'), () async {
      currentAndNextItem = findCurrentAndNextItem();
    });
  }
}

final globals = Globals();
