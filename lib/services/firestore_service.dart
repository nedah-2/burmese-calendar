import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myanmar_calendar/models/day.dart';
import 'package:myanmar_calendar/models/month.dart';

class CalendarService {
  static final CalendarService _instance = CalendarService._internal();

  factory CalendarService() {
    return _instance;
  }

  CalendarService._internal();

  Future<List<Month>> fetchMonths() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('months').get();

      List<Month> months =
          querySnapshot.docs.map((doc) => Month.fromJson(doc.data())).toList();

      // Sort the list of months by id
      months.sort((a, b) => a.id.compareTo(b.id));

      return months;
    } catch (e) {
      return [];
    }
  }

  Future<List<Day>> fetchDayList(String monthId) async {
    try {
      // Replace 'dayList' with the correct subcollection name in your Firestore
      CollectionReference dayListCollection =
          FirebaseFirestore.instance.collection('months/$monthId/dayList');

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await dayListCollection.get() as QuerySnapshot<Map<String, dynamic>>;

      List<Day> dayList =
          querySnapshot.docs.map((doc) => Day.fromJson(doc.data())).toList();

      // Sort dayList by id
      dayList.sort((a, b) => a.id.compareTo(b.id));

      return dayList;
    } catch (e) {
      return [];
    }
  }
}
