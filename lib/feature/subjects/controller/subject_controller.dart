import 'package:flutter/material.dart';
import 'package:timetable_generation_application/core/color/color_constants.dart';
import 'package:timetable_generation_application/core/config/api.dart';
import 'package:timetable_generation_application/core/global/helper_function.dart';

class SubjectController with ChangeNotifier {
  Future<void> addSubject({
    required String subjectName,
    required BuildContext context,
    required String courseId,
  }) async {
    try {
      await ApiConfig.firestore.collection('subjects').add({
        'subjectName': subjectName,
        'courseId': courseId,
        'assignedStaff': null
      });
      Navigator.of(context).pop();

      showSnackBar(
          context: context,
          message: 'Subject added successfully!',
          color: AppColor.primary);
    } catch (e) {
      showSnackBar(
        context: context,
        message: 'Error adding subject!',
      );
    }
  }

  Future<void> updateSubject(
      String subjectId, String subjectName, BuildContext context) async {
    try {
      await ApiConfig.firestore.collection('subjects').doc(subjectId).update({
        'subjectName': subjectName,
      });

      Navigator.of(context).pop();
      showSnackBar(
          context: context,
          message: "Subject updated successfully!",
          color: AppColor.primary);
    } catch (e) {
      showSnackBar(context: context, message: 'Error updating subject');
    }
  }

  void deleteSubject(String subjectId, BuildContext context) async {
    await ApiConfig.firestore.collection('subjects').doc(subjectId).delete();

    showSnackBar(
        context: context,
        message: "Subject deleted successfully!",
        color: AppColor.primary);
  }
}
