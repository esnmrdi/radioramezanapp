// loading required packages
import 'dart:async';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cron/cron.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/path_painter.dart';
import 'package:radioramezan/radio.dart';
import 'theme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Cron midnightCron = Cron();
  Cron liveHomePageCron = Cron();
  Path horizonPath, sunPath, verticalPathOne, verticalPathTwo;
  Size canvasSize;
  Paint horizonPaint, sunPaint, verticalPaint;
  Offset sunOffset;
  AnimationController sunAnimationController;
  Animation sunAnimation;
  Map<String, String> gregorianMonthNames;
  Map<String, String> hijriMonthNames;
  Animation<double> playPauseAnimation;
  AnimationController playPauseAnimationcontroller;

  Path drawHorizontalPath(double x1, double x2, double y) {
    Path path = Path();
    path.moveTo(x1, y);
    path.lineTo(x2, y);

    return path;
  }

  Path drawVerticalPath(double x, double y1, double y2) {
    Path path = Path();
    path.moveTo(x, y1);
    path.lineTo(x, y2);

    return path;
  }

  Path drawSunPath(Size size) {
    Path path = Path();
    path.moveTo(0, .9 * size.height);
    path.cubicTo(
      .2 * size.width,
      .9 * size.height,
      .25 * size.width,
      .2 * size.height,
      .5 * size.width,
      .2 * size.height,
    );
    path.cubicTo(.75 * size.width, .2 * size.height, .8 * size.width,
        .9 * size.height, size.width, .9 * size.height);

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
      '1': 'محرم',
      '2': 'صفر',
      '3': 'ربیع الاول',
      '4': 'ربیع الثانی',
      '5': 'جمادی الاول',
      '6': 'جمادی الثانی',
      '7': 'رجب',
      '8': 'شعبان',
      '9': 'رمضان',
      '10': 'شوال',
      '11': 'ذیقعده',
      '12': 'ذیحجه',
    };
    playPauseAnimationcontroller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    playPauseAnimation = CurvedAnimation(
      curve: Curves.linear,
      parent: playPauseAnimationcontroller,
    );
    horizonPaint = Paint()
      ..color = Colors.white.withOpacity(.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    sunPaint = Paint()
      ..color = Colors.yellow.withOpacity(.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    verticalPaint = Paint()
      ..color = Colors.white.withOpacity(.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
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
    return LayoutBuilder(
      builder: (context, constraints) {
        canvasSize =
            Size(.85 * constraints.maxWidth, .3 * constraints.maxHeight);
        horizonPath =
            drawHorizontalPath(0, canvasSize.width, .6 * canvasSize.height);
        verticalPathOne = drawVerticalPath(.21 * canvasSize.width,
            .32 * canvasSize.height, .55 * canvasSize.height);
        verticalPathTwo = drawVerticalPath(.79 * canvasSize.width,
            .32 * canvasSize.height, .55 * canvasSize.height);
        sunPath = drawSunPath(canvasSize);
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              colors: [
                RadioRamezanColors.ramady,
                Colors.black,
                RadioRamezanColors.ramady,
              ],
              radius: 1.5,
              stops: [.0, .7, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          foregroundDecoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/mosque_frame_top.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter),
          ),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mosque_frame_edge.png'),
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: .15 * constraints.maxHeight,
                ),
                Container(
                  height: .28 * constraints.maxHeight,
                  width: .85 * constraints.maxWidth,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        height: .1 * constraints.maxHeight,
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Image.asset(
                              'assets/images/city_frame.png',
                              fit: BoxFit.fill,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  globals.city.countryNameFa +
                                      ' | ' +
                                      globals.city.cityNameFa,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: .06 * constraints.maxWidth,
                        top: .09 * constraints.maxHeight,
                        child: Container(
                          height: .16 * constraints.maxHeight,
                          width: .22 * constraints.maxWidth,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Image.asset('assets/images/date_frame.png'),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: .05 * constraints.maxHeight),
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
                                    top: .06 * constraints.maxHeight),
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
                        top: .12 * constraints.maxHeight,
                        child: Container(
                          height: .16 * constraints.maxHeight,
                          width: .22 * constraints.maxWidth,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Image.asset('assets/images/date_frame.png'),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: .05 * constraints.maxHeight),
                                child: Text(
                                  gregorianMonthNames[json
                                      .decode(globals.gregorianDate)['month']],
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: .06 * constraints.maxHeight),
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
                        left: .06 * constraints.maxWidth,
                        top: .09 * constraints.maxHeight,
                        child: Container(
                          height: .16 * constraints.maxHeight,
                          width: .22 * constraints.maxWidth,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Image.asset('assets/images/date_frame.png'),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: .05 * constraints.maxHeight),
                                child: Text(
                                  hijriMonthNames[
                                      json.decode(globals.hijriDate)['month']],
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: .06 * constraints.maxHeight),
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
                Container(
                  height: .3 * constraints.maxHeight,
                  width: .85 * constraints.maxWidth,
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      CustomPaint(
                        painter: PathPainter(horizonPath, horizonPaint),
                      ),
                      CustomPaint(
                        painter: PathPainter(verticalPathOne, verticalPaint),
                      ),
                      CustomPaint(
                        painter: PathPainter(verticalPathTwo, verticalPaint),
                      ),
                      CustomPaint(
                        painter: PathPainter(sunPath, sunPaint),
                      ),
                      AnimatedBuilder(
                        animation: sunAnimationController,
                        builder: (context, child) {
                          sunOffset =
                              calculateSunPosition(sunPath, sunAnimation.value);
                          sunOffset =
                              Offset(sunOffset.dx - 12, sunOffset.dy - 12);
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
                      Center(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    globals.owghat.sunset,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
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
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    globals.owghat.sunrise,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
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
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: .14 * constraints.maxHeight,
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
                        top: .2 * constraints.maxHeight,
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
                Container(
                  height: .1 * constraints.maxHeight,
                  width: .85 * constraints.maxWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
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
                          Text(
                            globals.owghat.maghreb,
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
                          Text(
                            globals.owghat.zohr,
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
                          Text(
                            globals.owghat.sobh,
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
                SizedBox(height: .01 * constraints.maxHeight),
                Container(
                  height: .14 * constraints.maxHeight,
                  width: .9 * constraints.maxWidth,
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Colors.white,
                    shadowColor: Colors.black.withOpacity(.5),
                    margin: EdgeInsets.symmetric(
                        horizontal: .025 * constraints.maxWidth),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/golden_mosque_20percent.png'),
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.bottomLeft,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          Future.delayed(
                            Duration(milliseconds: 250),
                            () {
                              showMaterialModalBottomSheet(
                                context: context,
                                builder: (context) => RadioPlayer(),
                                duration: Duration(milliseconds: 500),
                                enableDrag: true,
                              );
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: 5),
                            RawMaterialButton(
                              constraints: BoxConstraints(
                                minWidth: 64,
                                minHeight: 64,
                              ),
                              padding: EdgeInsets.all(14),
                              shape: CircleBorder(),
                              elevation: globals.radioStreamIsLoaded ? 2 : 0,
                              child: globals.radioStreamIsLoaded
                                  ? AnimatedIcon(
                                      icon: AnimatedIcons.play_pause,
                                      size: 36,
                                      color: RadioRamezanColors.ramady,
                                      progress: playPauseAnimation,
                                    )
                                  : Container(
                                      height: 36,
                                      width: 36,
                                      // padding: EdgeInsets.all(18),
                                      child: CircularProgressIndicator(),
                                    ),
                              onPressed: globals.radioStreamIsLoaded
                                  ? () {
                                      if (globals.radioPlayerIsPaused) {
                                        playPauseAnimationcontroller.forward();
                                        globals.radioPlayer.play();
                                      } else {
                                        playPauseAnimationcontroller.reverse();
                                        globals.radioPlayer.pause();
                                      }
                                      setState(() {
                                        globals.radioPlayerIsPaused =
                                            !globals.radioPlayerIsPaused;
                                      });
                                    }
                                  : null,
                            ),
                            Expanded(
                              flex: 1,
                              child: CarouselSlider.builder(
                                itemCount: globals.currentAndNextItem.length,
                                options: CarouselOptions(
                                  viewportFraction: 1,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 10),
                                  autoPlayAnimationDuration:
                                      Duration(seconds: 1),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  scrollDirection: Axis.vertical,
                                ),
                                itemBuilder:
                                    (BuildContext context, int index, _) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 1,
                                      horizontal: 10,
                                    ),
                                    title: Text(
                                      globals.currentAndNextItem[index].title,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: globals.currentAndNextItem[index]
                                                .description !=
                                            ''
                                        ? Text(
                                            globals.currentAndNextItem[index]
                                                .description,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        : null,
                                    trailing: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: index == 0
                                            ? Colors.red
                                            : Colors.lightGreen,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        index == 0 ? 'پخش زنده' : 'برنامه بعد',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: .02 * constraints.maxHeight),
              ],
            ),
          ),
        );
      },
    );
  }
}
