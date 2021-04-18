// loading required packages
import 'dart:async';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cron/cron.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/radio_panel.dart';
import 'package:radioramezan/path_painter.dart';
import 'package:radioramezan/theme.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> homePageScaffoldKey;
  Cron dailyCron = Cron();
  Cron liveHomePageCron = Cron();
  Size canvasSize;
  Offset sunOffset;
  Paint sunPaint, horizonPaint, dayProgressPaint;
  Map<String, String> gregorianMonthNames;
  Map<String, String> hijriMonthNames;
  double dayProgress;

  Offset calculateSunPosition(Path path, double value) {
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }

  Path sunPath(Size size) {
    Path path = Path();
    path.moveTo(0, .9 * size.height);
    path.cubicTo(
      .25 * size.width,
      .9 * size.height,
      .25 * size.width,
      .2 * size.height,
      .5 * size.width,
      .2 * size.height,
    );
    path.cubicTo(.75 * size.width, .2 * size.height, .75 * size.width, 0.9 * size.height, size.width, .9 * size.height);
    return path;
  }

  Path horizonPath(Size size) {
    Path path = Path();
    path.moveTo(0, .55 * size.height);
    path.lineTo(size.width, .55 * size.height);
    return path;
  }

  Path dayProgressPath(Size size) {
    Path path = sunPath(size);
    path.lineTo(size.width, .55 * size.height);
    path.lineTo(0, .55 * size.height);
    path.close();
    return path;
  }

  @override
  void initState() {
    homePageScaffoldKey = GlobalKey<ScaffoldState>();
    gregorianMonthNames = {
      '1': 'JAN',
      '2': 'FEB',
      '3': 'MAR',
      '4': 'APR',
      '5': 'MAY',
      '6': 'JUN',
      '7': 'JUL',
      '8': 'AUG',
      '9': 'SEP',
      '10': 'OCT',
      '11': 'NOV',
      '12': 'DEC',
    };
    hijriMonthNames = {
      '01': 'محرم',
      '02': 'صفر',
      '03': 'ربیع الاول',
      '04': 'ربیع الثانی',
      '05': 'جمادی الاول',
      '06': 'جمادی الثانی',
      '07': 'رجب',
      '08': 'شعبان',
      '09': 'رمضان',
      '10': 'شوال',
      '11': 'ذیقعده',
      '12': 'ذیحجه',
    };
    sunPaint = Paint()
      ..color = Colors.yellow.withOpacity(.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    horizonPaint = Paint()
      ..color = Colors.white.withOpacity(.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    dayProgressPaint = Paint()
      ..color = Colors.yellow.withOpacity(.15)
      ..style = PaintingStyle.fill;
    dayProgress = (DateTime.now().hour * 60 + DateTime.now().minute) / 1440;
    dailyCron.schedule(Schedule.parse('0 0 * * *'), () async {
      await globals.dailyUpdate();
      setState(() {});
    });
    liveHomePageCron.schedule(Schedule.parse('*/1 * * * *'), () async {
      dayProgress = (DateTime.now().hour * 60 + DateTime.now().minute) / 1440;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homePageScaffoldKey,
      backgroundColor: Colors.black,
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.radio,
              color: Colors.white,
            ),
            onPressed: () {
              Future.delayed(
                Duration(milliseconds: 250),
                () {
                  Navigator.of(context).push(
                    globals.createRoute(RadioPanel()),
                  );
                },
              );
            },
          ),
        ],
        brightness: Brightness.dark,
      ),
      body: Container(
        width: kIsWeb ? MediaQuery.of(context).size.height / globals.webAspectRatio : MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(.5),
        ),
        foregroundDecoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/mosque_frame_top.png'), fit: BoxFit.fitWidth, alignment: Alignment.topCenter),
        ),
        child: Container(
          padding: EdgeInsets.only(
            top: .25 *
                (kIsWeb &&
                        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height / globals.webAspectRatio
                    ? MediaQuery.of(context).size.height / globals.webAspectRatio
                    : MediaQuery.of(context).size.width),
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/mosque_frame_edge.png'),
              fit: BoxFit.fill,
              alignment: Alignment.topCenter,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/city_frame.png'),
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.center,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        onTap: () {
                          globals.pageController.jumpToPage(4);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'امکان تغییر شهر در بخش تنظیمات مهیاست.',
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
                        child: Container(
                          height: .125 * constraints.maxHeight,
                          width: (360 / 127) * .125 * constraints.maxHeight,
                          child: Center(
                            child: Text(
                              globals.city.countryNameFa + ' : ' + globals.city.cityNameFa,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: .025 * constraints.maxHeight),
                  Container(
                    width: .85 * constraints.maxWidth,
                    height: .2 * constraints.maxHeight,
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Image.asset('images/date_frame.png'),
                              Padding(
                                padding: EdgeInsets.only(bottom: .075 * constraints.maxHeight),
                                child: Text(
                                  json.decode(globals.jalaliDate)['month'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: .075 * constraints.maxHeight),
                                child: Text(
                                  json.decode(globals.jalaliDate)['day'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 24,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Image.asset('images/date_frame.png'),
                              Padding(
                                padding: EdgeInsets.only(bottom: .065 * constraints.maxHeight),
                                child: Text(
                                  gregorianMonthNames[json.decode(globals.gregorianDate)['month']],
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: .075 * constraints.maxHeight),
                                child: Text(
                                  json.decode(globals.gregorianDate)['day'],
                                  style: TextStyle(
                                    fontFamily: '',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 24,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Image.asset('images/date_frame.png'),
                              Padding(
                                padding: EdgeInsets.only(bottom: .075 * constraints.maxHeight),
                                child: Text(
                                  hijriMonthNames[json.decode(globals.hijriDate)['month']],
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: .075 * constraints.maxHeight),
                                child: Text(
                                  json.decode(globals.hijriDate)['day'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 24,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: .025 * constraints.maxHeight),
                  Expanded(
                    flex: 1,
                    child: LayoutBuilder(
                      builder: (context, canvasConstraints) {
                        canvasSize = Size(.85 * canvasConstraints.maxWidth, canvasConstraints.maxHeight);
                        sunOffset = calculateSunPosition(sunPath(canvasSize), dayProgress);
                        return Container(
                          width: .85 * constraints.maxWidth,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    CustomPaint(
                                      painter: PathPainter(horizonPath(canvasSize), horizonPaint),
                                    ),
                                    CustomPaint(
                                      painter: PathPainter(sunPath(canvasSize), sunPaint),
                                    ),
                                    ClipRect(
                                      child: Container(
                                        width: sunOffset.dx,
                                        height: canvasSize.height,
                                        child: CustomPaint(
                                          painter: PathPainter(dayProgressPath(canvasSize), dayProgressPaint),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: sunOffset.dx - 12,
                                      top: sunOffset.dy - 12,
                                      child: Icon(
                                        CupertinoIcons.sun_max_fill,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: .025 * constraints.maxHeight),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: RadioRamezanColors.goldy[800],
                                                  shape: BoxShape.rectangle,
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Text(
                                                  'غروب آفتاب',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                globals.owghat.sunset,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: RadioRamezanColors.goldy[800],
                                                  shape: BoxShape.rectangle,
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Text(
                                                  'طلوع آفتاب',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                globals.owghat.sunrise,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: .575 * canvasConstraints.maxHeight,
                                      child: Container(
                                        width: .85 * constraints.maxWidth,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'افق',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: .75 * canvasConstraints.maxHeight,
                                      child: Container(
                                        width: .85 * constraints.maxWidth,
                                        child: Center(
                                          child: Text(
                                            'طول روز: ${(globals.owghat.dayLength / 60).truncate()} ساعت و ${globals.owghat.dayLength % 60} دقیقه',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: .025 * constraints.maxHeight),
                  Container(
                    width: .85 * constraints.maxWidth,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              globals.owghat.maghreb,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.cyan,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'اذان مغرب',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              globals.owghat.zohr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'ظهر شرعی',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              globals.owghat.sobh,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.cyan,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'اذان صبح',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: .035 * constraints.maxHeight),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
