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
  List<int> _indexFullmoonFalse = [];
  List<int> _indexFullmoonTrue = [];
  double _turns = 0.0;
  String _dragonHead = '';

  List<Month> _months = [];

  DateTime get selectedDate => _selectedDate;
  int get selectedMonthIndex => _selectedMonthIndex;
  int get selectedDateIndex => _selectedDateIndex;
  List<Day> get holidayList => _holidayList;
  List<Day> get fortuneTrueList => _fortuneTrueList;
  List<Day> get fortuneFalseList => _fortuneFalseList;
  List<int> get indexFullmoonFalse => _indexFullmoonFalse;
  List<int> get indexFullmoonTrue => _indexFullmoonTrue;
  Month get selectedMonth => _selectedMonth;
  double get turns => _turns;
  String get dragonHead => _dragonHead;

  List<Month> get months => _months;

  final DatabaseHelper database = DatabaseHelper();

  Future<bool> initCalendar(
      Function onLoadingTextChange, Function onLoadingComplete) async {
    await database.initHive();
    _months =
        await database.initCalendar(onLoadingTextChange, onLoadingComplete);
    if (_months.length == 12) {
      await changeMonthTo(_selectedMonthIndex);

      return true;
    }
    return false;
  }

  Future<bool> fetchData(
      Function onLoadingTextChange, Function onLoadingComplete) async {
    _months =
        await database.initCalendar(onLoadingTextChange, onLoadingComplete);
    if (_months.isNotEmpty) {
      await changeMonthTo(_selectedMonthIndex);
      return true;
    }
    return false;
  }

  // Method to update the calendar and get lists based on the selected month
  Future<void> changeMonthTo(int index) async {
    Month month = _months[index];

    List<Day> dayList = month.dayList;

    // Reset the lists for each category
    _holidayList = [];
    _fortuneTrueList = [];
    _fortuneFalseList = [];
    _indexFullmoonFalse = [];
    _indexFullmoonTrue = [];

    // Iterate over dayList and categorize days
    for (int i = 0; i < dayList.length; i++) {
      Day day = dayList[i];

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
        _indexFullmoonFalse.add(i + 1);
      }

      // Check for isFullmoon true and update the index
      if (day.isFullMoon == true) {
        _indexFullmoonTrue.add(i + 1);
      }
    }

    // Sort the lists based on the id property
    _holidayList.sort((a, b) => a.id.compareTo(b.id));
    _fortuneTrueList.sort((a, b) => a.id.compareTo(b.id));
    _fortuneFalseList.sort((a, b) => a.id.compareTo(b.id));
    _indexFullmoonFalse.sort();
    _indexFullmoonTrue.sort();

    _selectedMonth = month;
    _dragonHead = getDragonHead(_selectedDateIndex);
    _turns = getDirection(_dragonHead);

    notifyListeners();
  }

  void onDayTap(DateTime date) {
    _selectedDate = date;
    _selectedDateIndex = date.day;
    _dragonHead = getDragonHead(_selectedDateIndex);
    _turns = getDirection(_dragonHead);

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
    return _selectedDateIndex < (_indexFullmoonFalse[0] + 1)
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
}
