import 'dart:math';

class TimeInterval {
  final int start;
  final int end;
  final List<String> greetings;

  TimeInterval(this.start, this.end, this.greetings);

  bool isInInterval(DateTime dateTime) {
    final hour = dateTime.hour;
    if (start > end) {
      return hour >= start || hour < end;
    }
    return hour >= start && hour < end;
  }
}

String getGreeting() {
  final now = DateTime.now();
  final random = Random();

  final timeIntervals = [
    TimeInterval(5, 12, [
      "Salutations from the Dawn Chorus",
      "Well met in the Dew Hours",
      "Greetings in the Realm of First Light",
      "Salutations during the Songbird Symphony",
      "Well wishes from the Mist Kingdom",
      "Hail from the Land of Rising Gold",
    ]),
    TimeInterval(12, 17, [
      "Greetings from the Sun's High Throne",
      "Well met in the Hours of Bright Shadows",
      "Salutations during the Golden Zenith",
      "Hail from the Realm of Dancing Heat",
      "Welcome in the Time of Buzzing Wings",
      "Well wishes from the Meridian Court",
    ]),
    TimeInterval(17, 21, [
      "Greetings from the Ember Hours",
      "Well met in the Sunset Kingdom",
      "Salutations during the Twilight Procession",
      "Hail from the Copper Sky Realm",
      "Welcome in the Time of Lengthening Shadows",
      "Well wishes from the Dusk Parade",
    ]),
    TimeInterval(21, 5, [
      "Greetings from the Starlit Dominion",
      "Well met in the Realm of Night Whispers",
      "Salutations during the Owl Parliament",
      "Hail from the Kingdom of Silver Dreams",
      "Welcome in the Time of Moon Dancers",
      "Well wishes from the Velvet Hours",
    ]),
  ];

  for (var interval in timeIntervals) {
    if (interval.isInInterval(now)) {
      final index = random.nextInt(interval.greetings.length);
      return interval.greetings[index];
    }
  }
  return 'Hello there';
}
