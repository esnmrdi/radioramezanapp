// loading required packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/theme.dart';

class SupportUs extends StatelessWidget {
  final String paypalURL = 'https://www.paypal.com/paypalme2/RadioRamezan';
  final String paypingURL = 'https://www.payping.ir/@radioramezan';

  Future<String> loadTextAsset(String url) async {
    return await rootBundle.loadString(url);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      color: RadioRamezanColors.ramady,
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
                            Container(
                              height: 55,
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
                            Container(
                              height: 55,
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
                                  child:
                                      Image.asset('assets/images/payping.png'),
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
    );
  }
}
