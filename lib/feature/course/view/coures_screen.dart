import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/core/color/color_constants.dart';
import 'package:timetable_generation_application/core/config/api.dart';
import 'package:timetable_generation_application/core/global/helper_function.dart';
import 'package:timetable_generation_application/core/utils/loading.dart';
import 'package:timetable_generation_application/feature/course/controller/course_controller.dart';
import 'package:timetable_generation_application/feature/subjects/view/subject_screen.dart';

class CourseListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        title: Text(
          'QuickTimetable',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: Consumer<CourseController>(builder: (context, provider, _) {
        return StreamBuilder<QuerySnapshot>(
          stream: ApiConfig.firestore.collection('courses').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Loading(
                color: AppColor.primary,
              ));
            }

            final courseDocs = snapshot.data!.docs;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    decoration: boxDecoration(),
                    padding: EdgeInsets.only(top: 15, left: 15, right: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add a New Course!',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primary,
                          ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            'Press the button below to manage courses and effortlessly generate the timetable!',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                _addCourseDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColor.primary, // Custom button color
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Add Course",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Image.asset(
                              'assets/virtual-reality.png',
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  courseDocs.length == 0
                      ? Text('No courses available. Please add some!')
                      : GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: courseDocs.length,
                          itemBuilder: (context, index) {
                            var course = courseDocs[index];
                            return Container(
                              decoration: boxDecoration(),
                              margin: EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SubjectListScreen(
                                        courseId: course.id,
                                        courseName: course['courseName'],
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        PopupMenuButton<String>(
                                          color: AppColor.white,
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              _editCourse(
                                                  course.id,
                                                  course['courseName'],
                                                  context);
                                            } else if (value == 'delete') {
                                              provider.deleteCourse(
                                                  course.id, context);
                                            }
                                          },
                                          itemBuilder: (BuildContext context) {
                                            return [
                                              PopupMenuItem<String>(
                                                value: 'edit',
                                                child: Text('Edit'),
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'delete',
                                                child: Text('Delete'),
                                              ),
                                            ];
                                          },
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: AppColor.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 5),
                                      child: Image.asset(
                                        "assets/online-course.png",
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        '${course['courseName']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  void _addCourseDialog(BuildContext context) {
    TextEditingController courseNameController = TextEditingController();
    final provider = Provider.of<CourseController>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add Course',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: TextField(
            controller: courseNameController,
            decoration: InputDecoration(hintText: 'Enter course name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColor.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                provider.addCourse(courseNameController.text, context);
              },
              child: Text(
                'Add',
                style: TextStyle(color: AppColor.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editCourse(String courseId, String initialName, BuildContext context) {
    TextEditingController courseNameController =
        TextEditingController(text: initialName);

    final provider = Provider.of<CourseController>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Course',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          content: TextField(
            controller: courseNameController,
            decoration: InputDecoration(hintText: 'Enter course name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColor.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                provider.editCourse(
                    context: context,
                    courseId: courseId,
                    text: courseNameController.text);
              },
              child: Text(
                'Save',
                style: TextStyle(color: AppColor.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}
