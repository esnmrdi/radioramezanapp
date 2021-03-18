// loading required packages
import 'package:flutter/material.dart';
import 'package:radioramezan/theme.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: RadioRamezanColors.ramady,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 48,
                width: 48,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                'دریافت اطلاعات از سرور ...',
                style: TextStyle(
                  fontFamily: 'Sans',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
