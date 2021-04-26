// loading required packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
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
      margin: kIsWeb && MediaQuery.of(context).size.width > MediaQuery.of(context).size.height / globals.webAspectRatio
          ? EdgeInsets.symmetric(
              horizontal:
                  (MediaQuery.of(context).size.width - MediaQuery.of(context).size.height / globals.webAspectRatio) / 2)
          : null,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: ClipRRect(
        child: Scaffold(
          key: aboutUsScaffoldKey,
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
            child: FutureBuilder(
              future: loadTextAsset('texts/about_us.txt'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
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
                                  'درباره ما',
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
                      Expanded(
                        flex: 1,
                        child: DraggableScrollbar.semicircle(
                          controller: scrollController,
                          child: ListView.builder(
                            controller: scrollController,
                            padding: EdgeInsets.all(20),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
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
