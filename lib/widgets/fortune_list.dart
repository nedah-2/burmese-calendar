import 'package:flutter/material.dart';
import 'package:myanmar_calendar/models/day.dart';

class FortuneListWidget extends StatelessWidget {
  final List<Day> fortuneList;

  const FortuneListWidget({super.key, required this.fortuneList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 40),
      itemCount: fortuneList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        Day day = fortuneList[index];
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
          title: Text(day.burmese,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        );
      },
    );
  }
}
