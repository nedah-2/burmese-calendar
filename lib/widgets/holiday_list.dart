import 'package:flutter/material.dart';
import 'package:myanmar_calendar/models/day.dart';

class HolidayListWidget extends StatelessWidget {
  final List<Day> holidayList;

  const HolidayListWidget({super.key, required this.holidayList});

  @override
  Widget build(BuildContext context) {
    return holidayList.isEmpty
        ? const Center(
            child: Text("အားလပ်ရက်မရှိပါ"),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: holidayList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Day day = holidayList[index];
              return ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey.shade200,
                  ),
                  width: 40,
                  height: 40,
                  child: Center(
                      child: Text(
                    day.english,
                    style: const TextStyle(fontSize: 16),
                  )),
                ),
                title: Text(
                  day.holiday!,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              );
            },
          );
  }
}
