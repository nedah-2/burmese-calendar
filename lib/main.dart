import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Burmese Calendar'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Center(
                child: Text(
                  '${getMonthName(selectedMonthIndex + 1)} ${selectedDate.day}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 32),
              buildCalendar(),
              const SizedBox(height: 24),
              DropdownButton<int>(
                value: selectedMonthIndex,
                items: List.generate(
                  12,
                  (index) => DropdownMenuItem<int>(
                    value: index,
                    child: Text(getMonthName(index + 1)),
                  ),
                ),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedMonthIndex = newValue!;
                    selectedDate = DateTime(selectedDate.year,
                        selectedMonthIndex + 1, selectedDate.day);
                  });
                  print(
                      'Selected Month: ${getMonthName(selectedMonthIndex + 1)}');
                },
                hint: const Text('Select Month'),
              ),
              const SizedBox(height: 24),
              const TabBar(
                tabs: [
                  Tab(text: 'အားလပ်ရက်'),
                  Tab(text: 'ပြဿဒါး'),
                  Tab(text: 'ရက်ရာဇာ'),
                ],
              ),
              const SizedBox(
                width: double.infinity,
                height: 180,
                child: TabBarView(
                  children: [
                    Icon(Icons.directions_car),
                    Icon(Icons.directions_transit),
                    Icon(Icons.directions_bike),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCalendar() {
    DateTime today = DateTime.now();
    DateTime firstDayOfMonth =
        DateTime(selectedDate.year, selectedMonthIndex + 1, 1);
    DateTime lastDayOfMonth =
        DateTime(selectedDate.year, selectedMonthIndex + 2, 0);

    int numberOfDays = lastDayOfMonth.day;
    int startingWeekday = firstDayOfMonth.weekday;

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
                          ? Colors.blue
                          : Colors.transparent
                      : null,
                  border: isSameMonth(currentDate, selectedDate)
                      ? isSameDay(selectedDate, dayValue)
                          ? Border.all(color: Colors.blue, width: 2.0)
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
          weekWidgets.add(Container(color: Colors.red));
        }
      }

      calendarRows.add(TableRow(children: weekWidgets));
    }

    return Table(
      children: calendarRows,
    );
  }

  bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  void onDayTap(int day) {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month, day);
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
