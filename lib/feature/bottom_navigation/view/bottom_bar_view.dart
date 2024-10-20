import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/core/color/color_constants.dart';
import 'package:timetable_generation_application/feature/bottom_navigation/controller/bottom_controller.dart';
import 'package:timetable_generation_application/feature/bottom_navigation/widgets/bottom_items.dart';

class BottomBarView extends StatelessWidget {
  BottomBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationController>(
        builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: AppColor.bg,
        body: provider.screens[provider.currentScreen],
        bottomNavigationBar: Container(
          color: AppColor.white,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BottomNavigationItemes(
                text: "Courses",
                index: 0,
                icon: 'assets/course.png',
                onPressed: () {
                  provider.changeScreen(0);
                },
              ),
              BottomNavigationItemes(
                text: "Period",
                index: 1,
                icon: "assets/period.png",
                onPressed: () {
                  provider.changeScreen(1);
                },
              ),
              BottomNavigationItemes(
                text: "Staff",
                index: 2,
                icon: 'assets/staff.png',
                onPressed: () {
                  provider.changeScreen(2);
                },
              ),
              BottomNavigationItemes(
                text: "Timetable",
                index: 3,
                icon: 'assets/timetable.png',
                onPressed: () {
                  provider.changeScreen(3);
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
