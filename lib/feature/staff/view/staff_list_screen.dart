import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:timetable_generation_application/core/color/color_constants.dart';
import 'package:timetable_generation_application/core/config/api.dart';
import 'package:timetable_generation_application/core/global/helper_function.dart';
import 'package:timetable_generation_application/core/utils/loading.dart';
import 'package:timetable_generation_application/feature/staff/view/add_staff_screen.dart';
import 'package:timetable_generation_application/feature/staff/view/staff_assign.dart';

class StaffListScreen extends StatefulWidget {
  @override
  _StaffListScreenState createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.bg,
        body: StreamBuilder<QuerySnapshot>(
          stream: ApiConfig.firestore.collection('staff').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Loading());
            }

            final staffDocs = snapshot.data!.docs;

            return staffDocs == 0
                ? Center(child: Text('No staff available'))
                : ListView.builder(
                    itemCount: staffDocs.length,
                    itemBuilder: (context, index) {
                      var staff = staffDocs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AssignSubjectsScreen(
                                staffId: staff.id,
                                staffName: staff['staffName'],
                                currentSubjects: staff['subjects'],
                                courseId: staff['courseId'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: boxDecoration(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        color: staff['profile'] != null
                                            ? AppColor.light
                                            : AppColor.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: staff['profile'] != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              staff['profile'],
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Image.asset(
                                            'assets/staff_profile.png'),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          staff['staffName'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          staff['email'],
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          staff['place'],
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Dept: ${staff['courseName']}',
                                              style: TextStyle(
                                                  color: AppColor.primary,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            PopupMenuButton<String>(
                                              color: AppColor.white,
                                              onSelected: (value) {
                                                if (value == 'edit') {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddStaffScreen(
                                                                courseId: staff[
                                                                    'courseId'],
                                                                email: staff[
                                                                    'email'],
                                                                place: staff[
                                                                    'place'],
                                                                staffId:
                                                                    staff.id,
                                                                staffName: staff[
                                                                    'staffName'],
                                                                image: staff[
                                                                    'profile'],
                                                              )));
                                                } else if (value == 'delete') {
                                                  _deleteStaff(staff.id);
                                                }
                                              },
                                              itemBuilder:
                                                  (BuildContext context) {
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
                                              icon: Icon(Icons.more_vert),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: AppColor.light,
                              ),
                              Theme(
                                data: ThemeData()
                                    .copyWith(dividerColor: Colors.transparent),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: ExpansionTile(
                                    title: Text("Subjects"),
                                    expandedAlignment: Alignment.centerLeft,
                                    tilePadding: EdgeInsets.zero,
                                    children: [
                                      Wrap(
                                        spacing: 3,
                                        children: staff['subjects']
                                            .map<Widget>((subject) {
                                          return Chip(
                                            label: Text(
                                              subject,
                                              style: TextStyle(
                                                  color: AppColor.white),
                                            ),
                                            backgroundColor: AppColor.primary,
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                    shape: null,
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.primary,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddStaffScreen()),
            );
          },
          child: Icon(
            Icons.add,
            color: AppColor.white,
          ),
        ),
      ),
    );
  }

  void _deleteStaff(String staffId) async {
    await _firestore.collection('staff').doc(staffId).delete();
    showSnackBar(
        context: context, message: "staff delected", color: AppColor.primary);
  }
}
