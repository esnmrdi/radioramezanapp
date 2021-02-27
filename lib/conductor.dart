// loading required packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart';
import 'package:radioramezan/audio_player.dart';
import 'theme.dart';
import 'data_models/conductor_model.dart';

Future<Conductor> fetchConductor() async {
  final _response =
      await get('https://m.radioramezan.com/api/radio-playlist.php?city=3');

  if (_response.statusCode == 200) {
    return Conductor.fromJson(jsonDecode(_response.body));
  } else {
    throw Exception('Failed to load the conductor!');
  }
}

Future<void> datePicker(BuildContext context) async {
  final DateTime pickedDate = await DatePicker.showSimpleDatePicker(
    context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2021),
    lastDate: DateTime(2025),
    dateFormat: "dd-MMMM-yyyy",
    locale: DateTimePickerLocale.en_us,
    looping: true,
    titleText: 'انتخاب تاریخ',
    confirmText: 'تایید',
    cancelText: 'انصراف',
  );

  if (pickedDate != null && pickedDate != DateTime.now()) {
    return pickedDate;
  }
}

void showRadioItemModal(BuildContext context, RadioItem radioItem) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Image.network(radioItem.poster),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Image.asset('assets/images/praying_hands.jpg'),
                RawMaterialButton(
                  elevation: 0,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: 96.0,
                    color: Color.fromRGBO(255, 255, 255, .75),
                  ),
                  // padding: EdgeInsets.all(12.0),
                  shape: CircleBorder(),
                  onPressed: () {
                    // showAudioPlayerModal(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              radioItem.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              radioItem.description,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.schedule_rounded,
                  color: RadioRamezanColors.ramady,
                ),
                SizedBox(width: 10),
                Text('پخش از'),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 172, 193, 1.0),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    intl.DateFormat.Hm()
                        .format(
                          DateTime.fromMillisecondsSinceEpoch(
                              radioItem.startPlay.toInt() * 1000),
                        )
                        .toString(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text('تا'),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(193, 0, 50, 1.0),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    intl.DateFormat.Hm()
                        .format(
                          DateTime.fromMillisecondsSinceEpoch(
                              radioItem.endPlay.toInt() * 1000),
                        )
                        .toString(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  radioItem.video
                      ? Icons.movie_creation_rounded
                      : Icons.speaker_rounded,
                  color: RadioRamezanColors.ramady,
                ),
                SizedBox(width: 10),
                Text(radioItem.video ? 'آیتم تصویری' : 'آیتم صوتی'),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Container conductor(BuildContext context) {
  return Container(
    child: FutureBuilder(
      future: fetchConductor(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 5),
            itemCount: snapshot.data.programs.length,
            itemBuilder: (context, index) {
              RadioItem radioItem = snapshot.data.programs[index];
              return Column(
                children: <Widget>[
                  Card(
                    elevation: 2,
                    shape: Border(
                      right: BorderSide(
                        color: RadioRamezanColors.ramady,
                        width: 5,
                      ),
                    ),
                    color: Colors.white,
                    shadowColor: Color.fromRGBO(0, 0, 0, .1),
                    margin: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            showRadioItemModal(context, radioItem);
                          },
                          child: ListTile(
                            // leading: Image.network(radioItem.poster),
                            leading:
                                Image.asset('assets/images/praying_hands.jpg'),
                            title: Text(
                              radioItem.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              radioItem.description,
                              overflow: TextOverflow.ellipsis,
                            ),
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
                                      intl.DateFormat.Hm()
                                          .format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                radioItem.startPlay.toInt() *
                                                    1000),
                                          )
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error}"),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    ),
  );
}
