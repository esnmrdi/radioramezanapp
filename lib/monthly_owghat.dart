// loading required packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/theme.dart';
import 'data_models/owghat_model.dart';

class MonthlyOwghat extends StatefulWidget {
  @override
  MonthlyOwghatState createState() => MonthlyOwghatState();
}

class MonthlyOwghatState extends State<MonthlyOwghat> {
  GlobalKey<ScaffoldState> monthlyOwghatScaffoldState;
  ScrollController scrollController;

  @override
  void initState() {
    monthlyOwghatScaffoldState = GlobalKey<ScaffoldState>();
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          kIsWeb && MediaQuery.of(context).orientation == Orientation.landscape
              ? EdgeInsets.symmetric(
                  horizontal: (MediaQuery.of(context).size.width -
                          MediaQuery.of(context).size.height /
                              globals.webAspectRatio) /
                      2)
              : null,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Scaffold(
        key: monthlyOwghatScaffoldState,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              top: kIsWeb
                  ? globals.webTopPaddingFAB
                  : MediaQuery.of(context).padding.top,
            ),
            child: FloatingActionButton(
              elevation: 2,
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(CupertinoIcons.arrow_left),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/golden_mosque_20percent.png'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            ),
          ),
          foregroundDecoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/modal_top.png'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: .25 *
                    (kIsWeb
                        ? MediaQuery.of(context).size.height /
                            globals.webAspectRatio
                        : MediaQuery.of(context).size.width),
              ),
              Container(
                child: Text(
                  'اوقات شرعی ماه جاری',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'روز',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          'اذان\nصبح',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          'طلوع\nآفتاب',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          'اذان\nظهر',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          'غروب\nآفتاب',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          'اذان\nمغرب',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: DraggableScrollbar.semicircle(
                  controller: scrollController,
                  child: ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.only(bottom: 20),
                    itemCount: globals.owghatList.length,
                    itemBuilder: (context, index) {
                      Owghat owghat = globals.owghatList[index];
                      return Container(
                        height: 30,
                        color:
                            index == tz.TZDateTime.now(globals.timeZone).day - 1
                                ? RadioRamezanColors.goldy[100]
                                : index % 2 == 0
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.05)
                                    : Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: 20),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  (index + 1).toString(),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  owghat.sobh,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  owghat.sunrise,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  owghat.zohr,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  owghat.sunset,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  owghat.maghreb,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
