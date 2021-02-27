// loading required packages
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:preload_page_view/preload_page_view.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/custom_app_bar.dart';
import 'package:radioramezan/custom_bottom_navigation_bar.dart';
import 'package:radioramezan/custom_banner.dart';
import 'package:radioramezan/about_us.dart';
import 'package:radioramezan/contact_us.dart';
import 'package:radioramezan/support_us.dart';
import 'package:radioramezan/share_to_others.dart';
import 'package:radioramezan/monthly_owghat.dart';
import 'theme.dart';
import 'qibla.dart';
import 'conductor.dart';
import 'home_page.dart';
import 'prayers.dart';
import 'settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    RadioRamezanApp(),
  );
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class RadioRamezanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: RadioRamezanColors.ramady,
      ),
    );
    return MaterialApp(
      title: 'رادیو رمضان',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: Main(),
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('fa', 'IR'),
      ],
      locale: Locale('fa', 'IR'),
    );
  }
}

class _MainState extends State<Main> {
  @override
  void initState() {
    Globals.pageController = PreloadPageController(
      initialPage: Globals.navigatorIndex,
      keepPage: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    Globals.pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      maintainBottomViewPadding: true,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Scaffold(
                key: Globals.drawerKey,
                drawerEnableOpenDragGesture: false,
                drawer: drawer(context),
                appBar: CustomAppBar(),
                floatingActionButton:
                    Globals.navigatorIndex < 2 || Globals.navigatorIndex == 3
                        ? FloatingActionButton(
                            elevation: 2,
                            child: Globals.navigatorIndex == 0
                                ? Icon(Icons.gps_fixed_rounded)
                                : Globals.navigatorIndex == 1
                                    ? Icon(Icons.date_range_rounded)
                                    : Icon(Icons.search_rounded),
                            backgroundColor: RadioRamezanColors.goldy[600],
                            onPressed: () {
                              switch (Globals.navigatorIndex) {
                                case 0:
                                  {
                                    focusOnUserPosition();
                                  }
                                  break;
                                case 1:
                                  {
                                    datePicker(context);
                                  }
                                  break;
                                case 3:
                                  {
                                    // searchBox();
                                  }
                                  break;
                              }
                            })
                        : null,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
                body: SizedBox.expand(
                  child: PreloadPageView(
                    preloadPagesCount: 4,
                    controller: Globals.pageController,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index) {
                      setState(() => Globals.navigatorIndex = index);
                    },
                    children: <Widget>[
                      qibla(context),
                      conductor(context),
                      HomePage(),
                      prayers(),
                      settings(),
                    ],
                  ),
                ),
                bottomNavigationBar: CustomBottomNavigationBar(),
              ),
            ),
            CustomBanner(),
          ],
        ),
      ),
    );
  }
}

Drawer drawer(BuildContext context) {
  return Drawer(
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.fromRGBO(178, 73, 135, 1.0),
                  Color.fromRGBO(128, 44, 96, 1.0),
                ],
                radius: 1.0,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Center(
              child: Image.asset(
                  'assets/images/logo_white_transparent_background.png'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.format_list_numbered_rtl_rounded),
            title: Text(
              'اوقات شرعی ماه جاری',
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            trailing: Icon(Icons.arrow_left_rounded),
            onTap: () {
              Navigator.pop(context);
              showMaterialModalBottomSheet(
                context: context,
                builder: (context) => MonthlyOwghat(),
                duration: Duration(milliseconds: 500),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.monetization_on_rounded),
            title: Text(
              'حمایت مالی',
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            trailing: Icon(Icons.arrow_left_rounded),
            onTap: () {
              Navigator.pop(context);
              showMaterialModalBottomSheet(
                context: context,
                builder: (context) => SupportUs(),
                duration: Duration(milliseconds: 500),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.share_rounded),
            title: Text(
              'معرفی به دیگران',
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            trailing: Icon(Icons.arrow_left_rounded),
            onTap: () {
              Navigator.pop(context);
              showMaterialModalBottomSheet(
                context: context,
                builder: (context) => ShareToOthers(),
                duration: Duration(milliseconds: 250),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(
              'درباره ما',
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            trailing: Icon(Icons.arrow_left_rounded),
            onTap: () {
              Navigator.pop(context);
              showCupertinoModalBottomSheet(
                context: context,
                builder: (context) => AboutUs(),
                duration: Duration(milliseconds: 500),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.email_rounded),
            title: Text(
              'ارتباط با ما',
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            trailing: Icon(Icons.arrow_left_rounded),
            onTap: () {
              Navigator.pop(context);
              showMaterialModalBottomSheet(
                context: context,
                builder: (context) => ContactUs(),
                duration: Duration(milliseconds: 500),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text(
              'نسخه 1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
