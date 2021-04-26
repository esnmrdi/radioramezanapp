// loading required packages
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:radioramezan/globals.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Color.fromRGBO(33, 33, 33, 1.0)
            : Theme.of(context).primaryColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: GNav(
          gap: 0,
          activeColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor,
          iconSize: 28,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          duration: Duration(milliseconds: 500),
          tabBackgroundColor: Colors.white,
          tabs: [
            GButton(
              icon: CupertinoIcons.compass,
              text: 'قبله نما',
              iconColor: Colors.white,
            ),
            GButton(
              icon: CupertinoIcons.list_bullet,
              text: 'برنامه',
              iconColor: Colors.white,
            ),
            GButton(
              icon: CupertinoIcons.house_alt,
              text: 'خانه',
              iconColor: Colors.white,
            ),
            GButton(
              icon: CupertinoIcons.book,
              text: 'مناجات',
              iconColor: Colors.white,
            ),
            GButton(
              icon: CupertinoIcons.gear,
              text: 'تنظیمات',
              iconColor: Colors.white,
            ),
          ],
          selectedIndex: globals.navigatorIndex,
          onTabChange: (int index) {
            globals.navigatorIndex = index;
            globals.pageController.jumpToPage(index);
          },
        ),
      ),
    );
  }
}
