class RadioItem {
  final int mediaId;
  final String date;
  final String category;
  final String title;
  final String description;
  final String startHour;
  final double startTimestamp;
  final String address;

  RadioItem({
    this.mediaId,
    this.date,
    this.category,
    this.title,
    this.description,
    this.startHour,
    this.startTimestamp,
    this.address,
  });

  factory RadioItem.fromJson(Map<String, dynamic> parsedJson) {
    return RadioItem(
      mediaId: int.parse(parsedJson['media_id']),
      date: parsedJson['date'],
      category: parsedJson['category'],
      title: parsedJson['name_fa'],
      description: parsedJson['detail_fa'],
      startHour: parsedJson['start_hour'],
      startTimestamp: double.parse(parsedJson['start_timestamp']),
      address: parsedJson['address'],
    );
  }
}
