// loading required packages
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

bool lockInBackground = true;

Container settings() {
  return Container(
    // decoration: BoxDecoration(
    //   image: DecorationImage(
    //     image: AssetImage('assets/images/golden_mosque_30percent.png'),
    //     fit: BoxFit.fitWidth,
    //     alignment: Alignment.bottomCenter,
    //   ),
    // ),
    child: SettingsList(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      sections: [
        SettingsSection(
          title: 'نمایش',
          tiles: [
            SettingsTile.switchTile(
              title: 'تغییر پوسته',
              subtitle: 'انتخاب وضعیت تاریک / روشن',
              leading: Icon(Icons.brush_rounded),
              switchValue: false,
              onToggle: (bool value) {},
            ),
          ],
        ),
        SettingsSection(
          title: 'عملکرد',
          tiles: [
            SettingsTile(
              title: 'تنظیم موقعیت',
              subtitle: 'انتخاب کشور و شهر',
              leading: Icon(Icons.location_on_rounded),
            ),
            SettingsTile(
              title: 'فرمول محاسبه',
              subtitle: 'مکانیزم تعیین اوقات',
              leading: Icon(Icons.calculate_rounded),
            ),
          ],
        ),
        SettingsSection(
          title: 'زمان بندی',
          tiles: [
            SettingsTile(
              title: 'پخش',
              subtitle: 'شروع خودکار پیش از اذان',
              leading: Icon(
                Icons.access_alarm_rounded,
              ),
            ),
            SettingsTile(
              title: 'خاموشی',
              subtitle: 'توقف پس از مدت معین',
              leading: Icon(
                Icons.timelapse_rounded,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
