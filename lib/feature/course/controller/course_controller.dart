import 'package:flutter/material.dart';
import 'package:timetable_generation_application/core/color/color_constants.dart';
import 'package:timetable_generation_application/core/config/api.dart';
import 'package:timetable_generation_application/core/global/helper_function.dart';

class CourseController with ChangeNotifier {
  Future<void> addCourse(
    String courseName,
    BuildContext context,
  ) async {
    await ApiConfig.firestore.collection('courses').add({
      'courseName': courseName,
    });
    showSnackBar(
        context: context,
        message: "Course added successfully!",
        color: AppColor.primary);
    Navigator.pop(context);
  }

  Future<void> editCourse({
    required BuildContext context,
    required String text,
    required String courseId,
  }) async {
    ApiConfig.firestore.collection('courses').doc(courseId).update({
      'courseName': text,
    });
    showSnackBar(
        context: context,
        message: "Course Updated successfully!",
        color: AppColor.primary);
    Navigator.pop(context);
  }

  void deleteCourse(String courseId, BuildContext context) async {
    await ApiConfig.firestore.collection('courses').doc(courseId).delete();
    showSnackBar(
        context: context, message: "Course Deleted!", color: AppColor.primary);
  }
}
