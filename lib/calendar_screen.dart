import 'dart:async';

import 'package:connectivity/connectivity.dart';
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
  // Define the image assets to preload
  final List<String> imageAssets = [
    'assets/summer.jpg',
    'assets/rainy.jpg',
    'assets/winter.jpg',
    'assets/background.jpg'
  ];

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    calendar = Provider.of<CalendarProvider>(context, listen: false);

    initializeCalendar().then((success) {
      if (success) {
        _preloadImages();
        // Close the connectivity stream
        _connectivitySubscription.cancel();
      }
    });
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Handle connectivity changes here
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        // Fetch data if network available

        initializeCalendar().then((success) {
          if (success) {
            _preloadImages();
            // Close the connectivity Stream
            _connectivitySubscription.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  Future<void> _preloadImages() async {
    // Preload each image
    for (String asset in imageAssets) {
      await precacheImage(AssetImage(asset), context);
    }
  }

  Future<bool> initializeCalendar() async {
    return await calendar.initCalendar(onLoadingTextChange, onLoadingComplete);
  }

  Future<bool> fetchCalendarData() async {
    return await calendar.fetchData(onLoadingTextChange, onLoadingComplete);
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
      body: _isLoading ? _buildLoadingIndicator() : _buildCalendar(),
    );
  }

  Widget _buildLoadingIndicator() {
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
              const SizedBox(height: 24.0),
              Text(
                _loadingText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return const MyCalendar();
  }
}
