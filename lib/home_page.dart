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
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    verticalPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    sunPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.75)
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
    animation = Tween(begin: 0.0, end: 0.5).animate(animation);
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
    _path.moveTo(0, 0.5 * size.height);
    _path.lineTo(size.width, 0.5 * size.height);

    return _path;
  }

  Path drawVerticalPaths(Size size) {
    Path _path = Path();
    _path.moveTo(0.2 * size.width, 0.475 * size.height);
    _path.lineTo(0.2 * size.width, 0.25 * size.height);
    _path.moveTo(0.8 * size.width, 0.475 * size.height);
    _path.lineTo(0.8 * size.width, 0.25 * size.height);

    return _path;
  }

  Path drawSunPath(Size size) {
    Path _path = Path();
    _path.moveTo(0, 0.7 * size.height);
    _path.cubicTo(
      0.2 * size.width,
      0.7 * size.height,
      0.25 * size.width,
      0.2 * size.height,
      0.5 * size.width,
      0.2 * size.height,
    );
    _path.cubicTo(0.75 * size.width, 0.2 * size.height, 0.8 * size.width,
        0.7 * size.height, size.width, 0.7 * size.height);

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
            Size(0.85 * constraints.maxWidth, 0.4 * constraints.maxHeight);
        horizonPath = drawHorizonPath(canvasSize);
        verticalPaths = drawVerticalPaths(canvasSize);
        sunPath = drawSunPath(canvasSize);
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, RadioRamezanColors.ramady],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
            // image: DecorationImage(
            //   image: AssetImage('assets/images/golden_mosque_30percent.png'),
            //   fit: BoxFit.fitWidth,
            //   alignment: Alignment.bottomCenter,
            // ),
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
                  alignment: Alignment.topCenter),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: .15 * constraints.maxHeight,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: .09 * constraints.maxHeight,
                      width: (1 / 3) * constraints.maxWidth,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Image.asset('assets/images/city_frame.png'),
                          Text(
                            'تورنتو',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: .01 * constraints.maxHeight,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      height: .175 * constraints.maxHeight,
                      width: (2 / 18) * constraints.maxWidth,
                    ),
                    Container(
                      height: .175 * constraints.maxHeight,
                      width: (4 / 18) * constraints.maxWidth,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Image.asset('assets/images/date_frame.png'),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 0.04 * constraints.maxHeight),
                            child: Text(
                              'اردیبهشت',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 0.05 * constraints.maxHeight),
                            child: Text(
                              '26',
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
                    SizedBox(
                      height: .175 * constraints.maxHeight,
                      width: (1 / 18) * constraints.maxWidth,
                    ),
                    Container(
                      height: .175 * constraints.maxHeight,
                      width: (4 / 18) * constraints.maxWidth,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Image.asset('assets/images/date_frame.png'),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 0.04 * constraints.maxHeight),
                            child: Text(
                              'MAY',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 0.05 * constraints.maxHeight),
                            child: Text(
                              '10',
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
                    SizedBox(
                      height: .175 * constraints.maxHeight,
                      width: (1 / 18) * constraints.maxWidth,
                    ),
                    Container(
                      height: .175 * constraints.maxHeight,
                      width: (4 / 18) * constraints.maxWidth,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Image.asset('assets/images/date_frame.png'),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 0.04 * constraints.maxHeight),
                            child: Text(
                              'رمضان',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 0.05 * constraints.maxHeight),
                            child: Text(
                              '16',
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
                    SizedBox(
                      height: .175 * constraints.maxHeight,
                      width: (2 / 18) * constraints.maxWidth,
                    ),
                  ],
                ),
                SizedBox(
                  height: .01 * constraints.maxHeight,
                ),
                Container(
                  height: .4 * constraints.maxHeight,
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
                    ],
                  ),
                ),
                SizedBox(
                  height: .01 * constraints.maxHeight,
                ),
                Card(
                  elevation: 0,
                  shape: Border(
                    right: BorderSide(
                      color: RadioRamezanColors.goldy,
                      width: 5,
                    ),
                  ),
                  color: Colors.white60,
                  shadowColor: Color.fromRGBO(0, 0, 0, .25),
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: AnimatedCrossFade(
                    duration: Duration(seconds: 1),
                    firstChild: ListTile(
                      leading: Image.asset('assets/images/praying_hands.jpg'),
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
                          color: Color.fromRGBO(255, 0, 0, 1.0),
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
