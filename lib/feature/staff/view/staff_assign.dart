import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/core/color/color_constants.dart';
import 'package:timetable_generation_application/feature/staff/controller/staff_controller.dart';

class AssignSubjectsScreen extends StatefulWidget {
  final String staffId;
  final String courseId;
  final String staffName;
  final List<dynamic> currentSubjects;

  AssignSubjectsScreen({
    required this.staffId,
    required this.staffName,
    required this.currentSubjects,
    required this.courseId,
  });

  @override
  _AssignSubjectsScreenState createState() => _AssignSubjectsScreenState();
}

class _AssignSubjectsScreenState extends State<AssignSubjectsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<StaffController>(context, listen: false)
        .fetchSubjects(courseId: widget.courseId);
    Provider.of<StaffController>(context, listen: false).assignedSubjects =
        widget.currentSubjects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        title: Text(
          'Assign Subjects for ${widget.staffName}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<StaffController>(builder: (context, provider, _) {
        return ListView.builder(
          itemCount: provider.subjects.length,
          itemBuilder: (context, index) {
            var subject = provider.subjects[index];
            return CheckboxListTile(
              activeColor: AppColor.primary,
              title: Text(subject['subjectName']),
              value: provider.assignedSubjects.contains(subject['subjectName']),
              onChanged: (value) {
                provider.toggleSubject(
                  context: context,
                  subjectName: subject['subjectName'],
                  staffId: widget.staffId,
                  staffName: widget.staffName,
                );
              },
            );
          },
        );
      }),
    );
  }
}
