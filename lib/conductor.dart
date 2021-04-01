// loading required packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:radioramezan/theme.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/data_models/radio_item_model.dart';
import 'package:radioramezan/data_models/city_model.dart';

class Conductor extends StatefulWidget {
  @override
  ConductorState createState() => ConductorState();
}

class ConductorState extends State<Conductor> {
  GlobalKey<ScaffoldState> conductorScaffoldKey;
  ScrollController scrollController;
  List<RadioItem> selectiveRadioItemList;
  DateTime pickedDate;
  bool isFetching;

  Future<Null> fetchRadioItemList(City city, DateTime date) async {
    isFetching = true;
    final response = await get(
        'https://m.radioramezan.com/api/radio-conductor.php?city=' +
            city.cityId.toString() +
            '&date=' +
            intl.DateFormat('yyyy-MM-dd').format(date));

    if (response.statusCode == 200) {
      isFetching = false;
      setState(() {
        if (selectiveRadioItemList != null) selectiveRadioItemList.clear();
        selectiveRadioItemList = (json.decode(response.body) as List)
            .map((i) => RadioItem.fromJson(i))
            .toList();
      });
    } else {
      throw Exception('Failed to fetch the conductor!');
    }
  }

  Future<Null> datePicker(BuildContext context) async {
    DateTime date = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: pickedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
      dateFormat: "dd-MMMM-yyyy",
      locale: DateTimePickerLocale.en_us,
      looping: false,
      titleText: 'انتخاب تاریخ',
      confirmText: 'تایید',
      cancelText: 'انصراف',
      textColor: Theme.of(context).primaryColor,
    );

    if (date != null && date != pickedDate) {
      setState(() {
        pickedDate = date;
        fetchRadioItemList(globals.city, pickedDate);
      });
    }
  }

  Future<void> displayDetailsDialog(BuildContext context, RadioItem radioItem) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                child: Image.asset(
                    'assets/images/poster_' + radioItem.category + '.jpg'),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Text(
                      radioItem.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      radioItem.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    conductorScaffoldKey = GlobalKey<ScaffoldState>();
    scrollController = ScrollController(
        // initialScrollOffset: globals.currentAndNextItem[0] * 85.0,
        // keepScrollOffset: false,
        );
    isFetching = false;
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: conductorScaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
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
          IconButton(
            icon: Icon(
              CupertinoIcons.calendar,
              color: Colors.white,
            ),
            onPressed: () {
              datePicker(context);
            },
          ),
        ],
        brightness: Brightness.dark,
      ),
      body: Container(
        color: Theme.of(context).primaryColor.withOpacity(.1),
        child: isFetching
            ? Center(
                child: CircularProgressIndicator(),
              )
            : DraggableScrollbar.semicircle(
                controller: scrollController,
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  itemCount: selectiveRadioItemList != null
                      ? selectiveRadioItemList.length
                      : globals.radioItemList.length,
                  itemBuilder: (context, index) {
                    RadioItem radioItem = selectiveRadioItemList != null
                        ? selectiveRadioItemList[index]
                        : globals.radioItemList[index];
                    return Column(
                      children: <Widget>[
                        Card(
                          elevation: 2,
                          margin: EdgeInsets.zero,
                          color: index == globals.currentAndNextItem[0] &&
                                  (pickedDate == null ||
                                      pickedDate
                                              .difference(DateTime.now())
                                              .inDays ==
                                          0)
                              ? RadioRamezanColors.goldy[100]
                              : Colors.white,
                          shadowColor: Colors.black.withOpacity(.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: InkWell(
                            onTap: () {
                              Future.delayed(
                                Duration(milliseconds: 250),
                                () {
                                  displayDetailsDialog(context, radioItem);
                                },
                              );
                            },
                            borderRadius: BorderRadius.circular(5),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: radioItem.description != '' ? 2 : 10,
                                horizontal: 10,
                              ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset('assets/images/poster_' +
                                    radioItem.category +
                                    '.jpg'),
                              ),
                              title: Text(
                                radioItem.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: radioItem.description != ''
                                  ? Text(
                                      radioItem.description,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    )
                                  : null,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: index ==
                                                  globals
                                                      .currentAndNextItem[0] &&
                                              (pickedDate == null ||
                                                  pickedDate
                                                          .difference(
                                                              DateTime.now())
                                                          .inDays ==
                                                      0)
                                          ? Colors.red
                                          : Color.fromRGBO(0, 172, 193, 1.0),
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      index == globals.currentAndNextItem[0] &&
                                              (pickedDate == null ||
                                                  pickedDate
                                                          .difference(
                                                              DateTime.now())
                                                          .inDays ==
                                                      0)
                                          ? 'پخش زنده'
                                          : radioItem.startHour,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
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
      ),
    );
  }
}
