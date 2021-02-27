// loading required packages
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:radioramezan/globals.dart';

class CustomBottomNavigationBar extends StatelessWidget {
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GNav(
          gap: 8,
          activeColor: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).primaryColor
              : Colors.white,
          iconSize: 24,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          duration: Duration(milliseconds: 500),
          tabBackgroundColor: Theme.of(context).accentColor,
          tabs: [
            GButton(icon: Icons.explore_rounded, text: 'قبله نما'),
            GButton(
              icon: Icons.format_list_bulleted_rounded,
              text: 'برنامه',
            ),
            GButton(
              icon: Icons.home_rounded,
              text: 'خانه',
            ),
            GButton(
              icon: Icons.menu_book_rounded,
              text: 'ادعیه',
            ),
            GButton(
              icon: Icons.settings_rounded,
              text: 'تنظیمات',
            ),
          ],
          selectedIndex: Globals.navigatorIndex,
          onTabChange: (index) {
            Globals.navigatorIndex = index;
            Globals.pageController.jumpToPage(index);
          }
        ),
      ),
    );
  }
}
