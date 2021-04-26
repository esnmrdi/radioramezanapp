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
  List<String> autoStartStopTasks;
  Map<int, String> cityMap;

  void callbackDispatcher() {
    workmanager.executeTask((task, inputData) async {
      if (task.contains('start')) {
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

  void setAutoStartStopTasks() async {
    await workmanager.cancelAll();
    if (Settings.getValue<bool>('autoStartStopEnabled', false)) {
      workmanager.initialize(
        callbackDispatcher,
      );
      autoStartStopTasks.forEach((element) {
        DateTime event = DateTime.parse(
            intl.DateFormat('yyyy-MM-dd').format(DateTime.now()) + ' ' + globals.owghat.toMap()[element]);
        Duration nowToStartEventDiff =
            event.subtract(Duration(minutes: Settings.getValue<double>('autoStartDuration', 30).truncate())).difference(
                  DateTime.now(),
                );
        Duration nowToStopEventDiff =
            event.add(Duration(minutes: Settings.getValue<double>('autoStopDuration', 30).truncate())).difference(
                  DateTime.now(),
                );
        if (Settings.getValue<bool>('autoStartStop' + element + 'Enabled', false)) {
          if (nowToStartEventDiff > Duration.zero) {
            workmanager.registerOneOffTask(
              'autoStart' + element + 'Task',
              'autoStart' + element + 'Task',
              initialDelay: nowToStartEventDiff,
            );
          }
          if (nowToStopEventDiff > Duration.zero) {
            workmanager.registerOneOffTask(
              'autoStop' + element + 'Task',
              'autoStop' + element + 'Task',
              initialDelay: nowToStopEventDiff,
            );
          }
        }
      });
    }
  }

  @override
  void initState() {
    appSettingsScaffoldKey = GlobalKey<ScaffoldState>();
    scrollController = ScrollController();
    workmanager = Workmanager();
    autoStartStopTasks = ['sobh', 'zohr', 'maghreb'];
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
                          setAutoStartStopTasks();
                        },
                        childrenIfEnabled: [
                          CheckboxSettingsTile(
                            leading: Icon(CupertinoIcons.sunrise),
                            settingKey: 'autoStartStopSobhEnabled',
                            title: 'اذان صبح',
                            onChange: (value) {
                              setAutoStartStopTasks();
                            },
                          ),
                          CheckboxSettingsTile(
                            leading: Icon(CupertinoIcons.sun_max),
                            settingKey: 'autoStartStopZohrEnabled',
                            title: 'اذان ظهر',
                            onChange: (value) {
                              setAutoStartStopTasks();
                            },
                          ),
                          CheckboxSettingsTile(
                            leading: Icon(CupertinoIcons.sunset),
                            settingKey: 'autoStartStopMaghrebEnabled',
                            title: 'اذان مغرب',
                            onChange: (value) {
                              setAutoStartStopTasks();
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
                              setAutoStartStopTasks();
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
                              setAutoStartStopTasks();
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
