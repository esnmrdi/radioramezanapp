class Ad {
  final String banner;
  final String url;

  Ad({
    this.banner,
    this.url,
  });

  factory Ad.fromJson(Map<String, dynamic> parsedJson) {
    return Ad(
      banner: parsedJson['banner'],
      url: parsedJson['url'],
    );
  }
}
