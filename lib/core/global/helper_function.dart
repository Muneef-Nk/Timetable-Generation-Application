import 'package:flutter/material.dart';
import 'package:timetable_generation_application/core/color/color_constants.dart';

BoxDecoration boxDecoration() {
  return BoxDecoration(
      color: AppColor.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          spreadRadius: 1,
          blurRadius: 5,
        )
      ],
      borderRadius: BorderRadius.circular(8));
}

showSnackBar(
    {required BuildContext context, required String message, Color? color}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: Text(
          message,
          style: TextStyle(color: AppColor.white, fontSize: 12),
        ),
        backgroundColor: color ?? AppColor.red),
  );
}
