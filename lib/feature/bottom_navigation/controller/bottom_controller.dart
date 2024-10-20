import 'package:flutter/material.dart';
import 'package:timetable_generation_application/feature/course/view/coures_screen.dart';
import 'package:timetable_generation_application/feature/periods/days_periods_screen.dart';
import 'package:timetable_generation_application/feature/staff/view/staff_list_screen.dart';
import 'package:timetable_generation_application/feature/timetable/view/select_courses_screen.dart';

class BottomNavigationController with ChangeNotifier {
  int currentScreen = 0;

  final List<Widget> screens = [
    CourseListScreen(),
    DaysAndPeriodsScreen(),
    StaffListScreen(),
    CourseSelectionScreen(),
  ];

  changeScreen(int index) {
    currentScreen = index;
    notifyListeners();
  }
}
