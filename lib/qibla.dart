// loading required packages
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vector_math/vector_math.dart' as vmath;
import 'package:radioramezan/theme.dart';

class Qibla extends StatefulWidget {
  @override
  _Qibla createState() => _Qibla();
}

class _Qibla extends State<Qibla> {
  Completer<GoogleMapController> mapController = Completer();
  final CameraPosition montrealCameraPosition = CameraPosition(
    target: LatLng(45.5017, -73.5673),
    zoom: 16,
  );
  double kaabaOffset = 1.0241592; // Montreal offset from Kaaba in radians

  Future<LatLng> getUserPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    Position currentPosition;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
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

    controller
        .animateCamera(CameraUpdate.newCameraPosition(userCameraPosition));
  }

  double kaabaOffsetFromNorth(CameraPosition mapCameraPosition) {
    final LatLng kaabaPosition = LatLng(21.4225, 39.8262);
    var origin = mapCameraPosition.target;
    var orLa = vmath.radians(origin.latitude);
    var orLo = vmath.radians(origin.longitude);
    var deLa = vmath.radians(kaabaPosition.latitude);
    var deLo = vmath.radians(kaabaPosition.longitude);
    var toDegrees = vmath.degrees(atan(sin(deLo - orLo) /
        ((cos(orLa) * tan(deLa)) - (sin(orLa) * cos(deLo - orLo)))));

    if (orLa > deLa) {
      if ((orLo > deLo || orLo < vmath.radians(-180) + deLo) &&
          toDegrees > 0 &&
          toDegrees <= 90) {
        toDegrees += 180;
      } else if (orLo <= deLo &&
          orLo >= vmath.radians(-180) + deLo &&
          toDegrees > -90 &&
          toDegrees < 0) {
        toDegrees += 180;
      }
    }
    if (orLa < deLa) {
      if ((orLo > deLo || orLo < vmath.radians(-180) + deLo) &&
          toDegrees > 0 &&
          toDegrees < 90) {
        toDegrees += 180;
      }
      if (orLo <= deLo &&
          orLo >= vmath.radians(-180) + deLo &&
          toDegrees > -90 &&
          toDegrees <= 0) {
        toDegrees += 180;
      }
    }

    return vmath.radians(toDegrees);
  }

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          child: Stack(
            alignment: Alignment(.0, .0),
            children: <Widget>[
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
                  child: Image.asset('assets/images/compass.png'),
                ),
              ),
              Positioned(
                top: (constraints.maxHeight / 2) +
                    .9 *
                        (constraints.maxWidth / 2) *
                        sin(-(pi / 2 - kaabaOffset)) -
                    18,
                left: (constraints.maxWidth / 2) +
                    .9 *
                        (constraints.maxWidth / 2) *
                        cos(-(pi / 2 - kaabaOffset)) -
                    18,
                child: IgnorePointer(
                  child: Image.asset(
                    'assets/images/kaaba.png',
                    height: 36,
                  ),
                ),
              ),
              Positioned(
                left: 10,
                bottom: 10,
                child: FloatingActionButton(
                  elevation: 2,
                  backgroundColor: RadioRamezanColors.ramady,
                  child: Icon(CupertinoIcons.scope),
                  onPressed: () {
                    focusOnUserPosition();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
