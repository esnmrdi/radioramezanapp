// loading required packages
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vector_math/vector_math.dart' as vmath;
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/theme.dart';

class Qibla extends StatefulWidget {
  @override
  QiblaState createState() => QiblaState();
}

class QiblaState extends State<Qibla> {
  GlobalKey<ScaffoldState> qiblaScaffoldKey;
  Completer<GoogleMapController> mapController;
  CameraPosition montrealCameraPosition;
  double kaabaOffset; // Montreal offset from Kaaba in radians

  Future<LatLng> getUserPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    Position currentPosition;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'سرویس مکان یابی گوشی شما غیرفعال است.',
            style: TextStyle(fontFamily: 'Sans'),
          ),
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            textColor: RadioRamezanColors.goldy,
            label: 'ای بابا!',
            onPressed: () async {
              Geolocator.openLocationSettings();
            },
          ),
        ),
      );
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'متاسفانه اجازه دسترسی به مکان صادر نشد.',
              style: TextStyle(fontFamily: 'Sans'),
            ),
            duration: Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              textColor: RadioRamezanColors.goldy,
              label: 'ای بابا!',
              onPressed: () async {},
            ),
          ),
        );
      }
    }

    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    return LatLng(currentPosition.latitude, currentPosition.longitude);
  }

  Future<Null> focusOnUserPosition() async {
    final GoogleMapController controller = await mapController.future;
    final CameraPosition userCameraPosition = CameraPosition(
      target: await getUserPosition(),
      zoom: 16,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(userCameraPosition));
  }

  double kaabaOffsetFromNorth(CameraPosition mapCameraPosition) {
    final LatLng kaabaPosition = LatLng(21.4225, 39.8262);
    var origin = mapCameraPosition.target;
    var orLa = vmath.radians(origin.latitude);
    var orLo = vmath.radians(origin.longitude);
    var deLa = vmath.radians(kaabaPosition.latitude);
    var deLo = vmath.radians(kaabaPosition.longitude);
    var toDegrees = vmath.degrees(atan(sin(deLo - orLo) / ((cos(orLa) * tan(deLa)) - (sin(orLa) * cos(deLo - orLo)))));

    if (orLa > deLa) {
      if ((orLo > deLo || orLo < vmath.radians(-180) + deLo) && toDegrees > 0 && toDegrees <= 90) {
        toDegrees += 180;
      } else if (orLo <= deLo && orLo >= vmath.radians(-180) + deLo && toDegrees > -90 && toDegrees < 0) {
        toDegrees += 180;
      }
    }
    if (orLa < deLa) {
      if ((orLo > deLo || orLo < vmath.radians(-180) + deLo) && toDegrees > 0 && toDegrees < 90) {
        toDegrees += 180;
      }
      if (orLo <= deLo && orLo >= vmath.radians(-180) + deLo && toDegrees > -90 && toDegrees <= 0) {
        toDegrees += 180;
      }
    }

    return vmath.radians(toDegrees);
  }

  @override
  void initState() {
    qiblaScaffoldKey = GlobalKey<ScaffoldState>();
    mapController = Completer();
    montrealCameraPosition = CameraPosition(
      target: LatLng(45.5017, -73.5673),
      zoom: 16,
    );
    kaabaOffset = 1.0241592;
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: qiblaScaffoldKey,
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
              CupertinoIcons.scope,
              color: Colors.white,
            ),
            onPressed: () {
              focusOnUserPosition();
            },
          ),
        ],
        brightness: Brightness.dark,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            child: Stack(
              alignment: Alignment(.0, .0),
              children: [
                Container(
                  child: GoogleMap(
                    mapType: MapType.hybrid,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                    rotateGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    initialCameraPosition: montrealCameraPosition,
                    onMapCreated: (GoogleMapController controller) {
                      mapController.complete(controller);
                      kaabaOffset = kaabaOffsetFromNorth(montrealCameraPosition);
                    },
                    onCameraMove: (CameraPosition mapCameraPosition) {
                      setState(() {
                        kaabaOffset = kaabaOffsetFromNorth(
                          mapCameraPosition,
                        );
                      });
                    },
                    onCameraIdle: () {},
                  ),
                ),
                Positioned(
                  child: IgnorePointer(
                    child: Image.asset('images/compass.png'),
                  ),
                ),
                Positioned(
                  top:
                      (constraints.maxHeight / 2) + .9 * (constraints.maxWidth / 2) * sin(-(pi / 2 - kaabaOffset)) - 18,
                  left:
                      (constraints.maxWidth / 2) + .9 * (constraints.maxWidth / 2) * cos(-(pi / 2 - kaabaOffset)) - 18,
                  child: IgnorePointer(
                    child: Image.asset(
                      'images/kaaba.png',
                      height: 36,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
