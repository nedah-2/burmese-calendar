import 'package:connectivity/connectivity.dart';
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
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MonthAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(DayAdapter());
    }

    _monthBox = await Hive.openBox<Month>('monthBox');
    // Initialize shared preferences
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> isInternetConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<List<Month>> initCalendar(
      Function onLoadingTextChange, Function onLoadingComplete) async {
    _prefs = await SharedPreferences.getInstance();
    final int index = _prefs.getInt('index') ?? 0;
    final int lastWriteYear = await getLastWriteTimestamp();
    final int currentYear = DateTime.now().year;
    List<Month> months = [];
    bool isConnected = await isInternetConnected();
    if (isConnected) {
      if (index != 11 || lastWriteYear != currentYear) {
        months = await calendarService.fetchMonths();
        for (int i = index; i < months.length; i++) {
          bool hasInternet = await isInternetConnected();
          _prefs.setInt('index', i);
          if (!hasInternet) return [];
          Month month = months[i];

          onLoadingTextChange("Fetching data for ${month.english}");
          month.dayList = await calendarService.fetchDayList(month.english);
          storeMonth(i, month);
        }
        // Store year of write operation
        await _storeTimestamp('last_write');
        months = await fetchStoredMonths();
      } else {
        months = await fetchStoredMonths();
      }
      onLoadingComplete();
    } else {
      months = await fetchStoredMonths();
      if (months.length == 12) {
        onLoadingComplete();
      } else {
        onLoadingTextChange(
            "Check your internet contenction\n and try again...");
      }
    }

    print(months.length);

    return months;
  }

  Future<void> storeMonth(int index, Month month) async {
    await _monthBox.put(index, month);
  }

  Future<List<Month>> fetchStoredMonths() async {
    final List<Month> storedMonths = _monthBox.values.toList();
    return storedMonths;
  }

  Future<int> getLastWriteTimestamp() async {
    return _prefs.getInt('last_write') ?? 0;
  }

  Future<void> _storeTimestamp(String key) async {
    await _prefs.setInt(key, DateTime.now().year);
  }
}
