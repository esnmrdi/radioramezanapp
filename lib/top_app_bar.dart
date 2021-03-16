// loading required packages
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/radio.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        'رادیو رمضان',
        textAlign: TextAlign.center,
      ),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: () {
          globals.drawerKey.currentState.openDrawer();
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.radio,
            color: Colors.white,
          ),
          onPressed: () {
            Future.delayed(
              Duration(milliseconds: 250),
              () {
                showMaterialModalBottomSheet(
                  context: context,
                  builder: (context) => RadioPlayer(),
                  duration: Duration(milliseconds: 500),
                  enableDrag: true,
                );
              },
            );
          },
        ),
      ],
      brightness: Brightness.dark,
    );
  }
}
