import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/core/color/color_constants.dart';
import 'package:timetable_generation_application/core/config/api.dart';
import 'package:timetable_generation_application/core/global/custom_textfield.dart';
import 'package:timetable_generation_application/core/global/helper_function.dart';
import 'package:timetable_generation_application/core/utils/loading.dart';
import 'package:timetable_generation_application/feature/subjects/controller/subject_controller.dart';

class SubjectListScreen extends StatelessWidget {
  final String courseId;
  final String courseName;

  SubjectListScreen({required this.courseId, required this.courseName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        title: Text(
          'Subjects of $courseName',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<SubjectController>(builder: (context, provider, _) {
        return StreamBuilder<QuerySnapshot>(
          stream: ApiConfig.firestore
              .collection('subjects')
              .where('courseId', isEqualTo: courseId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Loading());
            }

            final subjectDocs = snapshot.data!.docs;

            return subjectDocs.length == 0
                ? Center(child: Text('No subjects available. Please add !'))
                : ListView.builder(
                    itemCount: subjectDocs.length,
                    itemBuilder: (context, index) {
                      var subject = subjectDocs[index];
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: boxDecoration(),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: AppColor.primary,
                                borderRadius: BorderRadius.circular(5)),
                            child: Image.asset(
                              'assets/book.png',
                              color: AppColor.white,
                            ),
                          ),
                          title: Text(
                            subject['subjectName'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Image.asset(
                                "assets/teacher.png",
                                width: 20,
                              ),
                              SizedBox(width: 10),
                              subject['assignedStaff'] != null
                                  ? Text(
                                      subject['assignedStaff'],
                                      style: TextStyle(
                                        color: AppColor.grey,
                                      ),
                                    )
                                  : Text(
                                      "No Staff Assigned",
                                      style: TextStyle(
                                        color: AppColor.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            color: AppColor.white,
                            onSelected: (value) {
                              if (value == 'edit') {
                                _editSubject(subject.id, subject['subjectName'],
                                    context);
                              } else if (value == 'delete') {
                                provider.deleteSubject(subject.id, context);
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
                        ),
                      );
                    },
                  );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primary,
        onPressed: () {
          _addSubjectDialog(context);
        },
        child: Icon(
          Icons.add,
          color: AppColor.white,
        ),
      ),
    );
  }

  void _addSubjectDialog(BuildContext context) {
    TextEditingController subjectNameController = TextEditingController();
    final provider = Provider.of<SubjectController>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add Subject',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: CustomTextField(
            controller: subjectNameController,
            hintText: 'Subject',
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
                String subjectName = subjectNameController.text.trim();
                if (subjectName.isNotEmpty) {
                  provider.addSubject(
                    context: context,
                    courseId: courseId,
                    subjectName: subjectName,
                  );
                } else {
                  showSnackBar(
                      context: context,
                      message: "Subject name cannot be empty.");
                }
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

  void _editSubject(
      String subjectId, String initialName, BuildContext context) {
    TextEditingController subjectNameController =
        TextEditingController(text: initialName);

    final provider = Provider.of<SubjectController>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Edit Subject',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: CustomTextField(
            controller: subjectNameController,
            hintText: "Subject",
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
                String subjectName = subjectNameController.text.trim();
                if (subjectName.isNotEmpty) {
                  provider.updateSubject(subjectId, subjectName, context);
                } else {
                  showSnackBar(
                      context: context,
                      message: "'Subject name cannot be empty.");
                }
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
