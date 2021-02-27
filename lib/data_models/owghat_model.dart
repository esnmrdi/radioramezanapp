class CityInfo {
  final int cityId;
  final String cityNameEnglish;
  final String cityNamePersian;
  final String timeZone;

  CityInfo({
    this.cityId,
    this.cityNameEnglish,
    this.cityNamePersian,
    this.timeZone,
  });

  factory CityInfo.fromJson(Map<String, dynamic> parsedJson) {
    return CityInfo(
      cityId: parsedJson['city_id'],
      cityNameEnglish: parsedJson['city_name_en'],
      cityNamePersian: parsedJson['city_name_fa'],
      timeZone: parsedJson['timeZone'],
    );
  }
}

class PrayerTimes {
  final String date;
  final String azanSobh;
  final String sunrise;
  final String azanZohr;
  final String sunset;
  final String azanMaghreb;

  PrayerTimes({
    this.date,
    this.azanSobh,
    this.sunrise,
    this.azanZohr,
    this.sunset,
    this.azanMaghreb,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> parsedJson) {
    return PrayerTimes(
      date: parsedJson['Date'],
      azanSobh: parsedJson['azan_sobh'],
      sunrise: parsedJson['sunrise'],
      azanZohr: parsedJson['zohr'],
      sunset: parsedJson['sunset'],
      azanMaghreb: parsedJson['maghreb'],
    );
  }
}

class Owghat {
  final CityInfo cityInfo;
  final PrayerTimes prayerTimes;

  Owghat({
    this.cityInfo,
    this.prayerTimes,
  });

  factory Owghat.fromJson(Map<String, dynamic> parsedJson) {
    return Owghat(
      cityInfo: parsedJson['city_info'],
      prayerTimes: parsedJson['prayerTimes'],
    );
  }
}
