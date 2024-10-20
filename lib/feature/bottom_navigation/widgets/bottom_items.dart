import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/core/color/color_constants.dart';
import 'package:timetable_generation_application/feature/bottom_navigation/controller/bottom_controller.dart';

class BottomNavigationItemes extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final int index;
  final String icon;
  const BottomNavigationItemes({
    super.key,
    required this.text,
    required this.onPressed,
    required this.index,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationController>(
        builder: (context, provider, _) {
      return InkWell(
        onTap: () {
          onPressed();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              color: index == provider.currentScreen
                  ? AppColor.primary
                  : AppColor.grey,
              width: 18,
            ),
            SizedBox(height: 3),
            Text(
              "$text",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: provider.currentScreen == index
                      ? AppColor.primary
                      : AppColor.grey,
                  fontSize: 12),
            ),
          ],
        ),
      );
    });
  }
}
