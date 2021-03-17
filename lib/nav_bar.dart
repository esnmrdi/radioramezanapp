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
            : Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GNav(
          gap: 0,
          activeColor: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).primaryColor
              : Colors.white,
          iconSize: 28,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          duration: Duration(milliseconds: 500),
          tabBackgroundColor: Theme.of(context).accentColor,
          tabs: [
            GButton(
              icon: CupertinoIcons.compass_fill,
              text: 'قبله',
            ),
            GButton(
              icon: CupertinoIcons.list_bullet,
              text: 'برنامه',
            ),
            GButton(
              icon: CupertinoIcons.house_fill,
              text: 'خانه',
            ),
            GButton(
              icon: CupertinoIcons.book_fill,
              text: 'دعا',
            ),
            GButton(
              icon: CupertinoIcons.gear_solid,
              text: 'تنظیم',
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
