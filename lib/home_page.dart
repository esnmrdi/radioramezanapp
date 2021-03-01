// loading required packages
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'theme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool radioItemToggle;
  Timer radioItemTimer;
  Path horizonPath;
  Path verticalPaths;
  Path sunPath;
  Size canvasSize;
  Paint horizonPaint;
  Paint verticalPaint;
  Paint sunPaint;
  Offset sunOffset;
  AnimationController animationController;
  Animation animation;

  @override
  void initState() {
    radioItemToggle = true;
    radioItemTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      radioItemToggle = !radioItemToggle;
    });
    horizonPaint = Paint()
      ..color = Colors.white.withOpacity(.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    verticalPaint = Paint()
      ..color = Colors.white.withOpacity(.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    sunPaint = Paint()
      ..color = Colors.yellow.withOpacity(.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );
    animation = Tween(begin: .0, end: .5).animate(animation);
    super.initState();
  }

  @override
  void dispose() {
    if (radioItemTimer != null) {
      radioItemTimer.cancel();
      radioItemTimer = null;
    }
    animationController.dispose();
    super.dispose();
  }

  Path drawHorizonPath(Size size) {
    Path _path = Path();
    _path.moveTo(0, .6 * size.height);
    _path.lineTo(size.width, .6 * size.height);

    return _path;
  }

  Path drawVerticalPaths(Size size) {
    Path _path = Path();
    _path.moveTo(.21 * size.width, .55 * size.height);
    _path.lineTo(.21 * size.width, .35 * size.height);
    _path.moveTo(.79 * size.width, .55 * size.height);
    _path.lineTo(.79 * size.width, .35 * size.height);

    return _path;
  }

  Path drawSunPath(Size size) {
    Path _path = Path();
    _path.moveTo(0, .9 * size.height);
    _path.cubicTo(
      .2 * size.width,
      .9 * size.height,
      .25 * size.width,
      .2 * size.height,
      .5 * size.width,
      .2 * size.height,
    );
    _path.cubicTo(.75 * size.width, .2 * size.height, .8 * size.width,
        .9 * size.height, size.width, .9 * size.height);

    return _path;
  }

  Offset calculateSunPosition(path, value) {
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }

  @override
  Widget build(BuildContext context) {
    animationController.forward(from: 0);
    return LayoutBuilder(
      builder: (context, constraints) {
        canvasSize =
            Size(.85 * constraints.maxWidth, .3 * constraints.maxHeight);
        horizonPath = drawHorizonPath(canvasSize);
        verticalPaths = drawVerticalPaths(canvasSize);
        sunPath = drawSunPath(canvasSize);
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, RadioRamezanColors.ramady],
              begin: const FractionalOffset(.0, .0),
              end: const FractionalOffset(.0, 1.0),
              stops: [.0, 1.0],
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
              // mainAxisSize: MainAxisSize.min,
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
                                Icon(
                                  Icons.location_pin,
                                ),
                                Text(
                                  'تورنتو',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
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
                                  'اردیبهشت',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: .07 * constraints.maxHeight),
                                child: Text(
                                  '26',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 28,
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
                                  'MAY',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: .06 * constraints.maxHeight),
                                child: Text(
                                  '10',
                                  style: TextStyle(
                                    fontFamily: '',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 28,
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
                                  'رمضان',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: .07 * constraints.maxHeight),
                                child: Text(
                                  '16',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 28,
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
                        painter: PathPainter(verticalPaths, verticalPaint),
                      ),
                      CustomPaint(
                        painter: PathPainter(sunPath, sunPaint),
                      ),
                      AnimatedBuilder(
                        animation: animationController,
                        builder: (context, child) {
                          sunOffset =
                              calculateSunPosition(sunPath, animation.value);
                          sunOffset =
                              Offset(sunOffset.dx - 12, sunOffset.dy - 12);
                          return Transform.translate(
                            offset: sunOffset,
                            child: child,
                          );
                        },
                        child: Icon(
                          Icons.wb_sunny_rounded,
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
                                    '19:17',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: RadioRamezanColors.goldy,
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
                                    '06:10',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: RadioRamezanColors.goldy,
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
                              'طول روز: ۷ ساعت و ۱۲ دقیقه',
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
                              color: RadioRamezanColors.redy,
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
                            '20:04',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
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
                            '12:37',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: RadioRamezanColors.redy,
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
                            '05:15',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: .01 * constraints.maxHeight),
                Container(
                  height: .16 * constraints.maxHeight,
                  width: .85 * constraints.maxWidth,
                  child: Column(
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        color: Colors.white,
                        shadowColor: Colors.black.withOpacity(.5),
                        margin: EdgeInsets.zero,
                        child: AnimatedCrossFade(
                          duration: Duration(seconds: 1),
                          firstChild: ListTile(
                            leading:
                                Image.asset('assets/images/praying_hands.jpg'),
                            title: Text(
                              'تلاوت قرآن کریم',
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              'شهریار پرهیزگار',
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'پخش زنده',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          secondChild: ListTile(
                            leading: Image.network(
                                'http:\/\/ffmpeg.radioramezan.com:8090\/images\/logo.png'),
                            title: Text(
                              'دعای سحر',
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              'محسن فرهمند صمیمی',
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 172, 255, 1.0),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'برنامه بعد',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          crossFadeState: radioItemToggle
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                        ),
                      ),
                      SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PathPainter extends CustomPainter {
  Path _path;
  Paint _paint;

  PathPainter(this._path, this._paint);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(this._path, this._paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
