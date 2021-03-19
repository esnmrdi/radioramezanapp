// loading required packages
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/data_models/prayer_model.dart';
import 'package:radioramezan/prayer_view.dart';
import 'theme.dart';

class Prayers extends StatefulWidget {
  @override
  _Prayers createState() => _Prayers();
}

class _Prayers extends State<Prayers> {
  List<Prayer> searchResult = [];
  TextEditingController searchController;
  bool showSearchBox;

  void onSearchTextChanged(String text) async {
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
  }

  @override
  void initState() {
    showSearchBox = false;
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  itemCount: showSearchBox && searchResult.length != 0
                      ? searchResult.length
                      : globals.prayerList.length,
                  itemBuilder: (context, index) {
                    Prayer prayer = showSearchBox && searchResult.length != 0
                        ? searchResult[index]
                        : globals.prayerList[index];
                    return Column(
                      children: <Widget>[
                        Card(
                          elevation: 2,
                          margin: EdgeInsets.zero,
                          shadowColor: Colors.black.withOpacity(.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: InkWell(
                            onTap: () {
                              Future.delayed(
                                Duration(milliseconds: 250),
                                () {
                                  showMaterialModalBottomSheet(
                                    context: context,
                                    builder: (context) => PrayerView(
                                      prayer: prayer,
                                    ),
                                    duration: Duration(milliseconds: 500),
                                    enableDrag: false,
                                  );
                                },
                              );
                            },
                            borderRadius: BorderRadius.circular(5),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 1,
                                horizontal: 10,
                              ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                    'assets/images/praying_hands.jpg'),
                              ),
                              title: Text(
                                prayer.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                prayer.reciter,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ),
              showSearchBox
                  ? Container(
                      padding: EdgeInsets.all(5),
                      color: Colors.white,
                      child: Card(
                        elevation: 2,
                        shadowColor: Colors.black.withOpacity(.5),
                        color: RadioRamezanColors.goldy[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListTile(
                          leading: Icon(
                            CupertinoIcons.search,
                            size: 32.0,
                            color: Colors.black,
                          ),
                          title: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'جستجوی عنوان یا قاری',
                              border: InputBorder.none,
                            ),
                            onChanged: onSearchTextChanged,
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              CupertinoIcons.xmark,
                              size: 32.0,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                showSearchBox = false;
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        !showSearchBox
            ? Positioned(
                left: 10,
                bottom: 10,
                child: FloatingActionButton(
                  elevation: 2,
                  backgroundColor: RadioRamezanColors.ramady,
                  child: Icon(CupertinoIcons.search),
                  onPressed: () {
                    setState(() {
                      showSearchBox = true;
                    });
                  },
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
