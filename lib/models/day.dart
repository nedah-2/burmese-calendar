// day_model.dart
class Day {
  final int id;
  final String english;
  final String burmese;
  final bool? isFullMoon;
  final String? holiday;
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
      holiday: json['isHoliday'],
      fortune: json['fortune'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english': english,
      'burmese': burmese,
      'isFullMoon': isFullMoon,
      'isHoliday': holiday,
      'fortune': fortune,
    };
  }
}
