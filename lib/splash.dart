// loading required packages
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    if (kIsWeb) {
      final splashImage = html.document.getElementsByClassName('splash-img');
      if (splashImage.isNotEmpty) {
        splashImage.first.remove();
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: kIsWeb ? Colors.transparent : Theme.of(context).primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 48,
                width: 48,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    kIsWeb ? Theme.of(context).primaryColor : Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                'دریافت اطلاعات از سرور',
                style: TextStyle(
                  fontFamily: 'Sans',
                  color: kIsWeb ? Theme.of(context).primaryColor : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
