// loading required packages
import 'package:intl/intl.dart' as intl;

class Owghat {
  final String sobh;
  final String sunrise;
  final String zohr;
  final String sunset;
  final String maghreb;
  final int dayLength;

  Owghat({
    this.sobh,
    this.sunrise,
    this.zohr,
    this.sunset,
    this.maghreb,
    this.dayLength,
  });

  factory Owghat.fromJson(Map<String, dynamic> parsedJson) {
    return Owghat(
      sobh: parsedJson['azan_sobh'],
      sunrise: parsedJson['sunrise'],
      zohr: parsedJson['zohr'],
      sunset: parsedJson['sunset'],
      maghreb: parsedJson['maghreb'],
      dayLength: intl.DateFormat('HH:mm')
          .parse(parsedJson['maghreb'])
          .difference(intl.DateFormat('HH:mm').parse(parsedJson['azan_sobh'])).inMinutes,
    );
  }
}
