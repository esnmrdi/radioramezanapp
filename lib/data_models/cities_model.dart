class City {
  final int countryId;
  final String countryNameEnglish;
  final String countryNamePersian;
  final int cityId;
  final String cityNameEnglish;
  final String cityNamePersian;
  final double latitude;
  final double longitude;
  final String timeZone;
  final int radius;
  final String url;

  City({
    this.countryId,
    this.countryNameEnglish,
    this.countryNamePersian,
    this.cityId,
    this.cityNameEnglish,
    this.cityNamePersian,
    this.latitude,
    this.longitude,
    this.timeZone,
    this.radius,
    this.url,
  });

  factory City.fromJson(Map<String, dynamic> parsedJson) {
    return City(
      countryId: parsedJson['country_id'],
      countryNameEnglish: parsedJson['country_name_en'],
      countryNamePersian: parsedJson['country_name_fa'],
      cityId: parsedJson['city_id'],
      cityNameEnglish: parsedJson['city_name_en'],
      cityNamePersian: parsedJson['city_name_fa'],
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      timeZone: parsedJson['time_zone'],
      radius: parsedJson['radius'],
      url: parsedJson['url'],
    );
  }
}
