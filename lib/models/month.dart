import 'package:hive/hive.dart';
import 'day.dart'; // Import your Day model

part 'month.g.dart';

@HiveType(typeId: 0)
class Month {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String english;

  @HiveField(2)
  final String burmese;

  @HiveField(3)
  final String headOne;

  @HiveField(4)
  final String headTwo;

  @HiveField(5)
  List<Day> dayList;

  Month({
    required this.id,
    required this.english,
    required this.burmese,
    required this.headOne,
    required this.headTwo,
    required this.dayList,
  });

  factory Month.fromJson(Map<String, dynamic> json) {
    return Month(
      id: json['id'],
      english: json['english'],
      burmese: json['burmese'],
      headOne: json['headOne'],
      headTwo: json['headTwo'],
      dayList: [],
    );
  }
}
