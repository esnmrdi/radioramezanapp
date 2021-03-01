// loading required packages
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:radioramezan/about_us.dart';
import 'package:radioramezan/contact_us.dart';
import 'package:radioramezan/support_us.dart';
import 'package:radioramezan/share_to_others.dart';
import 'package:radioramezan/monthly_owghat.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/golden_mosque_30percent.png'),
            fit: BoxFit.contain,
            alignment: Alignment.bottomLeft,
          ),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color.fromRGBO(178, 73, 135, 1.0),
                      Color.fromRGBO(128, 44, 96, 1.0),
                    ],
                    radius: 1.0,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                      'assets/images/logo_white_transparent_background.png'),
                ),
              ),
              ListTile(
                leading: Icon(Icons.format_list_numbered_rtl_rounded),
                title: Text(
                  'اوقات شرعی ماه جاری',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: Icon(Icons.arrow_left_rounded),
                onTap: () {
                  Navigator.pop(context);
                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) => MonthlyOwghat(),
                    duration: Duration(milliseconds: 500),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.monetization_on_rounded),
                title: Text(
                  'حمایت مالی',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: Icon(Icons.arrow_left_rounded),
                onTap: () {
                  Navigator.pop(context);
                  showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) => SupportUs(),
                    duration: Duration(milliseconds: 500),
                    expand: false,
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.share_rounded),
                title: Text(
                  'معرفی به دیگران',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: Icon(Icons.arrow_left_rounded),
                onTap: () {
                  Navigator.pop(context);
                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) => ShareToOthers(),
                    duration: Duration(milliseconds: 500),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  'درباره ما',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: Icon(Icons.arrow_left_rounded),
                onTap: () {
                  Navigator.pop(context);
                  showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) => AboutUs(),
                    duration: Duration(milliseconds: 500),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.email_rounded),
                title: Text(
                  'ارتباط با ما',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: Icon(Icons.arrow_left_rounded),
                onTap: () {
                  Navigator.pop(context);
                  showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) => ContactUs(),
                    duration: Duration(milliseconds: 500),
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  'نسخه 1.0.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
