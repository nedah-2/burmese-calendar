import 'package:flutter/material.dart';
import 'package:myanmar_calendar/calendar_provider.dart';
import 'package:myanmar_calendar/widgets/fortune_list.dart';
import 'package:myanmar_calendar/widgets/holiday_list.dart';
import 'package:provider/provider.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({super.key});

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarProvider>(builder: (context, calendar, child) {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
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
                              calendar.selectedMonth.burmese,
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
                              calendar.selectedDateIndex == -1
                                  ? ''
                                  : calendar
                                      .selectedMonth
                                      .dayList[calendar.selectedDateIndex - 1]
                                      .burmese,
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
                          onPressed: calendar.selectedMonthIndex > 0
                              ? () {
                                  calendar.onMonthTap(
                                      calendar.selectedMonthIndex - 1);
                                }
                              : null,
                          icon: const Icon(Icons.chevron_left)),
                      SizedBox(
                        width: 120,
                        child: TextButton(
                          onPressed: () async {
                            int? newValue = await showDialog<int>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  insetPadding: const EdgeInsets.symmetric(
                                      horizontal: 96),
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
                                              child: Text(calendar
                                                  .months[index].english)),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );

                            if (newValue != null) {
                              calendar.onMonthTap(newValue);
                            }
                          },
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.deepPurple),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                            ),
                          ),
                          child: Center(
                              child: Text(
                            calendar.selectedMonth.english,
                            style: const TextStyle(color: Colors.white),
                          )),
                        ),
                      ),

                      IconButton.filled(
                          onPressed: calendar.selectedMonthIndex < 11
                              ? () {
                                  calendar.onMonthTap(
                                      calendar.selectedMonthIndex + 1);
                                }
                              : null,
                          icon: const Icon(Icons.chevron_right)),
                      // Text(getDragonHead()),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                buildCalendar(calendar),
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
                      HolidayListWidget(holidayList: calendar.holidayList),
                      FortuneListWidget(fortuneList: calendar.fortuneFalseList),
                      FortuneListWidget(fortuneList: calendar.fortuneTrueList)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildCalendar(CalendarProvider calendar) {
    DateTime today = DateTime.now();
    int year = calendar.selectedDate.year;
    int month = calendar.selectedMonthIndex + 1;
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);

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
          DateTime currentDate = DateTime(year, month, dayValue);

          weekWidgets.add(
            GestureDetector(
              onTap: () {
                calendar.onDayTap(currentDate);
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
                  border: isSameMonth(currentDate, calendar.selectedDate)
                      ? isSameDay(calendar.selectedDate, dayValue)
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
                        : isSameMonth(currentDate, calendar.selectedDate)
                            ? isSameDay(calendar.selectedDate, dayValue)
                                ? Colors.deepPurple
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

    return Table(
      children: calendarRows,
    );
  }

  bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
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

  bool isSameDay(DateTime date, int day) {
    // Check if the given day is the same as the selected day
    return date.day == day;
  }
}