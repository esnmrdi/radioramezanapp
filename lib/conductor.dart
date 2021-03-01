// loading required packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:radioramezan/audio_player.dart';
import 'package:radioramezan/main.dart';
import 'theme.dart';
import 'data_models/programs_model.dart';

class Conductor extends StatelessWidget {
  Future<ProgramsList> fetchProgramsList() async {
    final _response =
        await get('https://m.radioramezan.com/api/radio-playlist.php?city=3');

    if (_response.statusCode == 200) {
      return ProgramsList.fromJson(jsonDecode(_response.body));
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
              Image.network(radioItem.poster),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder(
            future: fetchProgramsList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  itemCount: snapshot.data.programs.length,
                  itemBuilder: (context, index) {
                    final GlobalKey<ExpansionTileCardState> cardKey =
                        GlobalKey();
                    RadioItem radioItem = snapshot.data.programs[index];
                    return Column(
                      children: <Widget>[
                        ExpansionTileCard(
                          key: cardKey,
                          initialElevation: 2,
                          elevation: 2,
                          expandedColor: RadioRamezanColors.goldy[100],
                          borderRadius: BorderRadius.circular(5),
                          shadowColor: Colors.black.withOpacity(.5),
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
                                            radioItem.startPlay.toInt() * 1000),
                                      )
                                      .toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          children: <Widget>[
                            Divider(
                              thickness: 1.0,
                              height: 1.0,
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.spaceAround,
                              buttonHeight: 52.0,
                              buttonMinWidth: 90.0,
                              children: <Widget>[
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () {
                                    showRadioItemModal(context, radioItem);
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Icon(Icons.info_outline_rounded),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2.0),
                                      ),
                                      Text('نمایش جزئیات'),
                                    ],
                                  ),
                                ),
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  onPressed: () {
                                    showCupertinoModalBottomSheet(
                                      context: context,
                                      builder: (context) => AudioPlayer(),
                                      duration: Duration(milliseconds: 500),
                                      expand: true,
                                    );
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Icon(Icons.play_arrow_rounded),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2.0),
                                      ),
                                      Text('پخش از آرشیو'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
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
          Positioned(
            left: 10,
            bottom: 10,
            child: FloatingActionButton(
              elevation: 2,
              backgroundColor: RadioRamezanColors.goldy[600],
              child: Icon(Icons.date_range_rounded),
              onPressed: () {
                datePicker(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
