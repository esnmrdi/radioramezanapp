// loading required packages
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share/share.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/about_us.dart';
import 'package:radioramezan/contact_us.dart';
import 'package:radioramezan/monthly_owghat.dart';

class SideDrawer extends StatelessWidget {
  Future<String> loadVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return 'نسخه ' + packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/golden_mosque_20percent.png'),
            fit: BoxFit.contain,
            alignment: Alignment.bottomLeft,
          ),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Settings.getValue<bool>("darkThemeEnabled", false)
                          ? Color.fromRGBO(80, 80, 80, 1)
                          : Color.fromRGBO(178, 73, 135, 1),
                      Settings.getValue<bool>("darkThemeEnabled", false)
                          ? Color.fromRGBO(50, 50, 50, 1)
                          : Color.fromRGBO(128, 44, 96, 1),
                    ],
                    radius: 1,
                    stops: [.0, 1],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                      'assets/images/logo_white_transparent_background.png'),
                ),
              ),
              ListTile(
                leading: Icon(CupertinoIcons.list_bullet),
                title: Text(
                  'اوقات شرعی ماه جاری',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  globals.mainScaffoldKey.currentState.openEndDrawer();
                  Future.delayed(
                    Duration(milliseconds: 250),
                    () {
                      Navigator.of(context).push(
                        globals.createRoute(MonthlyOwghat()),
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.square_arrow_up),
                title: Text(
                  'معرفی به دیگران',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  globals.mainScaffoldKey.currentState.openEndDrawer();
                  Share.share(
                    'https://m.radioramezan.com',
                    subject: 'رادیو رمضان، همراه روزهای پر از معنویت شما',
                  );
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.info),
                title: Text(
                  'درباره ما',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  globals.mainScaffoldKey.currentState.openEndDrawer();
                  Future.delayed(
                    Duration(milliseconds: 250),
                    () {
                      Navigator.of(context).push(
                        globals.createRoute(AboutUs()),
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.mail),
                title: Text(
                  'ارتباط با ما',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  globals.mainScaffoldKey.currentState.openEndDrawer();
                  Future.delayed(
                    Duration(milliseconds: 250),
                    () {
                      Navigator.of(context).push(
                        globals.createRoute(ContactUs()),
                      );
                    },
                  );
                },
              ),
              Divider(),
              FutureBuilder(
                future: loadVersionNumber(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListTile(
                      title: Text(
                        snapshot.data,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("${snapshot.error}"),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
