// loading required packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/theme.dart';
import 'data_models/owghat_model.dart';

class MonthlyOwghat extends StatefulWidget {
  @override
  MonthlyOwghatState createState() => MonthlyOwghatState();
}

class MonthlyOwghatState extends State<MonthlyOwghat> {
  GlobalKey<ScaffoldState> monthlyOwghatScaffoldKey;
  ScrollController scrollController;

  @override
  void initState() {
    monthlyOwghatScaffoldKey = GlobalKey<ScaffoldState>();
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
      margin: kIsWeb && MediaQuery.of(context).size.width > MediaQuery.of(context).size.height / globals.webAspectRatio
          ? EdgeInsets.symmetric(
              horizontal:
                  (MediaQuery.of(context).size.width - MediaQuery.of(context).size.height / globals.webAspectRatio) / 2)
          : null,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: ClipRRect(
        child: Scaffold(
          key: monthlyOwghatScaffoldKey,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('images/golden_mosque_20percent.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    WaveWidget(
                      config: CustomConfig(
                        colors: [Colors.white70, Colors.white54, Colors.white30, Colors.white],
                        durations: [32000, 16000, 8000, 4000],
                        heightPercentages: [.65, .68, .75, .8],
                      ),
                      waveAmplitude: 0,
                      backgroundColor: Theme.of(context).primaryColor,
                      size: Size(
                        MediaQuery.of(context).size.width,
                        100,
                      ),
                    ),
                    Container(
                      height: 100,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'اوقات شرعی ماه جاری',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          FloatingActionButton(
                            elevation: 2,
                            backgroundColor: Colors.white,
                            child: Icon(
                              CupertinoIcons.xmark,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(20),
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
                          color: index == DateTime.now().day - 1
                              ? RadioRamezanColors.goldy[100]
                              : index % 2 == 0
                                  ? Theme.of(context).primaryColor.withOpacity(.05)
                                  : Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
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
      ),
    );
  }
}
