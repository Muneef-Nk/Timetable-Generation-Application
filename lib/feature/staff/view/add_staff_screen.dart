import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/core/color/color_constants.dart';
import 'package:timetable_generation_application/core/config/api.dart';
import 'package:timetable_generation_application/core/global/custom_textfield.dart';
import 'package:timetable_generation_application/core/global/helper_function.dart';
import 'package:timetable_generation_application/feature/staff/controller/staff_controller.dart';

class AddStaffScreen extends StatefulWidget {
  final String? staffId;
  final String? staffName;
  final String? email;
  final String? place;
  final String? courseId;
  final String? image;

  const AddStaffScreen(
      {super.key,
      this.staffId,
      this.staffName,
      this.email,
      this.place,
      this.courseId,
      this.image}); // To hold course ID for editing

  @override
  _AddStaffScreenState createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  String? selectedCourseId;
  String? selectedCourseName;
  List<QueryDocumentSnapshot> courses = [];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
    if (widget.staffName != null) {
      nameController.text = widget.staffName!;
    }
    if (widget.email != null) {
      emailController.text = widget.email!;
    }
    if (widget.place != null) {
      placeController.text = widget.place!;
    }
    selectedCourseId = widget.courseId;
    Provider.of<StaffController>(context, listen: false).imageUrl =
        widget.image;
  }

  Future<void> _fetchCourses() async {
    QuerySnapshot snapshot =
        await ApiConfig.firestore.collection('courses').get();
    setState(() {
      courses = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        title: Text(
          'Add Staff',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Consumer<StaffController>(builder: (context, provider, _) {
                  return GestureDetector(
                      onTap: () {
                        provider.pickImage();
                      },
                      child: provider.imageUrl != null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(provider.imageUrl!))
                          : CircleAvatar(
                              radius: 50,
                              child: Icon(Icons.add_a_photo, size: 50),
                            ));
                }),
                CustomTextField(
                  controller: nameController,
                  hintText: "Staff Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the staff name';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: emailController,
                  hintText: "Staff Email",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the staff email';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: placeController,
                  hintText: "Staff Place",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the staff place';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Container(
                  decoration: boxDecoration(),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButton<String>(
                    focusColor: AppColor.primary,
                    dropdownColor: AppColor.white,
                    hint: Text('Select Course'),
                    value: selectedCourseId,
                    underline: const SizedBox(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCourseId = newValue;
                        selectedCourseName = courses.firstWhere(
                            (course) => course.id == newValue)['courseName'];
                      });
                    },
                    items: courses.map((course) {
                      return DropdownMenuItem<String>(
                        value: course.id,
                        child: Text(
                          course['courseName'],
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    isExpanded: true,
                  ),
                ),
                SizedBox(height: 20),
                Consumer<StaffController>(builder: (context, provider, _) {
                  return ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppColor.primary)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          selectedCourseId != null) {
                        await provider.uploadImage();

                        if (provider.imageUrl == null) {
                          showSnackBar(
                              context: context,
                              message: "Please select a profile picture.");
                          return;
                        }

                        if (widget.staffId == null) {
                          provider.addStaff(
                            context: context,
                            staffName: nameController.text,
                            courseId: selectedCourseId!,
                            courseName: selectedCourseName!,
                            email: emailController.text,
                            place: placeController.text,
                          );
                        } else {
                          provider.updateStaff(
                            context: context,
                            staffId: widget.staffId!,
                            staffName: nameController.text,
                            courseId: selectedCourseId!,
                            courseName: selectedCourseName!,
                            email: emailController.text,
                            place: placeController.text,
                          );
                        }
                      } else {
                        showSnackBar(
                            context: context,
                            message: "Please complete all fields.");
                      }
                    },
                    child: Text(
                      widget.staffId == null ? 'Add Staff' : "Update Staff",
                      style: TextStyle(color: AppColor.white),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
