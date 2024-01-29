import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myanmar_calendar/calendar_screen.dart';
import 'package:myanmar_calendar/firebase_options.dart';
import 'package:myanmar_calendar/calendar_provider.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider(
      create: (context) => CalendarProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: const CalendarLoadingScreen(),
      ),
    );
  }
}

// class MyRotatingCircle extends StatefulWidget {
//   const MyRotatingCircle({Key? key})
//       : super(key: key); // Corrected key parameter

//   @override
//   State<MyRotatingCircle> createState() => _MyRotatingCircleState();
// }

// class _MyRotatingCircleState extends State<MyRotatingCircle> {
//   double turns = 0.0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Animated Rotation'),
//       ),
//       body: AnimatedRotation(
//         turns: turns,
//         duration: const Duration(milliseconds: 300),
//         child: Container(
//           width: 64,
//           height: 64,
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.blue,
//           ),
//           child: const Icon(
//             Icons.arrow_forward,
//             color: Colors.white,
//             size: 32,
//           ),
//         ),
//       ),
//     );
//   }
// }
