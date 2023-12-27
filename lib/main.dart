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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tabs Demo'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Month and Day',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 32),

            buildCalendar(),

            const SizedBox(height: 24),

            // Month Dropdown
            DropdownButton<String>(
              items: <String>[
                'January',
                'February',
                'March',
                'April',
                'May',
                'June',
                'July',
                'August',
                'September',
                'October',
                'November',
                'December'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // Handle dropdown value change
                print('Selected Month: $newValue');
                // Add your logic here to update the UI or perform any actions based on the selected month
              },
              hint: const Text('Select Month'),
            ),

            const SizedBox(height: 24),

            const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            Container(
              color: Colors.amber,
              width: double.infinity,
              height: 200,
              child: const TabBarView(
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
    );
  }

  Widget buildCalendar() {
    // Get the first and last day of the month
    DateTime firstDayOfMonth =
        DateTime(selectedDate.year, selectedDate.month, 1);
    DateTime lastDayOfMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0);

    // Calculate the number of days to display
    int numberOfDays = lastDayOfMonth.day;

    // Determine the weekday of the first day of the month
    int startingWeekday = firstDayOfMonth.weekday;

    // Create a list to represent the calendar rows
    List<TableRow> calendarRows = [];

    // Create the header row with day names
    calendarRows.add(
      TableRow(
        children: List.generate(
          7,
          (index) => Center(
            child: Text(
              getAbbreviatedDayName(index + 1),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );

    // Create the calendar rows
    for (int i = 0; i < 6; i++) {
      // Create a list to represent a week in the calendar
      List<Widget> weekWidgets = [];

      // Fill in the days for the week
      for (int j = 1; j <= 7; j++) {
        int dayValue = i * 7 + j - startingWeekday + 1;

        if (dayValue > 0 && dayValue <= numberOfDays) {
          // Display the day as a button
          weekWidgets.add(
            GestureDetector(
              onTap: () {
                // Handle day tap
                onDayTap(dayValue);
              },
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSameDay(selectedDate, dayValue)
                      ? Colors.blue // Highlight selected day
                      : Colors.transparent,
                ),
                child: Text(
                  '$dayValue',
                  style: TextStyle(
                    color: isSameDay(selectedDate, dayValue)
                        ? Colors.white // Text color for selected day
                        : Colors.black,
                  ),
                ),
              ),
            ),
          );
        } else {
          // Display an empty cell for days outside the current month
          weekWidgets.add(Container());
        }
      }

      // Add the week to the list of calendar rows
      calendarRows.add(TableRow(children: weekWidgets));
    }

    // Return the calendar as a Table
    return Table(
      border: TableBorder.all(),
      children: calendarRows,
    );
  }

  void onDayTap(int day) {
    // Update the selected date when a day is tapped
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month, day);
    });
    print('Selected date: $selectedDate');
  }

  String getAbbreviatedDayName(int day) {
    // Convert the day number to an abbreviated day name
    switch (day) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  bool isSameDay(DateTime date, int day) {
    // Check if the given day is the same as the selected day
    return date.day == day;
  }
}
