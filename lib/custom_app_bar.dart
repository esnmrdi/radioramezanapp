// loading required packages
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/audio_player.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
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
          Icons.menu_rounded,
          color: Colors.white,
        ),
        onPressed: () {
          Globals.drawerKey.currentState.openDrawer();
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.radio_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            showMaterialModalBottomSheet(
              context: context,
              builder: (context) => AudioPlayer(),
              duration: Duration(milliseconds: 500),
            );
          },
        ),
      ],
    );
  }
}
