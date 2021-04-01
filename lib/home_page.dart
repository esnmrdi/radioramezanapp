// loading required packages
import 'dart:async';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cron/cron.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/path_painter.dart';
import 'package:radioramezan/radio_modal.dart';
import 'package:radioramezan/theme.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> homePageScaffoldKey;
  Cron midnightCron = Cron();
  Cron liveHomePageCron = Cron();
  Path horizonPath, sunPath, verticalPathOne, verticalPathTwo;
  Size canvasSize;
  Paint horizonPaint, sunPaint;
  Offset sunOffset;
  AnimationController sunAnimationController;
  Animation sunAnimation;
  Map<String, String> gregorianMonthNames;
  Map<String, String> hijriMonthNames;

  Path drawHorizontalPath(double x1, double x2, double y) {
    Path path = Path();
    path.moveTo(x1, y);
    path.lineTo(x2, y);

    return path;
  }

  Path drawSunPath(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.cubicTo(
      .25 * size.width,
      size.height,
      .25 * size.width,
      .2 * size.height,
      .5 * size.width,
      .2 * size.height,
    );
    path.cubicTo(.75 * size.width, .2 * size.height, .75 * size.width,
        size.height, size.width, size.height);

    return path;
  }

  Offset calculateSunPosition(path, value) {
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }

  @override
  void initState() {
    homePageScaffoldKey = GlobalKey<ScaffoldState>();
    midnightCron.schedule(Schedule.parse('0 0 * * *'), () async {
      await globals.midnightCron();
      setState(() {});
    });
    liveHomePageCron.schedule(Schedule.parse('*/1 * * * *'), () async {
      setState(() {});
    });
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
    horizonPaint = Paint()
      ..color = Colors.white.withOpacity(.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    sunPaint = Paint()
      ..color = Colors.yellow.withOpacity(.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    sunAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );
    sunAnimation = CurvedAnimation(
      parent: sunAnimationController,
      curve: Curves.easeOut,
    );
    sunAnimation = Tween(
            begin: .0,
            end: (DateTime.now().hour * 60 + DateTime.now().minute) / 1440)
        .animate(sunAnimation);
    Future.delayed(Duration(seconds: 2), () {
      sunAnimationController.forward(from: 0);
    });
    super.initState();
  }

  @override
  void dispose() {
    sunAnimationController.dispose();
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
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.radio,
              color: Colors.white,
            ),
            onPressed: () {
              Future.delayed(
                Duration(milliseconds: 250),
                () {
                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) => RadioModal(),
                    duration: Duration(milliseconds: 500),
                    enableDrag: true,
                  );
                },
              );
            },
          ),
        ],
        brightness: Brightness.dark,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(.5),
          // gradient: RadialGradient(
          //   center: Alignment.topCenter,
          //   colors: [
          //     Theme.of(context).primaryColor.withOpacity(.2),
          //     Colors.white,
          //     Theme.of(context).primaryColor.withOpacity(.2),
          //   ],
          //   radius: 1.5,
          //   stops: [.0, .7, 1.0],
          //   tileMode: TileMode.clamp,
          // ),
        ),
        foregroundDecoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/mosque_frame_top.png'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter),
        ),
        child: Container(
          padding:
              EdgeInsets.only(top: .22 * MediaQuery.of(context).size.width),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/mosque_frame_edge.png'),
              fit: BoxFit.fill,
              alignment: Alignment.topCenter,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: .4 * constraints.maxHeight,
                    width: .85 * constraints.maxWidth,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          height: .15 * constraints.maxHeight,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Image.asset(
                                'assets/images/city_frame.png',
                                fit: BoxFit.fill,
                              ),
                              Text(
                                globals.city.countryNameFa +
                                    ' : ' +
                                    globals.city.cityNameFa,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: .075 * constraints.maxWidth,
                          top: .13 * constraints.maxHeight,
                          child: Container(
                            height: .2 * constraints.maxHeight,
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Image.asset('assets/images/date_frame.png'),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: .075 * constraints.maxHeight),
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
                                  padding: EdgeInsets.only(
                                      top: .075 * constraints.maxHeight),
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
                        ),
                        Positioned(
                          top: .18 * constraints.maxHeight,
                          child: Container(
                            height: .2 * constraints.maxHeight,
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Image.asset('assets/images/date_frame.png'),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: .065 * constraints.maxHeight),
                                  child: Text(
                                    gregorianMonthNames[json.decode(
                                        globals.gregorianDate)['month']],
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: .075 * constraints.maxHeight),
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
                        ),
                        Positioned(
                          left: .075 * constraints.maxWidth,
                          top: .13 * constraints.maxHeight,
                          child: Container(
                            height: .2 * constraints.maxHeight,
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Image.asset('assets/images/date_frame.png'),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: .075 * constraints.maxHeight),
                                  child: Text(
                                    hijriMonthNames[json
                                        .decode(globals.hijriDate)['month']],
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: .075 * constraints.maxHeight),
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
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: LayoutBuilder(
                      builder: (context, canvasConstraints) {
                        canvasSize = Size(.85 * canvasConstraints.maxWidth,
                            canvasConstraints.maxHeight);
                        horizonPath = drawHorizontalPath(
                            0, .925 * canvasSize.width, .6 * canvasSize.height);
                        sunPath = drawSunPath(canvasSize);
                        return Container(
                          width: .85 * constraints.maxWidth,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    CustomPaint(
                                      painter: PathPainter(
                                          horizonPath, horizonPaint),
                                    ),
                                    CustomPaint(
                                      painter: PathPainter(sunPath, sunPaint),
                                    ),
                                    AnimatedBuilder(
                                      animation: sunAnimationController,
                                      builder: (context, child) {
                                        sunOffset = calculateSunPosition(
                                            sunPath, sunAnimation.value);
                                        sunOffset = Offset(sunOffset.dx - 12,
                                            sunOffset.dy - 12);
                                        return Transform.translate(
                                          offset: sunOffset,
                                          child: child,
                                        );
                                      },
                                      child: Icon(
                                        CupertinoIcons.sun_max_fill,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: RadioRamezanColors
                                                      .goldy[800],
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
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
                                                  color: RadioRamezanColors
                                                      .goldy[800],
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
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
                                      top: .525 * canvasConstraints.maxHeight,
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
                  SizedBox(height: 20),
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
                  SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
