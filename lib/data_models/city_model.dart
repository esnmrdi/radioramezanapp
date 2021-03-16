class City {
  final int countryId;
  final String countryNameEn;
  final String countryNameFa;
  final int cityId;
  final String cityNameEn;
  final String cityNameFa;
  final double latitude;
  final double longitude;
  final String timeZone;
  final int radius;
  final String url;

  City({
    this.countryId,
    this.countryNameEn,
    this.countryNameFa,
    this.cityId,
    this.cityNameEn,
    this.cityNameFa,
    this.latitude,
    this.longitude,
    this.timeZone,
    this.radius,
    this.url,
  });

  factory City.fromJson(Map<String, dynamic> parsedJson) {
    return City(
      countryId: int.parse(parsedJson['country_id']),
      countryNameEn: parsedJson['country_name_en'],
      countryNameFa: parsedJson['country_name_fa'],
      cityId: int.parse(parsedJson['city_id']),
      cityNameEn: parsedJson['city_name_en'],
      cityNameFa: parsedJson['city_name_fa'],
      latitude: double.parse(parsedJson['latitude']),
      longitude: double.parse(parsedJson['longitude']),
      timeZone: parsedJson['time_zone'],
      radius: int.parse(parsedJson['radius']),
      url: parsedJson['url'],
    );
  }
}