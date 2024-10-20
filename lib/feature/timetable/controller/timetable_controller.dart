import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimetableController with ChangeNotifier {
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  // fetch sub
  Future<List<Map<String, dynamic>>> fetchSubjects({
    required String selectedCourseId,
  }) async {
    List<Map<String, dynamic>> subjectsList = [];

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('subjects')
        .where('courseId', isEqualTo: selectedCourseId)
        .get();

    for (var doc in snapshot.docs) {
      subjectsList.add({
        'assignedStaff': doc['assignedStaff'],
        'courseId': doc['courseId'],
        'subjectName': doc['subjectName'],
      });
    }

    return subjectsList;
  }

  // subject
  List<Map<String, dynamic>> assignSubjectsToPeriods(
      List<Map<String, dynamic>> subjects) {
    List<Map<String, dynamic>> assignedPeriods = [];
    int totalPeriods = 4;
    int totalDays = 5;

    subjects.shuffle();

    for (int day = 0; day < totalDays; day++) {
      for (int period = 0; period < totalPeriods; period++) {
        int subjectIndex = (day * totalPeriods + period) % subjects.length;

        assignedPeriods.add({
          "subject": subjects[subjectIndex]['subjectName'],
          "staff": subjects[subjectIndex]['assignedStaff']
        });
      }
    }
    return assignedPeriods;
  }

  Future<Map<String, Map<String, String>>> fetchPeriods() async {
    Map<String, Map<String, String>> periodsByDay = {};

    // Loop through all days of the week
    for (String currentDay in daysOfWeek) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('period')
          .doc('week')
          .get();

      if (snapshot.exists && snapshot[currentDay] != null) {
        periodsByDay[currentDay] =
            Map<String, String>.from(snapshot[currentDay]);
      }
    }

    return periodsByDay;
  }
}
