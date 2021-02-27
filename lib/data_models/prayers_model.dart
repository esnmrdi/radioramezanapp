class Verse {
  final String arabic;
  final String persian;

  Verse({
    this.arabic,
    this.persian,
  });

  factory Verse.fromJson(Map<String, dynamic> parsedJson) {
    return Verse(
      arabic: parsedJson['arabic'],
      persian: parsedJson['persian'],
    );
  }
}

class Prayer {
  final String title;
  final String audio;
  final List<Verse> verses;

  Prayer({
    this.title,
    this.audio,
    this.verses,
  });

  factory Prayer.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['verses'] as List;
    List<Verse> verses = list.map((i) => Verse.fromJson(i)).toList();
    return Prayer(
      title: parsedJson['title'],
      audio: parsedJson['audio'],
      verses: verses,
    );
  }
}
