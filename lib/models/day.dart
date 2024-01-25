import 'package:hive/hive.dart';

part 'day.g.dart';

@HiveType(typeId: 1)
class Day {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String english;

  @HiveField(2)
  final String burmese;

  @HiveField(3)
  final bool? isFullMoon;

  @HiveField(4)
  final String? holiday;

  @HiveField(5)
  final bool? fortune;

  Day({
    required this.id,
    required this.english,
    required this.burmese,
    this.isFullMoon,
    this.holiday,
    this.fortune,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      id: json['id'],
      english: json['english'],
      burmese: json['burmese'],
      isFullMoon: json['isFullMoon'],
      holiday: json['holiday'],
      fortune: json['fortune'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english': english,
      'burmese': burmese,
      'isFullMoon': isFullMoon,
      'holiday': holiday,
      'fortune': fortune,
    };
  }
}
