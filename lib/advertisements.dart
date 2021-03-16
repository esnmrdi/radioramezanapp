// loading required packages
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:radioramezan/globals.dart';

class Advertisements extends StatefulWidget {
  @override
  _Advertisements createState() => _Advertisements();
}

class _Advertisements extends State<Advertisements> {
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
    return Container(
      height: MediaQuery.of(context).size.width / 6.4,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.zero,
      child: CarouselSlider(
        options: CarouselOptions(
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: true,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 10),
          autoPlayAnimationDuration: Duration(seconds: 1),
          autoPlayCurve: Curves.fastOutSlowIn,
          scrollDirection: Axis.horizontal,
        ),
        items: globals.adList.map((ad) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  globals.launchURL(ad.url);
                },
                child: Image.network(
                  ad.banner,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
