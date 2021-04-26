class Verse {
  final String arabic;
  final String farsi;

  Verse({
    this.arabic,
    this.farsi,
  });

  factory Verse.fromJson(Map<String, dynamic> parsedJson) {
    return Verse(
      arabic: parsedJson['ar'],
      farsi: parsedJson['fa'],
    );
  }
}

class Prayer {
  final String title;
  final String subtitle;
  final String audio;
  String category;
  final List<Verse> verses;

  Prayer({
    this.title,
    this.subtitle,
    this.audio,
    this.category,
    this.verses,
  });

  factory Prayer.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['verses'] as List;
    List<Verse> _verses = list.map((i) => Verse.fromJson(i)).toList();
    return Prayer(
      title: parsedJson['title'],
      subtitle: parsedJson['subtitle'],
      audio: parsedJson['audio'],
      category: parsedJson['category'],
      verses: _verses,
    );
  }
}
