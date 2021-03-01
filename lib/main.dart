// loading required packages
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:preload_page_view/preload_page_view.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:radioramezan/custom_drawer.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/custom_app_bar.dart';
import 'package:radioramezan/custom_bottom_navigation_bar.dart';
import 'package:radioramezan/custom_banner.dart';
import 'package:radioramezan/conductor.dart';
import 'package:radioramezan/home_page.dart';
import 'theme.dart';
import 'qibla.dart';
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
                drawer: CustomDrawer(),
                appBar: CustomAppBar(),
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
                      Conductor(),
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
