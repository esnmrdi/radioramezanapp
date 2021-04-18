// loading required packages
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:radioramezan/splash.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/side_drawer.dart';
import 'package:radioramezan/nav_bar.dart';
import 'package:radioramezan/advertisements.dart';
import 'package:radioramezan/qibla.dart';
import 'package:radioramezan/conductor.dart';
import 'package:radioramezan/home_page.dart';
import 'package:radioramezan/prayers.dart';
import 'package:radioramezan/app_settings.dart';
import 'package:radioramezan/radio_bar.dart';
import 'package:radioramezan/theme.dart';

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) await FlutterDownloader.initialize();
  await Settings.init(
    cacheProvider: SharePreferenceCache(),
  );
  runApp(
    EasyDynamicThemeWidget(
      child: RadioRamezanApp(),
    ),
  );
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
        statusBarColor:
            Settings.getValue<bool>("darkThemeEnabled", false) ? RadioRamezanColors.darky : RadioRamezanColors.ramady,
      ),
    );
    return FutureBuilder(
      future: globals.init(),
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? MaterialApp(
                title: 'رادیو رمضان',
                theme: Settings.getValue<bool>("darkThemeEnabled", false) ? darkTheme : lightTheme,
                themeMode: EasyDynamicTheme.of(context).themeMode,
                home: Splash(),
                localizationsDelegates: [
                  GlobalCupertinoLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: [
                  Locale('fa', 'IR'),
                ],
                locale: Locale('fa', 'IR'),
              )
            : MaterialApp(
                title: 'رادیو رمضان',
                theme: Settings.getValue<bool>("darkThemeEnabled", false) ? darkTheme : lightTheme,
                themeMode: EasyDynamicTheme.of(context).themeMode,
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
      },
    );
  }
}

class Main extends StatefulWidget {
  Main({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MainState createState() => MainState();
}

class MainState extends State<Main> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    globals.radioPlayer.dispose();
    globals.playPauseAnimationController.dispose();
    globals.pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Container(
          color: Colors.white,
          margin:
              kIsWeb && MediaQuery.of(context).size.width > MediaQuery.of(context).size.height / globals.webAspectRatio
                  ? EdgeInsets.symmetric(
                      horizontal: (MediaQuery.of(context).size.width -
                              MediaQuery.of(context).size.height / globals.webAspectRatio) /
                          2)
                  : null,
          child: ClipRRect(
            child: Scaffold(
              key: globals.mainScaffoldKey,
              drawerEnableOpenDragGesture: false,
              drawer: SideDrawer(),
              body: SizedBox.expand(
                child: PreloadPageView(
                  preloadPagesCount: 4,
                  controller: globals.pageController,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (int index) {
                    setState(() {
                      globals.navigatorIndex = index;
                    });
                  },
                  children: [
                    Qibla(),
                    Conductor(),
                    HomePage(),
                    Prayers(),
                    AppSettings(),
                  ],
                ),
              ),
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioBar(),
                  NavBar(),
                  Advertisements(),
                ],
              ),
            ),
          ),
        ));
  }
}
