import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timetable_generation_application/core/color/color_constants.dart';
import 'package:timetable_generation_application/core/utils/loading.dart';
import 'package:timetable_generation_application/feature/timetable/view/timetable_screen.dart';

class CourseSelectionScreen extends StatefulWidget {
  @override
  _CourseSelectionScreenState createState() => _CourseSelectionScreenState();
}

class _CourseSelectionScreenState extends State<CourseSelectionScreen> {
  List<Map<String, dynamic>> courses = [];

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('courses').get();
    List<Map<String, dynamic>> fetchedCourses = snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['courseName'],
      };
    }).toList();
    setState(() {
      courses = fetchedCourses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: courses.isEmpty
          ? Center(child: Loading())
          : Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2,
                ),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TimetableScreen(
                              selectedCourseId: courses[index]['id']!),
                        ),
                      );
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          '${courses[index]['name']}',
                          style: TextStyle(color: AppColor.white),
                          textAlign: TextAlign.center,
                        ))),
                  );
                },
              ),
            ),
    );
  }
}
