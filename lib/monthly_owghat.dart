// loading required packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MonthlyOwghat extends StatelessWidget {
  Future<String> loadTextAsset() async {
    return await rootBundle.loadString('assets/texts/about_us.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top,
      child: FutureBuilder(
        future: loadTextAsset(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Text(snapshot.data),
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
