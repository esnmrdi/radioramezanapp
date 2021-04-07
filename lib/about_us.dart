// loading required packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:radioramezan/globals.dart';

class AboutUs extends StatefulWidget {
  @override
  AboutUsState createState() => AboutUsState();
}

class AboutUsState extends State<AboutUs> {
  GlobalKey<ScaffoldState> aboutUsScaffoldKey;
  ScrollController scrollController;

  Future<String> loadTextAsset(String url) async {
    return await rootBundle.loadString(url);
  }

  @override
  void initState() {
    aboutUsScaffoldKey = GlobalKey<ScaffoldState>();
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
      child: ClipRRect(
        child: Scaffold(
          key: aboutUsScaffoldKey,
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
                image: AssetImage('images/golden_mosque_20percent.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
            foregroundDecoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/modal_top.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
            child: FutureBuilder(
              future: loadTextAsset('texts/about_us.txt'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
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
                        child: DraggableScrollbar.semicircle(
                          controller: scrollController,
                          child: ListView.builder(
                            controller: scrollController,
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Column(
                                children: <Widget>[
                                  Text(snapshot.data),
                                  SizedBox(height: 20),
                                  Image.asset('images/faraj.png', scale: 2),
                                ],
                              );
                            },
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
      ),
    );
  }
}
