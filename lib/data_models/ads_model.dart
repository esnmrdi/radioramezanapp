class Ad {
  final String url;
  final String link;

  Ad({
    this.url,
    this.link,
  });

  factory Ad.fromJson(Map<String, dynamic> parsedJson) {
    return Ad(
      url: parsedJson['url'],
      link: parsedJson['link'],
    );
  }
}
