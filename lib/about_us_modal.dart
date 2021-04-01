// loading required packages
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class AboutUsModal extends StatefulWidget {
  @override
  AboutUsModalState createState() => AboutUsModalState();
}

class AboutUsModalState extends State<AboutUsModal> {
  GlobalKey<ScaffoldState> aboutUsModalScaffoldKey;

  Future<String> loadTextAsset(String url) async {
    return await rootBundle.loadString(url);
  }

  @override
  void initState() {
    aboutUsModalScaffoldKey = GlobalKey<ScaffoldState>();
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
        key: aboutUsModalScaffoldKey,
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
            future: loadTextAsset('assets/texts/about_us.txt'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    SizedBox(height: 90),
                    Container(
                      child: Text(
                        'درباره ما',
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
                            Image.asset('assets/images/faraj.png', scale: 2),
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
