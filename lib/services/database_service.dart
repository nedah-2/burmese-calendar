import 'package:hive/hive.dart';
import 'package:myanmar_calendar/services/firestore_service.dart';
import 'package:myanmar_calendar/models/day.dart';
import 'package:myanmar_calendar/models/month.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  late Box<Month> _monthBox;
  late SharedPreferences _prefs;
  final CalendarService calendarService = CalendarService();

  Future<void> initHive() async {
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    Hive.registerAdapter(MonthAdapter());
    Hive.registerAdapter(DayAdapter());
    _monthBox = await Hive.openBox<Month>('monthBox');

    // Initialize shared preferences
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<Month>> initCalendar(
      Function onLoadingTextChange, Function onLoadingComplete) async {
    final int lastWriteYear = await getMonthLastWriteTimestamp();
    final int currentYear = DateTime.now().year;
    List<Month> months = [];
    if (lastWriteYear != currentYear) {
      print("Initialize Calendar");
      months = await calendarService.fetchMonths();
      for (int i = 0; i < months.length; i++) {
        Month month = months[i];
        onLoadingTextChange("Fetching data for ${month.english}");
        month.dayList = await calendarService.fetchDayList(month.english);
        storeMonth(i, month);
      }
      // Store year of write operation
      await _storeTimestamp('last_write');
    } else {
      print("Load Calendar");
      months = await fetchStoredMonths();
    }
    onLoadingComplete();
    return months;
  }

  Future<void> storeMonth(int index, Month month) async {
    await _monthBox.put(index, month);
  }

  Future<List<Month>> fetchStoredMonths() async {
    final List<Month> storedMonths = _monthBox.values.toList();
    return storedMonths;
  }

  Future<int> getMonthLastWriteTimestamp() async {
    return _prefs.getInt('last_write') ?? 0;
  }

  Future<void> _storeTimestamp(String key) async {
    await _prefs.setInt(key, DateTime.now().year);
  }
}
