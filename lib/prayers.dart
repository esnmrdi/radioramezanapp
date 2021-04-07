// loading required packages
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/prayer_view.dart';
import 'package:radioramezan/data_models/prayer_model.dart';
import 'package:radioramezan/theme.dart';

class Prayers extends StatefulWidget {
  @override
  PrayersState createState() => PrayersState();
}

class PrayersState extends State<Prayers> {
  GlobalKey<ScaffoldState> prayersScaffoldKey;
  ScrollController scrollController;
  List<Prayer> searchResult = [];
  TextEditingController searchController;
  bool isSearching;
  Timer checkStoppedTyping;

  void onChangeQueryHandler(String text) {
    const duration = Duration(milliseconds: 800);
    if (checkStoppedTyping != null) {
      setState(() => checkStoppedTyping.cancel());
    }
    setState(() =>
        checkStoppedTyping = Timer(duration, () => updateSearchQuery(text)));
  }

  void updateSearchQuery(String text) async {
    searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    globals.prayerList.forEach((prayer) {
      if (prayer.title.contains(text) || prayer.reciter.contains(text))
        searchResult.add(prayer);
    });
    setState(() {});
    if (searchResult.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'عنوان مورد نظر شما یافت نشد.',
            style: TextStyle(fontFamily: 'Sans'),
          ),
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            textColor: RadioRamezanColors.goldy,
            label: 'ای بابا!',
            onPressed: () {},
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    prayersScaffoldKey = GlobalKey<ScaffoldState>();
    scrollController = ScrollController();
    searchController = TextEditingController();
    isSearching = false;
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: prayersScaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "جستجوی عنوان یا قاری",
                  hintStyle: TextStyle(
                    color: Colors.white30,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
                onChanged: (text) => onChangeQueryHandler(text),
              )
            : Text(
                'رادیو رمضان',
                textAlign: TextAlign.center,
              ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            globals.mainScaffoldKey.currentState.openDrawer();
          },
        ),
        actions: <Widget>[
          isSearching
              ? IconButton(
                  icon: Icon(
                    CupertinoIcons.arrow_left,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(
                    CupertinoIcons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                ),
        ],
        brightness: Brightness.dark,
      ),
      body: Container(
        color: Settings.getValue<bool>("darkThemeEnabled", false)
            ? Color.fromRGBO(50, 50, 50, .5)
            : Theme.of(context).primaryColor.withOpacity(.1),
        child: DraggableScrollbar.semicircle(
          controller: scrollController,
          child: ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            itemCount: isSearching && searchResult.length != 0
                ? searchResult.length
                : globals.prayerList.length,
            itemBuilder: (context, index) {
              Prayer prayer = isSearching && searchResult.length != 0
                  ? searchResult[index]
                  : globals.prayerList[index];
              return Column(
                children: <Widget>[
                  Card(
                    elevation: 2,
                    margin: EdgeInsets.zero,
                    color: Colors.white,
                    shadowColor: Colors.black.withOpacity(.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: InkWell(
                      onTap: () {
                        Future.delayed(
                          Duration(milliseconds: 250),
                          () {
                            Navigator.of(context).push(
                              globals.createRoute(PrayerView(prayer: prayer)),
                            );
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(5),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: prayer.reciter != '' ? 2 : 10,
                          horizontal: 10,
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset('images/poster_' +
                              prayer.category +
                              '_prayers.jpg'),
                        ),
                        title: Text(
                          prayer.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: prayer.reciter != ''
                            ? Text(
                                prayer.reciter,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
