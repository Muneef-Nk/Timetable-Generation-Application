import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timetable_generation_application/core/color/color_constants.dart';
import 'package:timetable_generation_application/core/config/api.dart';
import 'package:timetable_generation_application/core/global/helper_function.dart';

class StaffController with ChangeNotifier {
  Future<void> addStaff({
    required String staffName,
    required String courseId,
    required BuildContext context,
    required String courseName,
    required String email,
    required String place,
  }) async {
    await ApiConfig.firestore.collection('staff').add({
      'staffName': staffName,
      'subjects': [],
      'courseId': courseId,
      'courseName': courseName,
      'email': email,
      'place': place
    }).then((value) {
      Navigator.of(context).pop();

      return showSnackBar(
          context: context,
          message: 'Staff added successfully',
          color: AppColor.primary);
    });
  }

  Future<void> saveAssignments({
    required String staffId,
    required String staffName,
    required List subjects,
  }) async {
    await ApiConfig.firestore.collection('staff').doc(staffId).update({
      'subjects': subjects,
    });

    for (var subjectName in subjects) {
      var subjectSnapshot = await ApiConfig.firestore
          .collection('subjects')
          .where('subjectName', isEqualTo: subjectName)
          .limit(1)
          .get();

      if (subjectSnapshot.docs.isNotEmpty) {
        var subjectId = subjectSnapshot.docs[0].id;

        await ApiConfig.firestore.collection('subjects').doc(subjectId).update({
          'assignedStaff': staffName,
        });
      }
    }

    var allSubjectsSnapshot = await ApiConfig.firestore
        .collection('subjects')
        .where('assignedStaff', isEqualTo: staffName)
        .get();

    for (var subjectDoc in allSubjectsSnapshot.docs) {
      if (!subjects.contains(subjectDoc['subjectName'])) {
        await ApiConfig.firestore
            .collection('subjects')
            .doc(subjectDoc.id)
            .update({'assignedStaff': ''});
      }
    }
  }

  Future<void> updateStaff({
    required BuildContext context,
    required String staffId,
    required String staffName,
    required String courseId,
    required String courseName,
    required String email,
    required String place,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('staff').doc(staffId).update({
        'staffName': staffName,
        'courseId': courseId,
        'courseName': courseName,
        'email': email,
        'place': place,
      });
      showSnackBar(
          context: context,
          message: "Staff updated successfully",
          color: AppColor.primary);
      Navigator.of(context).pop();
    } catch (e) {
      showSnackBar(context: context, message: "Error updating staff");
    }
  }

  // staff assign

  List<DocumentSnapshot> subjects = [];
  List<dynamic> assignedSubjects = [];

  Future<void> fetchSubjects({required String courseId}) async {
    var subjectData = await ApiConfig.firestore
        .collection('subjects')
        .where('courseId', isEqualTo: courseId)
        .get();

    subjects = subjectData.docs;
    notifyListeners();
  }

  bool isSubjectAssigned(String subjectName) {
    for (var subject in subjects) {
      if (subject['subjectName'] == subjectName) {
        return subject['assignedStaff'] != null &&
            subject['assignedStaff'].isNotEmpty;
      }
    }
    return false;
  }

  void toggleSubject({
    required String subjectName,
    required BuildContext context,
    required String staffId,
    required String staffName,
  }) {
    if (isSubjectAssigned(subjectName) &&
        !assignedSubjects.contains(subjectName)) {
      showSnackBar(
          context: context,
          message: "This subject is already assigned to another staff.");
      return;
    }

    if (assignedSubjects.contains(subjectName)) {
      assignedSubjects.remove(subjectName);
    } else {
      assignedSubjects.add(subjectName);
    }

    saveAssignments(
      staffId: staffId,
      subjects: assignedSubjects,
      staffName: staffName,
    );
  }
}
