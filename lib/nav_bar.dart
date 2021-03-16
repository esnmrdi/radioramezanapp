// loading required packages
import 'package:flutter/material.dart';
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
          gap: 12,
          activeColor: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).primaryColor
              : Colors.white,
          iconSize: 32,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          duration: Duration(milliseconds: 500),
          tabBackgroundColor: Theme.of(context).accentColor,
          tabs: [
            GButton(icon: Icons.explore, text: 'قبله'),
            GButton(
              icon: Icons.format_list_bulleted,
              text: 'برنامه',
            ),
            GButton(
              icon: Icons.home,
              text: 'خانه',
            ),
            GButton(
              icon: Icons.menu_book,
              text: 'دعا',
            ),
            GButton(
              icon: Icons.settings,
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
