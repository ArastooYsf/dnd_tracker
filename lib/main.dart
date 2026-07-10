import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DndTrackerApp());
}

class DndTrackerApp extends StatelessWidget {
  const DndTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DnD Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
