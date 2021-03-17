// loading required packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/theme.dart';
import 'package:radioramezan/data_models/radio_item_model.dart';
import 'package:radioramezan/data_models/city_model.dart';

class Conductor extends StatefulWidget {
  @override
  _Conductor createState() => _Conductor();
}

class _Conductor extends State<Conductor> {
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
      textColor: RadioRamezanColors.ramady,
    );

    if (date != null && date != pickedDate) {
      setState(() {
        pickedDate = date;
        fetchRadioItemList(globals.city, pickedDate);
      });
    }
  }

  @override
  void initState() {
    isFetching = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: isFetching
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  itemCount: selectiveRadioItemList != null ? selectiveRadioItemList.length : globals.radioItemList.length,
                  itemBuilder: (context, index) {
                    RadioItem radioItem = selectiveRadioItemList != null ? selectiveRadioItemList[index] : globals.radioItemList[index];
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
                                () {},
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
                                radioItem.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(radioItem.description,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black54,
                                  )),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 172, 193, 1.0),
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      radioItem.startHour,
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
        Positioned(
          left: 10,
          bottom: 10,
          child: FloatingActionButton(
            elevation: 2,
            backgroundColor: RadioRamezanColors.ramady,
            child: Icon(Icons.date_range),
            onPressed: () {
              datePicker(context);
            },
          ),
        )
      ],
    );
  }
}
