class RadioItem {
  final double startPlay;
  final double endPlay;
  final bool video;
  final int fadeIn;
  final String poster;
  final String title;
  final String description;
  final int volume;
  final String address;

  RadioItem({
    this.startPlay,
    this.endPlay,
    this.video,
    this.fadeIn,
    this.poster,
    this.title,
    this.description,
    this.volume,
    this.address,
  });

  factory RadioItem.fromJson(Map<String, dynamic> parsedJson) {
    return RadioItem(
      startPlay: parsedJson['startPlay'].toDouble(),
      endPlay: parsedJson['endPlay'].toDouble(),
      video: parsedJson['video'],
      fadeIn: parsedJson['fadeIn'],
      poster: parsedJson['poster'],
      title: parsedJson['title'],
      description: parsedJson['description'],
      volume: parsedJson['volume'],
      address: parsedJson['address'],
    );
  }
}

class ProgramsList {
  final int currentTime;
  final List<RadioItem> programs;

  ProgramsList({
    this.currentTime,
    this.programs,
  });

  factory ProgramsList.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['Programs'] as List;
    List<RadioItem> programsList =
        list.map((i) => RadioItem.fromJson(i)).toList();
    return ProgramsList(
      currentTime: parsedJson['currentTime'],
      programs: programsList,
    );
  }
}
