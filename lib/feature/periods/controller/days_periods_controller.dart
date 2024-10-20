import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timetable_generation_application/core/color/color_constants.dart';
import 'package:timetable_generation_application/core/config/api.dart';
import 'package:timetable_generation_application/core/global/helper_function.dart';

class PeriodsController with ChangeNotifier {
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];
  bool isLoading = true;

  final List<List<TextEditingController>> periodControllers = List.generate(
    5,
    (index) => List.generate(4, (index) => TextEditingController()),
  );

  Future<void> loadPeriods() async {
    final String documentId = 'week';
    try {
      DocumentSnapshot doc =
          await ApiConfig.firestore.collection('period').doc(documentId).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        for (int dayIndex = 0; dayIndex < days.length; dayIndex++) {
          Map<String, dynamic>? periods = data[days[dayIndex]];
          if (periods != null) {
            for (int periodIndex = 0; periodIndex < 4; periodIndex++) {
              String periodKey = 'Period ${periodIndex + 1}';
              periodControllers[dayIndex][periodIndex].text =
                  periods[periodKey] ?? 'N/A';
            }
          }
        }
      }
    } catch (e) {
      print("Error loading periods: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> pickTime(
      BuildContext context, int dayIndex, int periodIndex) async {
    TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (startTime != null) {
      TimeOfDay? endTime = await showTimePicker(
        context: context,
        initialTime: startTime.replacing(hour: startTime.hour + 1),
      );

      if (endTime != null) {
        periodControllers[dayIndex][periodIndex].text =
            "${startTime.format(context)} - ${endTime.format(context)}";
      }
    }
    notifyListeners();
  }

  void saveTimetable(BuildContext context) async {
    Map<String, Map<String, String>> timetableData = {};
    for (int dayIndex = 0; dayIndex < days.length; dayIndex++) {
      Map<String, String> periods = {};
      for (int periodIndex = 0; periodIndex < 4; periodIndex++) {
        String periodText = periodControllers[dayIndex][periodIndex].text;
        periods['Period ${periodIndex + 1}'] =
            periodText.isEmpty ? 'N/A' : periodText;
      }
      timetableData[days[dayIndex]] = periods;
    }

    final String documentId = 'week';

    await FirebaseFirestore.instance
        .collection('period')
        .doc(documentId)
        .set(timetableData, SetOptions(merge: true));
    showSnackBar(
        context: context,
        message: "Period updated successfully!",
        color: AppColor.primary);
  }
}
