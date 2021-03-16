class Verse {
  final String arabic;
  final String farsi;

  Verse({
    this.arabic,
    this.farsi,
  });

  factory Verse.fromJson(Map<String, dynamic> parsedJson) {
    return Verse(
      arabic: parsedJson['arabic'],
      farsi: parsedJson['farsi'],
    );
  }
}

class Prayer {
  final String title;
  final String reciter;
  final String audio;
  final List<Verse> verses;

  Prayer({
    this.title,
    this.reciter,
    this.audio,
    this.verses,
  });

  factory Prayer.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['verses'] as List;
    List<Verse> _verses = list.map((i) => Verse.fromJson(i)).toList();
    return Prayer(
      title: parsedJson['title'],
      reciter: parsedJson['reciter'],
      audio: parsedJson['audio'],
      verses: _verses,
    );
  }
}