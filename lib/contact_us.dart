// loading required packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radioramezan/theme.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/golden_mosque_30percent.png'),
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
          ),
        ),
        foregroundDecoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/modal_top.png'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 60),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'ارتباط با ما',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: RadioRamezanColors.ramady,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    // Text(snapshot.data),
                    SizedBox(height: 20),
                    // Image.asset('assets/images/faraj.png', scale: 2),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
