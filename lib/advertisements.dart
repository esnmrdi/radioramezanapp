// loading required packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:radioramezan/globals.dart';

class Advertisements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kIsWeb
          ? (MediaQuery.of(context).size.height / globals.webAspectRatio) /
              globals.adAspectRatio
          : MediaQuery.of(context).size.width / globals.adAspectRatio,
      width: kIsWeb
          ? (MediaQuery.of(context).size.height / globals.webAspectRatio)
          : MediaQuery.of(context).size.width,
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
