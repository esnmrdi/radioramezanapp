// loading required packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/theme.dart';

class AppSettings extends StatefulWidget {
  @override
  AppSettingsState createState() => AppSettingsState();
}

class AppSettingsState extends State<AppSettings> {
  GlobalKey<ScaffoldState> appSettingsScaffoldKey;
  ScrollController scrollController;
  Map<int, String> cityMap;

  @override
  void initState() {
    appSettingsScaffoldKey = GlobalKey<ScaffoldState>();
    scrollController = ScrollController();
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
        color: Settings.getValue<bool>("darkThemeEnabled", false)
            ? Color.fromRGBO(50, 50, 50, .5)
            : Theme.of(context).primaryColor.withOpacity(.1),
        child: DraggableScrollbar.semicircle(
          controller: scrollController,
          child: ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(bottom: 20),
            itemCount: 1,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  SettingsGroup(
                    title: 'نمایش',
                    children: <Widget>[
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
                                statusBarColor: value
                                    ? Color.fromRGBO(50, 50, 50, 1)
                                    : RadioRamezanColors.ramady,
                              ),
                            );
                            DynamicTheme.of(context).setBrightness(
                              value ? Brightness.dark : Brightness.light,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                  SettingsGroup(
                    title: 'عملکرد',
                    children: <Widget>[
                      RadioModalSettingsTile<int>(
                        title: 'انتخاب کشور و شهر',
                        settingKey: 'cityId',
                        values: cityMap,
                        selected: 3,
                        onChange: (value) {
                          globals.cityChangeUpdate();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'تغییرات مربوط به شهر جدید اعمال شدند.',
                                style: TextStyle(fontFamily: 'Sans'),
                              ),
                              duration: Duration(seconds: 5),
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
                    children: <Widget>[
                      SwitchSettingsTile(
                        settingKey: 'autoStartStopEnabled',
                        title: 'پخش و خاموشی خودکار',
                        subtitle: 'گوش دادن به رادیو پیرامون وقت اذان',
                        enabledLabel: 'فعال',
                        disabledLabel: 'غیرفعال',
                        leading: Icon(CupertinoIcons.alarm),
                        onChange: (value) {
                          globals.setAutoStartStopTimers();
                          if (value)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'برای استفاده از این آپشن، اپلیکیشن نباید به طور کامل بسته شود.',
                                  style: TextStyle(fontFamily: 'Sans'),
                                ),
                                duration: Duration(seconds: 5),
                                behavior: SnackBarBehavior.floating,
                                action: SnackBarAction(
                                  textColor: RadioRamezanColors.goldy,
                                  label: 'باشه!',
                                  onPressed: () {},
                                ),
                              ),
                            );
                        },
                        childrenIfEnabled: <Widget>[
                          CheckboxSettingsTile(
                            leading: Icon(CupertinoIcons.sunrise),
                            settingKey: 'autoStartStopSobhEnabled',
                            title: 'اذان صبح',
                            onChange: (value) {
                              globals.setAutoStartStopTimers();
                            },
                          ),
                          CheckboxSettingsTile(
                            leading: Icon(CupertinoIcons.sun_max),
                            settingKey: 'autoStartStopZohrEnabled',
                            title: 'اذان ظهر',
                            onChange: (value) {
                              globals.setAutoStartStopTimers();
                            },
                          ),
                          CheckboxSettingsTile(
                            leading: Icon(CupertinoIcons.sunset),
                            settingKey: 'autoStartStopMaghrebEnabled',
                            title: 'اذان مغرب',
                            onChange: (value) {
                              globals.setAutoStartStopTimers();
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
                              globals.setAutoStartStopTimers();
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
                              globals.setAutoStartStopTimers();
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
