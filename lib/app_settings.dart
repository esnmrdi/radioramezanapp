// loading required packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:workmanager/workmanager.dart';
import 'package:intl/intl.dart' as intl;
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/theme.dart';

class AppSettings extends StatefulWidget {
  @override
  AppSettingsState createState() => AppSettingsState();
}

class AppSettingsState extends State<AppSettings> {
  GlobalKey<ScaffoldState> appSettingsScaffoldKey;
  ScrollController scrollController;
  Workmanager workmanager;
  Map<int, String> cityMap;

  void callbackDispatcher() {
    workmanager.executeTask((task, inputData) async {
      if (task == 'autoStartSobhTask' || task == 'autoStartZohrTask' || task == 'autoStartMaghrebTask') {
        if (globals.radioPlayerIsPaused) {
          globals.radioPlayer.play();
          globals.playPauseAnimationController.forward();
          globals.radioPlayerIsPaused = false;
        }
      } else {
        if (!globals.radioPlayerIsPaused) {
          globals.radioPlayer.stop();
          globals.playPauseAnimationController.reverse();
          globals.radioPlayerIsPaused = true;
        }
      }
      return Future.value(true);
    });
  }

  void setAutoStartStopTimers() async {
    await workmanager.cancelAll();
    if (Settings.getValue<bool>('autoStartStopEnabled', false)) {
      workmanager.initialize(
        callbackDispatcher,
        isInDebugMode: true,
      );
      if (Settings.getValue<bool>('autoStartStopSobhEnabled', false)) {
        DateTime sobh =
            DateTime.parse(intl.DateFormat('yyyy-MM-dd').format(DateTime.now()) + ' ' + globals.owghat.sobh);
        Duration nowToStartSobhDiff =
            sobh.subtract(Duration(minutes: Settings.getValue<double>('autoStartDuration', 30).truncate())).difference(
                  DateTime.now(),
                );
        if (nowToStartSobhDiff > Duration.zero) {
          workmanager.registerOneOffTask(
            "1",
            'autoStartSobhTask',
            initialDelay: nowToStartSobhDiff,
          );
        }
        Duration nowToStopSobhDiff =
            sobh.add(Duration(minutes: Settings.getValue<double>('autoStopDuration', 30).truncate())).difference(
                  DateTime.now(),
                );
        if (nowToStopSobhDiff > Duration.zero) {
          workmanager.registerOneOffTask(
            "2",
            'autoStopSobhTask',
            initialDelay: nowToStopSobhDiff,
          );
        }
      }
      if (Settings.getValue<bool>('autoStartStopZohrEnabled', false)) {
        DateTime zohr =
            DateTime.parse(intl.DateFormat('yyyy-MM-dd').format(DateTime.now()) + ' ' + globals.owghat.zohr);
        Duration nowToStartZohrDiff =
            zohr.subtract(Duration(minutes: Settings.getValue<double>('autoStartDuration', 30).truncate())).difference(
                  DateTime.now(),
                );
        if (nowToStartZohrDiff > Duration.zero) {
          workmanager.registerOneOffTask(
            "3",
            'autoStartZohrTask',
            initialDelay: nowToStartZohrDiff,
          );
        }
        Duration nowToStopZohrDiff =
            zohr.add(Duration(minutes: Settings.getValue<double>('autoStopDuration', 30).truncate())).difference(
                  DateTime.now(),
                );
        if (nowToStopZohrDiff > Duration.zero) {
          workmanager.registerOneOffTask(
            "4",
            'autoStopZohrTask',
            initialDelay: nowToStopZohrDiff,
          );
        }
      }
      if (Settings.getValue<bool>('autoStartStopMaghrebEnabled', false)) {
        DateTime maghreb =
            DateTime.parse(intl.DateFormat('yyyy-MM-dd').format(DateTime.now()) + ' ' + globals.owghat.maghreb);
        Duration nowToStartMaghrebDiff = maghreb
            .subtract(Duration(minutes: Settings.getValue<double>('autoStartDuration', 30).truncate()))
            .difference(
              DateTime.now(),
            );
        if (nowToStartMaghrebDiff > Duration.zero) {
          workmanager.registerOneOffTask(
            "5",
            'autoStartMaghrebTask',
            initialDelay: nowToStartMaghrebDiff,
          );
        }
        Duration nowToStopMaghrebDiff =
            maghreb.add(Duration(minutes: Settings.getValue<double>('autoStopDuration', 30).truncate())).difference(
                  DateTime.now(),
                );
        if (nowToStopMaghrebDiff > Duration.zero) {
          workmanager.registerOneOffTask(
            "6",
            'autoStopMaghrebTask',
            initialDelay: nowToStopMaghrebDiff,
          );
        }
      }
    }
  }

