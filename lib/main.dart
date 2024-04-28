import 'package:flutter/material.dart';
import 'package:quiz_app/start_screen.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 64, 20, 140),
                Color.fromARGB(255, 84, 20, 134),
              ],
            ),
          ),
          child: const StartScreen(),
        ),
      ),
    ),
  );
}
