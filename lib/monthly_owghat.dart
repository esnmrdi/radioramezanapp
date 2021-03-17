// loading required packages
import 'package:flutter/material.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/theme.dart';
import 'data_models/owghat_model.dart';

class MonthlyOwghat extends StatefulWidget {
  @override
  _MonthlyOwghat createState() => _MonthlyOwghat();
}

class _MonthlyOwghat extends State<MonthlyOwghat> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top,
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
              alignment: Alignment.topCenter),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 90),
            Container(
              child: Text(
                'اوقات شرعی ماه جاری',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: RadioRamezanColors.ramady,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'روز',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'اذان\nصبح',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'طلوع\nآفتاب',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'اذان\nظهر',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'غروب\nآفتاب',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'اذان\nمغرب',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: globals.owghatList.length,
                      itemBuilder: (context, index) {
                        Owghat owghat = globals.owghatList[index];
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: 30,
                          color: index == DateTime.now().day - 1
                              ? RadioRamezanColors.goldy[200]
                              : index % 2 == 0
                                  ? RadioRamezanColors.ramady.withOpacity(.05)
                                  : Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: Text((index + 1).toString()),
                              ),
                              Text(
                                owghat.sobh,
                              ),
                              Text(
                                owghat.sunrise,
                              ),
                              Text(
                                owghat.zohr,
                              ),
                              Text(
                                owghat.sunset,
                              ),
                              Text(
                                owghat.maghreb,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
