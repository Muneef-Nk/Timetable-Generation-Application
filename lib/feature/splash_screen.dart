import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timetable_generation_application/core/color/color_constants.dart';
import 'package:timetable_generation_application/feature/bottom_navigation/view/bottom_bar_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => BottomBarView()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'QuickTimetable',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.primary,
          ),
        ),
      ),
    );
  }
}
