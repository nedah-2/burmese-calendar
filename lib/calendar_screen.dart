import 'package:flutter/material.dart';
import 'package:myanmar_calendar/calendar_provider.dart';
import 'package:myanmar_calendar/widgets/calendar_widget.dart';

import 'package:provider/provider.dart';

class CalendarLoadingScreen extends StatefulWidget {
  const CalendarLoadingScreen({super.key});

  @override
  State<CalendarLoadingScreen> createState() => _CalendarLoadingScreenState();
}

class _CalendarLoadingScreenState extends State<CalendarLoadingScreen> {
  bool _isLoading = true;
  String _loadingText = 'Loading data...';
  late CalendarProvider calendar;

  @override
  void initState() {
    super.initState();
    calendar = Provider.of<CalendarProvider>(context, listen: false);
    initializeCalendar();
  }

  Future<void> initializeCalendar() async {
    await calendar.initCalendar(onLoadingTextChange, onLoadingComplete);
  }

  void onLoadingTextChange(String newText) {
    setState(() {
      _loadingText = newText;
    });
  }

  void onLoadingComplete() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? _buildLoadingScreen() : _buildCalendar(),
    );
  }

  Widget _buildLoadingScreen() {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/background_image.png', // Replace with your image asset path
            fit: BoxFit.cover,
          ),
        ),
        // Loading Content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16.0),
              Text(
                _loadingText,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    // Implement your calendar widget here
    // This could be a GridView, ListView, or any other widget to display the calendar
    return const MyCalendar();
  }
}
