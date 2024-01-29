import 'package:flutter/material.dart';
import 'package:myanmar_calendar/services/database_service.dart';

import 'package:myanmar_calendar/models/day.dart';
import 'package:myanmar_calendar/models/month.dart';

class CalendarProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  int _selectedMonthIndex = DateTime.now().month - 1;
  int _selectedDateIndex = DateTime.now().day;
  Month _selectedMonth = Month(
      id: 0, english: '', burmese: '', headOne: '', headTwo: '', dayList: []);

  List<Day> _holidayList = [];
  List<Day> _fortuneTrueList = [];
  List<Day> _fortuneFalseList = [];
  int _indexFullmoonFalse = -1;
  int _indexFullmoonTrue = -1;
  double _dragonHead = 0.0;

  List<Month> _months = [];

  DateTime get selectedDate => _selectedDate;
  int get selectedMonthIndex => _selectedMonthIndex;
  int get selectedDateIndex => _selectedDateIndex;
  List<Day> get holidayList => _holidayList;
  List<Day> get fortuneTrueList => _fortuneTrueList;
  List<Day> get fortuneFalseList => _fortuneFalseList;
  int get indexFullmoonFalse => _indexFullmoonFalse;
  int get indexFullmoonTrue => _indexFullmoonTrue;
  Month get selectedMonth => _selectedMonth;
  double get dragonHead => _dragonHead;

  List<Month> get months => _months;

  final DatabaseHelper database = DatabaseHelper();

  Future<void> initCalendar(
      Function onLoadingTextChange, Function onLoadingComplete) async {
    await database.initHive();
    _months =
        await database.initCalendar(onLoadingTextChange, onLoadingComplete);
    await changeMonthTo(_selectedMonthIndex);
  }

  // Method to update the calendar and get lists based on the selected month
  Future<void> changeMonthTo(int index) async {
    Month month = _months[index];

    List<Day> dayList = month.dayList;

    // Reset the lists for each category
    _holidayList = [];
    _fortuneTrueList = [];
    _fortuneFalseList = [];

    // Iterate over dayList and categorize days
    for (int i = 0; i < dayList.length; i++) {
      Day day = dayList[i];
      print(day.burmese);
      if (day.holiday != null) {
        _holidayList.add(day);
      }

      if (day.fortune == true) {
        _fortuneTrueList.add(day);
      } else if (day.fortune == false) {
        _fortuneFalseList.add(day);
      }

      // Check for isFullmoon false and update the index
      if (day.isFullMoon == false) {
        _indexFullmoonFalse = i + 1;
      }

      // Check for isFullmoon true and update the index
      if (day.isFullMoon == true) {
        _indexFullmoonTrue = i + 1;
      }
    }
    print(_indexFullmoonFalse);

    // Sort the lists based on the id property
    _holidayList.sort((a, b) => a.id.compareTo(b.id));
    _fortuneTrueList.sort((a, b) => a.id.compareTo(b.id));
    _fortuneFalseList.sort((a, b) => a.id.compareTo(b.id));

    print('Index of the day with isFullmoon false: $_indexFullmoonFalse');
    print('Index of the day with isFullmoon true: $_indexFullmoonTrue');
    _selectedMonth = month;
    _dragonHead = getDirection(getDragonHead(_selectedDateIndex));
    print(_dragonHead);
    notifyListeners();
  }

  void onDayTap(DateTime date) {
    _selectedDate = date;
    _selectedDateIndex = date.day;
    _dragonHead = getDirection(getDragonHead(_selectedDateIndex));
    print(_dragonHead);
    notifyListeners();
  }

  void onMonthTap(int month) {
    int currentYear = DateTime.now().year;
    int currentMonth = DateTime.now().month;
    int currentDay = DateTime.now().day;
    _selectedMonthIndex = month;
    _selectedDateIndex = (month + 1) == currentMonth ? currentDay : -1;
    _selectedDate = DateTime(currentYear, currentMonth, currentDay);
    changeMonthTo(month);
  }

  String getDragonHead(int current) {
    return current < (_indexFullmoonFalse + 1)
        ? _selectedMonth.headOne
        : _selectedMonth.headTwo;
  }

  double getDirection(String dragonHead) {
    if (dragonHead.contains('မြောက်')) {
      return 0.75;
    } else if (dragonHead.contains('ရှေ့')) {
      return 1.0;
    } else if (dragonHead.contains('တောင်')) {
      return 0.25;
    } else {
      return 0.5;
    }
  }

  // String getMonthName(int month) {
  //   switch (month) {
  //     case 1:
  //       return 'January';
  //     case 2:
  //       return 'February';
  //     case 3:
  //       return 'March';
  //     case 4:
  //       return 'April';
  //     case 5:
  //       return 'May';
  //     case 6:
  //       return 'June';
  //     case 7:
  //       return 'July';
  //     case 8:
  //       return 'August';
  //     case 9:
  //       return 'September';
  //     case 10:
  //       return 'October';
  //     case 11:
  //       return 'November';
  //     case 12:
  //       return 'December';
  //     default:
  //       return '';
  //   }
  // }
}
