// loading required packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radioramezan/theme.dart';

class AboutUs extends StatelessWidget {
  Future<String> loadTextAsset() async {
    return await rootBundle.loadString('assets/texts/about_us.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/golden_mosque_30percent.png'),
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
          future: loadTextAsset(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(height: 60),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'درباره ما',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: RadioRamezanColors.ramady,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: <Widget>[
                          Text(snapshot.data),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Image.asset('assets/images/faraj.png',
                                scale: 2),
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
    );
  }
}
