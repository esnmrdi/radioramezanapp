// loading required packages
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/about_us.dart';
import 'package:radioramezan/contact_us.dart';
import 'package:radioramezan/support_us.dart';
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
                      Color.fromRGBO(178, 73, 135, 1.0),
                      Color.fromRGBO(128, 44, 96, 1.0),
                    ],
                    radius: 1.0,
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
                  globals.drawerKey.currentState.openEndDrawer();
                  Future.delayed(
                    Duration(milliseconds: 250),
                    () {
                      showMaterialModalBottomSheet(
                        context: globals.drawerKey.currentContext,
                        builder: (context) => MonthlyOwghat(),
                        duration: Duration(milliseconds: 500),
                        enableDrag: true,
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.money_dollar_circle),
                title: Text(
                  'حمایت مالی',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  globals.drawerKey.currentState.openEndDrawer();
                  Future.delayed(
                    Duration(milliseconds: 250),
                    () {
                      showMaterialModalBottomSheet(
                        context: globals.drawerKey.currentContext,
                        builder: (context) => SupportUs(),
                        duration: Duration(milliseconds: 500),
                        enableDrag: true,
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
                  globals.drawerKey.currentState.openEndDrawer();
                  Future.delayed(
                    Duration(milliseconds: 250),
                    () {
                      Share.share(
                        'https://m.radioramezan.com',
                        subject: 'رادیو رمضان، همراه روزهای پر از معنویت شما',
                      );
                    },
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
                  globals.drawerKey.currentState.openEndDrawer();
                  Future.delayed(
                    Duration(milliseconds: 250),
                    () {
                      showMaterialModalBottomSheet(
                        context: globals.drawerKey.currentContext,
                        builder: (context) => AboutUs(),
                        duration: Duration(milliseconds: 500),
                        enableDrag: true,
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
                  globals.drawerKey.currentState.openEndDrawer();
                  Future.delayed(
                    Duration(milliseconds: 250),
                    () {
                      showMaterialModalBottomSheet(
                        context: globals.drawerKey.currentContext,
                        builder: (context) => ContactUs(),
                        duration: Duration(milliseconds: 500),
                        enableDrag: true,
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.question_circle),
                title: Text(
                  'راهنمای استفاده',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  globals.drawerKey.currentState.openEndDrawer();
                  Future.delayed(
                    Duration(milliseconds: 250),
                    () {

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
