// loading required packages
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:radioramezan/theme.dart';

class AppSettings extends StatefulWidget {
  @override
  AppSettingsState createState() => AppSettingsState();
}

class AppSettingsState extends State<AppSettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SettingsScreen(
        title: "",
        children: [
          SettingsGroup(
            title: 'نمایش',
            children: <Widget>[
              SwitchSettingsTile(
                settingKey: 'darkThemeEnabled',
                title: 'تغییر پوسته',
                subtitle: 'انتخاب وضعیت تاریک / روشن',
                enabledLabel: 'فعال',
                disabledLabel: 'غیرفعال',
                leading: Icon(Theme.of(context).brightness ==  Brightness.light ? CupertinoIcons.lightbulb : CupertinoIcons.lightbulb_slash),
                onChange: (value) {
                  Future.delayed(Duration(milliseconds: 250), () {
                    toggleBrightness(context, value);
                  });
                },
              ),
            ],
          ),
          SettingsGroup(
            title: 'عملکرد',
            children: <Widget>[
              RadioModalSettingsTile<int>(
                title: 'انتخاب کشور و شهر محل سکونت',
                settingKey: 'cityId',
                values: <int, String>{
                  0: 'کانادا، مونترآل',
                  1: 'کانادا، تورنتو',
                  2: 'کانادا، اتاوا',
                  3: 'کانادا،‌ کبک سیتی',
                },
                selected: 0,
                onChange: (value) {
                  debugPrint('$value');
                },
              ),
              RadioModalSettingsTile<int>(
                title: 'مکانیزم محاسبه اوقات شرعی',
                settingKey: 'owghatMechanism',
                values: <int, String>{
                  0: 'موسسه لواء قم',
                  7: 'ژئوفیزیک دانشگاه تهران',
                },
                selected: 0,
                onChange: (value) {
                  debugPrint('$value');
                },
              ),
            ],
          ),
          SettingsGroup(
            title: 'زمان بندی',
            children: <Widget>[
              SwitchSettingsTile(
                settingKey: 'autoStartupEnabled',
                title: 'پخش خودکار',
                subtitle: 'فعال سازی رادیو پیش از اذان',
                enabledLabel: 'فعال',
                disabledLabel: 'غیرفعال',
                leading: Icon(CupertinoIcons.alarm),
                onChange: (value) {
                  debugPrint('$value');
                },
                childrenIfEnabled: <Widget>[
                  CheckboxSettingsTile(
                    leading: Icon(CupertinoIcons.sunrise),
                    settingKey: 'autoStartupSobhEnabled',
                    title: 'اذان صبح',
                    onChange: (value) {
                      debugPrint('$value');
                    },
                  ),
                  CheckboxSettingsTile(
                    leading: Icon(CupertinoIcons.sun_max),
                    settingKey: 'autoStartupZohrEnabled',
                    title: 'اذان ظهر',
                    onChange: (value) {
                      debugPrint('$value');
                    },
                  ),
                  CheckboxSettingsTile(
                    leading: Icon(CupertinoIcons.sunset),
                    settingKey: 'autoStartupMaghrebEnabled',
                    title: 'اذان مغرب',
                    onChange: (value) {
                      debugPrint('$value');
                    },
                  ),
                  SliderSettingsTile(
                    settingKey: 'autoStartupDuration',
                    title: 'چند دقیقه پیش از اذان؟',
                    defaultValue: 30,
                    min: 0,
                    max: 60,
                    step: 10,
                    leading: Icon(CupertinoIcons.hourglass),
                    onChangeEnd: (value) {
                      debugPrint('$value');
                    },
                  ),
                ],
              ),
              SwitchSettingsTile(
                settingKey: 'AutoShutdownEnabled',
                title: 'خاموشی خودکار',
                subtitle: 'توقف پخش پس از مدت معین',
                enabledLabel: 'فعال',
                disabledLabel: 'غیرفعال',
                leading: Icon(CupertinoIcons.timer),
                onChange: (value) {
                  debugPrint('$value');
                },
                childrenIfEnabled: <Widget>[
                  SliderSettingsTile(
                    settingKey: 'autoShutdownDuration',
                    title: 'چند دقیقه پس از اذان؟',
                    defaultValue: 30,
                    min: 0,
                    max: 60,
                    step: 10,
                    leading: Icon(CupertinoIcons.hourglass),
                    onChangeEnd: (value) {
                      debugPrint('$value');
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
