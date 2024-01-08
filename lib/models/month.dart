import 'package:myanmar_calendar/models/day.dart';

// month_model.dart
class Month {
  final int id;
  final String name;
  final String headOne;
  final String headTwo;
  final List<Day> dayList;

  Month({
    required this.id,
    required this.name,
    required this.headOne,
    required this.headTwo,
    required this.dayList,
  });

  factory Month.fromJson(Map<String, dynamic> json) {
    List<Day> days = [];
    if (json['dayList'] != null) {
      json['dayList'].forEach((day) {
        days.add(Day.fromJson(day));
      });
    }

    return Month(
      id: json['id'],
      name: json['burmese'],
      headOne: json['headOne'],
      headTwo: json['headTwo'],
      dayList: days,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> daysJson =
        dayList.map((day) => day.toJson()).toList();

    return {
      'id': id,
      'burmese': name,
      'headOne': headOne,
      'headTwo': headTwo,
      'dayList': daysJson,
    };
  }
}
