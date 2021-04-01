// loading required packages
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:radioramezan/globals.dart';

class SupportUsModal extends StatefulWidget {
  @override
  SupportUsModalState createState() => SupportUsModalState();
}

class SupportUsModalState extends State<SupportUsModal> {
  GlobalKey<ScaffoldState> supportUsModalScaffoldState;
  String paypalURL;
  String paypingURL;

  Future<String> loadTextAsset(String url) async {
    return await rootBundle.loadString(url);
  }

  @override
  void initState() {
    supportUsModalScaffoldState = GlobalKey<ScaffoldState>();
    paypalURL = 'https://www.paypal.com/paypalme2/RadioRamezan';
    paypingURL = 'https://www.payping.ir/@radioramezan';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top,
      child: Scaffold(
        key: supportUsModalScaffoldState,
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
          child: FutureBuilder(
            future: loadTextAsset('assets/texts/support_us.txt'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    SizedBox(height: 90),
                    Container(
                      child: Text(
                        'حمایت مالی',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Column(
                          children: <Widget>[
                            Text(snapshot.data),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: MaterialButton(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    color: Colors.white,
                                    onPressed: () {
                                      globals.launchURL(paypalURL);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      child: Image.asset(
                                        'assets/images/paypal.png',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  flex: 1,
                                  child: MaterialButton(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    color: Colors.white,
                                    onPressed: () {
                                      globals.launchURL(paypingURL);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      child: Image.asset(
                                          'assets/images/payping.png'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
        ),
      ),
    );
  }
}
