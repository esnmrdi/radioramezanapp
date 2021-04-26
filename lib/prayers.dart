// loading required packages
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/prayer_view.dart';
import 'package:radioramezan/data_models/prayer_model.dart';
import 'package:radioramezan/theme.dart';

class Prayers extends StatefulWidget {
  @override
  PrayersState createState() => PrayersState();
}

class PrayersState extends State<Prayers> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> prayersScaffoldKey;
  TabController tabController;
  ScrollController scrollController;
  List<Prayer> searchResult = [];
  TextEditingController searchController;
  bool isSearching;
  Timer checkStoppedTyping;
  int selectedTabIndex;
  Map<int, String> searchHint = {
    0: 'سوره',
    1: 'دعا',
    2: 'خطبه، نامه و حکمت',
    3: 'دعا',
  };

  void onChangeQueryHandler(String text) {
    const duration = Duration(milliseconds: 800);
    if (checkStoppedTyping != null) {
      setState(() => checkStoppedTyping.cancel());
    }
    setState(() => checkStoppedTyping = Timer(duration, () => updateSearchQuery(text)));
  }

  void updateSearchQuery(String text) async {
    searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    globals.sources[globals.sources.keys.toList()[selectedTabIndex]].forEach((prayer) {
      if (prayer.title.contains(text)) searchResult.add(prayer);
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
    tabController = TabController(length: globals.sources.length, vsync: this);
    searchController = TextEditingController();
    isSearching = false;
    selectedTabIndex = 0;
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "جستجوی " + searchHint[selectedTabIndex],
                  hintStyle: TextStyle(
                    color: Colors.white30,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
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
        actions: [
          isSearching
              ? IconButton(
                  icon: Icon(
                    CupertinoIcons.xmark,
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
        bottom: TabBar(
            controller: tabController,
            isScrollable: true,
            onTap: (tabIndex) {
              setState(() {
                searchController.clear();
                searchResult.clear();
                selectedTabIndex = tabIndex;
              });
            },
            tabs: List<Widget>.generate(globals.sources.length, (int index) {
              return Tab(text: globals.sources.keys.toList()[index]);
            })),
        brightness: Brightness.dark,
      ),
      body: TabBarView(
        controller: tabController,
        children: List<Widget>.generate(
          globals.sources.length,
          (int sourceIndex) {
            return Container(
              child: DraggableScrollbar.semicircle(
                controller: scrollController,
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  itemCount: isSearching && searchResult.isNotEmpty
                      ? searchResult.length
                      : globals.sources[globals.sources.keys.toList()[sourceIndex]].length,
                  itemBuilder: (context, index) {
                    Prayer prayer = isSearching && searchResult.isNotEmpty
                        ? searchResult[index]
                        : globals.sources[globals.sources.keys.toList()[sourceIndex]][index];
                    return Column(
                      children: [
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
                              // isThreeLine: prayer.subtitle != '' ? true : false,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: prayer.subtitle != '' ? 2 : 10,
                                horizontal: 10,
                              ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset('images/poster_' + prayer.category + '_prayers.jpg'),
                              ),
                              title: Text(
                                prayer.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: prayer.subtitle != ''
                                  ? Text(
                                      prayer.subtitle,
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
            );
          },
        ),
      ),
    );
  }
}
