import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myanmar_calendar/data.dart';
import 'package:myanmar_calendar/firebase_options.dart';
import 'package:myanmar_calendar/models/day.dart';
import 'package:myanmar_calendar/widgets/fortune_list.dart';
import 'package:myanmar_calendar/widgets/holiday_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const MyCalendar(),
    );
  }
}

class MyCalendar extends StatefulWidget {
  const MyCalendar({super.key});

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  DateTime selectedDate = DateTime.now();
  int selectedMonthIndex = DateTime.now().month - 1;
  int selectedDateIndex = DateTime.now().day;

  List<Day> holidayList = [];
  List<Day> fortuneTrueList = [];
  List<Day> fortuneFalseList = [];
  int indexFullmoonFalse = -1;
  int indexFullmoonTrue = -1;

  @override
  void initState() {
    super.initState();
    initializeLists();
  }

  // Method to initialize the lists
  void initializeLists() {
    // Initialize lists for each category
    holidayList = [];
    fortuneTrueList = [];
    fortuneFalseList = [];

    // Initialize index for isFullmoon false
    indexFullmoonFalse = -1;

    // Iterate over dayList and categorize days
    for (int i = 0; i < month.dayList.length; i++) {
      Day day = month.dayList[i];

      if (day.holiday != null) {
        holidayList.add(day);
      }

      if (day.fortune == true) {
        fortuneTrueList.add(day);
      } else if (day.fortune == false) {
        fortuneFalseList.add(day);
      }

      // Check for isFullmoon false and update the index
      if (day.isFullMoon == false && indexFullmoonFalse == -1) {
        indexFullmoonFalse = i;
      }

      // Check for isFullmoon true and update the index
      if (day.isFullMoon == true && indexFullmoonTrue == -1) {
        indexFullmoonTrue = i;
      }
    }
    print('Index of the day with isFullmoon false: $indexFullmoonFalse');
    print('Index of the day with isFullmoon true: $indexFullmoonTrue');
  }

  String getDragonHead() {
    return selectedDateIndex < (indexFullmoonFalse + 2)
        ? month.headOne
        : month.headTwo;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: Text(
        //     month.name,
        //     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        //   ),
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 150, // Adjust the height as needed
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withOpacity(0.4),
                    ),
                    Column(
                      children: [
                        AppBar(
                          centerTitle: true,
                          title: Text(
                            month.name,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0, // Remove shadow
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            month.dayList[selectedDateIndex - 1].burmese,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton.filled(
                        onPressed: () {}, icon: const Icon(Icons.chevron_left)),
                    SizedBox(
                      width: 120,
                      child: TextButton(
                        onPressed: () async {
                          int? newValue = await showDialog<int>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                insetPadding:
                                    const EdgeInsets.symmetric(horizontal: 96),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                content: SizedBox(
                                  width: 120,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      12,
                                      (index) => TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, index),
                                        child: Center(
                                            child:
                                                Text(getMonthName(index + 1))),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );

                          if (newValue != null) {
                            updateCalendarAndLists(newValue);
                          }
                        },
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.deepPurple.shade50),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        child: Center(
                            child: Text(getMonthName(selectedMonthIndex + 1))),
                      ),
                    ),

                    IconButton.filled(
                        onPressed: () {},
                        icon: const Icon(Icons.chevron_right)),
                    // Text(getDragonHead()),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              buildCalendar(),
              const SizedBox(height: 24),
              const TabBar(
                tabs: [
                  Tab(text: 'အားလပ်ရက်'),
                  Tab(text: 'ပြဿဒါး'),
                  Tab(text: 'ရက်ရာဇာ'),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 180,
                child: TabBarView(
                  children: [
                    HolidayListWidget(holidayList: holidayList),
                    FortuneListWidget(fortuneList: fortuneFalseList),
                    FortuneListWidget(fortuneList: fortuneTrueList)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to update the calendar and get lists based on the selected month
  void updateCalendarAndLists(int? newValue) {
    setState(() {
      selectedMonthIndex = newValue!;
      selectedDate =
          DateTime(selectedDate.year, selectedMonthIndex + 1, selectedDate.day);

      // Call the method to initialize the lists
      initializeLists();
    });

    print('Selected Month: ${getMonthName(selectedMonthIndex + 1)}');
  }

  Widget buildCalendar() {
    DateTime today = DateTime.now();
    DateTime firstDayOfMonth =
        DateTime(selectedDate.year, selectedMonthIndex + 1, 1);
    DateTime lastDayOfMonth =
        DateTime(selectedDate.year, selectedMonthIndex + 2, 0);

    int numberOfDays = lastDayOfMonth.day;
    int startingWeekday = firstDayOfMonth.weekday % 7;

    List<TableRow> calendarRows = [];

    calendarRows.add(
      TableRow(
        children: List.generate(
          7,
          (index) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                getAbbreviatedDayName((index)), // Adjust day order
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );

    for (int i = 0; i < 6; i++) {
      List<Widget> weekWidgets = [];

      for (int j = 1; j <= 7; j++) {
        int dayValue = i * 7 + j - startingWeekday;

        if (dayValue > 0 && dayValue <= numberOfDays) {
          DateTime currentDate =
              DateTime(selectedDate.year, selectedMonthIndex + 1, dayValue);

          weekWidgets.add(
            GestureDetector(
              onTap: () {
                onDayTap(dayValue);
              },
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSameMonth(currentDate, today)
                      ? isSameDay(today, dayValue)
                          ? Colors.deepPurple
                          : Colors.transparent
                      : null,
                  border: isSameMonth(currentDate, selectedDate)
                      ? isSameDay(selectedDate, dayValue)
                          ? Border.all(color: Colors.deepPurple, width: 2.0)
                          : null
                      : null,
                ),
                child: Text(
                  '$dayValue',
                  style: TextStyle(
                    color: isSameMonth(currentDate, today)
                        ? isSameDay(today, dayValue)
                            ? Colors.white
                            : Colors.black87
                        : isSameMonth(currentDate, selectedDate)
                            ? isSameDay(selectedDate, dayValue)
                                ? Colors.blue
                                : Colors.black87
                            : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        } else {
          weekWidgets.add(Container());
        }
      }

      calendarRows.add(TableRow(children: weekWidgets));
    }

    List<Widget> first = calendarRows[1].children;

    if ((first[4] is! GestureDetector || first[5] is! GestureDetector)) {
      List<Widget> first = calendarRows.removeAt(1).children;
      List<Widget> last = calendarRows.removeLast().children;

      for (int i = 0; i < first.length; i++) {
        if (last[i] is GestureDetector) {
          first[i] = last[i];
        }
      }
      calendarRows.insert(1, TableRow(children: first));
    }

    // List<Widget> first = calendarRows.removeAt(1).children;
    // print(first);

    // calendarRows.insert(3, TableRow(children: first));

    return Table(
      // children: calendarRows,
      children: calendarRows,
    );
  }

  String tableRowToString(TableRow row) {
    List<String> rowContent = row.children.map((widget) {
      if (widget is Container && widget.child is Text) {
        return (widget.child as Text).data ?? '';
      }
      return '';
    }).toList();

    return rowContent.join('\t'); // You can adjust the separator as needed
  }

  bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  void onDayTap(int day) {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month, day);
      selectedDateIndex = day;
    });
    print('Selected date: $selectedDate');
  }

  String getAbbreviatedDayName(int day) {
    switch (day) {
      case 0:
        return 'Sun';
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      default:
        return '';
    }
  }

  String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  bool isSameDay(DateTime date, int day) {
    // Check if the given day is the same as the selected day
    return date.day == day;
  }
}