  @override
  void initState() {
    appSettingsScaffoldKey = GlobalKey<ScaffoldState>();
    scrollController = ScrollController();
    workmanager = Workmanager();
    cityMap = Map.fromIterable(
      globals.cityList,
      key: (city) => city.cityId,
      value: (city) => city.countryNameFa + '، ' + city.cityNameFa,
    );
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: appSettingsScaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'رادیو رمضان',
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            globals.mainScaffoldKey.currentState.openDrawer();
          },
        ),
        brightness: Brightness.dark,
      ),
      body: Container(
        child: DraggableScrollbar.semicircle(
          controller: scrollController,
          child: ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(bottom: 20),
            itemCount: 1,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  SettingsGroup(
                    title: 'نمایش',
                    subtitle: null,
                    children: [
                      SwitchSettingsTile(
                        settingKey: 'darkThemeEnabled',
                        title: 'تغییر پوسته',
                        subtitle: 'انتخاب بین قالب تاریک و روشن',
                        enabledLabel: 'فعال',
                        disabledLabel: 'غیرفعال',
                        leading: Icon(CupertinoIcons.paintbrush),
                        onChange: (value) {
                          Future.delayed(Duration(milliseconds: 250), () {
                            SystemChrome.setSystemUIOverlayStyle(
                              SystemUiOverlayStyle(
                                statusBarColor: value ? RadioRamezanColors.darky : RadioRamezanColors.ramady,
                              ),
                            );
                            EasyDynamicTheme.of(context).changeTheme();
                          });
                        },
                      ),
                    ],
                  ),
                  SettingsGroup(
                    title: 'عملکرد',
                    subtitle: null,
                    children: [
                      RadioModalSettingsTile<int>(
                        title: 'انتخاب کشور و شهر',
                        settingKey: 'cityId',
                        values: cityMap,
                        selected: 3,
                        onChange: (value) {
                          globals.cityChangeUpdate();
                        },
                      ),
                      RadioModalSettingsTile<int>(
                        title: 'مکانیزم محاسبه اوقات',
                        settingKey: 'owghatMethod',
                        values: <int, String>{
                          0: 'موسسه لواء قم',
                          7: 'موسسه ژئوفیزیک',
                        },
                        selected: 0,
                        onChange: (value) {
                          globals.owghatMethodChangeUpdate();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'این انتخاب صرفا بر روی نمایش اوقات شرعی اثر دارد و پخش زنده رادیو بر مبنای مکانیزم موسسه لواء تنظیم شده است.',
                                style: TextStyle(fontFamily: 'Sans'),
                              ),
                              duration: Duration(seconds: 8),
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                textColor: RadioRamezanColors.goldy,
                                label: 'باشه!',
                                onPressed: () {},
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SettingsGroup(
                    title: 'زمان بندی',
                    subtitle: null,
                    children: [
                      SwitchSettingsTile(
                        settingKey: 'autoStartStopEnabled',
                        title: 'پخش و خاموشی خودکار',
                        subtitle: 'گوش دادن به رادیو پیرامون وقت اذان',
                        enabled: false,
                        enabledLabel: 'فعال',
                        disabledLabel: 'غیرفعال',
                        leading: Icon(CupertinoIcons.alarm),
                        onChange: (value) {
                          setAutoStartStopTimers();
                        },
                        childrenIfEnabled: [
                          CheckboxSettingsTile(
                            leading: Icon(CupertinoIcons.sunrise),
                            settingKey: 'autoStartStopSobhEnabled',
                            title: 'اذان صبح',
                            onChange: (value) {
                              setAutoStartStopTimers();
                            },
                          ),
                          CheckboxSettingsTile(
                            leading: Icon(CupertinoIcons.sun_max),
                            settingKey: 'autoStartStopZohrEnabled',
                            title: 'اذان ظهر',
                            onChange: (value) {
                              setAutoStartStopTimers();
                            },
                          ),
                          CheckboxSettingsTile(
                            leading: Icon(CupertinoIcons.sunset),
                            settingKey: 'autoStartStopMaghrebEnabled',
                            title: 'اذان مغرب',
                            onChange: (value) {
                              setAutoStartStopTimers();
                            },
                          ),
                          SliderSettingsTile(
                            settingKey: 'autoStartDuration',
                            title: 'شروع پخش (چند دقیقه پیش از اذان؟)',
                            defaultValue: 30,
                            min: 10,
                            max: 90,
                            step: 10,
                            leading: Icon(CupertinoIcons.hourglass),
                            onChangeEnd: (value) {
                              setAutoStartStopTimers();
                            },
                          ),
                          SliderSettingsTile(
                            settingKey: 'autoStopDuration',
                            title: 'توقف پخش (چند دقیقه پس از اذان؟)',
                            defaultValue: 30,
                            min: 10,
                            max: 90,
                            step: 10,
                            leading: Icon(CupertinoIcons.hourglass),
                            onChangeEnd: (value) {
                              setAutoStartStopTimers();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
